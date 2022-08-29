package com.xz.filter;


import cn.hutool.core.date.DateUtil;
import com.google.gson.*;
import com.xz.filter.dao.ExpressionMapper;
import com.xz.filter.dao.HtmlMapper;
import com.xz.filter.dao.RegularMapper;
import com.xz.filter.dao.SourceMapper;
import com.xz.filter.pojo.*;
import com.xz.rbac.web.DeployRunning;
import de.innosystec.unrar.Archive;
import de.innosystec.unrar.NativeStorage;
import de.innosystec.unrar.exception.RarException;
import de.innosystec.unrar.rarfile.FileHeader;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.sevenz.SevenZFile;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrInputDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class SourceService implements Runnable {
    private Logger logger = LoggerFactory.getLogger(SourceService.class);
    private static String deployDir = DeployRunning.getDir();
    private HtmlMapper htmlMapper;
    private ExpressionMapper expressionMapper;
    private RegularMapper regularMapper;
    private SourceMapper sourceMapper;
    private Source source;
    private SolrClient httpSolrClient;

    // private RedisUtil redisUtil;

    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm").serializeNulls().create();
    private JsonParser jsonParser = new JsonParser();
    private TreeSet<String> keys = new TreeSet<>();
    private HashMap<String, Paragraph> keyPara = new HashMap<>();

    public SourceService(HtmlMapper htmlMapper, RegularMapper regularMapper, ExpressionMapper expressionMapper,
                         SourceMapper sourceMapper, SolrClient httpSolrClient) {
        this.htmlMapper = htmlMapper;
        this.regularMapper = regularMapper;
        this.expressionMapper = expressionMapper;
        this.sourceMapper = sourceMapper;
        this.httpSolrClient = httpSolrClient;
    }

    public void setSource(Source source) {
        this.source = source;
    }
    //source是插入数据库后，在这里分析

    //public Source parseSource(Source source) throws IOException, RarException {
    public void run() {
        long startSecond = System.currentTimeMillis();
        int fragmentCount = 0, htmlCount = 0;
        logger.info("regularMapper=" + regularMapper);
        logger.info("source=" + source);
        logger.info("source.getRegularID()=" + source.getRegularID());
        Regular reg = regularMapper.getRegular(source.getRegularID());
        JsonElement jsonElement = reg.getExpression();
        JsonArray jsonExps = jsonElement.getAsJsonArray();
        Expression[] exps = gson.fromJson(jsonExps, Expression[].class);
        Pattern paraPattern = Pattern.compile(reg.getParagraph(), Pattern.CASE_INSENSITIVE);
        //logger.info(exps.length + "");
        //重新从数据库读取Expression，避免正规式库修改，这边没同步
        List<Integer> expressionIDs = new ArrayList<>(exps.length);
        for (Expression exp : exps)
            expressionIDs.add(exp.getExpressionID());
        //exp.setPattern(Pattern.compile(exp.getExp(), Pattern.CASE_INSENSITIVE));
        Map<String, Object> param = new HashMap<>();
        param.put("expressionIDs", expressionIDs);
        List<Expression> expressionList = expressionMapper.selectExpression(param);
        //重新从数据库读取完毕
        System.out.println("expressionList ======================================== " + expressionList.size());
        for (int i = 0; i < exps.length; i++) {
            exps[i].setPattern(Pattern.compile(expressionList.get(i).getExp(), Pattern.CASE_INSENSITIVE));
            logger.info(expressionList.get(i).getExp());
        }
        //if (true) return null;

        File saveFile = new File(deployDir + source.getServerPath() + File.separator + source.getServerFilename());
        ArchiveEntry archiveEntry;
        Map<String, Integer> errMap = new HashMap<>();
        try {
            if (source.getFilename().endsWith(".zip")) {
                InputStream is = new FileInputStream(saveFile);
                ZipArchiveInputStream zais = new ZipArchiveInputStream(is, "GBK");
                while ((archiveEntry = zais.getNextEntry()) != null) {
                    if (archiveEntry.isDirectory()) continue;

                    String entryFileName = archiveEntry.getName();

                    if (entryFileName.endsWith("html") || entryFileName.endsWith("htm")) {
                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                        byte[] bytes = new byte[1024];
                        int temp;
                        while ((temp = zais.read(bytes)) != -1) {
                            outputStream.write(bytes, 0, temp);
                        }
                        outputStream.flush();
                        // 得到内存中写入的所有数据
                        byte[] data = outputStream.toByteArray();
                        logger.info("filesize:" + data.length + "，entryFileName:" + entryFileName);

                        fragmentCount += parseHtml(source, reg, paraPattern, exps, entryFileName, data);
                        htmlCount++;
                        outputStream.close();

                    }
                }
                zais.close();
                is.close();
            } else if (source.getFilename().endsWith(".7z")) {
                SevenZFile sevenZFile = new SevenZFile(saveFile);
                while ((archiveEntry = sevenZFile.getNextEntry()) != null) {
                    if (archiveEntry.isDirectory()) continue;

                    String entryFileName = archiveEntry.getName();
                    if (entryFileName.endsWith("html") || entryFileName.endsWith("htm")) {
                        byte[] data = new byte[(int) archiveEntry.getSize()];
                        try {
                            sevenZFile.read(data, 0, data.length);

                            fragmentCount += parseHtml(source, reg, paraPattern, exps, entryFileName, data);
                            htmlCount++;
                            logger.info("file:" + entryFileName + "，size:" + archiveEntry.getSize());
                        } catch (IOException e) {
                            int k = errMap.get(e.getMessage()) == null ? 0 : errMap.get(e.getMessage());
                            k++;
                            //logger.info(e.getMessage() + "\n,k=" + k);
                            errMap.put(e.getMessage(), k);
                            logger.info("file:" + entryFileName + "，" + e.getMessage());
                            //e.printStackTrace();
                        }
                    }
                }
                sevenZFile.close();
            } else if (source.getFilename().endsWith(".rar")) {
                //logger.info("rar:" + source.getFilename());
                NativeStorage storage = new NativeStorage(saveFile);
                Archive archive = new Archive(storage);
                FileHeader fh;
                while ((fh = archive.nextFileHeader()) != null) {
                    if (fh.isDirectory()) continue;

                    String entryFileName = fh.getFileNameString();

                    //logger.info("entryFileName:" + entryFileName);
                    if (entryFileName.endsWith("html") || entryFileName.endsWith("htm")) {
                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                        archive.extractFile(fh, outputStream);
                        outputStream.flush();
                        byte[] data = outputStream.toByteArray();
                        //logger.info("data.length:" + data.length + "，entryFileName:" + entryFileName);
                        fragmentCount += parseHtml(source, reg, paraPattern, exps, entryFileName, data);
                        htmlCount++;
                        outputStream.close();
                    }
                }
                archive.close();
            }
            source.setParseTime(System.currentTimeMillis() - startSecond);

            startSecond = System.currentTimeMillis();
            solrIndex();
            source.setIndexTime(System.currentTimeMillis() - startSecond);
            if (errMap.size() == 0) {
                if (fragmentCount > 0) {
                    source.setParseStatus(1);
                    source.setErrmsg("");
                } else {
                    source.setParseStatus(4);
                    source.setErrmsg("未解析到段落，请检查\"解析设置\"的段落正规式。");
                }
            } else {
                source.setParseStatus(4);
                source.setErrmsg(gson.toJson(errMap));
            }

            logger.info("parseTime:" + source.getParseTime());
            logger.info("indexTime:" + source.getIndexTime());
        } catch (IOException | RarException e) {
            e.printStackTrace();
            source.setErrmsg(e.getMessage());
            source.setParseStatus(2);
        } finally {
            source.setFragmentCount(fragmentCount);
            source.setHtmlCount(htmlCount);

            sourceMapper.updateSource(source);
        }
    }

    private int parseHtml(Source source, Regular reg, Pattern paraPattern, Expression[] exps, String entryFileName, byte[] data) {
        String hex = DigestUtils.sha256Hex(data);
        Html html = htmlMapper.getHtmlByCheckCode(hex);
        if (html == null) {//未处理过的，才需要解析导入
            html = new Html();
            html.setSourceID(source.getSourceID());
            html.setFilename(entryFileName);
            // html.setPath(entryFileName.); todo
            html.setSize(data.length);
            html.setCheckCode(hex);
            htmlMapper.insertHtml(html);

            return parseParagraph(source, reg, paraPattern, exps, html, data);
        }
        return 0;
    }

    private void mapAddElement(Map<String, Object> map, String patternName, String link) {
        if (link == null || "".equals(link)) return;

        Object a = map.get(patternName);
        if (a == null) {
            map.put(patternName, link);
        } else if (a instanceof String) {
            List<String> strings = new ArrayList<>();
            strings.add((String) a);
            strings.add(link);
            map.put(patternName, strings);
        } else if (a instanceof List) {
            ArrayList<String> strings = (ArrayList) a;
            strings.add(link);
            map.put(patternName, strings);
        }
    }

    private int parseParagraph(Source source, Regular reg, Pattern paraPattern, Expression[] exps, Html html, byte[] data) {
        int fragmentCount = 0;
        long tempTime = System.currentTimeMillis(), parseAndRedisTime = 0;
        try {
            String text = new String(data, reg.getCharset());
            Matcher m = paraPattern.matcher(text);

            while (m.find()) {
                if (m.groupCount() == 6) {
                    //System.out.println("body = " + m.group("paragraph"));
                    Paragraph p = new Paragraph();
                    p.setSourceID(source.getSourceID());
                    p.setHtmlID(html.getHtmlID());
                    p.setBody(m.group("paragraph"));
                    p.setPublisher(m.group("publisher"));
                    p.setPublishTime(new Timestamp(DateUtil.parse(m.group("year") + "-" + m.group("month") + "-" + m.group("day") +
                            " " + m.group("time"), "yyyy-MM-dd HH:mm:ss").getTime()));

                    Map<String, Object> link = new HashMap<>();
                    for (Expression exp : exps) {
                        mapAddElement(link, exp.getExpressionName(),
                                findLink(p, exp.getCapturingName(), exp.getPattern()));
                    }

                    if (link.size() > 0) { //有联系方式的，才保存
                        p.setLink(jsonParser.parse(gson.toJson(link)).getAsJsonObject().toString());
                        p.setBodyCheckCode(DigestUtils.sha256Hex(p.getPublisher() + p.getBody() + p.getLink()));

                        Paragraph before = keyPara.putIfAbsent(p.getBodyCheckCode(), p);
                        if (before != null) {
                            before.setRepeatCount(before.getRepeatCount() + 1);
                            keyPara.put(p.getBodyCheckCode(), before);
                        }
                      /*  boolean notExist = keys.add(p.getBodyCheckCode());
                        if (!notExist) {
                            Paragraph p1 = (Paragraph) redisUtil.get(p.getBodyCheckCode());
                            p1.setRepeatCount(p1.getRepeatCount() + 1);
                            p = p1;
                        }*/
                     /*   Paragraph before = keyPara.putIfAbsent(p.getBodyCheckCode(), p);
                        Object s = redisUtil.get(p.getBodyCheckCode());
                        if (s != null) {
                            p = (Paragraph) s;
                            p.setRepeatCount(p.getRepeatCount() + 1);
                        }*/
                        //redisUtil.set(p.getBodyCheckCode(), p, 60 * 60 * 24);

                        fragmentCount++;
                    }
                }
            }
            parseAndRedisTime += System.currentTimeMillis() - tempTime;
            logger.info(html.getFilename() + " parse Time=" + parseAndRedisTime);

            html.setFragmentCount(fragmentCount);
            html.setParseStatus(fragmentCount > 0 ? 1 : 4);
            htmlMapper.updateHtml(html);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fragmentCount;
    }

    private int solrIndex() {
        long startSecond = System.currentTimeMillis();
        UpdateResponse ur = null;
        //2.通过 client 将 document 加入索引库
        try {
            httpSolrClient.deleteByQuery("sourceID_i:" + source.getSourceID());
            logger.info("开始创建索引");
            //List<Object> list = redisUtil.getRedisList(keys);
            Collection<Paragraph> list = keyPara.values();

            List<SolrInputDocument> documents = new ArrayList<>();
            for (Object o : list) {
                Paragraph p = (Paragraph) o;
                // paragraphID id, P.sourceID sourceID_i, P.htmlID htmlID_n,body body_cn,publisher publisher_cn, publishTime publishTime_dt,

                SolrInputDocument doc = new SolrInputDocument();
                doc.addField("sourceID_i", p.getSourceID());
                doc.addField("htmlID_i", p.getHtmlID());
                doc.addField("body_cn", p.getBody());
                doc.addField("publisher_cn", p.getPublisher());
                doc.addField("publishTime_dt", p.getPublishTime());
                doc.addField("source_cn", source.getFilename());
                doc.addField("link_cn", p.getLink());
                doc.addField("insertTime_dt", new Timestamp(System.currentTimeMillis()));
                //doc.addField("warnLevel_n", p.getWarnLevel());
                doc.addField("repeatCount_i", p.getRepeatCount());
                doc.addField("checkCode_s", p.getBodyCheckCode());

                documents.add(doc);
            }
            //logger.info("size:" + documents.size());
            if (documents.size() > 0) {
                httpSolrClient.add(documents);
                ur = httpSolrClient.commit();
            }
            //redisUtil.del(keys);//清空redis！
            logger.info("创建索引库完成，耗时：" + (System.currentTimeMillis() - startSecond) / 1000 + "秒");
        } catch (SolrServerException | IOException e) {
            e.printStackTrace();
        }
        source.setIndexTime(System.currentTimeMillis() - startSecond);
        sourceMapper.updateSource(source);
        return Objects.requireNonNull(ur).getStatus();
    }

    private static String findLink(Paragraph para, String capturingName, Pattern pattern) {
        //Pattern pattern = Pattern.compile(regexp);
        Matcher m = pattern.matcher(para.getBody());
        if (m.find()) {
            try {
                return m.group(capturingName);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return "";
    }
//<div class="pull_right date details" title="(?<day>\d{2})\.(?<month>\d{2})\.(?<year>\d{4}) (?<time>\d{2}:\d{2}:\d{2})">[\s\S]+?<div class="from_name">\s*(?<publisher>[ \S]+?)\s*</div>[\s\S]+?<div class="text">(?<paragraph>[\s\S]{1,8191}?)</div>

    //skye:
    //sky(?:pe)?\s*[:：]?\s*(?<skype>[\w:.]{3,100})\s+

    //qq:
    // <a href="tel:(?<qq>\d{5,10}?)">\k<qq></a>
    //(?:企鹅|qq|扣扣|加q🐧)\s*[:：]?\s*(?<qq>\d{5,10}?)\D
    //(?:企鹅|qq|扣扣|加q|🐧🐧)\s*[:：]?\s*(?<qq>\d{5,10}?)\D

    //telegram:
    //<a href="https://t\.me/(?:\w{5,100}?)">(?<telegram>(?:@|(https://t\.me/))\w{5,100}?)</a>
    //<a href="https://t\.me/(?:\w{3,100}+)">(?<telegram>(?:@|(https://t\.me/))\w{3,100}+)</a>

    //微信
    //(?:wx|wechat|微信)\s*[:：]\s*(?<wx>[\w:.@]{5,100}?)\s


    //参考 email
    //"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$"　　　　//email地址
    //((\w+)|(\w+[!#$%&'*+\-,./=?^_`{|}~\w]*[!#$%&'*+\-,/=?^_`{|}~\w]))@(([0−9]1,3\.[0−9]1,3\.[0−9]1,3\.)|(([a−zA−Z0−9\-]+\.)+))([a−zA−Z]2,10|[0−9]1,3)(?)

    public static void main2(String[] args) {
        File file = new File("/home/gzhhy/projects/filter_xz/example/messages (2).html");
        String text = "";
        try {
            FileInputStream fileInputStream = new FileInputStream(file);
            // 把每次读取的内容写入到内存中，然后从内存中获取
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int len;
            // 只要没读完，不断的读取
            while ((len = fileInputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, len);
            }
            outputStream.flush();
            // 得到内存中写入的所有数据
            byte[] data = outputStream.toByteArray();
            fileInputStream.close();

            text = new String(data, StandardCharsets.UTF_8);
        } catch (IOException e) {
            e.printStackTrace();
        }
        Pattern pattern = Pattern.compile("a href=\"tel:(?<qq>\\d{5,10}?)\">\\k<qq></a>", Pattern.CASE_INSENSITIVE);//无<a href
        /*Pattern pattern = Pattern.compile("<div class=\"pull_right date details\" title=\"(?<day>\\d{2})\\.(?<month>\\d{2})\\.(?<year>\\d{4}) (?<time>\\d{2}:\\d{2}:\\d{2})\">[\\s\\S]+?" +
                "<div class=\"from_name\">\\s*(?<publisher>[ \\S]+?)\\s*</div>[\\s\\S]+?" +
                "<div class=\"text\">(?<paragraph>[\\s\\S]+?)</div>");*/
        Matcher m = pattern.matcher(text);
        int matchCount = 0;
        while (m.find()) {
            System.out.println("m.groupCount() = " + m.groupCount() + "----------++++-----------------------------------------");

            //int count = m.groupCount();
            /*while (count >= 0) {
                System.out.println("m.group(" + count + ") = " + m.group(count--));
            }*/
            System.out.println("link =" + m.group("qq"));
            System.out.println("group(0)=" + m.group(0));
            matchCount++;
        }
        System.out.println("matchCount = " + matchCount);
    }

    //<a href="https://t.me/(?:\w{5,100}?)">(?<telegram>(?:@|(https://t.me/))\w{5,100}?)</a>
    public static void main(String[] args) {
        String text =/* "<div class=\"message default clearfix\" id=\"message75753\">\n" +
                "    <div class=\"pull_left userpic_wrap\">\n" +
                "        <div class=\"userpic userpic6\" style=\"width: 42px; height: 42px\">\n" +
                "            <div class=\"initials\" style=\"line-height: 42px\">TS</div>\n" +
                "        </div>\n" +
                "    </div>\n" +*/
                "    <div class=\"body\">\n" +
                        "        <div class=\"pull_right date details\" title=\"03.04.2022 01:06:36\">01:06</div>\n" +
                        "        <div class=\"from_name\">T Setsuna</div>\n" +
                        "        <div class=\"text\">反正到手了，过程虽麻烦，也爽到了，就行了</div>\n" +
                        "    </div>\n" +
                        "</div>";
        String text1 = "  <div class=\"body\">\n\n       <div class=\"pull_right date details\" title=\"15.06.2022 05:53:13 UTC+08:00\">\n05:53\n" +
                "       </div>\n" +
                "\n" +
                "       <div class=\"from_name\">\n" +
                "Deleted Account\n" +
                "       </div>\n" +
                "\n" +
                "       <div class=\"text\">\n" +
                "安哥中介，卖内部信息找我，收货管道稳定<br>飞机： <a href=\"https://t.me/star426\">@star426</a><br>V号：Alisa-wx-CHWM<br>-----<br>蝙蝠 海鸥：<br>安久网贷，缺钱找我<br>蝙蝠号12878876<br>海鸥号363351<br>!!!!!!!!!!<br>!!!!!!!!!!<br>大众传媒发广告  飞机 <a href=\"https://t.me/aa779700\">@aa779700</a>\n" +
                "       </div>\n" +
                "\n" +
                "      </div>\n" +
                "\n" +
                "     </div>";
        //System.out.println(text);

        Pattern pattern = Pattern.compile("<div class=\"pull_right date details\" title=\"(?<day>\\d{2})\\.(?<month>\\d{2})\\.(?<year>\\d{4}) (?<time>\\d{2}:\\d{2}:\\d{2})(?: UTC\\+08:00)?\">[\\s\\S]+?<div class=\"from_name\">\\s*(?<publisher>[ \\S]+?)\\s*</div>[\\s\\S]+?<div class=\"text\">(?<paragraph>[\\s\\S]{1,8191}?)</div>", Pattern.CASE_INSENSITIVE);//无<a href

        Matcher m = pattern.matcher(text);
        int matchCount = 0;
        while (m.find()) {
            System.out.println("m.groupCount() = " + m.groupCount() + " ----------++++----------------------------------------");

            int count = m.groupCount();
            System.out.println("time=" + m.group("time"));

            for (int i = 0; i < count; i++)
                System.out.println("group(" + i + ")=" + m.group(i));
            matchCount++;
        }
        System.out.println("matchCount = " + matchCount);

    }
    /*public static void main(String[] args) {
        String text = "蝙蝠：  10119662\n" +
                "蝙蝠\uD83E\uDD87  \uD83E\uDD87      7269894\n" +
                "【蝙蝠</strong>ID<strong>：</strong>4678065<strong>】\n" +
                "蝙蝠ID：4678065\n" +
                "蝙蝠：8499727 ";
        System.out.println(text);

        Pattern pattern1 = Pattern.compile("(?:蝙蝠|蝙蝠ID|\uD83E\uDD87)\\s*[:：]?\\s*(?<batchat>\\d{5,10}?)\\D", Pattern.CASE_INSENSITIVE);
        Pattern pattern = Pattern.compile("(?:蝙蝠[a-zA-Z<>:：/]{29,40})(?<batchat>\\d{5,10}?)\\D", Pattern.CASE_INSENSITIVE);

        Matcher m = pattern.matcher(text);
        int matchCount = 0;
        while (m.find()) {
            System.out.println("m.groupCount() = " + m.groupCount() + " ----------++++----------------------------------------");

            //int count = m.groupCount();
            System.out.println("batchat=" + m.group("batchat"));
            System.out.println("group(0)=" + m.group(0));
            matchCount++;
        }
        System.out.println("matchCount = " + matchCount);
    }*/
}



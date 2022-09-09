package com.xz.filter.controller;

import cn.hutool.core.date.DateUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.xz.filter.dao.ExpressionMapper;
import com.xz.filter.dao.SourceMapper;
import com.xz.filter.pojo.Expression;
import com.xz.filter.pojo.Source;
import com.xz.util.Ognl;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.*;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/excel")
public class ExcelController {
    /* @Autowired
     private ParagraphMapper paragraphMapper;*/
    @Autowired
    private SourceMapper sourceMapper;
    @Autowired
    private HttpSolrClient httpSolrClient;
    @Autowired
    private ExpressionMapper expressionMapper;
    /*@Resource
    private Properties configs;*/
    private static Logger log = LoggerFactory.getLogger(ExcelController.class);

    /*@RequestMapping(value = "listParagraph", method = RequestMethod.GET)
    public void listParagraph(HttpServletResponse response,
                              @RequestParam(value = "sourceID", required = false, defaultValue = "0") int sourceID,
                              @RequestParam(value = "publishTime1", required = false) String publishTime1,
                              @RequestParam(value = "publishTime2", required = false) String publishTime2,
                              @RequestParam(value = "queryItem", required = false) String queryItem,
                              @RequestParam(value = "queryField", required = false) String queryField,
                              @RequestParam(value = "source", required = false) String source,
                              @RequestParam(value = "search", required = false) String search,
                              @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                              @RequestParam(value = "length", required = false, defaultValue = "100") int limit) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("sourceID", sourceID);
        org.springframework.beans.factory.access.BeanFactoryReference a;
        if (!"".equals(publishTime1) && publishTime1 != null)
            param.put("publishTime1", DateUtils.parseDateDayFormat(publishTime1));
        if (!"".equals(publishTime2) && publishTime2 != null)
            param.put("publishTime2", DateUtils.getNextDay(DateUtils.parseDateDayFormat(publishTime2)));

        if (queryItem != null && !"".equals(queryItem) &&
                queryField != null && !"".equals(queryField)) {
            //param.put(queryItem, queryField);
            param.put("queryItem", queryItem);
            param.put("queryField", queryField);
        }

        param.put("source", source);
        param.put("search", search);
        param.put("start", start);
        param.put("limit", limit);
        int count = paragraphMapper.selectParagraphCount(param);
        //log.debug("count=" + count);
        List<HashMap<String, Object>> paragraphs = paragraphMapper.selectParagraph(param);
       *//* for (HashMap<String, Object> d : paragraphs) {
            if (d.get("link_cn") != null)
                d.put("link_cn", d.get("link_cn").toString().replaceAll("[\"{}]", ""));
        }*//*

        String[] headers = {"来源", "段落", "发布人", "发布时间", "次数"};//, "提取结果"
        String[] prop = {"source", "body", "publisher", "publishTime", "repeatCount"};//, "link"
        // 先循环一次，拿到所有headers
        HashSet<String> classSet = new HashSet<>();
        for (HashMap<String, Object> d : paragraphs) {
            if (d.get("link") != null) {
                JSONObject jsonObject = JSON.parseObject(d.get("link").toString());
                classSet.addAll(jsonObject.keySet());
            }
        }

        List<String> headerList = new ArrayList<>();
        List<String> propList = new ArrayList<>();
        Collections.addAll(headerList, headers);
        Collections.addAll(propList, prop);

        for (String head : classSet) {
            Collections.addAll(headerList, head);
            Collections.addAll(propList, head);
        }

        for (HashMap<String, Object> d : paragraphs) {
            JSONObject jsonObject = JSON.parseObject(d.get("link").toString());
            for (String head : classSet) {
                if (jsonObject.get(head) != null)
                    d.put(head, jsonObject.get(head).toString().replace("https://t.me/", ""));//todo remove replace ,change regular replace it
            }
        }

        OutputStream out = null;
        try {
            XSSFWorkbook workbook = exportExcel("洗米结果",  headerList.toArray(new String[0]), paragraphs, propList.toArray(new String[0]));

            String downFileName = "洗米结果";

            response.setContentType("application/vnd.ms-excel;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                    java.net.URLEncoder.encode(downFileName, "UTF-8") + ".xls");//chrome 、 firefox都正常
            out = response.getOutputStream(); // 输出到文件流
            workbook.write(out);
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }*/

    @RequestMapping(value = "solrSearch", method = RequestMethod.GET)
    public void solrSearch(HttpServletResponse response,
                           @RequestParam(value = "sourceID", required = false, defaultValue = "0") int sourceID,
                           @RequestParam(value = "uploadTime1", required = false) String uploadTime1,
                           @RequestParam(value = "uploadTime2", required = false) String uploadTime2,
                           @RequestParam(value = "queryItem", required = false) String queryItem,
                           @RequestParam(value = "queryField", required = false) String queryField,
                           @RequestParam(value = "source", required = false) String source,
                           @RequestParam(value = "search", required = false) String search) {
        // List<SolrDocument> solrDocuments = new ArrayList<>();
      /*  String url = configs.getProperty("solr_url") + "/filter";
        log.debug("solr_url=" + url);
        SolrClient client = new HttpSolrClient.Builder(url).build();*/

        SolrQuery query = new SolrQuery();
        List<String> q = new ArrayList<>();
        // q.add("body_cn:" + search);
        if (Ognl.isNotEmpty(search)) q.add("body_cn:" + search);
        if (sourceID > 0) q.add("sourceID_i:" + sourceID);
        else if (Ognl.isNotEmpty(source)) q.add("source_cn:" + source);
        if (Ognl.isNotEmpty(queryField)) q.add("link_cn:" + queryField);

        if (q.size() == 0)
            if (Ognl.isNotEmpty(uploadTime1) && Ognl.isNotEmpty(uploadTime2)) {
                Map<String, Object> param = new HashMap<>();
                param.put("uploadTime1", uploadTime1);
                param.put("uploadTime2", DateUtil.formatDateTime(DateUtil.offsetDay(DateUtil.parseDate(uploadTime2), 1)).substring(0, 10));
                List<Source> sources = sourceMapper.selectSource(param);

                if (sources.size() > 0) {
                    List<String> orq = new ArrayList<>();
                    for (Source s : sources) {
                        orq.add("sourceID_i:" + s.getSourceID());
                    }
                    q.add("(" + String.join(" OR ", orq) + ")");
                } else
                    q.add("sourceID_i:" + 0);
            /*q.add(String.format("insertTime_dt:[%sT00:00:00.000Z TO %sT00:00:00.000Z]", uploadTime1,
                    DateUtil.formatDateTime(DateUtil.offsetDay(DateUtil.parseDate(uploadTime2), 1)).substring(0, 10)));*/
            }
        /*if (Ognl.isNotEmpty(uploadTime1) && Ognl.isNotEmpty(uploadTime2))
            q.add(String.format("insertTime_dt:[%sT00:00:00.000Z TO %sT00:00:00.000Z]", uploadTime1,
                    DateUtil.formatDateTime(DateUtil.offsetDay(DateUtil.parseDate(uploadTime2), 1)).substring(0, 10)));
        log.debug(String.format("insertTime_dt:[\"%sT00:00:00.000Z\" TO \"%sT00:00:00.000Z\" ]", uploadTime1, uploadTime2));*/
        //log.debug("q=" + String.join(" AND ", q));

        query.set("q", q.size() > 0 ? String.join(" AND ", q) : "body_cn:*");  //查询条件
        //query.set("df", "paragraph_body");  //查询条件
        //query.set("fl", "id");  //查询的项目
        query.setStart(0);  //起始index
        query.setRows(1048575 * 20);  //终了index
        query.set("sort", "id asc"); //sort key指定
        try {
            // 返回QueryResponse
            QueryResponse queryResponse = httpSolrClient.query(query);
            // client.close();
            // 返回Document
            SolrDocumentList docs = queryResponse.getResults();
            List<Expression> expressions = expressionMapper.selectExpression(new HashMap<>());
            String[] headers = {"来源", "段落", "发布人", "发贴时间", "次数"};//, "提取结果"
            String[] prop = {"source_cn", "body_cn", "publisher_cn", "publishTime", "repeatCount_i"};// "link_cn"
            /*List<String> headerList = Arrays.asList("来源", "段落", "发布人", "发贴时间", "次数");//, "飞机", "skype", "微信", "QQ"};//, "提取结果"
            List<String> propList = Arrays.asList("source_cn", "body_cn", "publisher_cn", "publishTime", "repeatCount_i");//, "telegram", "skype", "wx", "qq"};// "link_cn"*/

            // 先循环一次，拿到所有headers
            //
            HashSet<String> classSet = new HashSet<>();
            /*for (SolrDocument d : docs) {
                 //JSONObject jsonObject = JSON.parseObject(d.getFieldValue("link_cn").toString());//solr 8.6.3
                JSONObject jsonObject = JSON.parseObject(d.getFieldValues("link_cn").toArray()[0].toString());//solr 8.11.2
                classSet.addAll(jsonObject.keySet());
            }*/
            for (Expression expr : expressions) {
                //JSONObject jsonObject = JSON.parseObject(d.getFieldValue("link_cn").toString());//solr 8.6.3
                classSet.add(expr.getExpressionName());
            }

            List<String> headerList = new ArrayList<>();
            List<String> propList = new ArrayList<>();
            Collections.addAll(headerList, headers);
            Collections.addAll(propList, prop);

            for (String head : classSet) {
                headerList.add(head);
                propList.add(head);
            }

          /*  final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            //int k = 0;
            for (SolrDocument d : docs) {
                //JSONObject jsonObject = JSON.parseObject(d.getFieldValue("link_cn").toString());//solr 8.6.3
                JSONObject jsonObject = JSON.parseObject(d.getFieldValues("link_cn").toArray()[0].toString());//solr 8.11.2
                for (String head : classSet) {
                    if (jsonObject.get(head) != null)
                        d.setField(head, jsonObject.get(head).toString().replace("https://t.me/", ""));//todo remove replace ,change regular replace it
                }
                //if (k++ < 10) log.info(sdf.format((Date) d.getFieldValue("publishTime_dt")));
                d.setField("publishTime", sdf.format((Date) d.getFieldValue("publishTime_dt")));
            }*/

            OutputStream out = null;

            SXSSFWorkbook workbook = null;
            try {
                workbook = new SXSSFWorkbook();
                workbook.setCompressTempFiles(true); //压缩临时文件，很重要，否则磁盘很快就会被写满
                // for (int fromIndex = 0; fromIndex < docs.size(); fromIndex += 10000 * 100) {//max：1048575
                exportSolrExcel(workbook,  headerList.toArray(new String[0]), docs, propList.toArray(new String[0]), classSet.size());
                //  String downFileName = "洗米结果_" + uploadTime1 + "～" + uploadTime2;
                String downFileName = "洗米结果_" + uploadTime1 + "～" + uploadTime2;

                response.setContentType("application/vnd.ms-excel;charset=UTF-8");
                response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                        java.net.URLEncoder.encode(downFileName, "UTF-8") + ".xlsx");//chrome 、 firefox都正常
                out = response.getOutputStream(); // 输出到文件流
                workbook.write(out);
                out.flush();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (workbook != null) {
                    workbook.dispose();// 删除临时文件，很重要，否则磁盘可能会被写满
                }
                if (out != null) {
                    out.close();
                }
            }
        } catch (SolrServerException | IOException e) {
            e.printStackTrace();
        }

    }

    //通用格式
    private XSSFWorkbook exportExcel(String title, String[] headers, List dataset, String[] prop) throws Exception {
        // 声明一个工作薄
        XSSFWorkbook workbook = new XSSFWorkbook();
        int titleIndex = 1;
        for (int fromIndex = 0; fromIndex < dataset.size(); fromIndex += 1048575) {
            // 生成一个表格
            XSSFSheet sheet = workbook.createSheet(title + titleIndex++);

            //产生表格标题行
            XSSFRow row = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                XSSFCell cell = row.createCell(i);
                // cell.setCellStyle(style);
                XSSFRichTextString text = new XSSFRichTextString(headers[i]);
                cell.setCellValue(text);
            }

            //遍历集合数据，产生数据行
            Iterator it = dataset.subList(fromIndex, Math.min(fromIndex + 1048575, dataset.size())).iterator();
            int index = 0;
            while (it.hasNext()) {
                index++;
                row = sheet.createRow(index);
                Object object = it.next();
                //利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值
                for (int i = 0; i < prop.length; i++) {
                    XSSFCell cell = row.createCell(i);
                    //cell.setCellStyle(style2);

                    Object value = BeanUtils.getProperty(object, prop[i]);
                    //判断值的类型后进行强制类型转换
                    String textValue = null;
                    //其它数据类型都当作字符串简单处理
                    if (value != null) {
                        textValue = value.toString();
                    /*if (Verify.validShortDate(StringUtils.substring(textValue, 0, 10)))
                        textValue = StringUtils.substring(textValue, 0, 10);*/
                    }
                    //如果不是图片数据，就利用正则表达式判断textValue是否全部由数字组成
                    if (textValue != null) {
                  /*  Pattern p = Pattern.compile("^\\d+(\\.\\d+)?$");
                    Matcher matcher = p.matcher(textValue);
                    if (matcher.matches()) {
                        //是数字当作double处理
                        cell.setCellValue(Double.parseDouble(textValue));
                    } else {*/
                        XSSFRichTextString richString = new XSSFRichTextString(textValue);
                        cell.setCellValue(richString);
                        //}
                    }
                }
            }
        }
        return workbook;
    }

    //Solr 专用格式
    private SXSSFWorkbook exportSolrExcel(SXSSFWorkbook workbook,  String[] headers, SolrDocumentList docs, String[] prop, int dynamic) throws Exception {
        final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        // 声明一个工作薄
       /* SXSSFWorkbook workbook = new SXSSFWorkbook();
        workbook.setCompressTempFiles(true); //压缩临时文件，很重要，否则磁盘很快就会被写满*/
        int titleIndex = 1;
        for (int fromIndex = 0; fromIndex < docs.size(); fromIndex += 10000*100) {
            // 生成一个表格
            SXSSFSheet sheet = workbook.createSheet("洗米结果" + titleIndex++);

            //产生表格标题行
            SXSSFRow row = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                SXSSFCell cell = row.createCell(i);
                // cell.setCellStyle(style);
                XSSFRichTextString text = new XSSFRichTextString(headers[i]);
                cell.setCellValue(text);
            }

            //遍历集合数据，产生数据行
            Iterator<SolrDocument> it = docs.subList(fromIndex, Math.min(fromIndex + 10000*100, docs.size())).iterator();
            int index = 0;
            while (it.hasNext()) {
                index++;
                row = sheet.createRow(index);
                SolrDocument doc = it.next();
                //利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值
                for (int i = 0; i < prop.length; i++) {
                    SXSSFCell cell = row.createCell(i);
                    //cell.setCellStyle(style2);

                    // Object value = BeanUtils.getProperty(doc, prop[i]);
                    JSONObject jsonObject = JSON.parseObject(doc.getFieldValues("link_cn").toArray()[0].toString());

                    Object value = null;
                    if (i < prop.length - dynamic) {
                        if ("body_cn".equals(prop[i])) {
                            value = doc.getFieldValues(prop[i]).toArray()[0];
                        } else if ("publishTime".equals(prop[i])) {
                            value = sdf.format((Date) doc.getFieldValue("publishTime_dt"));
                        } else
                            value = doc.getFieldValue(prop[i]);
                    } else {
                        if (jsonObject.get(prop[i]) != null)
                            value = jsonObject.get(prop[i]).toString().replace("https://t.me/", "");
                    }

                    //当作字符串简单处理
                    if (value != null) {
                        XSSFRichTextString richString = new XSSFRichTextString(value.toString());
                        cell.setCellValue(richString);
                    }
                }
            }
        }
        return workbook;
    }
}

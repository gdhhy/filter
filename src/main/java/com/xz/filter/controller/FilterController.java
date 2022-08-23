package com.xz.filter.controller;

import cn.hutool.core.date.DateUtil;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.xz.filter.SolrIndex;
import com.xz.filter.SourceService;
import com.xz.filter.dao.ExpressionMapper;
import com.xz.filter.dao.HtmlMapper;
import com.xz.filter.dao.RegularMapper;
import com.xz.filter.dao.SourceMapper;
import com.xz.filter.pojo.Expression;
import com.xz.filter.pojo.Regular;
import com.xz.filter.pojo.Source;
import com.xz.pinyin.ChineseWord;
import com.xz.pinyin.PinyinUtil;
import com.xz.rbac.web.DeployRunning;
import com.xz.util.Ognl;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocumentList;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.*;

import static com.xz.util.ControllerHelp.wrap;

@Controller
@RequestMapping("/filter")

public class FilterController implements InitializingBean {
    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;
    @Autowired
    private SourceMapper sourceMapper;
    @Autowired
    private HtmlMapper htmlMapper;
    //@Autowired
    //private ParagraphMapper paragraphMapper;
    @Autowired
    private RegularMapper regularMapper;
    @Autowired
    private ExpressionMapper expressionMapper;
    @Autowired
    private HttpSolrClient httpSolrClient;
    @Resource
    private Properties configs;

    private static PinyinUtil pinyinUtil = new PinyinUtil();


    //private static String deployDir = DeployRunning.getDir();
    /*@Resource
    private Properties configs;*/
    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm").serializeNulls().create();
    private static Logger log = LoggerFactory.getLogger(FilterController.class);

    @Override
    public void afterPropertiesSet() {
        loadSources();
    }

    /*@ResponseBody
        @RequestMapping(value = "getConfigs", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
        public String getConfigs() {
            Map<String, Object> result = new HashMap<>();
            result.put("qq", configs.getProperty("qq"));
            result.put("wx", configs.getProperty("wx"));
            result.put("telegram", configs.getProperty("telegram"));
            result.put("skype", configs.getProperty("skype"));

            return gson.toJson(result);
        }

        @ResponseBody
        @Transactional
        @RequestMapping(value = "/saveConfigs", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
        public String saveConfigs(@RequestBody String string) {
            Map<String, Object> result = new HashMap<>();
            JsonParser parser = new JsonParser();
            JsonObject json = (JsonObject) parser.parse(string);

            configs.setProperty("qq", json.get("qq").getAsString().trim());
            configs.setProperty("wx", json.get("wx").getAsString().trim());
            configs.setProperty("telegram", json.get("telegram").getAsString().trim());
            configs.setProperty("skype", json.get("skype").getAsString().trim());

            try {
                //OutputStream out = new FileOutputStream("classpath:config.properties");
                log.debug("config:" + deployDir + "WEB-INF" + File.separator + "classes" + File.separator + "config.properties");
                OutputStream out = new FileOutputStream(deployDir + "WEB-INF" + File.separator + "classes" + File.separator + "config.properties");
                configs.store(out, "保存");
                out.close();

                result.put("succeed", true);
                result.put("message", "保存成功！");
            } catch (IOException e) {
                e.printStackTrace();
                result.put("message", e.getMessage());
            }

            result.putIfAbsent("succeed", false);
            return gson.toJson(result);
        }*/
    @Scheduled(cron = "0 0 *  * * ? ")
    public void loadSources() {
        log.debug("loadSources");
        pinyinUtil.clear();
        //if (sources == null)
        List<Source> sources = sourceMapper.selectSource(new HashMap<>());
        for (Source s : sources)
            pinyinUtil.addWords(s.getSource(), s);
    }

    @ResponseBody
    @RequestMapping(value = "liveSource", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String liveSource(@RequestParam(value = "pinyin", required = false) String pinyin) {
        ChineseWord[] words = pinyinUtil.distinguish(pinyin);
        List<Source> sources = new ArrayList<>(words.length);
        for (int i = 0; i < words.length; i++)
            sources.add(i, (Source) words[i].getObjRef());

        return gson.toJson(sources);
    }

    @ResponseBody
    @RequestMapping(value = "listSource", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listSource(@RequestParam(value = "draw", required = false) Integer draw,
                             @RequestParam(value = "sourceID", required = false) Integer sourceID,
                             @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                             @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();

        param.put("start", start);
        param.put("limit", limit);
        param.put("sourceID", sourceID);
        int count = sourceMapper.selectSourceCount(param);
        log.debug("count=" + count);
        List<Map<String, Object>> sources = sourceMapper.querySource(param);

        Map<String, Object> result = new HashMap<>();
        result.put("draw", draw);
        result.put("data", sources);
        result.put("iTotalRecords", count);//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", count);

        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "listRegular", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listRegular(@RequestParam(value = "draw", required = false) Integer draw,
                              @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                              @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();

        param.put("start", start);
        param.put("limit", limit);
        //int count = sourceMapper.selectSourceCount(param);
        // log.debug("count=" + count);
        List<Regular> regulars = regularMapper.selectRegular(param);

        Map<String, Object> result = new HashMap<>();
        result.put("draw", draw);
        result.put("data", regulars);
        result.put("iTotalRecords", regulars.size());//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", regulars.size());

        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "getRegular", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getRegular(@RequestParam(value = "regularID") Integer regularID) {
        return gson.toJson(regularMapper.getRegular(regularID));
    }

    /*@ResponseBody
    @Transactional
    @RequestMapping(value = "/saveRegular", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveRegular(@ModelAttribute("regular") Regular regular) {
        log.debug("JsonElement:" + regular.getExpression().toString());
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Map<String, Object> map = new HashMap<>();
        if (principal instanceof UserDetails) {

            log.debug("regular = " + regular);
            int result;
            map.put("title", "保存正规式配置");
            if (regular.getRegularID() > 0)
                result = regularMapper.updateRegular(regular);
            else
                result = regularMapper.insertRegular(regular);
            map.put("succeed", result > 0);
        } else {
            map.put("title", "保存正规式配置");
            map.put("succeed", false);
            map.put("message", "没登录用户信息，请重新登录！");
        }

        return gson.toJson(map);
    }*/
    @ResponseBody
    @Transactional
    @RequestMapping(value = "/saveRegular", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveRegular(@RequestBody String postJson) {
        Type regularType = new TypeToken<Regular>() {
        }.getType();
        Regular regular = gson.fromJson(postJson, regularType);

      /*  log.debug("regular = " + regular);
        log.debug("regular.expression = " + regular.getExpression()); */
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Map<String, Object> map = new HashMap<>();
        if (principal instanceof UserDetails) {
            int result;
            map.put("title", "保存正规式配置");
            if (regular.getRegularID() > 0)
                result = regularMapper.updateRegular(regular);
            else
                result = regularMapper.insertRegular(regular);
            map.put("succeed", result > 0);
        } else {
            map.put("title", "保存正规式配置");
            map.put("succeed", false);
            map.put("message", "没登录用户信息，请重新登录！");
        }

        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "/saveSourceSource", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveSourceSource(@RequestParam("sourceID") int sourceID, @RequestParam("source") String source) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> param = new HashMap<>();
        param.put("sourceID", sourceID);

        List<Source> sources = sourceMapper.selectSource(param);//目的是取文件信息,删除之
        if (sources.size() > 0) {
            Source s = sources.get(0);
            s.setSource(source);
            int k = sourceMapper.updateSource(s);
            map.put("succeed", k > 0);
            map.put("message", "修改文件来源成功！");
            loadSources();
        }

        map.putIfAbsent("succeed", false);
        map.putIfAbsent("message", "修改文件来源失败！");
        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "/indexSource", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String indexSource(@RequestParam("sourceID") int sourceID) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> param = new HashMap<>();
        param.put("sourceID", sourceID);
        List<Source> sources = sourceMapper.selectSource(param);
        SolrIndex service = new SolrIndex(sourceMapper, httpSolrClient, sources.get(0));
        Thread t = new Thread(service);
        t.start();

        map.put("succeed", true);
        map.put("message", "索引进程已启动，请等候片刻！");
        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "/deleteSource", method = RequestMethod.POST)
    public String deleteSource(@RequestParam("sourceID") int sourceID) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> param = new HashMap<>();
        param.put("sourceID", sourceID);
        //int deleteCount = paragraphMapper.deleteParagraphBySourceID(sourceID);
        int deleteCount = htmlMapper.deleteHtml(sourceID);
        List<Source> sources = sourceMapper.selectSource(param);//目的是取文件信息,删除之

        if (sources.size() == 1) {
            Source source = sources.get(0);
            log.debug(DeployRunning.getDir() + source.getServerPath() + File.separator + source.getServerFilename());
            File file = new File(DeployRunning.getDir() + source.getServerPath() + File.separator + source.getServerFilename());
            map.put("deleteFileSucceed", file.delete());
        }
        try {
            httpSolrClient.deleteByQuery("sourceID_i:" + sourceID);
            httpSolrClient.commit();
        } catch (SolrServerException | IOException e) {
            e.printStackTrace();
            map.put("errmsg", e.getMessage());
            map.put("succeed", false);
        }

        deleteCount += sourceMapper.deleteSource(sourceID);

        map.putIfAbsent("succeed", deleteCount > 0);
        map.put("affectedRowCount", deleteCount);

        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "/deleteRegular", method = RequestMethod.POST)
    public String deleteRegular(@RequestParam("regularID") int regularID) {
        Map<String, Object> map = new HashMap<>();

        int deleteCount = regularMapper.deleteRegular(regularID);
        map.put("succeed", deleteCount > 0);
        map.put("affectedRowCount", deleteCount);

        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "/parseSource", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String parseSource(@RequestParam("sourceID") int sourceID, @RequestParam("regularID") int regularID) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> param = new HashMap<>();
        param.put("sourceID", sourceID);
        //int deleteCount = paragraphMapper.deleteParagraphBySourceID(sourceID);//先删除旧的，再解析
        int deleteCount = htmlMapper.deleteHtml(sourceID);//先删除旧的，再解析
        List<Source> sources = sourceMapper.selectSource(param);

        if (sources.size() == 1) {
            Source source = sources.get(0);
            source.setRegularID(regularID);
            source.setParseStatus(3);
            sourceMapper.updateSource(source);
            SourceService sourceService = new SourceService(htmlMapper, regularMapper, expressionMapper, sourceMapper, httpSolrClient);
            sourceService.setSource(source);
            Thread ss = new Thread(sourceService);
            ss.start();
        }
        map.put("message", "分析进程已启动，请耐心等候。");
        map.put("succeed", true);
        //map.put("deleteParaCount", 0);
        map.put("deleteParaCount", deleteCount);

        return gson.toJson(map);
    }

    /*@ResponseBody
    @RequestMapping(value = "listParagraph", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listParagraph(@RequestParam(value = "sourceID", required = false, defaultValue = "0") int sourceID,
                                @RequestParam(value = "publishTime1", required = false) String publishTime1,
                                @RequestParam(value = "publishTime2", required = false) String publishTime2,
                                @RequestParam(value = "queryItem", required = false) String queryItem,
                                @RequestParam(value = "queryField", required = false) String queryField,
                                @RequestParam(value = "source", required = false) String source,
                                @RequestParam(value = "search", required = false) String search,
                                @RequestParam(value = "draw", required = false) Integer draw,
                                @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                                @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("sourceID", sourceID);
        if (Ognl.isNotEmpty(publishTime1))
            param.put("publishTime1", DateUtils.parseDateDayFormat(publishTime1));
        if (Ognl.isNotEmpty(publishTime2))
            param.put("publishTime2", DateUtils.getNextDay(DateUtils.parseDateDayFormat(publishTime2)));

        if (Ognl.isNotEmpty(queryItem) && Ognl.isNotEmpty(queryField)) {
            //param.put(queryItem, queryField);
            param.put("queryItem", queryItem);
            param.put("queryField", queryField);
        }
        param.put("source", source);
        param.put("search", search);
        param.put("start", start);
        param.put("limit", limit);
        int count = paragraphMapper.selectParagraphCount(param);
        log.debug("count=" + count);
        List<HashMap<String, Object>> paragraphs = paragraphMapper.selectParagraph(param);
        return wrap(draw, paragraphs, count);
    }*/

    @ResponseBody
    @RequestMapping(value = "solrSearch", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String solrSearch(@RequestParam(value = "sourceID", required = false, defaultValue = "0") int sourceID,
                             @RequestParam(value = "uploadTime1", required = false) String uploadTime1,
                             @RequestParam(value = "uploadTime2", required = false) String uploadTime2,
                             //@RequestParam(value = "queryItem", required = false) String queryItem,
                             @RequestParam(value = "queryField", required = false) String queryField,
                             @RequestParam(value = "source", required = false) String source,
                             @RequestParam(value = "search", required = false) String search,
                             @RequestParam(value = "draw", required = false) Integer draw,
                             @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                             @RequestParam(value = "length", required = false, defaultValue = "100") int limit) throws Exception {
        // List<SolrDocument> solrDocuments = new ArrayList<>();
        // String url = configs.getProperty("solr_url") + "/filter";
        //log.debug("solr_url=" + url);
        /*HttpSolrClient client = new HttpSolrClient.Builder(url).build();*/

        SolrQuery query = new SolrQuery();
        List<String> q = new ArrayList<>();
        // q.add("body_cn:" + search);
        if (Ognl.isNotEmpty(search)) q.add("body_cn:" + search);
        if (sourceID > 0) q.add("sourceID_i:" + sourceID);
        else if (Ognl.isNotEmpty(source)) q.add("source_cn:" + source);
        if (Ognl.isNotEmpty(queryField)) q.add("link_cn:" + queryField);
        //log.info("q=" + String.join(" AND ", q));
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
        //log.info(String.format("insertTime_dt:[\"%sT00:00:00.000Z\" TO \"%sT00:00:00.000Z\" ]",uploadTime1, uploadTime2));
        //log.info(q.toString());

        query.set("q", q.size() > 0 ? String.join(" AND ", q) : "body_cn:*");  //查询条件
        //query.set("df", "paragraph_body");  //查询条件
        //query.set("fl", "id");  //查询的项目
        query.setStart(start);  //起始index
        query.setRows(limit);  //终了index
        query.set("sort", "id asc"); //sort key指定
        // log.info(query.toString());

        // 返回QueryResponse
        QueryResponse response = httpSolrClient.query(query);
        //log.debug("query finish!");
        //client.close();
        // 返回Document
        SolrDocumentList docs = response.getResults();

        return wrap(draw, docs, (int) docs.getNumFound());
    }

    //expression 管理
    @ResponseBody
    @RequestMapping(value = "listExpression", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listExpression(@RequestParam(value = "draw", required = false, defaultValue = "1") int draw,
                                 @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                                 @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();

        param.put("start", start);
        param.put("limit", limit);
        //int count = sourceMapper.selectSourceCount(param);
        // log.debug("count=" + count);
        List<Expression> expressions = expressionMapper.selectExpression(param);
        return wrap(draw, expressions);
       /* Map<String, Object> result = new HashMap<>();
        result.put("draw", draw);
        result.put("data", expressions);
        result.put("iTotalRecords", expressions.size());//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", expressions.size());

        return gson.toJson(result);*/
    }

    @ResponseBody
    @RequestMapping(value = "getExpression", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getExpression(@RequestParam(value = "expressionID") int expressionID) {
        Map<String, Object> param = new HashMap<>();
        param.put("expressionID", expressionID);
        return gson.toJson(expressionMapper.selectExpression(param));
    }

    @ResponseBody
    @Transactional
    @RequestMapping(value = "/saveExpression", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveExpression(@ModelAttribute("expression") Expression expression) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Map<String, Object> map = new HashMap<>();
        if (principal instanceof UserDetails) {

            log.debug("expression = " + expression);
            int result;
            map.put("title", "保存正规式配置");
            if (expression.getExpressionID() > 0)
                result = expressionMapper.updateExpression(expression);
            else
                result = expressionMapper.insertExpression(expression);
            map.put("succeed", result > 0);
        } else {
            map.put("title", "保存正规式配置");
            map.put("succeed", false);
            map.put("message", "没登录用户信息，请重新登录！");
        }

        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "/deleteExpression", method = RequestMethod.POST)
    public String deleteExpression(@RequestParam("expressionID") int expressionID) {
        Map<String, Object> map = new HashMap<>();

        int deleteCount = expressionMapper.deleteExpression(expressionID);
        map.put("succeed", deleteCount > 0);
        map.put("affectedRowCount", deleteCount);

        return gson.toJson(map);
    }

}

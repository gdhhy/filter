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
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
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
    private static Logger log = LogManager.getLogger(ExcelController.class);

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

        String[] headers = {"??????", "??????", "?????????", "????????????", "??????"};//, "????????????"
        String[] prop = {"source", "body", "publisher", "publishTime", "repeatCount"};//, "link"
        // ??????????????????????????????headers
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
            XSSFWorkbook workbook = exportExcel("????????????",  headerList.toArray(new String[0]), paragraphs, propList.toArray(new String[0]));

            String downFileName = "????????????";

            response.setContentType("application/vnd.ms-excel;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                    java.net.URLEncoder.encode(downFileName, "UTF-8") + ".xls");//chrome ??? firefox?????????
            out = response.getOutputStream(); // ??????????????????
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

        query.set("q", q.size() > 0 ? String.join(" AND ", q) : "body_cn:*");  //????????????
        //query.set("df", "paragraph_body");  //????????????
        //query.set("fl", "id");  //???????????????
        query.setStart(0);  //??????index
        query.setRows(1048575 * 20);  //??????index
        query.set("sort", "id asc"); //sort key??????
        try {
            // ??????QueryResponse
            QueryResponse queryResponse = httpSolrClient.query(query);
            // client.close();
            // ??????Document
            SolrDocumentList docs = queryResponse.getResults();
            List<Expression> expressions = expressionMapper.selectExpression(new HashMap<>());
            String[] headers = {"??????", "??????", "?????????", "????????????", "??????"};//, "????????????"
            String[] prop = {"source_cn", "body_cn", "publisher_cn", "publishTime", "repeatCount_i"};// "link_cn"
            /*List<String> headerList = Arrays.asList("??????", "??????", "?????????", "????????????", "??????");//, "??????", "skype", "??????", "QQ"};//, "????????????"
            List<String> propList = Arrays.asList("source_cn", "body_cn", "publisher_cn", "publishTime", "repeatCount_i");//, "telegram", "skype", "wx", "qq"};// "link_cn"*/

            // ??????????????????????????????headers
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
                workbook.setCompressTempFiles(true); //??????????????????????????????????????????????????????????????????
                // for (int fromIndex = 0; fromIndex < docs.size(); fromIndex += 10000 * 100) {//max???1048575
                exportSolrExcel(workbook,  headerList.toArray(new String[0]), docs, propList.toArray(new String[0]), classSet.size());
                //  String downFileName = "????????????_" + uploadTime1 + "???" + uploadTime2;
                String downFileName = "????????????_" + uploadTime1 + "???" + uploadTime2;

                response.setContentType("application/vnd.ms-excel;charset=UTF-8");
                response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                        java.net.URLEncoder.encode(downFileName, "UTF-8") + ".xlsx");//chrome ??? firefox?????????
                out = response.getOutputStream(); // ??????????????????
                workbook.write(out);
                out.flush();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (workbook != null) {
                    workbook.dispose();// ???????????????????????????????????????????????????????????????
                }
                if (out != null) {
                    out.close();
                }
            }
        } catch (SolrServerException | IOException e) {
            e.printStackTrace();
        }

    }

    //????????????
    private XSSFWorkbook exportExcel(String title, String[] headers, List dataset, String[] prop) throws Exception {
        // ?????????????????????
        XSSFWorkbook workbook = new XSSFWorkbook();
        int titleIndex = 1;
        for (int fromIndex = 0; fromIndex < dataset.size(); fromIndex += 1048575) {
            // ??????????????????
            XSSFSheet sheet = workbook.createSheet(title + titleIndex++);

            //?????????????????????
            XSSFRow row = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                XSSFCell cell = row.createCell(i);
                // cell.setCellStyle(style);
                XSSFRichTextString text = new XSSFRichTextString(headers[i]);
                cell.setCellValue(text);
            }

            //????????????????????????????????????
            Iterator it = dataset.subList(fromIndex, Math.min(fromIndex + 1048575, dataset.size())).iterator();
            int index = 0;
            while (it.hasNext()) {
                index++;
                row = sheet.createRow(index);
                Object object = it.next();
                //?????????????????????javabean????????????????????????????????????getXxx()?????????????????????
                for (int i = 0; i < prop.length; i++) {
                    XSSFCell cell = row.createCell(i);
                    //cell.setCellStyle(style2);

                    Object value = BeanUtils.getProperty(object, prop[i]);
                    //?????????????????????????????????????????????
                    String textValue = null;
                    //????????????????????????????????????????????????
                    if (value != null) {
                        textValue = value.toString();
                    /*if (Verify.validShortDate(StringUtils.substring(textValue, 0, 10)))
                        textValue = StringUtils.substring(textValue, 0, 10);*/
                    }
                    //?????????????????????????????????????????????????????????textValue???????????????????????????
                    if (textValue != null) {
                  /*  Pattern p = Pattern.compile("^\\d+(\\.\\d+)?$");
                    Matcher matcher = p.matcher(textValue);
                    if (matcher.matches()) {
                        //???????????????double??????
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

    //Solr ????????????
    private SXSSFWorkbook exportSolrExcel(SXSSFWorkbook workbook,  String[] headers, SolrDocumentList docs, String[] prop, int dynamic) throws Exception {
        final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        // ?????????????????????
       /* SXSSFWorkbook workbook = new SXSSFWorkbook();
        workbook.setCompressTempFiles(true); //??????????????????????????????????????????????????????????????????*/
        int titleIndex = 1;
        for (int fromIndex = 0; fromIndex < docs.size(); fromIndex += 10000*100) {
            // ??????????????????
            SXSSFSheet sheet = workbook.createSheet("????????????" + titleIndex++);

            //?????????????????????
            SXSSFRow row = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                SXSSFCell cell = row.createCell(i);
                // cell.setCellStyle(style);
                XSSFRichTextString text = new XSSFRichTextString(headers[i]);
                cell.setCellValue(text);
            }

            //????????????????????????????????????
            Iterator<SolrDocument> it = docs.subList(fromIndex, Math.min(fromIndex + 10000*100, docs.size())).iterator();
            int index = 0;
            while (it.hasNext()) {
                index++;
                row = sheet.createRow(index);
                SolrDocument doc = it.next();
                //?????????????????????javabean????????????????????????????????????getXxx()?????????????????????
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

                    //???????????????????????????
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

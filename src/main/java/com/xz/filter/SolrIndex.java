package com.xz.filter;


import com.xz.filter.dao.SourceMapper;
import com.xz.filter.pojo.Source;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.common.SolrInputDocument;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
@Deprecated
@Service
public class SolrIndex implements Runnable {
    private static Logger log = LogManager.getLogger(SolrIndex.class);
    private HttpSolrClient httpSolrClient;
    private SourceMapper sourceMapper;
   // private ParagraphMapper paragraphMapper;
    private Source source;

    public SolrIndex(SourceMapper sourceMapper,  HttpSolrClient httpSolrClient, Source source) {
        this.sourceMapper = sourceMapper;
        //this.paragraphMapper = paragraphMapper;
        this.httpSolrClient=httpSolrClient;
        this.source = source;
    }

    @Override
    public void run() {
        long startSecond = System.currentTimeMillis();
//1.创建 HttpSolrClient.Builder 对象，通过它创建客户端通信
       /* HttpSolrClient.Builder builder = new HttpSolrClient.Builder(configs.get("solr_url").toString());
        HttpSolrClient solrClient = builder.build();*/

        //2.通过 client 将 document 加入索引库
       /* try {
            int start = 0, limit = 10000;
            Map<String, Object> param = new HashMap<>();
            param.put("limit", limit);
            param.put("sourceID", source.getSourceID());
            while (true) {
                log.debug("创建索引，开始记录：" + start);
                param.put("start", start);
                List<HashMap<String, Object>> paras = paragraphMapper.selectParagraphForIndex(param);
                if (paras.size() > 0) {
                    //参数1是 solr core 的名字
                    httpSolrClient.add( getDocuments(paras));
                    httpSolrClient.commit();
                    start = start + limit;
                }
                if (paras.size() == 0 || paras.size() < limit)
                    break;
            }
            log.debug("创建索引库完成");
        } catch (SolrServerException | IOException e) {
            e.printStackTrace();
        }
        source.setIndexTime(System.currentTimeMillis() - startSecond );
        sourceMapper.updateSource(source);*/
    }

    private List<SolrInputDocument> getDocuments(List<HashMap<String, Object>> paragraphs) {
        List<SolrInputDocument> documents = new ArrayList<>();

        paragraphs.forEach(para -> {
            SolrInputDocument document = new SolrInputDocument();
            for (String key : para.keySet()) {
               // log.debug(key);
                document.addField(key, para.get(key));
            }
            documents.add(document);
        });

        return documents;
    }


}

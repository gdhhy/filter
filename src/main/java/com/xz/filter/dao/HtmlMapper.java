package com.xz.filter.dao;

import com.xz.filter.pojo.Html;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface HtmlMapper {
    List<Html> selectHtml(@Param("param") Map<String, Object> param);

    Html getHtmlByCheckCode(String checkCode);

    //List<Map<String,Object>> queryHtml(@Param("param") Map<String, Object> param);

    int selectHtmlCount(@Param("param") Map<String, Object> param);

    int updateHtml(@Param("pojo") Html html);

    int deleteHtml(@Param("sourceID") int sourceID);

    int insertHtml(@Param("pojo") Html html);
}

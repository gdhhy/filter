package com.xz.filter.dao;

import com.xz.filter.pojo.Source;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface SourceMapper {
    List<Source> selectSource(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> querySource(@Param("param") Map<String, Object> param);

    int selectSourceCount(@Param("param") Map<String, Object> param);

    int updateSource(@Param("pojo") Source source);

    int refreshSource(@Param("pojo") Source source);

    //int updateSourceSource(@Param("pojo") Source source);

    // int repeatParagraph(@Param("pojo") Source source);

    int deleteSource(@Param("sourceID") int sourceID);

    int insertSource(@Param("pojo") Source source);
}

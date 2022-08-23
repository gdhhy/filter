package com.xz.filter.dao;

import com.xz.filter.pojo.Paragraph;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
public interface ParagraphMapper {
    List<HashMap<String, Object>> selectParagraph(@Param("param") Map<String, Object> param);

    List<HashMap<String, Object>> selectParagraphForIndex(@Param("param") Map<String, Object> param);

    List<HashMap<String, Object>> selectParagraphForIndexCount(@Param("param") Map<String, Object> param);

    //Paragraph getParagraphByCheckCode(@Param("pojo") Paragraph paragraph);

    int selectParagraphCount(@Param("param") Map<String, Object> param);

    // int repeatParagraph(@Param("pojo") Paragraph paragraph);
    //  int updateParagraph(@Param("pojo") Paragraph paragraph);

    int deleteParagraphBySourceID(@Param("sourceID") int sourceID);

    int deleteRepeatParagraph(@Param("htmlID") int htmlID);

    int calcRepeatParagraph(@Param("htmlID") int htmlID);

    int insertParagraph(@Param("pojo") Paragraph paragraph);
}

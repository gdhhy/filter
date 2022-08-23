package com.xz.filter.dao;

import com.xz.filter.pojo.Regular;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface RegularMapper {
    List<Regular> selectRegular(@Param("param") Map<String, Object> param);

    Regular getRegular(@Param("regularID") int regularID);

    int selectRegularCount(@Param("param") Map<String, Object> param);

    int updateRegular(@Param("pojo") Regular regular);

    int deleteRegular(@Param("regularID") int regularID);

    int insertRegular(@Param("pojo") Regular regular);
}

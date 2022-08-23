package com.xz.filter.dao;

import com.xz.filter.pojo.Expression;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ExpressionMapper {
    List<Expression> selectExpression(@Param("param") Map<String, Object> param);

    //int selectExpressionCount(@Param("param") Map<String, Object> param);

    int updateExpression(@Param("pojo") Expression expression);

    int deleteExpression(@Param("expressionID") int expressionID);

    int insertExpression(@Param("pojo") Expression expression);

    /*RegularExpression*/
    int deleteRegularExpression(@Param("regularID") int regularID);

    int insertRegularExpression(@Param("param") Map<String, Object> param);
}

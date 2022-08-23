package com.xz.filter.pojo;

import java.io.Serializable;
import java.util.regex.Pattern;

public class Expression implements Serializable {
    private int expressionID;
    private String expressionName;
    private String capturingName;
    private String exp;
    private int orderID;
    private Pattern pattern;

    public int getExpressionID() {
        return expressionID;
    }

    public void setExpressionID(int expressionID) {
        this.expressionID = expressionID;
    }

    public String getExpressionName() {
        return expressionName;
    }

    public void setExpressionName(String expressionName) {
        this.expressionName = expressionName;
    }

    public String getCapturingName() {
        return capturingName;
    }

    public void setCapturingName(String capturingName) {
        this.capturingName = capturingName;
    }

    public String getExp() {
        return exp;
    }

    public void setExp(String exp) {
        this.exp = exp;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public Pattern getPattern() {
        return pattern;
    }

    public void setPattern(Pattern pattern) {
        this.pattern = pattern;
    }
}

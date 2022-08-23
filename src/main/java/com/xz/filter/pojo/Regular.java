package com.xz.filter.pojo;


import com.google.gson.JsonElement;

import java.io.Serializable;
import java.sql.Timestamp;

public class Regular implements Serializable {
    private int regularID;
    private String regularName;
    private String paragraph;
    private String charset;
    private String warnKeyword;
    private Timestamp settingTime;
    private JsonElement expression; //not JsonArray

    public int getRegularID() {
        return regularID;
    }

    public void setRegularID(int regularID) {
        this.regularID = regularID;
    }

    public String getRegularName() {
        return regularName;
    }

    public void setRegularName(String regularName) {
        this.regularName = regularName;
    }

    public String getParagraph() {
        return paragraph;
    }

    public void setParagraph(String paragraph) {
        this.paragraph = paragraph;
    }

    public String getCharset() {
        return charset;
    }

    public void setCharset(String charset) {
        this.charset = charset;
    }

    public String getWarnKeyword() {
        return warnKeyword;
    }

    public void setWarnKeyword(String warnKeyword) {
        this.warnKeyword = warnKeyword;
    }

    public Timestamp getSettingTime() {
        return settingTime;
    }

    public void setSettingTime(Timestamp settingTime) {
        this.settingTime = settingTime;
    }

    public JsonElement getExpression() {
        return expression;
    }

    public void setExpression(JsonElement expression) {
        this.expression = expression;
    }
}

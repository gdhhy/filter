package com.xz.filter.pojo;

import java.io.Serializable;
import java.sql.Timestamp;

public class Paragraph implements Serializable {
    private int paragraphID;
    private int sourceID;
    private int htmlID;
    private String body;
    private String publisher;
    private Timestamp publishTime;
    private String link  ;
    private Timestamp insertTime;
    private String bodyCheckCode;
    private int times;
    private int warnLevel;
    private int repeatCount = 1;

    public int getParagraphID() {
        return paragraphID;
    }

    public void setParagraphID(int paragraphID) {
        this.paragraphID = paragraphID;
    }

    public int getSourceID() {
        return sourceID;
    }

    public void setSourceID(int sourceID) {
        this.sourceID = sourceID;
    }

    public int getHtmlID() {
        return htmlID;
    }

    public void setHtmlID(int htmlID) {
        this.htmlID = htmlID;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public Timestamp getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(Timestamp publishTime) {
        this.publishTime = publishTime;
    }

    public Timestamp getInsertTime() {
        return insertTime;
    }

    public void setInsertTime(Timestamp insertTime) {
        this.insertTime = insertTime;
    }

    public String getBodyCheckCode() {
        return bodyCheckCode;
    }

    public void setBodyCheckCode(String bodyCheckCode) {
        this.bodyCheckCode = bodyCheckCode;
    }

    public int getTimes() {
        return times;
    }

    public void setTimes(int times) {
        this.times = times;
    }

    public int getWarnLevel() {
        return warnLevel;
    }

    public void setWarnLevel(int warnLevel) {
        this.warnLevel = warnLevel;
    }

    public int getRepeatCount() {
        return repeatCount;
    }

    public void setRepeatCount(int repeatCount) {
        this.repeatCount = repeatCount;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }
}

package com.xz.filter.pojo;

import java.io.Serializable;

public class Body implements Serializable {
    private int bodyID;
    private String content;
    private String checkCode ;

    public int getBodyID() {
        return bodyID;
    }

    public void setBodyID(int bodyID) {
        this.bodyID = bodyID;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCheckCode() {
        return checkCode;
    }

    public void setCheckCode(String checkCode) {
        this.checkCode = checkCode;
    }
}

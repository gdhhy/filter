package com.xz.filter.pojo;

import java.io.Serializable;

public class Html implements Serializable {
    private int htmlID;
    private int sourceID;
    private String filename;
   // private String path;
    private int size;
    private int fragmentCount;
    private int parseStatus;
    private String checkCode;

    public int getHtmlID() {
        return htmlID;
    }

    public void setHtmlID(int htmlID) {
        this.htmlID = htmlID;
    }

    public int getSourceID() {
        return sourceID;
    }

    public void setSourceID(int sourceID) {
        this.sourceID = sourceID;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

  /*  public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }*/

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public int getFragmentCount() {
        return fragmentCount;
    }

    public void setFragmentCount(int fragmentCount) {
        this.fragmentCount = fragmentCount;
    }

    public int getParseStatus() {
        return parseStatus;
    }

    public void setParseStatus(int parseStatus) {
        this.parseStatus = parseStatus;
    }

    public String getCheckCode() {
        return checkCode;
    }

    public void setCheckCode(String checkCode) {
        this.checkCode = checkCode;
    }
}

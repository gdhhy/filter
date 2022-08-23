package com.xz.filter.pojo;

import java.io.Serializable;
import java.sql.Timestamp;

public class Source implements Serializable {
    private int sourceID;// '唯一标识'
    private String source;// '收集来源'
    private int regularID = 1;// '正规式配置'
    private String filename;// '文件名'
    // private String ext;// COMMENT '扩展名'
    private String path;// '路径'
    private long size;// '文件尺寸'
    private int htmlCount;// zip html文件数
    private Timestamp uploadTime;// '上传时间'
    private String serverPath;// '服务器保存路径'
    private String serverFilename;// '服务器保存文件名'
    private int fragmentCount;// '分析段落数'
    private int parseStatus = 0;//0：未分析，1：成功分析，2：分析失败，3：正在分析
    private String uploadUser;
    private String checkCode;
    private String errmsg;
    private long parseTime;//解析消耗时间，单位秒
    private long indexTime;//创建全文搜索索引时间

    public int getSourceID() {
        return sourceID;
    }

    public void setSourceID(int sourceID) {
        this.sourceID = sourceID;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public int getRegularID() {
        return regularID;
    }

    public void setRegularID(int regularID) {
        this.regularID = regularID;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }


    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public long getSize() {
        return size;
    }

    public void setSize(long size) {
        this.size = size;
    }

    public int getHtmlCount() {
        return htmlCount;
    }

    public void setHtmlCount(int htmlCount) {
        this.htmlCount = htmlCount;
    }

    public Timestamp getUploadTime() {
        return uploadTime;
    }

    public void setUploadTime(Timestamp uploadTime) {
        this.uploadTime = uploadTime;
    }

    public String getServerPath() {
        return serverPath;
    }

    public void setServerPath(String serverPath) {
        this.serverPath = serverPath;
    }

    public String getServerFilename() {
        return serverFilename;
    }

    public void setServerFilename(String serverFilename) {
        this.serverFilename = serverFilename;
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

    public String getUploadUser() {
        return uploadUser;
    }

    public void setUploadUser(String uploadUser) {
        this.uploadUser = uploadUser;
    }

    public String getCheckCode() {
        return checkCode;
    }

    public void setCheckCode(String checkCode) {
        this.checkCode = checkCode;
    }

    public long getParseTime() {
        return parseTime;
    }

    public void setParseTime(long parseTime) {
        this.parseTime = parseTime;
    }

    public String getErrmsg() {
        return errmsg;
    }

    public void setErrmsg(String errmsg) {
        this.errmsg = errmsg;
    }

    public long getIndexTime() {
        return indexTime;
    }

    public void setIndexTime(long indexTime) {
        this.indexTime = indexTime;
    }
}

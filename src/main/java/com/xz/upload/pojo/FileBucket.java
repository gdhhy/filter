package com.xz.upload.pojo;

/**
 * Created by hhy on 17-5-23.
 */
import org.springframework.web.multipart.MultipartFile;

public class FileBucket {

    MultipartFile file;

    public MultipartFile getFile() {
        return file;
    }

    public void setFile(MultipartFile file) {
        this.file = file;
    }
}
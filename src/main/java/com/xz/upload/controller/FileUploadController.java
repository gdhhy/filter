package com.xz.upload.controller;

/**
 * Created by hhy on 2020-08-30
 */

import cn.hutool.core.date.DateUtil;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.xz.ExceptionAdapter;
import com.xz.filter.dao.SourceMapper;
import com.xz.filter.pojo.Source;
import com.xz.rbac.web.DeployRunning;
import com.xz.upload.pojo.FileBucket;
import de.innosystec.unrar.Archive;
import de.innosystec.unrar.NativeStorage;
import de.innosystec.unrar.rarfile.FileHeader;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.sevenz.SevenZFile;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.util.*;

@Controller
@RequestMapping("/upload")
public class FileUploadController {
    private static Logger logger = LogManager.getLogger(FileUploadController.class);
    @Autowired
    private SourceMapper sourceMapper;
   /* @Autowired
    private ParagraphMapper paragraphMapper;
    @Autowired
    private RegularMapper regularMapper;*/

    private static String relative_directory = "upload";
    private static String UPLOAD_LOCATION = DeployRunning.getDir() + relative_directory + File.separator;
    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    /**
     * 海报上传
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/uploadFile", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String uploadFile(@Valid FileBucket fileBucket, BindingResult result) {
        Map<String, Object> resultMap = new HashMap<>();
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserDetails ud;
        if (principal instanceof UserDetails) {
            ud = (UserDetails) principal;
        } else {
            resultMap.put("success", false);
            resultMap.put("error", "未登录！");

            return gson.toJson(resultMap);
        }

        if (result.hasErrors()) {
            List<Map<String, Object>> files = new ArrayList<>();
            Map<String, Object> file = new HashMap<>();
            file.put("error", "validation errors");
            files.add(file);

            resultMap.put("success", false);
            resultMap.put("error", files);
        } else {
            System.out.println("Fetching file");
            String ext = fileBucket.getFile().getOriginalFilename().substring(fileBucket.getFile().getOriginalFilename().indexOf("."));
            //MultipartFile multipartFile = fileBucket.getFile();
           /*logger.debug(fileBucket.toString());
            logger.debug(fileBucket.getFile() +"");*/
         /*   logger.debug(StringUtils.toUTF8(fileBucket.getFile().getOriginalFilename()));//todo 中文文件名编码错误
            logger.debug(StringUtils.toGb2312(fileBucket.getFile().getOriginalFilename()));
            logger.debug(StringUtils.toISO8859_1(fileBucket.getFile().getOriginalFilename()));*/
            logger.debug(fileBucket.getFile().getOriginalFilename());
            //Map<String, Object> file = new HashMap<>();

            //String server_save_filename = fileBucket.getFile().getOriginalFilename().substring(0, fileBucket.getFile().getOriginalFilename().indexOf("."));
            String sourceSource = fileBucket.getFile().getOriginalFilename().substring(0, fileBucket.getFile().getOriginalFilename().indexOf("."));
            String server_save_filename = sourceSource + "_" + (new Date()).getTime() + ext;
            logger.debug("server_save_filename:" + server_save_filename);
            try {
                File saveFile = new File(UPLOAD_LOCATION + server_save_filename);
                FileCopyUtils.copy(fileBucket.getFile().getBytes(), saveFile);
                FileInputStream in = new FileInputStream(saveFile);

                String hex = DigestUtils.sha256Hex(in);
                in.close();
                HashMap<String, Object> param = new HashMap<>();
                param.put("checkCode", hex);
                List<Source> sources = sourceMapper.selectSource(param);

                if (sources.size() == 0) {
                    Source source = new Source();
                    source.setSource(sourceSource);
                    source.setFilename(fileBucket.getFile().getOriginalFilename());
                    source.setCheckCode(hex);
                    source.setPath(UPLOAD_LOCATION);
                    source.setServerFilename(server_save_filename);
                    source.setServerPath(relative_directory);
                    source.setSize(saveFile.length());
                    source.setUploadTime(new Timestamp(System.currentTimeMillis()));

                    source.setUploadUser(ud.getUsername());
                    source.setRegularID(1);
                    System.out.println("ext = " + ext);
                    if (".zip".equals(ext) || ".7z".equals(ext) || ".rar".equals(ext)) {
                        source.setHtmlCount(getHtmlFileCount(saveFile));
                    } else source.setHtmlCount(1);
                    sourceMapper.insertSource(source);
                    logger.debug("sourceID:" + source.getSourceID());

                  /*SourceService sourceService = new SourceService(sourceMapper, paragraphMapper, regularMapper);
                    sourceService.filterSource(source);*/

                    resultMap.put("success", true);
                    resultMap.put("url", source.getServerPath() + File.separator + source.getServerFilename());
                } else {
                    resultMap.put("success", false);
                    resultMap.put("error", "文件曾被上传，上传时间：" + DateUtil.format(sources.get(0).getUploadTime(), "yyyy-MM-dd HH:mm"));
                    saveFile.delete();
                }

            } catch (IOException e) {
                resultMap.put("error", e.getMessage());
            }


            resultMap.putIfAbsent("success", false);
        }

        return gson.toJson(resultMap);
    }

    private int getHtmlFileCount(File file) {
        int count = 0;

        try {
            ArchiveEntry archiveEntry;
            logger.debug("file:" + file.getName());
            String ext = file.getName().substring(file.getName().indexOf("."));
            if (".zip".equals(ext)) {
                InputStream is;
                //can read Zip archives
                ZipArchiveInputStream zais;
                is = new FileInputStream(file);
                zais = new ZipArchiveInputStream(is);
               /* ZipFile zipFile = new ZipFile(file);
                Enumeration<ZipArchiveEntry> entryEnumeration = zipFile.getEntries();*/
                //把zip包中的每个文件读取出来
                //然后把文件写到指定的文件夹
                while ((archiveEntry = zais.getNextEntry()) != null) {
                    //获取文件名
                    if (archiveEntry.isDirectory()) continue;
                    String entryFileName = archiveEntry.getName();
                    if (entryFileName.endsWith("html") || entryFileName.endsWith("htm")) count++;
                }
                zais.close();
                is.close();
            } else if (".7z".equals(ext)) {
                SevenZFile sevenZFile = new SevenZFile(file);
                while ((archiveEntry = sevenZFile.getNextEntry()) != null) {
                    if (archiveEntry.isDirectory()) continue;

                    String entryFileName = archiveEntry.getName();
                    if (entryFileName.endsWith("html") || entryFileName.endsWith("htm")) count++;
                }
                sevenZFile.close();
            } else if (".rar".equals(ext)) {
                NativeStorage storage = new NativeStorage(file);
                Archive archive = new Archive(storage);
                FileHeader fh;
                while ((fh = archive.nextFileHeader()) != null) {
                    if (fh.isDirectory()) continue;

                    String entryFileName = fh.getFileNameString();
                    if (entryFileName.endsWith("html") || entryFileName.endsWith("htm")) count++;
                }
                archive.close();
            } else
                return 1;
        } catch (Exception e) {
            throw new ExceptionAdapter(e);
        }
        return count;
    }

    /**
     * @param fileBucket
     * @param result
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/singleUpload", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String singleFileUpload(@Valid FileBucket fileBucket, BindingResult result) {
        Map<String, Object> resultMap = new HashMap<>();

        if (result.hasErrors()) {
            List<Map<String, Object>> files = new ArrayList<>();
            Map<String, Object> file = new HashMap<>();
            //file.put("error", "validation errors");
            files.add(file);

            resultMap.put("success", false);
            resultMap.put("error", files);
        } else {
            System.out.println("Fetching file");
            //MultipartFile multipartFile = fileBucket.getFile();
            Map<String, Object> file = new HashMap<>();
            String server_save_filename = fileBucket.getFile().getOriginalFilename().substring(0, fileBucket.getFile().getOriginalFilename().indexOf("."));
            server_save_filename += "_" + (new Date()).getTime() + fileBucket.getFile().getOriginalFilename().substring(fileBucket.getFile().getOriginalFilename().indexOf((".")));
            logger.debug("server_save_filename:" + server_save_filename);
            try {
                FileCopyUtils.copy(fileBucket.getFile().getBytes(), new File(DeployRunning.getDir() + "upload_tmp" + File.separator + server_save_filename));
            } catch (IOException e) {
                file.put("error", e.getMessage());
            }

            List<Map<String, Object>> files = new ArrayList<>();
            if (file.get("error") == null) {
                file.put("url", File.separator + "upload_tmp" + File.separator + server_save_filename);
                resultMap.put("success", true);
                resultMap.put("status", "OK");
            }
            resultMap.putIfAbsent("success", false);
            files.add(file);

            resultMap.put("files", files);
        }

        return gson.toJson(resultMap);
    }

/*
    @RequestMapping(value = "/multiUpload", method = RequestMethod.GET)
    public String getMultiUploadPage(ModelMap model) {
        MultiFileBucket filesModel = new MultiFileBucket();
        model.addAttribute("multiFileBucket", filesModel);
        return "multiFileUploader";
    }

    @RequestMapping(value = "/multiUpload", method = RequestMethod.POST)
    public String multiFileUpload(@Valid MultiFileBucket multiFileBucket,
                                  BindingResult result, ModelMap model) throws IOException {

        if (result.hasErrors()) {
            System.out.println("validation errors in multi upload");
            return "multiFileUploader";
        } else {
            System.out.println("Fetching files");
            List<String> fileNames = new ArrayList<>();
            // Now do something with file...
            for (FileBucket bucket : multiFileBucket.getFiles()) {
                FileCopyUtils.copy(bucket.getFile().getBytes(), new File(UPLOAD_LOCATION + bucket.getFile().getOriginalFilename()));
                fileNames.add(bucket.getFile().getOriginalFilename());
            }

            model.addAttribute("fileNames", fileNames);
            return "multiSuccess";
        }
    }*/

    /**
     * 合买的上传图片
     */
    @ResponseBody
    @RequestMapping(value = "/fileUpload", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String fildUpload(@RequestParam(value = "avatar", required = false) MultipartFile file,
                             HttpServletRequest request) {

        Map[] results = new Map[1];
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("status", "ERR");
        resultMap.put("message", "Invalid file format!");
        //获得物理路径webapp所在路径
        String pathRoot = request.getSession().getServletContext().getRealPath("");
        logger.debug("pathRoot = " + pathRoot);
        String path = "";
        if (!file.isEmpty()) {
            //生成uuid作为文件名称
            String uuid = UUID.randomUUID().toString().replaceAll("-", "");
            //获得文件类型（可以判断如果不是图片，禁止上传）
            String contentType = file.getContentType();
            //获得文件后缀名称
            String imageName = contentType.substring(contentType.indexOf("/") + 1);
            path = "upload_tmp/" + uuid + "." + imageName;
            try {
                file.transferTo(new File(pathRoot + path));
            } catch (Exception e) {
                e.printStackTrace();
            }
            resultMap.put("status", "OK");
            resultMap.put("message", "文件上传成功!");
            resultMap.put("url", File.separator + path);
        } else {
            resultMap.put("status", "ERR");
            resultMap.put("message", "文件不存在,上传失败!");
        }
        System.out.println(path);
        //request.setAttribute("imagesPath", path);

        //return "success";
        results[0] = resultMap;
        return gson.toJson(results);
    }
}
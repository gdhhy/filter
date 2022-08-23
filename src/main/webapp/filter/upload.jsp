<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.bootcss.com/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>
<script src="../js/resize.js"></script>

<script src="http://static.runoob.com/assets/jquery-validation-1.14.0/dist/jquery.validate.min.js"></script>

<%--<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.css" />--%>
<link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" href="../jQuery-File-Upload-master/css/jquery.fileupload.css">
<script type="text/javascript">
    jQuery(function ($) {
        'use strict';
        // Change this to the location of your server-side upload handler:
        //var url = window.location.hostname === 'blueimp.github.io' ? '//jquery-file-upload.appspot.com/' : 'server/php/',
        var url = '/upload/uploadFile.jspa',
            uploadButton = $('<button/>')
                .addClass('btn btn-mini btn-primary')
                .prop('disabled', true)
                .text('Processing...')
                .on('click', function () {
                    var $this = $(this),
                        data = $this.data();
                    $this.off('click')
                        .text('Abort')
                        .on('click', function () {
                            $this.remove();
                            data.abort();
                        });
                    data.submit().always(function () {
                        $this.remove();
                    });
                });
        $('#fileupload').fileupload({
            url: url,
            dataType: 'json',
            autoUpload: false,
            //maxFileSize: 200 * 1024 * 1024, web.xml配置
            acceptFileTypes: /([.\/])(zip|7z)$/i
            // Enable image resizing, except for Android and Opera,
            // which actually support image resizing, but fail to
            // send Blob objects via XHR requests:
            /*  disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent),
              previewMaxWidth: 100,
              previewMaxHeight: 100,*/
            // previewCrop: true
        }).on('fileuploadadd', function (e, data) {//在文件选择框选择文件，按了确定
            data.context = $('<div/>').appendTo('#files');
            $.each(data.files, function (index, file) {
                //console.log("filename:" + file.name);
                var node = $('<p/>').append($('<span/>').text(file.name));
                if (!index) {
                    node.append('<br>').append(uploadButton.clone(true).data(data));
                }
                node.appendTo(data.context);
            });
        }).on('fileuploadprocessalways', function (e, data) {
            if (data.result)
                console.log(data.result);
            var index = data.index,
                file = data.files[index],
                node = $(data.context.children()[index]);
            if (file.preview) {
                node.prepend('<br>').prepend(file.preview);
            }
            if (file.error) {
                node.append('<br>').append($('<span class="text-danger"/>').text(file.error));
            }
            if (index + 1 === data.files.length) {
                data.context.find('button').text('上传').prop('disabled', !!data.files.error);
            }
        }).on('fileuploadprogressall', function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress .progress-bar').css(
                'width',
                progress + '%'
            );
        }).on('fileuploaddone', function (e, data) {
            console.log(" JSON.stringify(data):" + JSON.stringify(data.result));
            //{"success":false,"uploadTime":1599485771000,"error":"文件曾被上传"}
            //{"success":true,"source":{"sourceID":46,"regularID":1,"filename":"messages20.html","path":"/home/gzhhy/projects/filter_xz/build/libs/exploded/filter_xz-1.0-SNAPSHOT.war/upload/",
            // "size":1197055,"uploadTime":"2020-09-08 09:19:14","serverPath":"upload","serverFilename":"messages20_1599527954817.html","fragmentCount":0,"parseStatus":0,
            // "uploadUser":"dongtian","checkCode":"abc0f54d27261c6eb673a9118612ea4a53935eab52e36e48b1b2f3ee0e21aca7"}}
            console.log(" JSON.stringify(data):" + JSON.stringify(data.context));
            //console.log(" JSON.stringify(e):" + JSON.stringify(e));
            //$.each(data.result.files, function (index, file) {
            if (data.result.success) {
                var link = $('<a>').attr('target', '_blank').prop('href', data.result.url);
                $(data.context.children()[0]).wrap(link);
            } else {
                var error = $('<span class="text-danger"/>').text(data.result.error);
                $(data.context.children()[0]).append(error);
            }
            // });
        }).on('fileuploadfail', function (e, data) {
            $.each(data.files, function (index) {
                var error = $('<span class="text-danger"/>').text('上传文件失败！');
                $(data.context.children()[index]).append('<br>').append(error);
            });
        }).prop('disabled', !$.support.fileInput)
            .parent().addClass($.support.fileInput ? undefined : 'disabled');

    });
</script>
<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa">首页</a>
        </li>
        <li class="active">文件上传</li>
    </ul><!-- /.breadcrumb -->


    <!-- /section:basics/content.searchbox -->
</div>
<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">
    <div class="page-header">

    </div><!-- /.page-header -->


    <div class="row">
        <div class="col-xs-12">

            <div class="row">
                <div class="col-xs-8 center-block ">
                    <%--  <p>
                          <button class="btn btn-danger btn-block  ">增加新海报</button>--%>
                    <span class="btn btn-mini btn-success fileinput-button">
                <i class="glyphicon glyphicon-plus"></i>
                <span>选择文件...</span>
                        <!-- The file input field used as target for the file upload widget -->
                <input id="fileupload" type="file" name="file" multiple>
            </span>
                    <br>
                    <br>
                    <!-- The global progress bar -->
                    <div id="progress" class="progress">
                        <div class="progress-bar progress-bar-success"></div>
                    </div>
                    <!-- The container for the uploaded files -->
                    <div id="files" class="files"></div>
                </div>

                <div class="col-xs-12 grey">备注:
                    <ul>
                        <li>仅支持zip、7z压缩文件上传；</li>
                        <li>最大支持约100M文件；</li>
                        <li>7z压缩率高，建议使用7z；</li>
                        <li>上传完毕，请在文件管理进行编辑来源和数据抽取。</li>
                    </ul>
                </div>
            </div>

            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

</div>
<!-- /.page-content -->
<!-- #dialog-confirm -->
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="../jQuery-File-Upload-master/js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="../jQuery-File-Upload-master/js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="../jQuery-File-Upload-master/js/jquery.fileupload-process.js"></script>
<!-- The File Upload audio preview plugin -->
<%--<script src="../jQuery-File-Upload-master/js/jquery.fileupload-image.js"></script>--%>
<!-- The File Upload validation plugin -->
<script src="../jQuery-File-Upload-master/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript">

</script>
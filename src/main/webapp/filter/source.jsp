<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.bootcss.com/datatables/1.10.21/js/jquery.dataTables.min.js"></script>
<%--<script src="http://ace.jeka.by/assets/js/jquery.dataTables.bootstrap.min.js"></script>--%>
<script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap.min.js"></script>

<script src="https://cdn.datatables.net/buttons/1.6.3/js/dataTables.buttons.min.js"></script>
<%--<script src="http://ace.jeka.by/assets/js/dataTables.select.min.js"></script>  Select for DataTables 1.1.2--%>
<script src="https://cdn.datatables.net/select/1.3.1/js/dataTables.select.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<script src="https://cdn.bootcss.com/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>
<script src="../js/resize.js"></script>
<script src="http://static.runoob.com/assets/jquery-validation-1.14.0/dist/jquery.validate.min.js"></script>
<script src="http://bootboxjs.com/assets/js/bootbox.all.min.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.1/css/select.dataTables.min.css"/>
<%--<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.css" />--%>
<link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
<script type="text/javascript">
    jQuery(function ($) {
        var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "columns": [
                    {"data": "sourceID", "sClass": "center"},
                    {"data": "filename", "sClass": "center"},
                    {"data": "size", "sClass": "center"},
                    /*{"data": "source", "sClass": "center", "defaultContent": ""},*/
                    {"data": "regularName", "sClass": "center", "defaultContent": ""},//4
                    {"data": "uploadTime", "sClass": "center"},
                    {"data": "htmlCount", "sClass": "center"},
                    {"data": "fragmentCount", "sClass": "center"},
                    {"data": "parseStatus", "sClass": "center"},
                    {"data": "parseTime", "sClass": "center"},//9
                    {"data": "indexTime", "sClass": "center"},
                    {"data": "errmsg", "sClass": "center"}
                ],

                'columnDefs': [
                    {"orderable": false, "searchable": false, className: 'text-center', "targets": 0},
                    {
                        "orderable": false, className: 'text-center', "targets": 1, title: '文件名', render: function (data, type, row, meta) {
                            return "<a href='" + row["serverPath"] + "/" + row["serverFilename"] + "' style='text-decoration: none;' target='_blank'>" + data + "</a>";
                        }
                    },
                    {"orderable": false, className: 'text-center', "targets": 2, title: '文件大小', render: renderSize},
                    /*{"orderable": false, className: 'text-center', "targets": 3, title: '来源'},*/
                    {"orderable": false, className: 'text-center', "targets": 3, title: '正规式配置'},
                    {"orderable": false, 'targets': 4, 'searchable': false, title: '上传时间'},
                    {"orderable": false, "searchable": false, className: 'text-center', "targets": 5, title: 'html数量'},
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 6, title: '段落数量', render: function (data, type, row, meta) {
                            return '<a href="#" data-sourceID="{0}" data-source="{1}">{2}</a>'.format(row['sourceID'], row['source'], data);
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 7, title: '处理结果', render: function (data, type, row, meta) {
                            var resultChs = ['未处理', '已处理', '失败', '正在抽取', '有错误'];
                            return row["errmsg"] !== "" ? "<a title='" + row["errmsg"] + "' href='#' style='text-decoration: none;'>" + resultChs[data] + "</a>" : resultChs[data];
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 8, title: '抽取耗时', render: function (data, type, row, meta) {
                            if (data < 0) return '正在处理...';
                            if (data === undefined || data < 0.1) return '未处理';
                            return renderTime2Read(data);
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 9, title: '索引耗时', render: function (data, type, row, meta) {
                            if (data < 0) return '正在处理...';
                            if (data === undefined || data < 0.1) return '未索引';
                            return renderTime2Read(data);
                        }
                    },
                    {
                        "orderable": false, 'searchable': false, 'targets': 10, title: '操作', width: 100,
                        render: function (data, type, row, meta) {
                            console.log(row["parseStatus"]);
                            var parseLink = row["indexTime"] < 0.1 || row["parseStatus"] !== 3 ? '<a class="hasLink" title="抽取" href="#" data-Url="javascript:showSourceDialog({0});">'.format(row["sourceID"]) +
                                '<i class="ace-icon fa fa-lightbulb-o blue bigger-140"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' : '';
                            /*var indexLink = row["fragmentCount"] >                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               0  ? '<a class="hasLink" title="重建索引" href="#" data-Url="javascript:showIndexDialog({0},\'{1}\');">'.format(row["sourceID"], row["filename"]) +
                            '<i class="ace-icon glyphicon glyphicon-refresh orange2 bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;'  : '';*/
                            return '<div class="hidden-sm hidden-xs action-buttons">' +

                                '<a class="hasLink" title="修改来源" href="#" data-Url="javascript:showEditDialog({0});">'.format(row["sourceID"]) +
                                '<i class="ace-icon glyphicon glyphicon-edit green bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                parseLink +
                                //indexLink +
                                '<a class="hasLink" title="删除" href="#" data-Url="javascript:deleteSource({0},\'{1}\');">'.format(row["sourceID"], row["filename"]) +
                                '<i class="ace-icon glyphicon glyphicon-trash red bigger-120"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }

                ],
                "aLengthMenu": [[20, 100], ["20", "100"]],//二组数组，第一组数量，第二组说明文字;
                "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                searching: false,
                "ajax": {
                    url: "/filter/listSource.jspa",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },
                "processing": true,
                "serverSide": true,
                select: {style: 'single'}
            });
        myTable.on('order.dt search.dt', function () {
            myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                cell.innerHTML = i + 1;
            });
        });
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('a:eq(1)').click(function () {
                $.cookie("data-sourceID", $(this).attr("data-sourceID"));
                $.cookie("data-source", $(this).attr("data-source"));
                window.open("/index.jspa?content=/filter/paragraph3.jsp&menuID=21", "_blank");
            });
            $('#dynamic-table tr').find('.hasLink').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
        });
        $('.btn-success').click(function () {
            search();
        });

        $('.form-search :text').keydown(function (event) {
            if (event.keyCode === 13)
                search();
        });

        function renderTime2Read(data) {
            if (data < 1000) return data + "ms";//1秒内
            if (data < 10 * 1000) return data / 1000 + "s";//10秒内
            data = Math.floor(data / 1000);
            if (data < 3600)//1小时内
                return (Math.floor(data / 60 % 60) > 0 ? Math.floor(data / 60 % 60).toString() + "m" : "") + (data % 60) + "s";
            else
                return (Math.floor(data / 3600) > 0 ? Math.floor(data / 3600).toString() + "h" : "") + Math.floor(data / 60 % 60) + "m";
            //todo 超过1天？

            /*// 小时位
            var hr = Math.floor(data / 3600);
            var hrStr = hr.toString();
            if (hrStr.length === 1) hrStr = '0' + hrStr;
            var returnStr = hrStr;
            // 分钟位
            var min = Math.floor(data / 60 % 60);
            var minStr = min.toString();
            if (minStr.length === 1) minStr = '0' + minStr;
            returnStr += ':' + minStr;
            // 秒位
            var sec = Math.floor(data % 60);
            var secStr = sec.toString();
            if (secStr.length === 1) secStr = '0' + secStr;
            returnStr += ':' + secStr;
            return returnStr;*/
        }

        function renderSize(value) {
            if (null == value || value === '') {
                return "0 Bytes";
            }
            var unitArr = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
            var srcsize = parseFloat(value);
            var index = Math.floor(Math.log(srcsize) / Math.log(1024));
            var size = srcsize / Math.pow(1024, index);
            size = size.toFixed(2);//保留的小数位数
            return size + ' ' + unitArr[index];
        }

        var currentAjax;

        function deleteSource(sourceID, filename) {
            if (sourceID === undefined) return;
            $('#filename').text(filename);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "删除确认",
                //title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-trash bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {

                            $.ajax({
                                type: "POST",
                                url: "/filter/deleteSource.jspa?sourceID=" + sourceID,
                                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {//todo masking
                                    var result = JSON.parse(response);
                                    if (result.succeed)
                                        myTable.ajax.reload();
                                    else
                                        showDialog("请求结果：" + result.succeed, result.message);
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText);
                                },
                                beforeSend: function () {
                                    if (currentAjax) currentAjax.abort();
                                    $('#loadingText').text("正在删除，请稍后……");
                                    $("#loadingModal").modal({backdrop: 'static', keyboard: false});
                                    $("#loadingModal").modal('show');
                                },
                                complete: function () {
                                    $("#loadingModal").modal('hide');
                                }
                            });
                            $(this).dialog("close");
                        }
                    },
                    {
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                        "class": "btn btn-minier",
                        click: function () {
                            $(this).dialog("close");
                        }
                    }
                ]
            });
        }

        var regularOptions = $('#regularID');

        function showSourceDialog(sourceID) {
            $('#sourceID').val(sourceID);
            if ($("#regularID option").length === 0)
                $.getJSON("/filter/listRegular.jspa", function (result) {
                    if (result.iTotalRecords > 0) {
                        $("#regularID option").remove();
                        $.each(result.data, function (n, value) {
                            regularOptions.append('<option value="{0}">{1}</option>'.format(value.regularID, value.regularName));
                        });
                        //加载正规式成功后，再加载Source
                        loadSourceForEditSource(sourceID);
                    }
                });
            else loadSourceForEditSource(sourceID);
        }

        function loadSourceForEditSource(sourceID) {
            $.ajax({
                type: "GET",
                url: '/filter/listSource.jspa',
                data: {'sourceID': sourceID},
                contentType: "application/json; charset=utf-8",
                cache: false,
                success: function (response, textStatus) {
                    var respObject = JSON.parse(response);
                    $('#filename3').text(respObject.data[0].filename);
                    $('#filesize').text(renderSize(respObject.data[0].size));
                    $('#uploadTime').text(respObject.data[0].uploadTime);
                    $('#fragmentCount').text(respObject.data[0].fragmentCount);

                    if (respObject.data[0].regularID > 0)
                        $("#regularID option[value='" + respObject.data[0].regularID + "']").attr("selected", "selected");
                    else
                        $("#regularID option:first").attr("selected", "selected");

                    $("#dialog-parse").removeClass('hide').dialog({
                        resizable: false, modal: true, title: "数据抽取", width: 580, height: 330,//title_html: true,
                        buttons: [
                            {
                                html: "<i class='ace-icon glyphicon glyphicon-refresh bigger-110'></i>&nbsp;开始抽取",
                                "class": "btn btn-danger btn-minier",
                                click: function () {
                                    sourceForm.submit();
                                    $(this).dialog("close");
                                }
                            }, {
                                html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                                "class": "btn btn-minier",
                                click: function () {
                                    $(this).dialog("close");
                                }
                            }
                        ]
                    });
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    showDialog("请求状态码：" + response.status, response.responseText);
                }
            });
        }

        function showIndexDialog(sourceID, filename) {
            $('#filename4').text(filename);
            $("#dialog-index").removeClass('hide').dialog({
                resizable: false, modal: true, width: 350, title: "创建索引",//title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-lightbulb-o bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/filter/indexSource.jspa?sourceID=" + sourceID,
                                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    var result = JSON.parse(response);
                                    myTable.ajax.reload();
                                    showDialog("请求结果：" + result.succeed, result.message);
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText);
                                }
                            });
                            $(this).dialog("close");
                        }
                    },
                    {
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                        "class": "btn btn-minier",
                        click: function () {
                            $(this).dialog("close");
                        }
                    }
                ]
            });
        }

        function showEditDialog(sourceID) {
            if (sourceID === undefined) return;
            $('#sourceID9').val(sourceID);

            $.ajax({
                type: "GET",
                url: '/filter/listSource.jspa',
                data: {'sourceID': sourceID},
                contentType: "application/json; charset=utf-8",
                cache: false,
                success: function (response, textStatus) {
                    var respObject = JSON.parse(response);
                    $('#filename9').text(respObject.data[0].filename);
                    $('#filesize9').text(renderSize(respObject.data[0].size));
                    $('#uploadTime9').text(respObject.data[0].uploadTime);
                    $('#fragmentCount9').text(respObject.data[0].fragmentCount);
                    $('#source').val(respObject.data[0].source);

                    $("#dialog-edit9").removeClass('hide').dialog({
                        resizable: false,
                        modal: true,
                        title: "编辑数据源",
                        width: 580,
                        height: 350,
                        //title_html: true,
                        buttons: [
                            {
                                html: "<i class='ace-icon fa fa-save bigger-110'></i>&nbsp;保存",
                                "class": "btn btn-primary btn-minier",
                                click: function () {
                                    var json = {sourceID: $('#sourceID9').val(), source: $('#source').val()};
                                    $.ajax({
                                        type: "POST",
                                        url: "/filter/saveSourceSource.jspa",
                                        contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                        data: json,
                                        cache: false,
                                        success: function (response, textStatus) {
                                            var result = JSON.parse(response);
                                            showDialog("请求结果：" + result.succeed, result.message);
                                            myTable.ajax.reload();
                                        },
                                        error: function (response, textStatus) {/*能够接收404,500等错误*/
                                            showDialog("请求状态码：" + response.status, response.responseText);
                                        }
                                    });

                                    $(this).dialog("close");
                                }
                            }, {
                                html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                                "class": "btn btn-minier",
                                click: function () {
                                    $(this).dialog("close");
                                }
                            }
                        ]
                    });
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    showDialog("请求状态码：" + response.status, response.responseText);
                }
            });
        }

        //var currentAjax;
        var sourceForm = $('#sourceForm');
        sourceForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",

            submitHandler: function (form) {
                var parseParam = {
                    sourceID: $('#sourceID').val(),
                    regularID: $('#regularID').children('option:selected').val()
                };
                //console.log("data:" + JSON.stringify(parseParam));
                $.ajax({
                    type: "POST",
                    url: "/filter/parseSource.jspa?sourceID=" + $('#sourceID').val() + "&regularID=" + $('#regularID').children('option:selected').val(),
                    //data: parseParam,
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var result = JSON.parse(response);
                        /*if (!result.succeed) {
                            showDialog("抽取失败", result.message);
                        } else if (result.paragraphCount === 0) {
                            showDialog("抽取无效", result.message);
                        } else {
                            myTable.ajax.reload();
                        } */
                        showDialog("请求结果：" + result.succeed, result.message);
                        myTable.ajax.reload();
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                    beforeSend: function () {
                        if (currentAjax) currentAjax.abort();
                        $('#loadingText').text("正在提交任务，请稍后……");
                        $("#loadingModal").modal({backdrop: 'static', keyboard: false});
                        $("#loadingModal").modal('show');
                    },
                    complete: function () {
                        $("#loadingModal").modal('hide');
                    }
                });
            },
            invalidHandler: function (form) {
                console.log("invalidHandler");
            }
        });

        function showDialog(title, content) {
            $("#errorText").html(content);
            $("#dialog-error").removeClass('hide').dialog({
                modal: true,
                width: 480,
                title: title,
                buttons: [{
                    text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                        $(this).dialog("close");
                    }
                }]
            });
        }

        /*function search() {
            var url = "/filter/listSource.jspa";
            var searchParam = "?threeThirty=" + $('#three_thirty').is(':checked');
            $('.form-search :text').each(function () {
                if ($(this).val())
                    searchParam += "&" + $(this).attr("name") + "=" + $(this).val();
            });
            if (searchParam !== "")
                url = "/filter/listSource.jspa" + searchParam;
            myTable.ajax.url(encodeURI(url)).load();
        }*/

    })
</script>
<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa">首页</a>
        </li>
        <li class="active">文件管理</li>
    </ul><!-- /.breadcrumb -->

    <!-- #section:basics/content.searchbox -->
    <div class="nav-search" id="nav-search">
        <form class="form-search">
  <span class="input-icon">
  <input type="text" placeholder="Search ..." class="nav-search-input" id="nav-search-input" autocomplete="off"/>
  <i class="ace-icon fa fa-search nav-search-icon"></i>
  </span>
        </form>
    </div><!-- /.nav-search -->

    <!-- /section:basics/content.searchbox -->
</div>
<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">
    <div class="page-header">

    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        上传文件列表
                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div id="dt">
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                        </table>
                    </div>
                </div>
            </div>

            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

</div>
<!-- /.page-content -->
<div id="dialog-delete" class="hide">
    <div class="alert alert-info bigger-110">
        删除上传文件： <span id="filename" class="red"></span> ，分析结果、索引、服务器上文件一起删除！
    </div>

    <div class="space-6"></div>

    <p class="bigger-110 bolder center grey">
        <i class="icon-hand-right blue bigger-120"></i>
        确认吗？
    </p>
</div>
<div id="dialog-index" class="hide">
    <div class="alert alert-info bigger-110">
        将对<br/> <span id="filename4" class="light-orange "></span> <br/>文件创建索引，索引成功后，在全文搜索能够快速查询。
    </div>

    <div class="space-6"></div>

    <p class="bigger-110 bolder center grey">
        <i class="icon-hand-right blue bigger-120"></i>
        确认吗？
    </p>
</div>

<div id="dialog-parse" class="hide" style="z-index: 10">
    <div class="col-xs-12" style="padding-top: 10px">
        <!-- PAGE CONTENT BEGINS -->
        <form class="form-horizontal" role="form" id="sourceForm">
            <div class="col-sm-12">
                <div class="row">
                    <label class="col-sm-2">文件名</label>
                    <div class="col-sm-10 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey;font-size:  large" id="filename3"></div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row" style="margin-bottom: 6px;margin-top:6px">
                    <label class="col-sm-4">文件大小</label>
                    <div class="col-sm-8 no-padding" id="filesize" style="border-bottom: 1px solid; border-bottom-color: lightgrey;"></div>
                </div>
                <div class="row" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-sm-4">上传日期</label>
                    <div class="col-sm-8 no-padding" id="uploadTime" style="border-bottom: 1px solid; border-bottom-color: lightgrey "></div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-sm-4">分析结果</label>
                    <div class="col-sm-8 no-padding" id="fragmentCount" style="border-bottom: 1px solid; border-bottom-color: lightgrey "></div>
                </div>
            </div>
            <div class="col-sm-12 center">
                <div class="form-group" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-xs-2 control-label no-padding-right" for="regularID"> 正规式配置 </label>
                    <div class="col-xs-5">
                        <select class="form-control col-xs-8" name="regularID" id="regularID">
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-sm-12" style="text-decoration-color: lightgrey">
                提示：重新抽取，将会覆盖旧的。
            </div>

            <input type="hidden" id="sourceID" name="sourceID">
        </form>
    </div>
</div>
<div id="dialog-edit9" class="hide">
    <div class="col-xs-12" style="padding-top: 10px">
        <!-- PAGE CONTENT BEGINS -->
        <form class="form-horizontal" role="form" id="sourceForm2">
            <div class="col-sm-12">
                <div class="row">
                    <label class="col-sm-2">文件名</label>
                    <div class="col-sm-10 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey;font-size:  large" id="filename9"></div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row" style="margin-bottom: 6px;margin-top:6px">
                    <label class="col-sm-4">文件大小</label>
                    <div class="col-sm-8 no-padding" id="filesize9" style="border-bottom: 1px solid; border-bottom-color: lightgrey;"></div>
                </div>
                <div class="row" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-sm-4">上传日期</label>
                    <div class="col-sm-8 no-padding" id="uploadTime9" style="border-bottom: 1px solid; border-bottom-color: lightgrey "></div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-sm-4">分析结果</label>
                    <div class="col-sm-8 no-padding" id="fragmentCount9" style="border-bottom: 1px solid; border-bottom-color: lightgrey "></div>
                </div>
            </div>
            <div class="col-sm-12 center">
                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                    <label class="col-xs-2 control-label" for="source"> 来源 </label>
                    <div class="col-xs-10 pull-left">
                        <input type="text" id="source" name="source" class="col-xs-10" placeholder="来源"/>
                    </div>
                </div>
            </div>
            <input type="hidden" id="sourceID9" name="sourceID9">
        </form>
    </div>
</div>
<div id="dialog-error" class="hide alert" title="提示">
    <p id="errorText">失败，请稍后再试，或与系统管理员联系。</p>
</div>
<div class="modal fade" id="loadingModal">
    <div style="width: 200px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-100px;margin-top:-10px">
        <div class="progress progress-striped active" style="margin-bottom: 0;">
            <div class="progress-bar" style="width: 100%;" id="loadingText">正在抽取……</div>
        </div>
    </div>
</div>

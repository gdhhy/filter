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
                        "orderable": false, className: 'text-center', "targets": 1, title: '?????????', render: function (data, type, row, meta) {
                            return "<a href='" + row["serverPath"] + "/" + row["serverFilename"] + "' style='text-decoration: none;' target='_blank'>" + data + "</a>";
                        }
                    },
                    {"orderable": false, className: 'text-center', "targets": 2, title: '????????????', render: renderSize},
                    /*{"orderable": false, className: 'text-center', "targets": 3, title: '??????'},*/
                    {"orderable": false, className: 'text-center', "targets": 3, title: '???????????????'},
                    {"orderable": false, 'targets': 4, 'searchable': false, title: '????????????'},
                    {"orderable": false, "searchable": false, className: 'text-center', "targets": 5, title: 'html??????'},
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 6, title: '????????????', render: function (data, type, row, meta) {
                            return '<a href="#" data-sourceID="{0}" data-source="{1}">{2}</a>'.format(row['sourceID'], row['source'], data);
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 7, title: '????????????', render: function (data, type, row, meta) {
                            var resultChs = ['?????????', '?????????', '??????', '????????????', '?????????'];
                            return row["errmsg"] !== "" ? "<a title='" + row["errmsg"] + "' href='#' style='text-decoration: none;'>" + resultChs[data] + "</a>" : resultChs[data];
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 8, title: '????????????', render: function (data, type, row, meta) {
                            if (data < 0) return '????????????...';
                            if (data === undefined || data < 0.1) return '?????????';
                            return renderTime2Read(data);
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 9, title: '????????????', render: function (data, type, row, meta) {
                            if (data < 0) return '????????????...';
                            if (data === undefined || data < 0.1) return '?????????';
                            return renderTime2Read(data);
                        }
                    },
                    {
                        "orderable": false, 'searchable': false, 'targets': 10, title: '??????', width: 100,
                        render: function (data, type, row, meta) {
                            console.log(row["parseStatus"]);
                            var parseLink = row["indexTime"] < 0.1 || row["parseStatus"] !== 3 ? '<a class="hasLink" title="??????" href="#" data-Url="javascript:showSourceDialog({0});">'.format(row["sourceID"]) +
                                '<i class="ace-icon fa fa-lightbulb-o blue bigger-140"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' : '';
                            /*var indexLink = row["fragmentCount"] >                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               0  ? '<a class="hasLink" title="????????????" href="#" data-Url="javascript:showIndexDialog({0},\'{1}\');">'.format(row["sourceID"], row["filename"]) +
                            '<i class="ace-icon glyphicon glyphicon-refresh orange2 bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;'  : '';*/
                            return '<div class="hidden-sm hidden-xs action-buttons">' +

                                '<a class="hasLink" title="????????????" href="#" data-Url="javascript:showEditDialog({0});">'.format(row["sourceID"]) +
                                '<i class="ace-icon glyphicon glyphicon-edit green bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                parseLink +
                                //indexLink +
                                '<a class="hasLink" title="??????" href="#" data-Url="javascript:deleteSource({0},\'{1}\');">'.format(row["sourceID"], row["filename"]) +
                                '<i class="ace-icon glyphicon glyphicon-trash red bigger-120"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }

                ],
                "aLengthMenu": [[20, 100], ["20", "100"]],//??????????????????????????????????????????????????????;
                "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//?????????5????????????????????????
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                searching: false,
                "ajax": {
                    url: "/filter/listSource.jspa",
                    "data": function (d) {//????????????????????????
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //???columns?????????????????????
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
            if (data < 1000) return data + "ms";//1??????
            if (data < 10 * 1000) return data / 1000 + "s";//10??????
            data = Math.floor(data / 1000);
            if (data < 3600)//1?????????
                return (Math.floor(data / 60 % 60) > 0 ? Math.floor(data / 60 % 60).toString() + "m" : "") + (data % 60) + "s";
            else
                return (Math.floor(data / 3600) > 0 ? Math.floor(data / 3600).toString() + "h" : "") + Math.floor(data / 60 % 60) + "m";
            //todo ??????1??????

            /*// ?????????
            var hr = Math.floor(data / 3600);
            var hrStr = hr.toString();
            if (hrStr.length === 1) hrStr = '0' + hrStr;
            var returnStr = hrStr;
            // ?????????
            var min = Math.floor(data / 60 % 60);
            var minStr = min.toString();
            if (minStr.length === 1) minStr = '0' + minStr;
            returnStr += ':' + minStr;
            // ??????
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
            size = size.toFixed(2);//?????????????????????
            return size + ' ' + unitArr[index];
        }

        var currentAjax;

        function deleteSource(sourceID, filename) {
            if (sourceID === undefined) return;
            $('#filename').text(filename);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "????????????",
                //title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-trash bigger-110'></i>&nbsp;??????",
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
                                        myTable.ajax.reload(null, false);//null???callback,false????????????????????????
                                    else
                                        showDialog("???????????????" + result.succeed, result.message);
                                },
                                error: function (response, textStatus) {/*????????????404,500?????????*/
                                    showDialog("??????????????????" + response.status, response.responseText);
                                },
                                beforeSend: function () {
                                    if (currentAjax) currentAjax.abort();
                                    $('#loadingText').text("??????????????????????????????");
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
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; ??????",
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
                        //????????????????????????????????????Source
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
                        resizable: false, modal: true, title: "????????????", width: 580, height: 330,//title_html: true,
                        buttons: [
                            {
                                html: "<i class='ace-icon glyphicon glyphicon-refresh bigger-110'></i>&nbsp;????????????",
                                "class": "btn btn-danger btn-minier",
                                click: function () {
                                    sourceForm.submit();
                                    $(this).dialog("close");
                                }
                            }, {
                                html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; ??????",
                                "class": "btn btn-minier",
                                click: function () {
                                    $(this).dialog("close");
                                }
                            }
                        ]
                    });
                },
                error: function (response, textStatus) {/*????????????404,500?????????*/
                    showDialog("??????????????????" + response.status, response.responseText);
                }
            });
        }

        function showIndexDialog(sourceID, filename) {
            $('#filename4').text(filename);
            $("#dialog-index").removeClass('hide').dialog({
                resizable: false, modal: true, width: 350, title: "????????????",//title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-lightbulb-o bigger-110'></i>&nbsp;??????",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/filter/indexSource.jspa?sourceID=" + sourceID,
                                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    var result = JSON.parse(response);
                                    myTable.ajax.reload(null, false);//null???callback,false????????????????????????
                                    showDialog("???????????????" + result.succeed, result.message);
                                },
                                error: function (response, textStatus) {/*????????????404,500?????????*/
                                    showDialog("??????????????????" + response.status, response.responseText);
                                }
                            });
                            $(this).dialog("close");
                        }
                    },
                    {
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; ??????",
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
                        title: "???????????????",
                        width: 580,
                        height: 350,
                        //title_html: true,
                        buttons: [
                            {
                                html: "<i class='ace-icon fa fa-save bigger-110'></i>&nbsp;??????",
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
                                            showDialog("???????????????" + result.succeed, result.message);
                                            myTable.ajax.reload(null, false);//null???callback,false????????????????????????
                                        },
                                        error: function (response, textStatus) {/*????????????404,500?????????*/
                                            showDialog("??????????????????" + response.status, response.responseText);
                                        }
                                    });

                                    $(this).dialog("close");
                                }
                            }, {
                                html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; ??????",
                                "class": "btn btn-minier",
                                click: function () {
                                    $(this).dialog("close");
                                }
                            }
                        ]
                    });
                },
                error: function (response, textStatus) {/*????????????404,500?????????*/
                    showDialog("??????????????????" + response.status, response.responseText);
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
                            showDialog("????????????", result.message);
                        } else if (result.paragraphCount === 0) {
                            showDialog("????????????", result.message);
                        } else {
                            myTable.ajax.reload();
                        } */
                        showDialog("???????????????" + result.succeed, result.message);
                        myTable.ajax.reload(null, false);//null???callback,false????????????????????????
                    },
                    error: function (response, textStatus) {/*????????????404,500?????????*/
                        showDialog("??????????????????" + response.status, response.responseText);
                    },
                    beforeSend: function () {
                        if (currentAjax) currentAjax.abort();
                        $('#loadingText').text("????????????????????????????????????");
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
                    text: "??????", "class": "btn btn-primary btn-xs", click: function () {
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
            <a href="/index.jspa">??????</a>
        </li>
        <li class="active">????????????</li>
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
                        ??????????????????
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
        ????????????????????? <span id="filename" class="red"></span> ????????????????????????????????????????????????????????????
    </div>

    <div class="space-6"></div>

    <p class="bigger-110 bolder center grey">
        <i class="icon-hand-right blue bigger-120"></i>
        ????????????
    </p>
</div>
<div id="dialog-index" class="hide">
    <div class="alert alert-info bigger-110">
        ??????<br/> <span id="filename4" class="light-orange "></span> <br/>???????????????????????????????????????????????????????????????????????????
    </div>

    <div class="space-6"></div>

    <p class="bigger-110 bolder center grey">
        <i class="icon-hand-right blue bigger-120"></i>
        ????????????
    </p>
</div>

<div id="dialog-parse" class="hide" style="z-index: 10">
    <div class="col-xs-12" style="padding-top: 10px">
        <!-- PAGE CONTENT BEGINS -->
        <form class="form-horizontal" role="form" id="sourceForm">
            <div class="col-sm-12">
                <div class="row">
                    <label class="col-sm-2">?????????</label>
                    <div class="col-sm-10 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey;font-size:  large" id="filename3"></div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row" style="margin-bottom: 6px;margin-top:6px">
                    <label class="col-sm-4">????????????</label>
                    <div class="col-sm-8 no-padding" id="filesize" style="border-bottom: 1px solid; border-bottom-color: lightgrey;"></div>
                </div>
                <div class="row" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-sm-4">????????????</label>
                    <div class="col-sm-8 no-padding" id="uploadTime" style="border-bottom: 1px solid; border-bottom-color: lightgrey "></div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-sm-4">????????????</label>
                    <div class="col-sm-8 no-padding" id="fragmentCount" style="border-bottom: 1px solid; border-bottom-color: lightgrey "></div>
                </div>
            </div>
            <div class="col-sm-12 center">
                <div class="form-group" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-xs-2 control-label no-padding-right" for="regularID"> ??????????????? </label>
                    <div class="col-xs-5">
                        <select class="form-control col-xs-8" name="regularID" id="regularID">
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-sm-12" style="text-decoration-color: lightgrey">
                ?????????????????????????????????????????????
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
                    <label class="col-sm-2">?????????</label>
                    <div class="col-sm-10 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey;font-size:  large" id="filename9"></div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row" style="margin-bottom: 6px;margin-top:6px">
                    <label class="col-sm-4">????????????</label>
                    <div class="col-sm-8 no-padding" id="filesize9" style="border-bottom: 1px solid; border-bottom-color: lightgrey;"></div>
                </div>
                <div class="row" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-sm-4">????????????</label>
                    <div class="col-sm-8 no-padding" id="uploadTime9" style="border-bottom: 1px solid; border-bottom-color: lightgrey "></div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row" style="margin-bottom: 5px;margin-top: 5px">
                    <label class="col-sm-4">????????????</label>
                    <div class="col-sm-8 no-padding" id="fragmentCount9" style="border-bottom: 1px solid; border-bottom-color: lightgrey "></div>
                </div>
            </div>
            <div class="col-sm-12 center">
                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                    <label class="col-xs-2 control-label" for="source"> ?????? </label>
                    <div class="col-xs-10 pull-left">
                        <input type="text" id="source" name="source" class="col-xs-10" placeholder="??????"/>
                    </div>
                </div>
            </div>
            <input type="hidden" id="sourceID9" name="sourceID9">
        </form>
    </div>
</div>
<div id="dialog-error" class="hide alert" title="??????">
    <p id="errorText">?????????????????????????????????????????????????????????</p>
</div>
<div class="modal fade" id="loadingModal">
    <div style="width: 200px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-100px;margin-top:-10px">
        <div class="progress progress-striped active" style="margin-bottom: 0;">
            <div class="progress-bar" style="width: 100%;" id="loadingText">??????????????????</div>
        </div>
    </div>
</div>

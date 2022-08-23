<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.bootcss.com/datatables/1.10.21/js/jquery.dataTables.min.js"></script>
<script src="http://ace.jeka.by/assets/js/jquery.dataTables.bootstrap.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.6.3/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/select/1.3.1/js/dataTables.select.min.js"></script>
<script src="http://bootboxjs.com/assets/js/bootbox.all.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<%--<script src="https://cdn.bootcss.com/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>--%>
<script src="../js/resize.js"></script>
<!-- page specific plugin scripts --><%--
<script src="../components/jquery-ui/jquery-ui.js"></script>

<%--<link rel="stylesheet" href="../components/datatables/select.dataTables.css"/>--%>
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.1/css/select.dataTables.min.css"/>
<%--<link href="http://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" rel="stylesheet">--%>
<%--<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.css" />--%>
<link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
<script type="text/javascript">
    //https://www.cnblogs.com/yeminglong/p/5512271.html
    var HtmlUtil = {
        /*1.用浏览器内部转换器实现html转码*/
        htmlEncode: function (html) {
            //1.首先动态创建一个容器标签元素，如DIV
            var temp = document.createElement("div");
            //2.然后将要转换的字符串设置为这个元素的innerText(ie支持)或者textContent(火狐，google支持)
            (temp.textContent !== undefined) ? (temp.textContent = html) : (temp.innerText = html);
            //3.最后返回这个元素的innerHTML，即得到经过HTML编码转换的字符串了
            var output = temp.innerHTML;
            temp = null;
            return output;
        }
    };
    jQuery(function ($) {
        var myTable = $('#dynamic-table')
        //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "columns": [
                    {"data": "regularID", "sClass": "center"},
                    {"data": "regularName", "sClass": "center"},
                    {"data": "paragraph", "sClass": "center"},
                    {"data": "charset", "sClass": "center"},
                    {"data": "settingTime", "sClass": "center"},//4 
                    {"data": "regularID", "sClass": "center"}
                ],

                'columnDefs': [
                    {"orderable": false, "searchable": false, className: 'text-center', "targets": 0, width: 20},
                    {"orderable": false, className: 'text-center', "targets": 1, title: '配置名', width: 100},
                    {
                        "orderable": false, className: 'text-center', "targets": 2, title: '正规式', render: function (data, type, row, meta) {
                            return HtmlUtil.htmlEncode(data);
                        }
                    },
                    {"orderable": false, className: 'text-center', "targets": 3, title: '文件字符集', width: 110},
                    {"orderable": false, 'targets': 4, 'searchable': false, title: '设置时间', width: 130},
                    {
                        "orderable": false, 'searchable': false, 'targets': 5, title: '操作', width: 80,
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasLink" href="#" data-Url="javascript:editRegular({0});">'.format(data) +
                                '<i class="ace-icon fa fa-edit blue bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasLink" href="#" data-Url="javascript:deleteRegular({0},\'{1}\');">'.format(data, row["regularName"]) +
                                '<i class="ace-icon fa fa-trash-o red bigger-130"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }
                ],
                "aLengthMenu": [[20, 100], ["20", "100"]],//二组数组，第一组数量，第二组说明文字;
                //"aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                searching: false,
                "ajax": {
                    url: "/filter/listRegular.jspa",
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

            $('#dynamic-table tr').find('.hasLink').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
        });


        function deleteRegular(regularID, filename) {
            if (regularID === undefined) return;
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
                                url: "/filter/deleteRegular.jspa?regularID=" + regularID,
                                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    var result = JSON.parse(response);
                                    if (result.succeed)
                                        myTable.ajax.reload();
                                    else
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

        var regularForm = $('#regularForm');
        regularForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",

            highlight: function (e) {
                $(e).closest('.form-group').removeClass('has-info').addClass('has-error');
            },

            success: function (e) {
                $(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
                $(e).remove();
            },

            errorPlacement: function (error, element) {
                error.insertAfter(element.parent());
            },

            submitHandler: function (form) {
                //console.log(regularForm.serialize());// + "&productImage=" + av atar_ele.get(0).src);
                //console.log("form:" + form);
                var expressions = [];

                expressionTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    console.log("rowIdx1:" + rowIdx);
                    if ($('#expression-table tr').eq(rowIdx + 1).find('input[type="checkbox"]').prop("checked")) { //todo why +1
                        //var trRow = $("#expression-table tbody tr").eq(rowIdx);
                        console.log("rowIdx:" + rowIdx);
                        expressions.push({
                            "expressionID": this.data()["expressionID"],
                            "expressionName": this.data()["expressionName"],
                            "capturingName": this.data()["capturingName"],
                            "exp": this.data()["exp"],
                            "orderID": this.data()["orderID"]
                        });
                    }
                });
                console.log("expressions:" + JSON.stringify(expressions));
                var regular = {
                    expression: expressions, paragraph: $('#paragraph').val(), regularName: $('#regularName').val(), regularID: $('#regularID').val(),
                    charset: $('#charset').children('option:selected').val()
                };
                console.log("regular:" + JSON.stringify(regular));
                $.ajax({
                    type: "POST",
                    url: "/filter/saveRegular.jspa",
                    data: JSON.stringify(regular),
                    //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var result = JSON.parse(response);
                        if (!result.succeed) {
                            $("#errorText").html(result.errmsg);
                            $("#dialog-error").removeClass('hide').dialog({
                                modal: true,
                                width: 600,
                                title: result.title,
                                buttons: [{
                                    text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                        $(this).dialog("close");
                                        myTable.ajax.reload();
                                    }
                                }]
                            });
                        } else {
                            myTable.ajax.reload();
                            $("#dialog-edit").dialog("close");
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        $("#errorText").html(response.responseText);
                        $("#dialog-error").removeClass('hide').dialog({
                            modal: true,
                            width: 600,
                            title: "请求状态码：" + response.status,//404，500等
                            buttons: [{
                                text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                    $(this).dialog("close");
                                }
                            }]
                        });
                    }
                });
            },
            invalidHandler: function (form) {
                console.log("invalidHandler");
            }
        });

        function editRegular(regularID) {
            $.getJSON("/filter/getRegular.jspa?regularID=" + regularID, function (ret) {
                showRegularDialog(ret);
            });
        }

        /*  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) { //当切换tab时，强制重新计算列宽
              console.log("1");
              $.fn.dataTable.tables({visible: true, api: true}).columns.adjust();
          });*/
        var expressionTable;

        function showRegularDialog(regular) {
            expressionTable = $('#expression-table').DataTable({
                bAutoWidth: false, dom: 't',
                paging: false, searching: false, ordering: false, "destroy": true, "info": false,
                select: {style: 'multi', selector: 'td:first-child :checkbox'}, scrollCollapse: true,
                //height: 200, sScrollX: "100%", "sScrollXInner": "99%",
                scrollY: 200,
                "columns": [
                    {"data": "expressionID", "sClass": "center"},
                    {"data": "expressionName", "sClass": "center"},
                    {"data": "capturingName", "sClass": "center"},
                    {"data": "exp", "sClass": "center"},
                    {"data": "orderID", "sClass": "center"} //4
                ],

                'columnDefs': [
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return '<input type="checkbox">';
                        }
                    },
                    {"orderable": false, className: 'text-center', "targets": 1, title: '正规式名称', width: 100},
                    {"orderable": false, className: 'text-center', "targets": 2, title: '捕获名', width: 100},
                    {
                        "orderable": false, className: 'text-center', "targets": 3, title: '正规式', render: function (data, type, row, meta) {
                            return HtmlUtil.htmlEncode(data);
                        }
                    },
                    {"orderable": false, className: 'text-center', "targets": 4, title: '顺序号', width: 60}
                ],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: "/filter/listExpression.jspa",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });

            $('#regularName').val(regular.regularName);
            $('#paragraph').text(regular.paragraph);
            $('#regularID').val(regular.regularID);
            $("#charset option[value='" + regular.charset + "']").attr("selected", "selected");
            var title = "新增数据抽取配置", btnText = "增加";
            if (regular.regularID > 0) {
                title = "修改数据抽取配置";
                btnText = "保存";
            }
            $("#dialog-edit").removeClass('hide').dialog({
                resizable: false,
                width: 680,
                height: 610,
                modal: true,
                title: title,
                buttons: [{
                    html: "<i class='ace-icon fa fa-floppy-o bigger-110'></i>&nbsp;" + btnText,
                    "class": "btn btn-danger btn-minier",
                    click: function () {
                        if (regularForm.valid())
                            regularForm.submit();
                    }
                }, {
                    html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp;关闭",
                    "class": "btn btn-minier",
                    click: function () {
                        $('#dialog-edit').dialog('close');
                    }
                }],
                title_html: true
            });
        }

        //$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap padding-4';
        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "text": "<i class='fa fa-plus-square bigger-130'></i>&nbsp;&nbsp;新增",
                    "className": "btn btn-xs btn-white btn-primary "
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));
        myTable.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            showRegularDialog({regularID: 0, paragraph: ''});
        });
        $.ajax({
            type: "GET",
            url: "/filter/getConfigs.jspa",
            contentType: "application/json; charset=utf-8",
            cache: false,
            success: function (response, textStatus) {
                var respObject = JSON.parse(response);

                $('#qq').val(respObject.qq);
                $('#wx').val(respObject.wx);
                $('#skype').val(respObject.skype);
                $('#telegram').val(respObject.telegram);
            },
            error: function (response, textStatus) {/*能够接收404,500等错误*/
                $("#errorText").html(response.responseText);
                $("#dialog-error").removeClass('hide').dialog({
                    modal: true,
                    width: 600,
                    title: "请求状态码：" + response.status,//404，500等
                    buttons: [{
                        text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                            $(this).dialog("close");
                        }
                    }]
                });
            }

        });

        function showDialog(title, content) {
            $("#errorText").html(content);
            $("#dialog-error").removeClass('hide').dialog({
                modal: true,
                width: 500,
                title: title,
                buttons: [{
                    text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                        $(this).dialog("close");
                    }
                }]
            });
        }

        $('#saveConfigBtn').on('click', function (e) {
            var json = {'qq': $('#qq').val(), 'wx': $('#wx').val(), 'skype': $('#skype').val(), 'telegram': $('#telegram').val()};
            $.ajax({
                type: "POST",
                url: "/filter/saveConfigs.jspa",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(json),
                cache: false,
                success: function (response, textStatus) {
                    var result = JSON.parse(response);
                    //if (!result.succeed)
                    showDialog("请求结果：" + result.succeed, result.message);
                    /* else
                         showDialog("操作提示", result.message);*/
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    showDialog("请求状态码：" + response.status, response.responseText);
                }
            });
        });
    })
</script>
<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa">首页</a>
        </li>
        <li class="active">正规式配置</li>
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
        <div class="col-sm-12">

            <div class="row">

                <div class="col-sm-12">
                    <div class="table-header">
                        正规式配置列表
                        <div class="pull-right tableTools-container"></div>
                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div id="dt">
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                        </table>
                    </div>
                </div>
            </div>
            <div class="row">

                <div class="col-xs-12 col-sm-12">
                    <form class="form-horizontal" role="form" id="configForm">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                                    <label class="col-xs-2 control-label no-padding-right" for="regularName"> QQ </label>
                                    <div class="col-xs-10">
                                        <input type="text" id="qq" name="qq" class="col-xs-10 dark" placeholder="QQ"/>
                                    </div>

                                </div>
                                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                                    <label class="col-xs-2 control-label no-padding-right" for="paragraph"> 微信 </label>
                                    <div class="col-xs-10">
                                        <input type="text" id="wx" name="wx" class="col-xs-10 dark" placeholder="微信"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                                    <label class="col-xs-2 control-label no-padding-right" for="regularName"> 飞机 </label>
                                    <div class="col-xs-10">
                                        <input type="text" id="telegram" name="telegram" class="col-xs-10 dark" placeholder="telegram"/>
                                    </div>

                                </div>
                                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                                    <label class="col-xs-2 control-label no-padding-right" for="paragraph"> Skype </label>
                                    <div class="col-xs-10">
                                        <input type="text" id="skype" name="skype" class="col-xs-10 dark" placeholder="Skype"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row center">
                            <button type="button" class="btn btn-sm btn-success" id="saveConfigBtn">
                                保存
                                <i class="ace-icon glyphicon glyphicon-ok icon-on-right bigger-100"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

</div>
<!-- /.page-content -->
<div id="dialog-delete" class="hide">
    <div class="alert alert-info bigger-110">
        删除配置： <span id="filename" class="red"></span> ，不可恢复！<br/><br/>
        <span class="orange2">  警告：删除配置将严重影响数据抽取!</span>
    </div>

    <div class="space-6"></div>

    <p class="bigger-110 bolder center grey">
        <i class="icon-hand-right blue bigger-120"></i>
        确认吗？
    </p>
</div>
<div id="dialog-edit" class="hide" style="z-index: 10">
    <div class="col-xs-12" style="padding-top: 10px">
        <!-- PAGE CONTENT BEGINS -->
        <form class="form-horizontal" role="form" id="regularForm">
            <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                <label class="col-xs-2 control-label no-padding-right" for="regularName"> 配置名 </label>
                <div class="col-xs-10">
                    <input type="text" id="regularName" name="regularName" class="col-xs-10" placeholder="配置名"/>
                </div>

            </div>
            <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                <label class="col-xs-2 control-label no-padding-right" for="charset"> 字符集 </label>
                <div class="col-xs-5">
                    <select class="form-control col-xs-8" name="charset" id="charset">
                        <option value="ANSI">ANSI</option>
                        <option value="UTF-8">UTF-8</option>
                        <option value="GBK">GBK</option>
                    </select>
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                <label class="col-xs-2 control-label no-padding-right" for="paragraph"> 内容正规式 </label>
                <div class="col-xs-10">
                    <%-- <input type="text" id="paragraph" name="paragraph" placeholder="正规式" />--%>
                    <textarea class="col-xs-12 dark" id="paragraph" name="paragraph" rows="5">内容正规式</textarea>
                </div>
            </div>

            <div class="row">
                <label for="expression-table">选择需要解析的内容：</label>
                <table id="expression-table" class="table table-striped table-bordered table-hover">
                </table>
            </div>
            <input type="hidden" id="regularID" name="regularID">
        </form>
    </div>
</div>

<div id="dialog-error" class="hide alert" title="提示">
    <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
</div>
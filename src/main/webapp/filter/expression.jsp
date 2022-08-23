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

<%--<link rel="stylesheet" href="../components/datatables/select.dataTables.css"/>--%>
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.1/css/select.dataTables.min.css"/>

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
                    {"data": "expressionID", "sClass": "center"},
                    {"data": "expressionName", "sClass": "center"},
                    {"data": "capturingName", "sClass": "center"},
                    {"data": "exp", "sClass": "center"},
                    //  {"data": "orderID", "sClass": "center"},//4
                    {"data": "expressionID", "sClass": "center"}
                ],

                'columnDefs': [
                    {"orderable": false, "searchable": false, className: 'text-center', "targets": 0, width: 20},
                    {"orderable": false, className: 'text-center', "targets": 1, title: '中文名称', width: 100},
                    {"orderable": false, className: 'text-center', "targets": 2, title: '捕获名', width: 100},
                    {
                        "orderable": false, className: 'text-center', "targets": 3, title: '正规式', render: function (data, type, row, meta) {
                            return HtmlUtil.htmlEncode(data);
                        }
                    },
                    //{"orderable": false, className: 'text-center', "targets": 4, title: '顺序号', width: 100},
                    {
                        "orderable": false, 'searchable': false, 'targets': 4, title: '操作', width: 80,
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasLink" title="编辑"  href="#" data-Url="javascript:editExpression({0});">'.format(data) +
                                '<i class="ace-icon fa fa-edit blue bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasLink" title="删除" href="#" data-Url="javascript:deleteExpression({0},\'{1}\');">'.format(data, row["expressionName"]) +
                                '<i class="ace-icon fa fa-trash-o red bigger-130"></i>' +
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
                    url: "/filter/listExpression.jspa",
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

        function deleteExpression(expressionID, filename) {
            if (expressionID === undefined) return;
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
                                url: "/filter/deleteExpression.jspa?expressionID=" + expressionID,
                                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    var result = JSON.parse(response);
                                    if (result.succeed) {
                                        myTable.ajax.reload();
                                    } else
                                        bootbox.alert({message: "请求结果：" + result.succeed + "\n" + result.message});
                                    /*showDialog("请求结果：" + result.succeed, result.message);*/
                                    $('#dialog-delete').dialog('close');
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    //showDialog("请求状态码：" + response.status, response.responseText);
                                    console.log(response.responseText);
                                    bootbox.alert({
                                        message: response.responseText, callback: function () {
                                            $('#dialog-delete').dialog('close');
                                        }
                                    });
                                }
                            });

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

        var expressionForm = $('#expressionForm');
        expressionForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",
            rules: {
                capturingName: {required: true}/*,
                orderID: {digits: true, required: true}*/
            },
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
                $.ajax({
                    type: "POST",
                    url: "/filter/saveExpression.jspa",
                    data: expressionForm.serialize(),
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                    cache: false,
                    success: function (response, textStatus) {
                        var result = JSON.parse(response);
                        if (!result.succeed) {
                            bootbox.alert({
                                message: result.errmsg,
                                callback: function () {
                                    $("#dialog-edit").dialog("close");
                                }
                            });
                            /* $("#errorText").html(result.errmsg);
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
                             });*/
                        } else {
                            myTable.ajax.reload();
                            $("#dialog-edit").dialog("close");
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        bootbox.alert({
                            message: response.responseText,
                            callback: function () {
                                $("#dialog-edit").dialog("close");
                            }
                        });
                        /* $("#errorText").html(response.responseText);
                         $("#dialog-error").removeClass('hide').dialog({
                             modal: true,
                             width: 600,
                             title: "请求状态码：" + response.status,//404，500等
                             buttons: [{
                                 text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                     $(this).dialog("close");
                                 }
                             }]
                         });*/
                    }
                });
            },
            invalidHandler: function (form) {
                console.log("invalidHandler");
            }
        });

        function editExpression(expressionID) {
            $.getJSON("/filter/getExpression.jspa?expressionID=" + expressionID, function (ret) {
                showExpressionDialog(ret);
            });
        }

        function showExpressionDialog(expression) {
            $('#expressionName').val(expression[0].expressionName);
            $('#capturingName').val(expression[0].capturingName);
            $('#exp').val(expression[0].exp);
            $('#orderID').val(expression[0].orderID);
            $('#expressionID').val(expression[0].expressionID);
            var title = "新增正规式", btnText = "增加";
            if (expression[0].expressionID > 0) {
                title = "编辑正规式";
                btnText = "保存";
            }
            $("#dialog-edit").removeClass('hide').dialog({
                resizable: false,
                //icon:'fa fa-key',
                width: 680,
                height: 290,
                modal: true,
                title: title,
                buttons: [{
                    html: "<i class='ace-icon fa fa-floppy-o bigger-110'></i>&nbsp;" + btnText,
                    "class": "btn btn-danger btn-minier",
                    click: function () {
                        if (expressionForm.valid())
                            expressionForm.submit();
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
            showExpressionDialog([{expressionID: 0, capturingName: ''}]);
        });

        $("#bootbox-confirm").on(ace.click_event, function () {
            bootbox.confirm("Are you sure?", function (result) {
                if (result) {
                    //
                }
            });
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
    })
</script>
<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa">首页</a>
        </li>
        <li class="active">正规式库</li>
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
                        正规式列表
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
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

</div>
<!-- /.page-content -->
<div id="dialog-delete" class="hide">
    <div class="alert alert-info bigger-110">
        删除正规式： <span id="filename" class="red"></span> ，不可恢复！<br/><br/>
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
        <form class="form-horizontal" role="form" id="expressionForm">
            <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                <label class="col-xs-2 control-label no-padding-right" for="expressionName"> 中文名称</label>
                <div class="col-xs-10">
                    <input type="text" id="expressionName" name="expressionName" placeholder="正规式中文名"/>
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                <label class="col-xs-2 control-label no-padding-right" for="capturingName"> 捕获名 </label>
                <div class="col-xs-10">
                    <input type="text" id="capturingName" name="capturingName" placeholder="捕获名"/>
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                <label class="col-xs-2 control-label no-padding-right" for="exp"> 正规式 </label>
                <div class="col-xs-10">
                    <input type="text" id="exp" name="exp" style="width: 100%" placeholder="正规式"/>
                </div>
            </div>
            <%-- <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                 <label class="col-xs-2 control-label no-padding-right" for="orderID"> 顺序号 </label>
                 <div class="col-xs-10">
                     <input type="text" id="orderID" name="orderID" style="width: 50px" placeholder="顺序号"/>
                 </div>
             </div>--%>
            <input type="hidden" id="expressionID" name="expressionID">
        </form>
    </div>
</div>

<div id="dialog-error" class="hide alert" title="提示">
    <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
</div>
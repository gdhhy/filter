<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.bootcss.com/datatables/1.10.21/js/jquery.dataTables.min.js"></script>
<script src="http://ace.jeka.by/assets/js/jquery.dataTables.bootstrap.min.js"></script>

<script src="https://cdn.datatables.net/select/1.3.1/js/dataTables.select.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<%--<script src="https://cdn.bootcss.com/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>--%>
<script src="../js/resize.js"></script>
<%--<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>--%>
<%--<script src="http://static.runoob.com/assets/jquery-validation-1.14.0/dist/jquery.validate.min.js"></script>--%>


<script src="https://cdn.datatables.net/buttons/1.6.3/js/dataTables.buttons.min.js"></script>
<%--<script src="http://ace.jeka.by/assets/js/buttons.flash.min.js"></script>--%>
<script src="http://ace.jeka.by/assets/js/buttons.html5.min.js"></script>
<script src="http://ace.jeka.by/assets/js/buttons.print.min.js"></script>
<script src="http://ace.jeka.by/assets/js/buttons.colVis.min.js"></script>
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>
<script src="../components/moment/min/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.zh-CN.js"></script>


<!-- page specific plugin scripts --><%--
<script src="../components/jquery-ui/jquery-ui.js"></script>
<script src="https://cdn.bootcss.com/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>--%>
<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.1/css/select.dataTables.min.css"/>
<%--<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.css" />--%>
<link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

<script type="text/javascript">
    jQuery(function ($) {
        var startDate = moment().startOf('month');
        var endDate = moment();

        var sourceID = $.cookie('data-sourceID');
        var source = $.cookie('data-source');
        $.removeCookie('data-sourceID');
        $.removeCookie('data-source');
        var firstUrl = "/filter/solrSearch.jspa?queryField={0}&search={1}&source={2}&sourceID={3}&uploadTime1={4}&uploadTime2={5}".format("", "", "undefined" == typeof source ? "" : source,
            "undefined" == typeof sourceID ? "" : sourceID,
            startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"));

        var sourceInput = $('#source');
        var queryStartDate = new Date();
        if (sourceID) {
            $('#form-sourceID').val(sourceID);
            firstUrl += "?sourceID=" + sourceID;
            sourceInput.val(source);
            sourceInput.attr("readonly", true);
            sourceInput.after("<i  class='ace-icon fa fa-lock grey'></i>");
        }

        var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "columns": [
                    {"data": "id", "sClass": "center"},
                    {"data": "source_cn", "sClass": "center", "defaultContent": ""},
                    {"data": "body_cn", "sClass": "center"},
                    {"data": "publisher_cn", "sClass": "center"},
                    {"data": "publishTime_dt", "sClass": "center"},//4
                    {"data": "repeatCount_i", "sClass": "center"},
                    {"data": "link_cn", "sClass": "center", "defaultContent": ""}
                ],

                'columnDefs': [
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, className: 'text-center', "targets": 1, title: '来源', width: 200},
                    {
                        "orderable": false, className: 'text-center', "targets": 2, title: '段落', render: function (data, type, row, meta) {
                            if (data.length > 80) {
                                return "<a title='" + data.replace(/<br>/g, "\n") + "' href='#' style='text-decoration: none;'>" + data.replace(/[\r\n<br>]/g, "").substring(0, 78) + "…" + "</a>";
                            } else {
                                return data.replace(/[\r\n<br>]/g, "");
                            }
                        }
                    },
                    {"orderable": false, className: 'text-center', "targets": 3, title: '发布人', width: 120},
                    {"orderable": false, className: 'text-center', "targets": 4, title: '发布时间', width: 130},
                    {"orderable": false, className: 'text-center', "targets": 5, title: '次数', width: 50},
                    {
                        "orderable": false, 'targets': 6, 'searchable': false, title: '提取结果', render: function (data, type, row, meta) {
                            var jsonObject = $.parseJSON(data);
                            var text = "";
                            jQuery.each(jsonObject, function (key, val) {
                                text += '{0}:<a href="#"  class="research"  data-item="{1}" data-value="{2}">{3}</a><br/>'.format(key, key, val, val);
                            });
                            return text;
                        }
                    }
                ],
                "aLengthMenu": [[15, 100], ["15", "100"]],//二组数组，第一组数量，第二组说明文字;
                "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                searching: false,
                "ajax": {
                    url: firstUrl,
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
            /* myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                 cell.innerHTML = i + 1;
             });*/
        }).on('page.dt', function () {
            queryStartDate = new Date();
        }).on('draw', function () {
            var times = new Date() - queryStartDate;
            $('#headerText').text("符合条件记录列表， 查询耗时：" + times + " 毫秒");
            console.log("times:" + times);
            $('#dynamic-table tr').find('.research').click(function () {
                $('#queryField').val('"' + $(this).attr("data-value") + '"');
                //console.log("data-item:" + $(this).attr("data-item"));
                search();
            });
        });
        $('.btn-success').click(function () {
            search();
        });

        $('.form-search :text').keydown(function (event) {
            if (event.keyCode === 13)
                search();
        });


        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "extend": "copy",
                    "text": "<i class='fa fa-copy bigger-110 pink'></i> <span class='hidden'>Copy to clipboard</span>",
                    "className": "btn btn-white btn-primary btn-bold"
                },
                {
                    "extend": "csv",
                    "text": "<i class='fa fa-database bigger-110 orange'></i> <span class='hidden'>Export to CSV</span>",
                    "className": "btn btn-white btn-primary btn-bold"
                },
                {
                    "extend": "excel",
                    "text": "<i class='fa fa-file-excel-o bigger-110 green'></i> <span class='hidden'>Export to Excel</span>",
                    "className": "btn btn-white btn-primary btn-bold"
                },
                {
                    "extend": "pdf",
                    "text": "<i class='fa fa-file-pdf-o bigger-110 red'></i> <span class='hidden'>Export to PDF</span>",
                    "className": "btn btn-white btn-primary btn-bold"
                },
                {
                    "extend": "print",
                    "text": "<i class='fa fa-print bigger-110 grey'></i> <span class='hidden'>Print</span>",
                    "className": "btn btn-white btn-primary btn-bold",
                    autoPrint: false
                }
            ]
        }); // todo why only copy csv print
        myTable.buttons().container().appendTo($('.tableTools-container'));

        function search() {
            var url = "/filter/solrSearch.jspa?queryField={0}&search={1}&source={2}&sourceID={3}&uploadTime1={4}&uploadTime2={5}";

            queryStartDate = new Date();
            myTable.ajax.url(encodeURI(url.format($('#queryField').val().trim(), $('#search').val(), sourceInput.val(), $('#form-sourceID').val(),
                startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD")))).load();
        }

        //excel
        $('.btn-info').click(function () {
            var url = "/excel/solrSearch.jspa?queryField={0}&search={1}&source={2}&sourceID={3}&uploadTime1={4}&uploadTime2={5}";
            url = encodeURI(url.replace("/filter/", "/excel/").format($('#queryField').val().trim(), $('#search').val(), sourceInput.val(), $('#form-sourceID').val(),
                startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD")));

            window.location.href = url;
        });

        var sourceBloodHound = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('sourceID'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            // 在文本框输入字符时才发起请求
            remote: {url: "/filter/liveSource.jspa?pinyin=%QUERY", wildcard: '%QUERY'}
        });

        sourceBloodHound.initialize();
        //https://blog.haohtml.com/archives/17456
        $('#source').typeahead({hint: true},
            {
                limit: 100,
                source: sourceBloodHound.ttAdapter(),
                display: function (item) {
                    return item.source
                },
                templates: {
                    suggestion: function (item) {
                        return '<p><strong>' + item.source + '</strong> <br/> <span class="light-grey">上传日期：' + item.uploadTime + '</span></p>';
                    },

                    notFound: '<div class="red">没匹配</div>'

                }
            }
        );
        $('#source').bind('typeahead:select', function (ev, suggestion) {
            $('#form-sourceID').val(suggestion.sourceID);
        });
        $('#source').keydown(function (event) {
            if (event.which === 8)
                $('#form-sourceID').val('');
        });
        $('#form-dateRange').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            startDate: startDate,
            endDate: endDate,
            ranges: {
                '清空': [null, null],
                '本月': [moment().startOf('month')],
                '上月': [moment().month(moment().month() - 1).startOf('month'), moment().month(moment().month() - 1).endOf('month')],
                '本季': [moment().startOf('quarter')],
                '上季': [moment().quarter(moment().quarter() - 1).startOf('quarter'), moment().quarter(moment().quarter() - 1).endOf('quarter')],
                '今年': [moment().startOf('year')],
                '去年': [moment().year(moment().year() - 1).startOf('year'), moment().year(moment().year() - 1).endOf('year')]
            },
            locale: locale
        }, function (start, end, label) {
            startDate = start;
            endDate = end;
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
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
        <li class="active">全文搜索</li>
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

        <form class="form-search form-inline">
            <label>上传日期：</label>
            <!-- #section:plugins/date-time.datepicker -->
            <div class="input-group">
                <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
                       style="color: black;width:200px"
                       data-date-format="YYYY-MM-DD"/>
                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
            </div>&nbsp;&nbsp;&nbsp;
            <label class="control-label no-padding-right">段落： </label>
            <span class="input-icon input-icon-right">
                <input type="text" name="search" id="search" placeholder="段落……" class="nav-search-input" autocomplete="off" style="font-size: 9px;color: black"/>
            </span>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <div class="form-group">
                <label class="control-label no-padding-right" for="source">来源:</label>
                <div class="input-group">
                    <input type="text" name="source" id="source" placeholder="来源……" class="nav-search-input typeahead scrollable" autocomplete="off" style="font-size: 9px;color: black;width:300px"/>
                    <input type="hidden" id="form-sourceID"/>
                </div>
            </div>

            <label class=" control-label no-padding-right">&nbsp;&nbsp;&nbsp;提取结果： </label>

            <div class="input-group">

                <input class="nav-search-input ace " type="text" id="queryField" name="queryField"
                       style="width: 180px;font-size: 9px;color: black"
                       placeholder="完全匹配用英文双引号括起来"/>
            </div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            <button type="button" class="btn btn-sm btn-success" id="queryInfectious">
                查询
                <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-100"></i>
            </button> &nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-sm btn-info">
                导出
                <i class="ace-icon fa fa-file-excel-o icon-on-right bigger-100"></i>
            </button>
        </form>
    </div><!-- /.page-header -->


    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        <span id="headerText">符合条件记录列表</span>
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

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
<!-- page specific plugin scripts --><%--
<script src="../components/jquery-ui/jquery-ui.js"></script>
<script src="https://cdn.bootcss.com/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>--%>

<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.1/css/select.dataTables.min.css"/>
<%--<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.css" />--%>
<link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

<script type="text/javascript">
    jQuery(function ($) {
        /*var startDate = moment().subtract(365, 'd');
        var endDate = moment();*/
        var dataUrl = "/filter/listParagraph.jspa";
        var sourceID = $.cookie('data-sourceID');
        var source = $.cookie('data-source');
        $.removeCookie('data-sourceID');
        $.removeCookie('data-source');
        var sourceInput = $('#source');
        if (sourceID) {
            dataUrl = "/filter/listParagraph.jspa?sourceID=" + sourceID;
            sourceInput.val(source);
            sourceInput.attr("readonly", true);
            sourceInput.after("<i  class='ace-icon fa fa-lock grey'></i>");
        }
        //alert('dataUrl:' + dataUrl);

        var myTable = $('#dynamic-table')
        //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "columns": [
                    {"data": "paragraphID", "sClass": "center"},
                    {"data": "source", "sClass": "center", "defaultContent": ""},
                    {"data": "body", "sClass": "center"},
                    {"data": "publisher", "sClass": "center"},
                    {"data": "publishTime", "sClass": "center"},//4
                    {"data": "repeatCount", "sClass": "center"},
                    {"data": "qq", "sClass": "center", "defaultContent": ""},
                    {"data": "wx", "sClass": "center", "defaultContent": ""},
                    {"data": "telegram", "sClass": "center", "defaultContent": ""},
                    {"data": "skype", "sClass": "center", "defaultContent": ""},//9
                    {"data": "filename", "sClass": "center"}
                ],

                'columnDefs': [
                    {"orderable": false, "searchable": false, className: 'text-center', "targets": 0, width: 20},
                    {"orderable": false, className: 'text-center', "targets": 1, title: '??????', width: 200},
                    {
                        "orderable": false, className: 'text-center', "targets": 2, title: '??????', render: function (data, type, row, meta) {
                            if (data.length > 50) {
                                return "<a title='" + data.replace(/<br>/g, "\n") + "' href='#' style='text-decoration: none;'>" + data.replace(/[\r\n<br>]/g, "").substring(0, 48) + "???" + "</a>";
                            } else {
                                return data.replace(/[\r\n<br>]/g, "");
                            }
                        }
                    },
                    {"orderable": false, className: 'text-center', "targets": 3, title: '?????????', width: 120},
                    {"orderable": false, className: 'text-center', "targets": 4, title: '????????????', width: 130},
                    {"orderable": false, className: 'text-center', "targets": 5, title: '??????', width: 50},
                    {
                        "orderable": false, 'targets': 6, 'searchable': false, title: 'QQ', width: 80, render: function (data, type, row, meta) {
                            return data ? '<a href="#"  class="research"  data-item="qq" data-value="{0}">{1}</a>'.format(data, data) : '';
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 7, title: '??????', width: 60, render: function (data, type, row, meta) {
                            return data ? '<a href="#"  class="research"  data-item="wx" data-value="{0}">{1}</a>'.format(data, data) : '';
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 8, title: '??????', width: 80, render: function (data, type, row, meta) {
                            return data ? '<a href="#"  class="research"  data-item="telegram" data-value="{0}">{1}</a>'.format(data, data) : '';
                        }
                    },
                    {
                        "orderable": false, "searchable": false, className: 'text-center', "targets": 9, title: 'skype', width: 80,
                        render: function (data, type, row, meta) {
                            return data;
                          /*  if (data === null) return '';
                            var reg = new RegExp(/[<>]/g);
                            data = data.replace(reg, '');
                            return '<a href="#"  class="research"  data-item="skype" data-value="{0}">{1}</a>'.format(data, data.length > 28 ? data.substring(0, 26) + "..." : data);*/
                        }
                    },
                    {
                        "orderable": false, className: 'text-center', "targets": 10, title: '?????????', width: 80, render: function (data, type, row, meta) {
                            return data.substring(data.indexOf("/") + 1, data.indexOf("."));
                        }
                    }/*,
                    {
                        "orderable": false, 'searchable': false, 'targets': 10, title: '??????', width: 100,
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="green" href="#" data-memberNo="{0}">'.format(data) +
                                '<i class="ace-icon fa fa-film bigger-130"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }*/

                ],
                "aLengthMenu": [[15, 100], ["15", "100"]],//??????????????????????????????????????????????????????;
                "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//?????????5????????????????????????
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                searching: false,
                "ajax": {
                    url: dataUrl,
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
            $('#dynamic-table tr').find('.research').click(function () {
                $('#queryField').val($(this).attr("data-value"));
                $("#queryItem option[value='" + $(this).attr("data-item") + "']").attr("selected", "selected");
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
            var url = "/filter/listParagraph.jspa?queryItem={0}&queryField={1}&search={2}&source={3}";//publishTime1={0}&publishTime2={1}
            if (dataUrl.indexOf('?') > 0)
                url = dataUrl + '&queryItem={0}&queryField={1}&search={2}';
            myTable.ajax.url(encodeURI(url.format($('#queryItem').val(), $('#queryField').val().trim(), $('#search').val(), sourceInput.val()))).load();
        }

        //excel
        $('.btn-info').click(function () {
            var url = "/excel/listParagraph.jspa?queryItem={0}&queryField={1}&search={2}&source={3}&length=10000";//publishTime1={0}&publishTime2={1}
            if (dataUrl.indexOf('?') > 0)
                url = dataUrl + '&queryItem={0}&queryField={1}&search={2}&length=10000';
            url = encodeURI(url.replace("/filter/", "/excel/").format($('#queryItem').val(), $('#queryField').val().trim(), $('#search').val(), sourceInput.val()));

            window.location.href = url;
        });

        /*$('#form-dateRange').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
          /!*  startDate: startDate,
            endDate: endDate,*!/
            startDate: '', //startDate???endDate ??????????????? ranges ??????????????????????????????ranges?????????. ????????????????????????
            endDate: '',
            ranges: {
                '??????': [null, null],
                '??????': [moment().startOf('month')],
                '??????': [moment().month(moment().month() - 1).startOf('month'), moment().month(moment().month() - 1).endOf('month')],
                '??????': [moment().startOf('quarter')],
                '??????': [moment().quarter(moment().quarter() - 1).startOf('quarter'), moment().quarter(moment().quarter() - 1).endOf('quarter')],
                '??????': [moment().startOf('year')],
                '??????': [moment().year(moment().year() - 1).startOf('year'), moment().year(moment().year() - 1).endOf('year')]
            },
            locale: locale
        }, function (start, end, label) {
            startDate = start;
            endDate = end;
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });*/
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

        <form class="form-search form-inline">

            <label class=" control-label no-padding-right">????????? </label>
            <span class="input-icon input-icon-right">
                <input type="text" name="search" id="search" placeholder="??????????????????" class="nav-search-input" autocomplete="off" style="font-size: 9px;color: black"/>
            </span>

            <label class=" control-label no-padding-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;????????? </label>
            <span class="input-icon input-icon-right">
                <input type="text" name="source" id="source" placeholder="????????????" class="nav-search-input" autocomplete="off" style="font-size: 9px;color: black"/>
            </span>

            <label class=" control-label no-padding-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;???????????? </label>

            <div class="input-group">
                <select class="nav-search-input ace" id="queryItem" name="queryItem" style="font-size: 9px;color: black">
                    <option value="qq">QQ</option>
                    <option value="wx">??????</option>
                    <option value="telegram">??????</option>
                    <option value="skype">skype</option>
                </select>&nbsp;
                <input class="nav-search-input ace " type="text" id="queryField" name="queryField"
                       style="width: 180px;font-size: 9px;color: black"
                       placeholder="?????????"/>
            </div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            <%-- <label>???????????????</label>
             <!-- #section:plugins/date-time.datepicker -->
             <div class="input-group">
                 <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
                        style="color: black "
                        data-date-format="YYYY-MM-DD"/>
                 <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
             </div>&nbsp;&nbsp;&nbsp;--%>

            <button type="button" class="btn btn-sm btn-success" id="queryInfectious">
                ??????
                <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-100"></i>
            </button> &nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-sm btn-info">
                ??????
                <i class="ace-icon fa fa-file-excel-o icon-on-right bigger-100"></i>
            </button>
        </form>
    </div><!-- /.page-header -->


    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        ????????????????????????
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

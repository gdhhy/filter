<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>${systemTitle}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <!-- basic styles -->

    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

    <%--<!--[if IE 7]>
    <link rel="stylesheet" href="assets/css/font-awesome-ie7.min.css"/>
    <![endif]-->--%>

    <!-- page specific plugin styles -->

    <!-- fonts -->

    <link rel="stylesheet" href="assets/fonts/font.css?family=Open+Sans:400,300"/>

    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>
    <%--<link rel="stylesheet" href="http://ace.jeka.by/assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />--%>
    <%--<link rel="stylesheet" href="assets/css/ace-rtl.min.css"/>--%>

    <%--<!--[if lte IE 8]>
    <link rel="stylesheet" href="assets/css/ace-ie.min.css"/>
    <![endif]-->--%>

    <!-- inline styles related to this page -->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

    <%--<!--[if lt IE 9]>
    <script src="js/html5shiv/dist/html5shiv.js"></script>
    <script src="js/respond/dest/respond.min.js"></script>
    <![endif]-->--%>

    <%--<script src="js/jquery-1.12.4.min.js"></script>--%>

    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
    <script src="js/common.js"></script>


    <script type="text/javascript">
        jQuery(function ($) {
            var lastContent = $.getReferrerUrlParam("content");
            //var thisContent = $.getUrlParam("content");
            /*console.log("last:" + lastContent);
            console.log("this:" + thisContent);*/

            $.cookie('firstContent', lastContent);
        })
    </script>
</head>

<body class="login-layout">
<div class="main-container">
    <div class="main-content">
        <div class="row"><p></p>><p></p>><p></p>
            <div class="col-sm-10 col-sm-offset-1">
                <div class="login-container">
                    <div class="center">
                        <h1>
                            <i class="icon-leaf green"></i>
                            <span class="red">${systemTitle}</span>
                            <span class="white">${systemTitle2}</span>
                        </h1>
                    </div>

                    <div class="space-6"></div>

                    <div class="position-relative">
                        <div id="login-box" class="login-box visible widget-box no-border">
                            <div class="widget-body">
                                <div class="widget-main">
                                    <c:if test="${param.error == null or errMsg==''}">
                                        <h4 class="header blue lighter bigger">
                                            <i class="ace-icon fa fa-coffee green"></i>
                                            ???????????????????????????
                                        </h4>
                                    </c:if>
                                    <c:if test="${param.error != null }">
                                        <h4 class="header red lighter bigger">
                                            <i class="icon-coffee red"></i>
                                                ${errMsg}
                                        </h4>
                                    </c:if>
                                    <div class="space-6"></div>

                                    <form action="/login" method="post">
                                        <fieldset>
                                            <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="text" class="form-control" placeholder="?????????" id="username" name="loginName"/>
                                                            <i class="ace-icon fa fa-user"></i>
														</span>
                                            </label>

                                            <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="password" class="form-control" id="password" name="password" placeholder="??????"/>
														    <i class="ace-icon fa fa-lock"></i>
														</span>
                                            </label>
                                            <c:if test="${not empty captchaEnc}">
                                                <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="text" class="form-control" id="j_captcha" name="j_captcha" placeholder="?????????"/>
														   <img src="data:image/png;base64,${captchaEnc}"/></br>
														</span>
                                                </label>
                                            </c:if>

                                            <div class="space"></div>

                                            <div class="clearfix">
                                                <label class="inline">
                                                    <input type="checkbox" id="rememberme" name="remember-me" class="ace"/>
                                                    <span class="lbl">?????????</span>
                                                </label>
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                       value="${_csrf.token}"/>
                                                <button type="button" class="width-35 pull-right btn btn-sm btn-primary" onclick="javascript:submit();">
                                                    <i class="icon-key"></i>
                                                    ??????
                                                </button>
                                            </div>

                                            <div class="space-4"></div>
                                        </fieldset>
                                    </form>
                                    <br/>
                                </div>
                            </div><!-- /widget-body -->
                        </div><!-- /login-box -->

                        <div id="forgot-box" class="forgot-box widget-box no-border">
                            <div class="widget-body">
                                <div class="widget-main">
                                    <h4 class="header red lighter bigger">
                                        <i class="icon-key"></i>
                                        ????????????
                                    </h4>

                                    <div class="space-6"></div>
                                    <p>
                                        ??????????????????<span class="header blue bolder bigger"> ${loginName}</span>
                                    </p><br/><br/>

                                    <div class="clearfix">
                                        <button type="button" class="width-35 pull-right btn btn-sm btn-danger" onclick="location='${mainUrl}'">
                                            <i class="icon-lightbulb"></i>
                                            ??????
                                        </button>
                                    </div>
                                </div><!-- /widget-main -->

                                <div class="toolbar center">
                                    <a href="#" onclick="location='/logout.jspa'" class="back-to-login-link">
                                        ??????
                                        <i class="icon-arrow-right"></i>
                                    </a>
                                </div>
                            </div><!-- /widget-body -->
                        </div><!-- /forgot-box -->
                    </div><!-- /position-relative -->
                </div>
            </div><!-- /.col -->
        </div><!-- /.row -->
    </div>
</div><!-- /.main-container -->

<!-- basic scripts -->


<%--<script src="js/jquery-1.12.4.min.js"></script>--%>
<%--<script src="https://cdn.bootcss.com/jquery-1.12.4/jquery.min.js"></script>--%>
<script type="text/javascript">
    if ("ontouchend" in document) document.write("<script src='assets/js/jquery.mobile.custom.min.js'>" + "<" + "/script>");
</script>

<!-- inline scripts related to this page -->

<script type="text/javascript">
    function show_box(id) {
        jQuery('.widget-box.visible').removeClass('visible');
        jQuery('#' + id).addClass('visible');
    }

    $(function () {
        $('#password').bind('keypress', function (event) {
            if (event.keyCode === 13)
                $('form').eq(0).submit();
        });
    });
    <c:if test="${loginSucceed==true}">show_box("forgot-box");
    </c:if>
</script>
</body>
</html>

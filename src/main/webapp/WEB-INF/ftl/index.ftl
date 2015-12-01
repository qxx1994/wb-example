<!doctype html>
<html class="no-js">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>webbuilder</title>
    <meta name="description" content="webbuilder">
    <meta name="keywords" content="index">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <link rel="icon" type="image/png" href="assets/i/favicon.png">
    <link rel="apple-touch-icon-precomposed" href="assets/i/favicon.png">
    <meta name="apple-mobile-web-app-title" content="重庆市两江新区校园食品监管平台"/>
    <link rel="stylesheet" href="assets/css/amazeui.min.css"/>
    <link rel="stylesheet" href="assets/css/admin.css">
    <link rel="stylesheet" href="assets/css/font-awesome.min.css">
</head>
<body>
<!--[if lte IE 9]>
<p class="browsehappy">你正在使用<strong>过时</strong>的浏览器，系统暂不支持。 请 <a href="http://browsehappy.com/"  target="_blank">升级浏览器</a>
    以获得更好的体验！</p>
<![endif]-->

<header class="am-topbar admin-header">
    <div class="am-topbar-brand">
      <h1>webbuilder演示</h1>
    </div>
    <button class="am-topbar-btn am-topbar-toggle am-btn am-btn-sm am-btn-success am-show-sm-only"
            data-am-collapse="{target: '#topbar-collapse'}"><span class="am-sr-only">导航切换</span> <span
            class="am-icon-bars"></span></button>

    <div class="am-collapse am-topbar-collapse" id="topbar-collapse">
        <ul class="am-nav am-nav-pills am-topbar-nav am-topbar-right admin-header-list">
            <li class="am-dropdown" data-am-dropdown>
                <a  href="javascript:;">
                    <span class="am-icon-users"></span>${(user.name!='')?string(user.name,user.username)}
                </a>

            </li>
            <li class="am-dropdown" data-am-dropdown>
                <a   href="javascript:out();">
                    <span class="am-icon-power-off"></span> 退出
                </a>
            </li>
        </ul>
    </div>
</header>

<div class="am-cf admin-main">
    <!-- sidebar start -->
    <div class="admin-sidebar am-offcanvas " id="admin-offcanvas" style="overflow: auto">
        <div class="am-offcanvas-bar admin-offcanvas-bar">
            <ul class="am-list admin-sidebar-list">
                <li><a onclick="goPage('page/index_page.html');" href="javascript:void(0)"><span
                        class="am-icon-home"></span> 首页</a></li>

            <#list user.getModulesByPid("-1") as module>
                <#assign module_c_list=user.getModulesByPid(module.u_id,"M")/>
                <#if (module_c_list?size> 0)>
                <li class="admin-parent">
                    <a class="am-cf" data-am-collapse="{target: '#collapse-nav_${module.u_id}'}"><span class="${module.icon}"></span>
                     ${module.name}<span class="am-icon-angle-right am-fr am-margin-right"></span></a>
                    <ul class="am-list am-collapse admin-sidebar-sub <#if module_index==0>am-in</#if>" id="collapse-nav_${module.u_id}">
                     <#list module_c_list as module_c>
                         <li><a  onclick="goPage('${module_c.uri}');"  href="javascript:void(0)" class="am-cf">
                             <span class="${module_c.icon}"></span>
                         ${module_c.name}<span class="am-icon-star am-fr am-margin-right admin-icon-yellow"></span></a></li>
                     </#list>
                    </ul>
                </li>
                </#if>
            </#list>
                <li><a href="#"><span class="am-icon-sign-out"></span> 注销</a></li>
            </ul>

            <div class="am-panel am-panel-default admin-sidebar-panel">
                <div class="am-panel-bd">
                    <p><span class="am-icon-bookmark"></span> 公告</p>
                </div>
            </div>

        </div>
    </div>
    <!-- sidebar end -->

    <!-- content start -->
    <div class="admin-content" id="admin-content">
    </div>

</div>


<a href="#" class="am-show-sm-only admin-menu" data-am-offcanvas="{target: '#admin-offcanvas'}">
    <span class="am-icon-btn am-icon-th-list"></span>
</a>

<footer data-am-widget="footer"
        class="am-footer am-footer-default"
        data-am-footer="{  }">
    <div class="am-footer-switch">
    <div class="am-footer-miscs ">
        <p>CopyRight©2015</p>
        <p>webbuilder</p>
    </div>
</footer>

<!--[if lt IE 9]>
<script src="http://libs.baidu.com/jquery/1.11.1/jquery.min.js"></script>
<script src="http://cdn.staticfile.org/modernizr/2.8.3/modernizr.js"></script>
<script src="assets/js/amazeui.ie8polyfill.min.js"></script>
<![endif]-->

<!--[if (gte IE 9)|!(IE)]><!-->
<script src="assets/js/jquery.min.js"></script>
<!--<![endif]-->
<script src="assets/js/amazeui.min.js"></script>
<script src="assets/js/app.js"></script>
<script src="resources/boot.js"></script>
</body>
</html>

<script type="text/javascript">
    if (window.location.hash){
        if(window.location.hash.indexOf("/")!=-1){
            goPage(window.location.hash.substr(1));
        }
    }else{
        goPage("page/index_page.html");
    }

    function out(){
        seajs.use(["request"],function(reqeust){
            reqeust.post("login/exit",{},function(data){
                if(data.success){
                    window.location.href = "login.html";
                }
            });
        })
    }
</script>

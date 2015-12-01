<html>
<!DOCTYPE html>
<html lang="en" class="no-js">

<head>
    <meta charset="utf-8">
    <title>系统登陆</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- CSS -->
    <link rel="stylesheet" href="assets/css/reset.css">
    <link rel="stylesheet" href="assets/css/supersized.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/toastr.min.css">
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="assets/js/html5.js"></script>
    <![endif]-->
</head>
<body>
<div class="page-container">
    <h1>登录系统</h1>

    <form action="#" onsubmit="return false;" method="post">
        <input type="text" name="username" id="username" class="username" placeholder="请输入您的用户名！">
        <input type="password" name="password" id="password" class="password" placeholder="请输入您的用户密码！">
        <button type="submit" onclick="login()" class="submit_button">登录</button>
        <div class="error"><span>+</span></div>
    </form>
</div>
<!-- Javascript -->
<script src="assets/js/jquery-1.8.2.min.js"></script>
<script src="assets/js/supersized.3.2.7.min.js"></script>
<script src="assets/js/supersized-init.js"></script>
<script src="assets/js/scripts.js"></script>
<script src="assets/js/toastr.min.js"></script>
<script src="resources/boot.js"></script>
</body>
</html>
<script type="text/javascript">
    var url = "${param.url!''}";
    function login() {
        var username = $("#username").val();
        var password = $("#password").val();
        if (username == "" || password == "") {
            toastr["error"]("请输入正确的用户名密码!");
            return;
        }
       var info = showTips("info","登陆中...");
        seajs.use("request",function(request){
            request.post("login",{username:username,password:password},function(e){
                toastr.clear(info);
                if(e.success){
                   window.location.href=url!=""?url+window.location.hash:"index.html";
                }else{
                    toastr["error"](e.data);
                }
            })
        });
    }

    function showTips(type,message){
      return toastr[type](message);
    }

    toastr.options = {
        "closeButton": false,
        "debug": false,
        "newestOnTop": false,
        "progressBar": false,
        "positionClass": "toast-bottom-left",
        "preventDuplicates": false,
        "onclick": null,
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut":"4000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    };
</script>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a onclick="goPage('page/user/list.html')" href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">系统维护-用户管理</strong>
        </a>
    </div>
</div>
<form onsubmit="return false" id="searchForm" class="am-form-inline main_frame" user="form"
      style="margin-left: 20px;width: 99%">
    <div class="am-form-group">
        <input name="username$LIKE" class="am-form-field" placeholder="用户名">
    </div>
    <div class="am-form-group">
        <input name="name$LIKE" class="am-form-field" placeholder="姓名">
    </div>
    <button onclick="page.loadGrid()" class="am-btn am-btn-default">搜索</button>
    <#if user.hasAccessModuleLevel("user","C")>
        <button onclick="page.newModule()" class="am-btn am-btn-primary">新增</button>
    </#if>
</form>
<div class="am-panel am-panel-primary main_frame" style="margin-left: 20px;margin-right: 10px;margin-top: 5px;">
    <div class="am-panel-hd">用户列表</div>
    <div class="am-panel-bd">
        <div id="roe_list">

        </div>
    </div>
</div>
<form id="edit_form_" action="" style="display: none" onsubmit="return page.submitForm();" class="am-form sec_form"
      data-am-validator>

</form>

<script type="text/html" id="user_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover">
        <thead>
        <tr>
            <th>用户名</th>
            <th>姓名</th>
            <th>联系电话</th>
        <#if user.hasAccessModuleLevel("user","U")>
            <th>操作</th>
        </#if>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr id="index_{{index}}">
            <td>{{val.username}}</td>
            <td>{{val.name}}</td>
            <td>{{val.phone}}</td>
            <#if user.hasAccessModuleLevel("user","U")>
            <td>
                <button onclick="page.editModule('{{val.u_id}}')" class="am-btn-primary am-btn am-btn-default">
                    <i class="am-icon-cog"></i>
                    编辑
                </button>
            </td>
            </#if>
        </tr>
        {{/each}}
        </tbody>
    </table>
    <ul class="am-pagination am-pagination-centered">
        {{if pageIndex==0}}
        <li class="am-disabled"><a href="javascript:void('0')">&laquo;</a></li>
        {{/if}}
        {{if pageIndex!=0}}
        <li><a href="javascript:page.doPage(0)">&laquo;</a></li>
        {{/if}}
        {{buildPage totalPage}}
        {{if pageIndex==totalPage-1}}
        <li class="am-disabled"><a href="javascript:void('0')">&raquo;</a></li>
        {{/if}}
        {{if pageIndex!=totalPage-1}}
        <li><a href="javascript:page.doPage({{totalPage-1}})">&raquo;</a></li>
        {{/if}}
    </ul>
</script>

<script type="text/html" id="edit_user_form">
    <fieldset>
        <div class="am-form-group">
            <label for="username">用户名：</label>
            <input type="hidden" name="u_id" value="{{data.u_id}}"/>
            <input type="text" value="{{data.username}}" name="username" id="username" minlength="1"
                   placeholder="用户名不能为空"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="password">密码：</label>
            <input type="password" value="" name="password" id="password" minlength="1" placeholder="密码"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="name">姓名：</label>
            <input type="text" value="{{data.name}}" name="name" id="name" minlength="1" placeholder="姓名"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="phone">联系电话：</label>
            <input type="text" value="{{data.phone}}" name="phone" id="phone" minlength="1" placeholder="联系电话"/>
        </div>
        <div class="am-form-group">
            <label for="phone">e-mail：</label>
            <input type="text" value="{{data.email}}" name="email" id="email" minlength="1" placeholder="电子邮箱"/>
        </div>
        <div class="am-form-group">
            <label for="module_user">分配角色：</label>

            <div id="user_role_list" style="max-width: 600px;" class="am-scrollable-horizontal am-text-nowrap">

            </div>
        </div>
        <p align="center">
            <input id="submitBtn" type="submit" class="am-btn am-btn-primary btn-loading-example" value="提交"
                   data-am-loading="{loadingText: '保存中...', resetText: '保存成功!'}"/>
            <button class="am-btn am-btn-secondary" type="button" onclick="page.showGrid();">返回</button>
        </p>
    </fieldset>
</script>
<script type="text/html" id="user_role_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover am-table-compact">
        <thead>
        <tr>
            <th>/</th>
            <th>ID</th>
            <th>角色名称</th>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr class="am-active">
            <td align="right"><input id="c_{{val.u_id}}" class="r-user" value="{{val.u_id}}" name="users" type="checkbox"/></td>
            <td onclick="changeCheckBox('c_{{val.u_id}}')">{{val.u_id}}</td>
            <td onclick="changeCheckBox('c_{{val.u_id}}')">
                {{val.name}}
            </td>
        </tr>
        {{/each}}
        </tbody>
    </table>
</script>
<script type="text/javascript" src="${basePath}/resources/js/module/list.js">

</script>
<script type="text/javascript">
    var api = "user/", sortField = "u_id";
    var page = new Page({
        "list.div": "roe_list", "list.template": "user_list_template",
        "form.div": "edit_form_", "form.template": "edit_user_form"
    });

    function changeCheckBox(id) {
        var box = $('#' + id);
        logger.info(box.prop("checked"));
        box.prop("checked", (!box.prop("checked")) ? "checked" : false);
    }
    page.onAdd = page.onEdit = function (data) {
        if(data){
            $("#password").val("$default");
        }
        page.$request.list("role/", {}, function (datas) {
            if (datas.total) {
                var html = page.$template("user_role_list_template", datas);
                $("#user_role_list").html(html);
                if (data) {
                    $('.r-user').prop("checked", false);
                    var userRoles = data.data.userRoles;
                    $(userRoles).each(function (i, m) {
                        $('#c_' + m.role_id).prop("checked", true);
                    });
                }
            }
        });
    }

    page.submitForm = function () {
        var data = {};
        var arr = $("#" + page.config["form.div"]).serializeArray();
        $.each(arr, function (i, d) {
            data[d.name] = d.value;
        });
        data.userRoles = initUserRolesList();
        page.nowFunc(data);
        logger.info(data);
        return false;
    }
    function initUserRolesList(){
        var l = $(".r-user");
        var users = [];
        $(l).each(function(i,ro){
            if($(ro).prop("checked")){
                users.push({role_id:$(ro).val()});
            }
        });
        logger.info(users);
        return users;
    }
</script>
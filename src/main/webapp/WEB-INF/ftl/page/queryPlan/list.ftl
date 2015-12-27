<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a onclick="goPage('page/user/list.html')" href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">系统开发-查询方案管理</strong>
        </a>
    </div>
</div>
<form onsubmit="return false" id="searchForm" class="am-form-inline main_frame" user="form"
      style="margin-left: 20px;width: 99%">
    <div class="am-form-group">
        <input name="type$LIKE" class="am-form-field" placeholder="方案类型">
    </div>
    <div class="am-form-group">
        <input name="name$LIKE" class="am-form-field" placeholder="方案名称">
    </div>
    <button onclick="page.loadGrid()" class="am-btn am-btn-default">搜索</button>
<#if user.hasAccessModuleLevel("s_query_plan","C")>
    <button onclick="page.newModule({data:{}})" class="am-btn am-btn-primary">新建模板</button>
</#if>
</form>
<div class="am-panel am-panel-primary main_frame" style="margin-left: 20px;margin-right: 10px;margin-top: 5px;">
    <div class="am-panel-hd">方案列表</div>
    <div class="am-panel-bd">
        <div id="roe_list">

        </div>
    </div>
</div>
<form id="edit_form_" action="" style="display: none" onsubmit="return page.submitForm();" class="am-form sec_form"
      data-am-validator>

</form>

<script type="text/html" id="query_plan_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover">
        <thead>
        <tr>
            <th>方案类型</th>
            <th>方案名称</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr id="index_{{index}}">
            <td>{{val.type}}</td>
            <td>{{val.name}}</td>
            <td>
                <button onclick="page.editModule('{{val.u_id}}')" class="am-btn-primary am-btn am-btn-default">
                    <i class="am-icon-cog"></i>
                   编辑
                </button>
            </td>
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

<script type="text/html" id="query_plan_info_form">
    <fieldset>
        <div class="am-form-group">
            <label for="type">方案类型：</label>
            <input type="text"  value="{{data.type}}" name="type" id="type" minlength="1"
                   required/>
            <input type="hidden" readonly value="{{data.u_id}}" name="u_id" id="u_id"/>
        </div>
        <div class="am-form-group">
            <label for="name">方案名称：</label>
            <input type="text"  value="{{data.name}}" name="name" id="name" minlength="1"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="module_id">模块ID：</label>
            <input type="text"  value="{{data.module_id}}" name="module_id" id="module_id" minlength="1"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="data_api">数据接口：</label>
            <input type="text"  value="{{data.data_api}}" name="data_api" id="data_api" minlength="1"
                   required/>
        </div>

        <div class="am-form-group">
            <label for="query_condition">绑定角色：</label>
            <div id="role_bind_list" style="max-width: 500px;" class="am-scrollable-horizontal am-text-nowrap">

            </div>
        </div>
        <div class="am-form-group">
            <label for="query_condition">可选查询条件：</label>
            <div id="query_condition_list" style="max-width: 500px;" class="am-scrollable-horizontal am-text-nowrap">

            </div>
        </div>
        <div class="am-form-group">
            <label for="show_fields">列表显示字段：</label>
            <div id="show_fields_list" style="max-width: 500px;" class="am-scrollable-horizontal am-text-nowrap">
            </div>
        </div>
        <div class="am-form-group">
            <label for="info_template_id">查看详情模板：</label>
            <input type="text"  value="{{data.info_template_id}}" name="info_template_id" id="info_template_id" minlength="1" />
        </div>
        <p align="center">
            <input id="submitBtn" type="submit" class="am-btn am-btn-primary btn-loading-example" value="提交"
                   data-am-loading="{loadingText: '保存中...', resetText: '保存成功!'}"/>
            <button class="am-btn am-btn-secondary" type="button" onclick="page.showGrid();">返回</button>
        </p>
    </fieldset>
</script>

<script type="text/html" id="__role_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover am-table-compact">
        <thead>
        <tr>
            <th>/</th>
            <th>角色ID</th>
            <th>角色名称</th>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr class="am-active" class="role_bind_list_form">
            <td align="right"><input id="c_{{val.u_id}}" class="r-role" value="{{val.u_id}}" name="users" type="checkbox"/></td>
            <td onclick="changeCheckBox('c_{{val.u_id}}')">{{val.u_id}}</td>
            <td onclick="changeCheckBox('c_{{val.u_id}}')">
                {{val.name}}
            </td>
        </tr>
        {{/each}}
        </tbody>
    </table>
</script>

<script type="text/html" id="show_fields_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover am-table-compact">
        <thead>
        <tr>
            <th><i onclick="addShowFiles()" style="cursor: pointer" class="fa fa-plus"></i></th>
            <th>字段ID</th>
            <th>显示名称</th>
            <th>字典</th>
        </tr>
        </thead>
        <tbody  id="fields_table">
        {{each data as val index}}
        <tr  class="am-active fields_data" id="showFields_{{index}}">
            <td>
                <i class="fa fa-times" style="cursor: pointer" onclick="$('#showFields_{{index}}').remove()"></i>
            </td>
            <td><input style="width: 100%;" value="{{val.field}}" name="field" /></td>
            <td><input style="width: 100%;" value="{{val.header}}" name="header" /></td>
            <td><input style="width:  100%;" value="{{val.mapper}}" name="mapper" /></td>
        </tr>
        {{/each}}
        </tbody>
    </table>
</script>

<script type="text/html" id="query_condition_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover am-table-compact">
        <thead>
        <tr>
            <th><i onclick="addCondition()" style="cursor: pointer" class="fa fa-plus"></i></th>
            <th>字段ID</th>
            <th>显示名称</th>
            <th>类型</th>
        </tr>
        </thead>
        <tbody  id="condition_table">
        {{each data as val index}}
        <tr class="am-active condition_data" id="condition_{{index}}">
            <td>
                <i class="fa fa-times" style="cursor: pointer" onclick="$('#condition_{{index}}').remove()"></i>
            </td>
            <td><input style="width: 100%;" value="{{val.id}}"  name="id" /></td>
            <td><input style="width: 100%;" value="{{val.text}}"   name="text" /></td>
            <td><input  style="width: 100%;" value="{{val.type}}"  name="f_type" /></td>
        </tr>
        {{/each}}
        </tbody>
    </table>
</script>

<script type="text/javascript" src="${basePath}/resources/js/module/list.js"></script>

<script type="text/javascript">
    var plan_id;
    var api = "cf/s_query_plan/";
    var page = new Page({
        "list.div": "roe_list", "list.template": "query_plan_list_template",
        "form.div": "edit_form_", "form.template": "query_plan_info_form",
        "grid.sortField":"request_time","grid.sortOrder":"desc","auto.load":false
    });
    page.loadGrid = function () {
        var param = getFromData("searchForm");
        page.grid.sort("create_time","desc");
        param.includes=["name","type","u_id"];
        page.grid.load(param);

    }
    page.init(function(){
        page.loadGrid();
    });

    page.onAdd=page.onEdit=function(data){
        initBindList(data);
    }

    var id = 100000;
    function addShowFiles() {
        var html ="  <tr class=\"am-active fields_data\" id=\"showFields_"+id+"\">";
        html+= "<td><i class=\"fa fa-times\" style=\"cursor: pointer\" onclick=\"$('#showFields_"+id+"').remove()\"></i> </td>";
        html+="<td><input style=\"width: 100%;\" name=\"field\" /></td>";
        html+="<td><input style=\"width: 100%;\" name=\"header\" /></td>";
        html+="<td><input style=\"width: 100%;\" name=\"mapper\" /></td>";
        html+="</tr>";
        id++;
        $("#fields_table").append(html);
    }
    function addCondition(){
        var html ="  <tr class=\"am-active condition_data\" id=\"condition_"+id+"\">";
        html+= "<td><i class=\"fa fa-times\" style=\"cursor: pointer\" onclick=\"$('#condition_"+id+"').remove()\"></i> </td>";
        html+="<td><input style=\"width: 100%;\" name=\"id\" /></td>";
        html+="<td><input style=\"width: 100%;\" name=\"text\" /></td>";
        html+="<td><input style=\"width: 100%;\" name=\"f_type\" /></td>";
        html+="</tr>";
        id++;
        $("#condition_table").append(html);
    }

    function initBindList(data){
        seajs.use(["request","template"],function(request,template){

            if (!data.data.show_fields) {
                data.data.show_fields = "[]";
            } if (!data.data.query_condition) {
                data.data.query_condition = "[]";

            }
            var html = template("show_fields_list_template", {data: JSON.parse(data.data.show_fields)});
            $("#show_fields_list").html(html);
            var html = template("query_condition_list_template", {data: JSON.parse(data.data.query_condition)});
            $("#query_condition_list").html(html);

            request.list("role/", {}, function (datas) {
                if (datas.total) {
                    var html =template("__role_list_template", datas);
                    $("#role_bind_list").html(html);
                    if(data){
                        request.list("cf/s_query_plan_role", {key:JSON.stringify({plan_id:data.data.u_id})}, function (data) {
                            if("total" in data){
                                $(data.data).each(function(i,d){
                                   // if(d.is_default){
                                        $('#c_' + d.role_id).prop("checked", true);
                                   // }
                                });
                            }

                        });
                    }
                }
            });
        });
    }

    page.submitForm = function(){
        var data = {};
        var arr = $("#"+page.config["form.div"]).serializeArray();
        $.each(arr, function (i, d) {
            data[d.name] = d.value;
        });
        data.plan_role = initRoleData();
        data.query_condition = JSON.stringify(initConditionData());
        data.show_fields = JSON.stringify(initFieldsData());

        page.nowFunc(data);
        return false;
    }


    function initFieldsData(){
        var el = $(".fields_data");
        var datas=[];
        $(el).each(function (i, e) {
            var field = $($("#" + e.id + " input[name='field']")).val();
            var header = $($("#" + e.id + " input[name='header']")).val();
            var mapper = $($("#" + e.id + " input[name='mapper']")).val();
            var tmp = {field:field,header:header,mapper:mapper};
            datas.push(tmp);
        });
        return datas;
    }

    function initConditionData(){
        var el = $(".condition_data");
        var datas=[];
        $(el).each(function (i, e) {
            var id = $($("#" + e.id + " input[name='id']")).val();
            var text = $($("#" + e.id + " input[name='text']")).val();
            var type = $($("#" + e.id + " input[name='f_type']")).val();
            var tmp = {id:id,text:text,type:type};
            datas.push(tmp);
        });
        return datas;
    }


    function initRoleData(){
        var el = $(".r-role");
        var roles = [];
        $(el).each(function (i, ro) {
            if ($(ro).prop("checked")) {
                roles.push({role_id: $(ro).val(),is_default:0});
            }
        });
        return roles;
    }

    function changeCheckBox(id) {
        var box = $('#' + id);
        logger.info(box.prop("checked"));
        box.prop("checked", (!box.prop("checked")) ? "checked" : false);
    }

</script>
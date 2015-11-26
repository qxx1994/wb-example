<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a onclick="goPage('page/role/list.html')" href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">系统维护-角色管理</strong>
        </a>
    </div>
</div>
<form onsubmit="return false" id="searchForm" class="am-form-inline main_frame" role="form"
      style="margin-left: 20px;width: 99%">
    <div class="am-form-group">
        <input name="name$LIKE" class="am-form-field" placeholder="名称">
    </div>
    <button onclick="page.loadGrid()" class="am-btn am-btn-default">搜索</button>
    <button onclick="page.newModule()" class="am-btn am-btn-primary">新增</button>
</form>
<div class="am-panel am-panel-primary main_frame" style="margin-left: 20px;margin-right: 10px;margin-top: 5px;">
    <div class="am-panel-hd">角色列表</div>
    <div class="am-panel-bd">
        <div id="roe_list">

        </div>
    </div>
</div>
<form id="edit_form_" action="" style="display: none" onsubmit="return page.submitForm();" class="am-form sec_form"
      data-am-validator>

</form>

<script type="text/html" id="role_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover">
        <thead>
        <tr>
            <th>ID</th>
            <th>名称</th>
            <th>备注</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr id="index_{{index}}">
            <td>{{val.u_id}}</td>
            <td>{{val.name}}</td>
            <td>{{val.remark}}</td>
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

<script type="text/html" id="edit_role_form">
    <fieldset>
        <div class="am-form-group">
            <label for="u_id">角色标识(ID)：</label>
            <input type="text" value="{{data.u_id}}" name="u_id" id="u_id" minlength="1" placeholder="ID不能为空"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="name">角色名称：</label>
            <input type="text" value="{{data.name}}" name="name" id="name" minlength="1" placeholder="名称不能为空"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="remark">备注：</label>
            <textarea id="remark" name="remark" maxlength="200">{{data.remark}}</textarea>
        </div>
        <div class="am-form-group" >
            <label for="module_role">权限分配：</label>
            <div id="module_list" style="max-width: 800px" class="am-scrollable-horizontal am-text-nowrap">

            </div>
        </div>
        <p align="center">
            <input id="submitBtn" type="submit" class="am-btn am-btn-primary btn-loading-example" value="提交"
                   data-am-loading="{loadingText: '保存中...', resetText: '保存成功!'}"/>
            <button class="am-btn am-btn-secondary" type="button" onclick="page.showGrid();">返回</button>
        </p>
    </fieldset>
</script>
<script type="text/html" id="module_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover am-table-compact">
        <thead>
        <tr>
            <th>/</th>
            <th>ID</th>
            <th>权限名称</th>
            <th>操作选项</th>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        {{if val.p_id=='-1'}}
        <tr class="am-active">
            <td align="center" style="cursor: pointer">
                <i class="fa fa-exchange fa-1x"></i>
            </td>
            <td>{{val.u_id}}</td>
            <td>{{val.name}}</td>
            <td>
                /
            </td>
        </tr>
        {{/if}}

        {{if val.p_id!='-1'}}
        {{option=toObj(val.m_option)}}
        <tr class="role_module" id="{{val.u_id}}">
            <td align="right">
                <input id="c_{{val.u_id}}" class="r-used" p_id="{{val.p_id}}" value="{{val.u_id}}" name="operate" type="checkbox"/>
            </td>
            <td onclick="changeCheckBox('c_{{val.u_id}}')">{{val.u_id}}</td>
            <td onclick="changeCheckBox('c_{{val.u_id}}')">
                <i class="{{val.icon}}"></i>
                {{val.name}}
            </td>
            <td>
                {{each option as op index}}
                <label class="am-checkbox-inline">
                    <input type="checkbox" class="level-used" id="{{val.u_id}}-{{op.id}}"  {{if op.checked}} checked="checked" {{/if}} name="levels" value="{{op.id}}">{{op.text}}({{op.id}})
                </label>
                {{/each}}
            </td>
        </tr>
        {{/if}}
        {{/each}}
        </tbody>
    </table>
</script>
<script type="text/javascript" src="${basePath}/resources/js/module/list.js">

</script>
<script type="text/javascript">
    var api = "/role/", sortField = "u_id";
    var page = new Page({
        "list.div": "roe_list", "list.template": "role_list_template",
        "form.div": "edit_form_", "form.template": "edit_role_form"
    });
    page.onAdd=page.onEdit = function (data) {
        page.$request.list("/module/", {sortField: "sort_index"}, function (datas) {
            if (datas.total) {
                var html = page.$template("module_list_template", datas);
                $("#module_list").html(html);
                if(data){
                    $('.level-used').prop("checked",false);
                    $('.r-used').prop("checked",false);
                    var modules = data.data.modules;

                    $(modules).each(function(i,m){

                        $('#c_' + m.module_id).prop("checked",true);
                        $(m.levels).each(function(i,l){
                            $('#' + m.module_id+"-"+ l).prop("checked",true);
                        });
                    });
                }
            }
        });
    }
    function changeCheckBox(id) {
        var box = $('#' + id);
        logger.info(box.prop("checked"));
        box.prop("checked", (!box.prop("checked")) ? "checked" : false);
    }
    function showOrHide(clazz) {
        $(clazz).toggle();
        ;
    }
    function initModulesList(){
        var modules = [];
        var role_module_e = $(".role_module");
        var tmp={};
        $(role_module_e).each(function(i,e){
            var used = $("#"+e.id+" .r-used");
            if(!$(used[0]).prop("checked")){
                return;
            }
            var roleModule = {};
            roleModule.module_id = e.id;
            var levels_list = [];
            var levels = $("#"+e.id+" .level-used");
            $(levels).each(function(x,d){
                    if(!$(d).prop("checked"))return;
                    levels_list.push($(d).val());
            });
            roleModule.o_level=JSON.stringify(levels_list);
            modules.push(roleModule);
            var p_id = $(used[0]).attr("p_id");
            tmp[p_id] = p_id;

        });
       for(var e in tmp){
           modules.push({o_level:"[\"M\"]",module_id:e});
       }
        logger.info(modules);
        return modules;
    }

    page.submitForm = function () {
        var data = {};
        var arr = $("#"+page.config["form.div"]).serializeArray();
        $.each(arr, function (i, d) {
            data[d.name] = d.value;
        });
        data.modules = initModulesList();
        page.nowFunc(data);
        logger.info(data);
        return false;
    }
</script>
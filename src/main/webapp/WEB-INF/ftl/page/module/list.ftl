<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a onclick="goPage('page/module/list.html')" href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">系统维护-权限管理</strong>
        </a>
    </div>
</div>
<form onsubmit="return false" id="searchForm" class="am-form-inline main_frame" role="form"
      style="margin-left: 20px;width: 99%">
    <div class="am-form-group">
        <input name="name$LIKE" class="am-form-field" placeholder="名称">
    </div>

    <div class="am-form-group">
        <input name="sort_index$START" class="am-form-field" placeholder="序号">
    </div>
    <button onclick="page.loadGrid()" class="am-btn am-btn-default">搜索</button>
    <#if user.hasAccessModuleLevel("module","C")>
    <button onclick="add()" class="am-btn am-btn-primary">新增</button>
    </#if>
</form>
<div class="am-panel am-panel-primary main_frame" style="margin-left: 20px;margin-right: 10px;margin-top: 5px;">
    <div class="am-panel-hd">权限列表</div>
    <div class="am-panel-bd">
        <div id="module_list" class="am-scrollable-horizontal am-text-nowrap">

        </div>
    </div>
</div>
<form id="edit_form_" action="" style="display: none" onsubmit="return page.submitForm();" class="am-form sec_form"
      data-am-validator>

</form>

<script type="text/html" id="m_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover">
        <thead>
        <tr>
            <th>ID</th>
            <th>父级</th>
            <th>名称</th>
            <th>映射路径</th>
            <th>图标</th>
            <th>序号</th>
            <th>状态</th>
        <#if user.hasAccessModuleLevel("module","U")>
            <th>操作</th>
        </#if>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr id="index_{{index}}" {{val.p_id=="-1"?"class=am-active":""}}>
            <td>{{val.u_id}}</td>
            <td>{{val.p_id}}</td>
            <td>{{val.name}}</td>
            <td>{{val.uri}}</td>
            <td><span class="{{val.icon}}"></span></td>
            <td>{{val.sort_index}}</td>
            <td>{{sta val.status}}</td>
        <#if user.hasAccessModuleLevel("module","U")>
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

<script type="text/html" id="edit_form">
    <fieldset>
        <div class="am-form-group">
            <label for="u_id">权限标识(ID)：</label>
            <input type="text" value="{{data.u_id}}"  {{if data.u_id}}readonly{{/if}} name="u_id" id="u_id" minlength="1" placeholder="ID不能为空"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="name">权限名称：</label>
            <input type="text" value="{{data.name}}" name="name" id="name" minlength="1" placeholder="名称不能为空"
                   required/>
        </div>

        <div class="am-form-group">
            <label for="uri">映射路径：</label>
            <input type="text" id="uri" name="uri" value="{{data.uri}}" placeholder="uri地址"/>
        </div>
        <div class="am-form-group">
            <label for="icon">图标</label>
            <input type="text" id="icon" name="icon" value="{{data.icon}}" placeholder="图标样式"/>
            <small><a target="_blank" href="http://fontawesome.io/icons/">获取图标样式</a></small>
            <span class="am-form-caret"></span>
        </div>
        <div class="am-form-group">
            <label for="p_id">上级菜单</label>
            <input type="text" id="p_id" name="p_id" value="{{data.p_id}}" placeholder="父目录" required/>
            <span class="am-form-caret"></span>
        </div>
        <div class="am-form-group">
            <label for="sort_index">序号：</label>
            <input type="number" name="sort_index" value="{{data.sort_index}}" class="" id="sort_index"
                   placeholder="排序序号" min="0"
                   max="99999999999999999" required/>
        </div>
        <div class="am-form-group">
            <label for="remark">备注：</label>
            <textarea id="remark" name="remark" maxlength="200">{{data.remark}}</textarea>
        </div>
        <div class="am-form-group">
            <label for="level_list" style="color: red">可选权限：</label>

            <div id="level_list" style="max-width: 600px;" class="am-scrollable-horizontal am-text-nowrap">
                {{option=toObj(data.m_option)}}
                <table id="level_table"
                       class="am-table am-table-bordered am-table-striped am-table-hover am-table-compact">
                    <thead>
                    <tr>
                        <td align="center"><i onclick="newLevel()" style="cursor: pointer" class="fa fa-plus"></i></td>
                        <th>ID</th>
                        <th>名称</th>
                        <th>是否默认</th>
                    </tr>
                    </thead>
                    <tbody>
                    {{each option as op index}}
                    <tr class="level_list_form am-active" id="level_{{op.id}}">
                        <form action="#" onsubmit="return false;">
                            <td align="center"><i class="fa fa-times" style="cursor: pointer"
                                                  onclick="$('#level_{{op.id}}').remove()"></i></td>
                            <td><input name="l_id" style="width: 80px" value="{{op.id}}"/></td>
                            <td><input name="l_text" value="{{op.text}}"/></td>
                            <td>
                                <input name="checked" type="checkbox" {{op.checked?'checked':''}}/>
                            </td>
                        </form>
                    </tr>
                    {{/each}}
                    </tbody>
                </table>
            </div>
        </div>

        <p align="center">
            <input id="submitBtn" type="submit" class="am-btn am-btn-primary btn-loading-example" value="提交"
                   data-am-loading="{loadingText: '保存中...', resetText: '保存成功!'}"/>
            <button class="am-btn am-btn-secondary" type="button" onclick="page.showGrid();">返回</button>
        </p>
    </fieldset>
</script>


<script type="text/javascript" src="${basePath}/resources/js/module/list.js">
</script>
<script type="text/javascript">
    var api = "/module/";
    var page = new Page({
        "list.div": "module_list", "list.template": "m_template",
        "form.div": "edit_form_", "form.template": "edit_form",
        "grid.sortField": "sort_index", "grid.sortOrder": "asc"
    });

    function add() {
        var def = "[{\"id\":\"M\", \"text\":\"菜单可见\", \"uri\":\"\"},{\"id\":\"C\", \"text\":\"新增\", \"uri\":\"\"},{\"id\":\"R\", \"text\":\"查询\", \"uri\":\"\"},{\"id\":\"U\", \"text\":\"修改\", \"uri\":\"\"},{\"id\":\"D\", \"text\":\"删除\", \"uri\":\"\"}]";
        page.newModule({m_option: def})
    }
    var l_tmp = 1;
    function newLevel() {
        var id = l_tmp++;
        var html = '<tr class="am-active level_list_form" id="level_' + id + '">';
        html += '   <td align="center"><i class="fa fa-times" onclick="$(\'#level_' + id + '\').remove()"></i></td>';
        html += '  <td><input name="l_id" style="width: 80px"/></td>';
        html += '<td><input name="l_text" /></td>';
        html += ' <td><input type="checkbox" name="checked"/></td>';
        html += "</tr>"
        $("#level_table").append(html);
    }

    page.submitForm = function(){
        var data = {};
        var arr = $("#"+page.config["form.div"]).serializeArray();
        $.each(arr, function (i, d) {
            data[d.name] = d.value;
        });
        data.m_option=JSON.stringify(initLevelData());
        page.nowFunc(data);
        return false;
    }

    function initLevelData() {
        var el = $(".level_list_form");
        var datas=[];
        $(el).each(function (i, e) {
            var id = $($("#" + e.id + " input[name='l_id']")).val();
            var text = $($("#" + e.id + " input[name='l_text']")).val();
            var checked = $($("#" + e.id + " input[name='checked']")).prop("checked");
            var tmp = {id:id,text:text,checked:checked};
            datas.push(tmp);
        });
        return datas;
    }

</script>
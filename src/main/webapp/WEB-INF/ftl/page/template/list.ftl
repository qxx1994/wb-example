<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a onclick="goPage('page/module/list.html')" href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">系统开发-模板管理</strong>
        </a>
    </div>
</div>
<form onsubmit="return false" id="searchForm" class="am-form-inline main_frame" role="form"
      style="margin-left: 20px;width: 99%">
    <div class="am-form-group">
        <input name="name$LIKE" class="am-form-field" placeholder="模板类型">
    </div>

    <div class="am-form-group">
        <input name="sort_index$START" class="am-form-field" placeholder="模板名称">
    </div>
    <button onclick="page.loadGrid()" class="am-btn am-btn-default">搜索</button>
<#if user.hasAccessModuleLevel("s_template","C")>
    <button onclick="goPage('page/template/save.html')" class="am-btn am-btn-primary">新建模板</button>
</#if>
</form>
<div class="am-panel am-panel-primary main_frame" style="margin-left: 20px;margin-right: 10px;margin-top: 5px;">
    <div class="am-panel-hd">模板列表</div>
    <div class="am-panel-bd">
        <div id="s_template_list" class="am-scrollable-horizontal am-text-nowrap">

        </div>
    </div>
</div>
<form id="s_template_edit_form_" action="" style="display: none" onsubmit="return page.submitForm();"
      class="am-form sec_form"
      data-am-validator>

</form>

<script type="text/html" id="s_template_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover">
        <thead>
        <tr>
            <th>ID</th>
            <th>模板类型</th>
            <th>模板名称</th>
        <#if user.hasAccessModuleLevel("s_template","U")>
            <th>操作</th>
        </#if>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr id="index_{{index}}" {{val.p_id=="-1"?"class=am-active":""}}>
            <td>{{val.u_id}}</td>
            <td>{{val.type}}</td>
            <td>{{val.name}}</td>
        <#if user.hasAccessModuleLevel("s_template","U")>
            <td>
                <button onclick="goPage('page/template/save.html?id={{val.u_id}}')" class="am-btn-primary am-btn am-btn-default">
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

<script type="text/html" id="s_template_edit_form">
    <fieldset>
        <div class="am-form-group">
            <label for="u_id">ID：</label>
            <input type="text" value="{{data.u_id}}" {{if data.u_id}}readonly{{/if}} name="u_id" id="u_id" minlength="1"
            placeholder="ID不能为空"
            required/>
        </div>

        <div class="am-form-group">
            <label for="type">模板类型：</label>
            <input type="text" value="{{data.type}}" name="type" id="type" minlength="1" placeholder="类型不能为空"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="name">模板名称：</label>
            <input type="text" value="{{data.name}}" name="name" id="name" minlength="1" placeholder="名称不能为空"
                   required/>
        </div>

        <div class="am-form-group">
            <label for="remark">模板内容：</label>
            <div id="content_frame">

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
    var api = "cf/s_template";
    var page = new Page({
        "list.div": "s_template_list", "list.template": "s_template_template",
        "form.div": "s_template_edit_form_", "form.template": "s_template_edit_form"
    });


</script>
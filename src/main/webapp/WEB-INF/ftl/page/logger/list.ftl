<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a onclick="goPage('page/user/list.html')" href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">系统维护-日志管理</strong>
        </a>
    </div>
</div>
<form onsubmit="return false" id="searchForm" class="am-form-inline main_frame" user="form"
      style="margin-left: 20px;width: 99%">
    <div class="am-form-group">
        <input name="module_desc$LIKE" class="am-form-field" placeholder="操作类型">
    </div>
    <div class="am-form-group">
        <input name="s_user.username" class="am-form-field" placeholder="操作用户">
    </div>
    <button onclick="page.loadGrid()" class="am-btn am-btn-default">搜索</button>
</form>
<div class="am-panel am-panel-primary main_frame" style="margin-left: 20px;margin-right: 10px;margin-top: 5px;">
    <div class="am-panel-hd">日志列表</div>
    <div class="am-panel-bd">
        <div id="roe_list">

        </div>
    </div>
</div>
<form id="edit_form_" action="" style="display: none" onsubmit="return page.submitForm();" class="am-form sec_form"
      data-am-validator>

</form>

<script type="text/html" id="logger_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover">
        <thead>
        <tr>
            <th>ip</th>
            <th>请求时间</th>
            <th>操作类型</th>
            <th>操作用户</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr id="index_{{index}}">
            <td>{{val.client_ip}}</td>
            <td>{{val.request_time}}</td>
            <td>{{val.module_desc}}</td>
            <td>{{val.s_user.username}}</td>
            <td>
                <button onclick="page.editModule('{{val.u_id}}')" class="am-btn-primary am-btn am-btn-default">
                    <i class="am-icon-cog"></i>
                   详情
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

<script type="text/html" id="logger_info_form">
    <fieldset>
        <div class="am-form-group">
            <label for="username">ID：</label>
            <input type="text" readonly value="{{data.u_id}}" name="u_id" id="u_id" minlength="1"/>
        </div>

        <div class="am-form-group">
            <label for="password">操作类型：</label>
            <input type="text" readonly value="{{data.module_desc}}" name="module_desc" id="module_desc" minlength="1"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="name">请求时间(耗时)：</label>
            <input type="text" readonly value="{{data.request_time}}({{data.use_time}}ms) " name="request_time" id="request_time" minlength="1"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="phone">请求路径：</label>
            <input type="text" readonly value="{{data.request_uri}}" name="request_uri" id="request_uri" minlength="1"/>
        </div>
        <div class="am-form-group">
            <label for="phone">class：</label>
            <input type="text" readonly value="{{data.class_name}}" name="class_name" id="class_name" minlength="1" />
        </div>
        <div class="am-form-group">
            <label for="request_method">method：</label>
            <input type="text" readonly value="{{data.request_method}}" name="request_method" id="request_method" minlength="1" />
        </div>
        <div class="am-form-group">
            <label for="user_agent">客户端标识：</label>
            <input type="text" readonly value="{{data.user_agent}}" name="user_agent" id="user_agent" minlength="1" />
        </div>
        <div class="am-form-group">
            <label for="request_param">参数：</label>
            <input type="text" readonly value="{{data.request_param}}" name="request_param" id="request_param" minlength="1" />
        </div>
        <p align="center">
            <button class="am-btn am-btn-secondary" type="button" onclick="page.showGrid();">返回</button>
        </p>
    </fieldset>
</script>
<script type="text/javascript" src="${basePath}/resources/js/module/list.js">

</script>
<script type="text/javascript">
    var api = "cf/s_logger/";
    var page = new Page({
        "list.div": "roe_list", "list.template": "logger_list_template",
        "form.div": "edit_form_", "form.template": "logger_info_form",
        "grid.sortField":"request_time","grid.sortOrder":"desc","auto.load":false
    });
    page.loadGrid = function () {
        var param = getFromData("searchForm");
        page.grid.sort("request_time","desc");
        param.includes=["s_user.name","s_user.username","user_id","u_id","client_ip","request_time","module_desc"];
        param["request_time$NOTNULL"]="true";
        page.grid.load(param);
    }
    page.init(function(){
        page.loadGrid();
    });

</script>
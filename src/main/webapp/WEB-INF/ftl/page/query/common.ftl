<div class="am-cf am-padding" style="width: 200px">
    <div class="am-fl am-cf">
        <a onclick="" href="javascript:void(0)">
            <div class="am-form am-form-inline main_frame">
                <div class="am-form-group am-form-select">
                    <span id="plan_list"></span>
                </div>
            </div>
        </a>
    </div>
</div>

<form onsubmit="return false" id="searchForm" class="am-form am-form-inline main_frame" user="form"
      style="width: 70%;margin: auto">
    <ul id="searchConditionList" class="am-avg-sm-2 am-avg-md-3 am-avg-lg-5 am-thumbnails">
    </ul>
</form>

<div class="am-panel am-panel-primary main_frame" style="margin-left: 20px;margin-right: 10px;margin-top: 5px;">
    <div class="am-panel-hd">数据列表</div>
    <div class="am-panel-bd">
        <div id="data_list">

        </div>
    </div>
</div>
<script type="text/html" id="common_list_template_${param.module}">

</script>
<script type="text/html" id="pagerTemplate">
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
<script type="text/javascript">
    var module = "${param.module}";
    var plan_list_api = "queryPlan/list/" + module + "/";
    var plan_list = [];
    var request;
    var nowPlanId = null;
    var nowPlan = {};
    initPlanList();

    var grid = null;
    function initPlanHTML() {
        var html = "<select class='am-input-sm' style='width: 200px' onchange='nowPlanId=this.value();initPlan()'>";
        $(plan_list).each(function (i, data) {
            if (data.is_default == 1) {
                nowPlanId = data.plan.u_id;
            }
            html += "<option " + (data.is_default == 1 ? "selected" : "") + " value=\"" + data.plan.u_id + "\">" + (data.plan.name) + "(" + (data.plan.type) + ")</option>";
        });
        html += "</select>";
        return html;
    }

    function initGridData(){
        var api =nowPlan.data_api;
        grid = new Grid(api,"data_list","common_list_template_"+module);
        grid.load({});
    }

    //初始化选择的plan
    function initPlan() {
        request.get("/queryPlan/" + nowPlanId, {}, function (data) {
            if (data.success) {
                nowPlan = data.data;
                $("#searchConditionList").html(initQueryConditionHTML());
                $("#common_list_template_"+module).html(initDataGridTemplate()+$("#pagerTemplate").html());
                initGridData();
            }
        });
    }

    function getQueryConditionTemplate(conf) {
        var html = "";
        html += " <input name=" + conf.id + " class=\"am-form-field\" placeholder=" + conf.text + ">";
        return html;
    }

    function initDataGridTemplate() {
        if (nowPlan.show_fields) {
            var datas = JSON.parse(nowPlan.show_fields);
            var html = "<table class=\"am-table am-table-bordered am-table-striped am-table-hover\">";
            html += "<thead><tr>";
            $(datas).each(function (i, data) {
                html += "<th>" + data.header + "</th>";
            });
            html += "<th>操作</th>";
            html += "</tr></thead>";
            html += "<tbody> {{each data as val index}} <tr id=\"index_{{index}}\">";
            //生成模板
            $(datas).each(function (i, data) {
                html += " <td>{{val."+data.field+"}}</td>";
            });
            html += "<td><button onclick=\"page.editModule('{{val.u_id}}')\" class=\"am-btn-primary am-btn am-btn-default\">";
            html += " <i class=\"am-icon-cog\"></i>查看</button> </td></tr> " +
                    "{{/each}}";
            html += " </tbody>";
            html += "</table>";
        }
        return html;
    }

    function initQueryConditionHTML() {
        if (nowPlan.query_condition) {
            var datas = JSON.parse(nowPlan.query_condition);
            var html = "";
            $(datas).each(function (i, data) {
                html += "<li>";
                html += getQueryConditionTemplate(data);
                html += "</li>";
            });
            html += " <li><button onclick=\"page.loadGrid()\" class=\"am-btn am-btn-default\">搜索</button></li>";
            return html;
        }
    }

    //加载方案列表
    function initPlanList() {
        seajs.use("request", function (req) {
            request = req;
            request.get(plan_list_api, {}, function (data) {
                if (data.success) {
                    plan_list = data.data;
                    $("#plan_list").html(initPlanHTML());
                    initPlan();
                } else {
                    alert(data.data);
                }
            });
        });
    }

</script>
<!-- content start -->

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">首页</strong>
    </div>
</div>

<ul class="am-avg-sm-1 am-avg-md-4 am-margin am-padding am-text-center admin-content-list ">
    <li><a href="#" class="am-text-success"><span class="am-icon-btn fa-buysellads fa-1x"></span><br/>新增购进<br/>0</a>
    </li>
    <li><a href="#" class="am-text-danger"><span
            class="am-icon-btn am-icon-recycle"></span><br/>新增使用<br/>0</a>
    </li>
    <li><a href="#" class="am-text-warning"><span class="am-icon-btn am-icon-briefcase"></span><br/>今日访问<br/><span id="counter">0</span>
    </a>
    </li>
    <li><a href="javascript:void()" class="am-text-secondary"><span class="am-icon-btn am-icon-user-md"></span><br/>在线用户<br/><span id="online">0</span></a>
    </li>
</ul>
<div class="am-panel am-panel-primary main_frame" style="margin-left: 20px;margin-right: 10px;margin-top: 5px;">
    <div class="am-panel-hd">
    <#if user.hasAccessModuleLevel('b_publicity','C')>
        <a href="javascript:void(0)" style="color: white" onclick="goPage('page/publicity/save.html')">
            <i class="fa fa-plus-circle"></i>
        </a>
    </#if>公示公告
    </div>
    <div class="am-panel-bd">
        <div id="b_publicity">

        </div>
    </div>
    <div id="downloadFrame"></div>
</div>


<script type="text/html" id="b_publicity_list_template">
    <table class="am-table am-table-bordered am-table-striped am-table-hover">
        <thead>
        <tr>
            <th>序号</th>
            <th>标题</th>
            <th>发布时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        {{each data as val index}}
        <tr id="index_{{index}}">
            <td>{{index+1}}</td>
            <td>
                <i style="color: {{val.readerSize==0?'red':'green'}} ;" class="fa fa-tags"></i>&nbsp;
                <a style="{{if val.is_urgent==1}}color:red{{/if}}"
                   onclick="goPage('page/publicity/info.html?id={{val.u_id}}')"
                   href="#page/publicity/info.html?id={{val.u_id}}">
                    {{val.title}}
                </a>
            </td>
            <td>{{val.create_date}}</td>
            <td>
                {{if toObj(val.file_list).length!=0}}
                <span>
                     <a href="javascript:void(0)" onclick="downloadFile({{val.file_list}})"><i
                             class="fa fa-cloud-download"></i>下载附件</a>
                </span>&nbsp;&nbsp;
                {{/if}}
                <#if user.hasAccessModuleLevel("b_publicity","U")>
                    <span>
                         <a href="javascript:void(0)" onclick="goPage('page/publicity/save.html?id={{val.u_id}}')"><i
                                 class="am-icon-cog"></i> 编辑</a>
                    </span>
                    <span>&nbsp;&nbsp;</span>
                    <a href="javascript:void(0)" title="阅读次数"><span class="am-badge am-badge-success am-round">{{val.readerSize}}</span></a>
                </#if>
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

<script type="text/javascript" src="${basePath}/resources/js/module/list.js">

</script>
<script type="text/javascript">
    var api = "cf/b_publicity/";
    var page = new Page({
        "list.div": "b_publicity", "list.template": "b_publicity_list_template",
        "form.div": "edit_form_", "form.template": "logger_info_form",
        "grid.sortField": "create_date", "grid.sortOrder": "desc", "auto.load": false
    });
    page.loadGrid = function () {
        var param = {};
        page.grid.sort("create_date", "desc");
        page.grid.load(param);
    }
    page.init(function () {
        page.loadGrid();
    });

    function downloadFile(datas) {
        $(datas).each(function (i, data) {
            var url = getServicePath("file/download/" + data.id + "?name=" + data.name);
            //  $("#download").attr("href",getServicePath("file/download/" + data.id + "?name=" + data.name));
            $("#downloadFrame").append("<iframe style='display:none' src='" + url + "'></iframe>");
        });
    }
    initOnlineNumber();
    function initOnlineNumber(){
        seajs.use(["request"],function(request){
            request.get("online/total",{},function(e){
                if(e.success){
                    $("#online").html(e.data);
                }
            });
            //登陆次数，次数为 access/counter
            request.get("login/counter/"+(new Date().format("yyyy-MM-dd")),{},function(e){
                if(e.success){
                    $("#counter").html(e.data);
                }
            });

        });
    }

</script>
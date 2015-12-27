<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">首页-${param.id???string('编辑','新增')}模板</strong>
        </a>
    </div>
</div>
<form id="edit_form" action="" onsubmit="return submitForm();" class="am-form"
      data-am-validator>
    <input type="hidden" name="u_id" id="u_id"/>
    <fieldset>
        <div class="am-form-group">
            <label for="u_id">ID：</label>
            <input type="text" name="u_id" ${param.id???string('readonly','')} id="u_id" minlength="1"
            placeholder="ID不能为空"
            required/>
        </div>
        <div class="am-form-group">
            <label for="type">类型：</label>
            <input type="text" value="" name="type" id="type" minlength="1"
                   placeholder="类型不能为空"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="type">名称：</label>
            <input type="text" value="" name="name" id="name" minlength="1"
                   placeholder="名称不能为空"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="content">内容：</label>
            <script id="content"></script>
        </div>
        <p align="center">
        <#if user.hasAccessModuleLevel('s_template','U')>
            <input id="submitBtn" type="submit" class="am-btn am-btn-primary btn-loading-example" value="保存"
                   data-am-loading="{loadingText: '保存中...', resetText: '保存成功'}"/>
        </#if>
            <button class="am-btn am-btn-secondary" type="button" onclick="goPage('page/template/list.html')">返回</button>
        </p>
    </fieldset>
</form>
</div>
<script>
    window.UEDITOR_HOME_URL = "${basePath}plugins/ueditor/";
</script>
<script type="text/javascript" charset="utf-8" src="${basePath}plugins/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="${basePath}plugins/ueditor/ueditor.all.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${basePath}plugins/ueditor/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript">
    var dataId = '${param.id!''}';

    var editor = UE.getEditor('content');
    editor.ready(function () {
        editor.focus();
        loadUploader();
    });
    function ___initInfo() {

    }
    var request;
    function loadUploader() {
        seajs.use(["request"], function (req) {
            request = req;
            if (dataId != '') {
                loadData();
            }
        });
    }

    var submiting = false;
    function submitForm() {
        try {
            if(submiting){
                return false;
            }
            var data = getFromData("edit_form");
            data.content = data.editorValue;
            var $btn = $("#submitBtn")
            if (dataId != '') {
                submiting=true;
                $btn.button('loading');
                request.update("cf/s_template/" + dataId, data, function (e) {
                    if (e.success) {
                        $btn.button('reset');
                    } else {
                        $btn.button('reset');
                        $btn.html("重试");
                        alert(e.data);
                    }
                    submiting=false;
                });
            } else {
                $btn.button('loading');
                request.add("cf/s_template", data, function (e) {
                    logger.info(e);
                    if (e.success) {
                        $btn.button('reset');
                        goPage("page/template/save.html?id="+ e.data)
                    } else {
                        $btn.button('reset');
                        $btn.val("重试");
                        alert(e.data);
                        submiting=false;
                    }
                });
            }
        } catch (e) {
            logger.debug(e);
        }
        return false;
    }

    function loadData() {
        request.info("cf/s_template/", dataId, function (data) {
            if (data.success) {
                if(data.data.content)
                    editor.setContent(data.data.content);
                for (var e in data.data) {
                    $("#edit_form #" + e).val(data.data[e]);
                }
            } else {
                alert(data.data);
            }
        });
    }
</script>
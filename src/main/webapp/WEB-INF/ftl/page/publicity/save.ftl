<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">首页-公示公告-${param.id???string('编辑','新增')}</strong>
        </a>
    </div>
</div>
<form id="edit_form" action="" onsubmit="return submitForm();" class="am-form"
      data-am-validator>
    <input type="hidden" name="u_id" id="u_id"/>
    <fieldset>
        <div class="am-form-group">
            <label for="title">标题：</label>
            <input type="text" value="" name="title" id="title" minlength="5"
                   placeholder="标题不能少于5个字"
                   required/>
        </div>
        <div class="am-form-group">
            <label for="content">内容：</label>
            <script id="content"></script>
        </div>
        <div class="am-form-group">
            <label for="content">紧急：</label>
            <select id="is_urgent" name="is_urgent">
                <option selected value="1">是</option>
                <option value="2">否</option>
            </select>
        </div>
        <div class="am-form-group">
            <label for="name">附件：</label>

            <div id="" style="max-width: 800px" class="am-scrollable-horizontal am-text-nowrap">
                <table id="file_table"
                       class="am-table am-table-bordered am-table-striped am-table-hover am-table-compact">
                    <thead>
                    <tr>
                        <td align="center">
                            <div id="fileButton" name="fileButton" style="display: none">
                            </div>
                            <a href="javascript:void(0)" onclick="$('.webuploader-element-invisible').click()"><i
                                    style="cursor: pointer" class="fa fa-plus"></i></span></a>
                        </td>
                        <th>文件名</th>
                        <th>文件大小</th>
                        <th>状态</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <a href="javascript:void(0)" onclick="$('.webuploader-element-invisible').click()"><i
                        style="cursor: pointer" class="fa fa-plus"></i></span>添加附件</a>&nbsp;&nbsp;
                <a onclick="uploader.upload();" href="javascript:void(0)"><i class="fa fa-cloud-upload"></i>开始上传</a>
            </div>
        </div>
        <p align="center">
        <#if user.hasAccessModuleLevel('b_publicity','U')>
            <input id="submitBtn" type="submit" class="am-btn am-btn-primary btn-loading-example" value="保存"
                   data-am-loading="{loadingText: '保存中...', resetText: '保存成功'}"/>
        </#if>
            <button class="am-btn am-btn-secondary" type="button" onclick="goPage('page/index_page.html')">返回</button>
        </p>
    </fieldset>
</form>
</div>
<script>
    window.UEDITOR_HOME_URL = "${basePath}plugins/ueditor/";
</script>
<script type="text/javascript" charset="utf-8" src="${basePath}plugins/ueditor/ueditor.config.min.js"></script>
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
    var uploader, request;
    function loadUploader() {
        seajs.use(["request", "upload"], function (req, up) {
            request = req;
            uploader = new WebUploader.Uploader({
                swf: ROOT_PATH + 'plugins/webuploader/Uploader.swf',
                server: getServicePath("/file/upload"),
                pick: '#fileButton',
                resize: false,
                compress:false
            });
            initListener();
            $('.webuploader-element-invisible').hide();
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
            data.file_list = JSON.stringify(getFileListData());
            if (!fileAllUpload) {
                alert("还有文件未上传!");
                return false;
            }
            var $btn = $("#submitBtn")
            if (dataId != '') {
                submiting=true;
                $btn.button('loading');
                request.update("cf/b_publicity/" + dataId, data, function (e) {
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
                request.add("cf/b_publicity", data, function (e) {
                    logger.info(e);
                    if (e.success) {
                        $btn.button('reset');
                        goPage("page/publicity/save.html?id="+ e.data)
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
        request.info("cf/b_publicity/", dataId, function (data) {
            if (data.success) {
                if(data.data.content)
                    editor.setContent(data.data.content);
                for (var e in data.data) {
                    $("#edit_form #" + e).val(data.data[e]);
                }

                var fileList = JSON.parse(data.data.file_list);

                var $list = $("#file_table");
                for (var i = 0; i < fileList.length; i++) {
                    var file = fileList[i];
                    $list.append('<tr class="file_list_form am-active" id="file_' + file.id + '">' +
                            '<td align="center"><i class="fa fa-times" style="cursor: pointer" onclick="removeFile(\'' + file.id + '\')"></i></td>' +
                            '<td><input style="width:100%;height: 25px;font-size: 14px" type="text" name="fileName" value="' + file.name + '" /></td>' +
                            '<td><input type="hidden" name="fileId" value="' + file.id + '" /><input type="hidden" name="fileSize" value="' + file.size + '" />' + file.size + '</td>' +
                            '<td class="state">已上传</td>' +
                            '</div>');
                }
            } else {
                alert(data.data);
            }
        });
    }
    var fileAllUpload = false;
    function getFileListData() {
        var list = $("#file_table .file_list_form");
        var files = [];
        fileAllUpload = true;
        $(list).each(function (i, file) {
            var fileId = $(file).find("[name='fileId']")[0].value;
            if (fileId == '' || fileId == null) {
                fileAllUpload = false;
            }
            var fileName = $(file).find("[name='fileName']")[0].value;
            var fileSize = $(file).find("[name='fileSize']")[0].value;
            files.push({id: fileId, name: fileName, size: fileSize});
        });
        return files;
        //获取文件列表
    }
    function bytesToSize(bytes) {
        if (bytes === 0) return '0 B';
        var k = 1024, // or 1024
                sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
                i = Math.floor(Math.log(bytes) / Math.log(k));
        return (bytes / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
    }
    function removeFile(id) {
        try {
            uploader.removeFile(id);
        } catch (e) {
        }
        $('#file_' + id).remove();
    }
    function initListener() {
        var $list = $("#file_table");
        uploader.on('fileQueued', function (file) {
            logger.info(file);
            $list.append('<tr class="file_list_form am-active" id="file_' + file.id + '">' +
                    '<td align="center"><i class="fa fa-times" style="cursor: pointer" onclick="removeFile(\'' + file.id + '\')"></i></td>' +
                    '<td><input style="width:100%;height: 25px;font-size: 14px" type="text" name="fileName" value="' + file.name + '" /></td>' +
                    '<td><input type="hidden" name="fileId" /><input type="hidden" name="fileSize" value="' + (bytesToSize(file.size)) + '" />' + (bytesToSize(file.size)) + '</td>' +
                    '<td class="state">等待上传</td>' +
                    '</div>');

            uploader.md5File(file)
                // 及时显示进度
                    .progress(function (percentage) {
                        var range = ( percentage * 100).toFixed(1);
                        console.log('校验md5进度:', range + "%");
                        var $li = $('#file_' + file.id);
                        $li.find(".state")[0].innerHTML = '加载文件:' + range + "%";
                    })
                // 完成
                    .then(function (val) {
                        console.log('md5值:', val);
                        var $li = $('#file_' + file.id);
                        request.service("/resources/" + val, {}, "GET", function (data) {
                            if (data && data.success) {
                                $li.find(".state")[0].innerHTML = "文件秒传成功";
                                $li.find('[name="fileId"]')[0].value = data.data.u_id;
                                uploader.removeFile(file.id);
                            }
                            else {
                                $li.find(".state")[0].innerHTML = '等待上传';
                            }
                        });
                    });
        });

        uploader.on('uploadProgress', function (file, percentage) {
            var $li = $('#file_' + file.id),
                    $percent = $li.find('.progress .progress-bar');
            // 避免重复创建
            if (!$percent.length) {
                $percent = $('<div class="progress progress-striped active">' +
                        '<div class="progress-bar" role="progressbar" style="width: 0%">' +
                        '</div>' +
                        '</div>').appendTo($li).find('.progress-bar');
            }
            var range = ( percentage * 100).toFixed(1);
            if (percentage < 1) {
                $li.find('.state').text('上传中:' + range + '%');
            } else {
                $li.find('.state').text('等待回应...');
            }
            logger.info(range + '%');
            $percent.css('width', range + '%');
        });
        uploader.on('uploadSuccess', function (file, message) {
            var $li = $('#file_' + file.id);
            if (message.code != '200') {
                $li.find('.state').text('上传失败!');
            } else {
                $li.find('.state').text('上传完成!');
                $li.find('[name="fileId"]')[0].value = message.data[0].u_id;
            }
            logger.info(message);
        });
    }
</script>
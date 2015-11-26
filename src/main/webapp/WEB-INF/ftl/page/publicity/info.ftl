<head>
    <link href="${basePath}plugins/ueditor/themes/default/dialogbase.css"/>
</head>
<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a href="javascript:void(0)">
            <strong class="am-text-primary am-text-lg">首页-公示公告-详情</strong>
        </a>
    </div>
</div>
<form id="edit_form" action="" onsubmit="return submitForm();" class="am-form sec_form"
      data-am-validator>
    <fieldset>
        <div class="am-form-group">
            <label for="title">标题：</label>
           <div id="title"></div>
        </div>
        <div class="am-form-group">
            <label for="content">内容：</label>
            <div id="content"></div>
        </div>
        <div class="am-form-group">
            <label for="name">附件：</label>
            <div id="" style="max-width: 800px" class="am-scrollable-horizontal am-text-nowrap">
                <table id="file_table"
                       class="am-table am-table-bordered am-table-striped am-table-hover am-table-compact">
                    <thead>
                    <tr>
                        <th>文件名</th>
                        <th>文件大小</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
        <p align="center">
            <button class="am-btn am-btn-secondary" type="button" onclick="goPage('page/index_page.html')">返回</button>
        </p>
    </fieldset>
</form>
</div>
<script type="text/javascript"src="${basePath}/plugins/ueditor/ueditor.parse.js"></script>
<script type="text/javascript">
    var dataId = '${param.id!''}';
    var uploader,request;
    var readId="";
    function loadUploader() {
        seajs.use(["request","upload"], function (req,up) {
            request = req;
            if(dataId!=''){
                loadData();
                  doRead();
            }
        });
    }

    function doRead(cb){
        //标记阅读
        request.add("cf/b_publicity_reader/",{publicity_id:dataId},function(data){
            logger.info(data);
            if(data.success){
                readId=data.data;
                if(cb)cb();
            }
        });
    }
    function flagDownLoadFc(){
        //标记下载
        request.update("cf/b_publicity_reader/"+readId,{u_id:readId,download_file:1},function(data){
            logger.info(data);
        });
    }
    function flagDownLoad(){
        if(readId==""){
            doRead(function(){
                flagDownLoadFc();
            });
        }else{
            flagDownLoadFc();
        }
    }

    function loadData(){
        request.info("cf/b_publicity/",dataId,function(data){
            logger.info(data);
            if(data.success){
                for(var e in data.data){
                    $("#edit_form #"+e).html(data.data[e]);
                }
                var fileList = JSON.parse(data.data.file_list);
                var $list = $("#file_table");
                for(var i=0;i<fileList.length;i++){
                    var file = fileList[i];
                    var url = getServicePath("file/download/" + file.id + "?name=" + file.name);
                    $list.append('<tr class="file_list_form am-active" id="file_' + file.id + '">' +
                            '<td><a onclick="flagDownLoad()" target="_blank" href="'+url+'">'+file.name+'</a></td>' +
                            '<td> '+file.size+'</div>');
                }
                uParse('#content',{
                    rootPath : '',
                    chartContainerHeight:500
                });
            }else{
                alert(data.data);
            }
        });
    }
    loadUploader();
</script>
$("#admin-offcanvas").height($(window).height() - 130);
if ($(window).width() < 540) {
    $("#title").attr("src", "resources/img/logo_sort.png");
}
var progress = $.AMUI.progress;
progress.configure({minimum: 0.2, parent: ".admin-main"});

window.onresize = function () {
    if ($(window).width() < 540) {
        $("#title").attr("src", "resources/img/logo_sort.png");
    } else {
        $("#title").attr("src", "resources/img/title.jpg");
    }
    $("#admin-offcanvas").height($(window).height() - 130);
}

var his = [];
function goBack() {
    if (his[his.length - 2])
        goPage(his[his.length - 2], true);
    delete his[his.length - 2];
}

function goPage(url, isHis) {
    if (url.indexOf("http") == 0) {
        return;
    }
    progress.start();
    $(".nprogress-bar").css("background", "rgb(243,123,29)");
    $("#admin-content").load(url, {}, function (e, s) {
        if ("error" == s) {
            logger.error(s);
        } else {
            window.location.hash = url;
            if (!isHis && his[his.length - 1] != url)
                his.push(url);
            if (isHis == true) {
                delete his[his.length - 1];
            }
            progress.done();
        }

    });
    $("#ifr").attr("src", url);
}

function getFromData(formId) {
    var data = {};
    var arr = $("#" + formId).serializeArray();
    $.each(arr, function (i, d) {
        data[d.name] = d.value;
    });
    return data;
}

//------对表格进行操作------
var Grid = function (api, e_id, tmpId) {
    this.pageIndex = 0;
    this.pageSize = 10;
    this.maxShowPage = 3;
    this.sortField;
    this.sortOrder ;
    this.tmpParam = {};
    this.eId = e_id;
    this.$template = null, this.$request = null;
    var proto = this;
    this.paging = function (page) {
        proto.pageIndex = page;
    };

    var buildPage = function (totalPage) {
        var str = "";
        var start = 0;
        if (proto.pageIndex < proto.maxShowPage) {
            start = 0;
        } else {
            start = proto.pageIndex - proto.maxShowPage;
        }
        var tmp = totalPage;
        if (totalPage > proto.maxShowPage)
            totalPage = proto.pageIndex + proto.maxShowPage
        if (totalPage > tmp)
            totalPage = tmp;
        for (var i = start; i < totalPage; i++) {
            if (proto.pageIndex == i) {
                str += "<li class=\"am-active\"><a href=\"javascript:void(" + i + ")\">" + (i + 1) + "</a></li>";
            } else {
                str += "<li ><a href=\"javascript:page.doPage(" + (i) + ")\">" + (i + 1) + "</a></li>";
            }
        }
        return str;
    };
    this.sort = function (f, o) {
        if (f)
            proto.sortField = f;
        if (o)proto.sortOrder = o;
    };
    this.reload = function () {
        proto.load(proto.tmpParam);
    };
    this.helper = function (s, f) {
        if (proto.$template == null) {
            seajs.use(["request", "template"], function (request, tmp) {
                proto.$template = tmp;
                proto.$request = request;
                proto.$template.helper(s, f);
            });
        } else {
            proto.$template.helper(s, f);
        }
    }
    this.onload = function (data) {
    }
    this.load = function (param) {
        proto.tmpParam = param;
        progress.set(0.2);
        seajs.use(["request", "template"], function (request, template) {
            if (proto.$template == null)
                proto.$template = template;
            progress.set(0.4);
            proto.$template.helper("buildPage", buildPage);
            progress.set(0.6);
            request.get(api, {
                includes:JSON.stringify(param.includes),
                excludes:JSON.stringify(param.excludes),
                key: JSON.stringify(param),
                pageSize: proto.pageSize,
                pageIndex: proto.pageIndex,
                sortOrder: proto.sortOrder,
                sortField: proto.sortField
            }, function (datas) {
                if(!('total' in datas)&&!datas.success){
                    if(datas.code=='5021')
                    initLogin();
                    else{
                        alert(datas.data);
                    }
                    progress.done();
                    return;
                }
                progress.set(0.8);
                var totalPage = Math.ceil(datas.total / proto.pageSize);
                if (!proto.render) {
                    proto.render = template.renderFile(tmpId);
                }
                var html = proto.render({
                    data: datas.data,
                    pageIndex: proto.pageIndex,
                    pageSize: proto.pageSize,
                    totalPage: totalPage
                });
                $("#" + proto.eId).html(html);
                progress.done();
                proto.onload(datas);
            });
        });
    }

    return proto;
};

var Form = function (api, id) {
    var eId = id;
    var proto = this;
    this.getData = function () {
        var data = {};
        var arr = $("#" + eId).serializeArray();
        $.each(arr, function (i, d) {
            data[d.name] = d.value;
        });
        return data;
    };
    return this;
};

function initLogin(){
    alert("请登陆！");
}


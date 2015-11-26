/**
 * Created by 浩 on 2015-11-20 0020.
 */
var Page = function (conf) {
    var proto = this;
    proto.config = conf;
    proto.inied = false;
    proto.init = function (cb) {
        seajs.use(["request", "template"], function (request, template) {
            proto.$request = request;
            proto.$template = template;
            proto.grid = new Grid(api, proto.config['list.div'], proto.config['list.template'])
            proto.grid.helper("sta", function (va) {
                var m = {"s_0": "已弃用", "s_1": "正常"};
                var v = m["s_" + va];
                return v ? v : "未知";
            });
            proto.grid.helper("toObj", function (va) {
                return JSON.parse(va);
            });
            proto.grid.sort(proto.config['grid.sortField'], proto.config['grid.sortOrder']);
            if (false != proto.config['auto.load']) {
                proto.loadGrid();
            }
            if(cb){
                cb();
            }
        });
    };
    proto.showGrid = function () {
        $(".sec_form").fadeOut(100, function () {
            $(".main_frame").fadeIn(200);
        });
    }
    proto.showForm = function () {
        $(".main_frame").fadeOut(100, function () {
            $(".sec_form").fadeIn(200);
        });
    }
    proto.newModule = function (data) {
        if (!data)data = {};
        proto.showForm();
        var html = proto.$template(proto.config['form.template'], {data: data});
        $("#" + proto.config['form.div']).html(html);
        proto.onAdd();
        proto.nowFunc = function (data) {
            var $btn = $("#submitBtn")
            $btn.button('loading');
            proto.$request.add(api, data, function (e) {
                if (e.success) {
                    proto.loadGrid();
                } else {
                    $btn.val("重试");
                    alert(e.data);
                }
                $btn.button('reset');
            });
        }
    }

    proto.submitForm = function () {
        var data = {};
        var arr = $("#" + proto.config["form.div"]).serializeArray();
        $.each(arr, function (i, d) {
            data[d.name] = d.value;
        });
        proto.nowFunc(data);
        return false;
    }

    proto.doPage = function (page) {
        proto.grid.paging(page);
        proto.loadGrid();
    }

    proto.onEdit = function (data) {
    }
    proto.onAdd = function () {
    }
    proto.editModule = function (id) {
        proto.showForm();
        proto.$request.info(api, id, function (data) {
            if (data.success) {
                var html = proto.$template(proto.config["form.template"], data);
                $("#" + proto.config["form.div"]).html(html);
                proto.onEdit(data);
                proto.nowFunc = function (data) {
                    var $btn = $("#submitBtn");
                    $btn.button('loading');
                    proto.$request.update(api+"/"+data.u_id, data, function (e) {
                        if (e.success) {
                            proto.loadGrid();
                            window.setTimeout(function () {
                                $btn.val("提交");
                            }, 1000);
                            $btn.button('reset');
                        } else {
                            $btn.button('reset');
                            $btn.val("重试");
                            alert(e.data);
                        }
                    });
                }
            } else {
                alert(data.data);
            }
        });
    }

    proto.loadGrid = function () {
        var param = getFromData("searchForm");
        proto.grid.load(param);
    }
    if (false != proto.config['auto.load']) {
        proto.init();
    }
    return proto;
}
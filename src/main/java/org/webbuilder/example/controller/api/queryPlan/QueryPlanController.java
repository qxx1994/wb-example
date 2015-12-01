package org.webbuilder.example.controller.api.queryPlan;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.webbuilder.sql.DataBase;
import org.webbuilder.sql.Table;
import org.webbuilder.sql.param.query.QueryParam;
import org.webbuilder.web.core.aop.logger.AccessLogger;
import org.webbuilder.web.core.authorize.annotation.Authorize;
import org.webbuilder.web.core.bean.ResponseMessage;
import org.webbuilder.web.core.utils.WebUtil;
import org.webbuilder.web.po.role.UserRole;
import org.webbuilder.web.po.user.User;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by 浩 on 2015-12-01 0001.
 */
@RestController
@AccessLogger("查询方案")
@RequestMapping("/queryPlan")
public class QueryPlanController {


    @Resource
    private DataBase dataBase;

    //方案表
    private String plan_table = "s_query_plan";

    //方案角色关联表
    private String plan_role_table = "s_query_plan_role";

    @RequestMapping("/list/{module}")
    @AccessLogger("获取用户对应模块的所有查询方案")
    @Authorize
    public Object list(@PathVariable("module") String module) {
        try {
            //当前登陆用户持有的角色
            User user = WebUtil.getLoginUser();
            List<UserRole> userRoles = user.getUserRoles();
            List<String> roleIdList = new LinkedList<>();
            for (UserRole userRole : userRoles) {
                roleIdList.add(userRole.getRole_id());
            }
            QueryParam param = new QueryParam();
            //角色id IN
            param.where("role_id$IN", roleIdList)
                    .where("plan.module_id", module);
            param.include("u_id", "is_default", "plan.u_id", "plan.name", "plan.type");//指定查询字段
            Table table = dataBase.getTable(plan_role_table);//查角色关联表
            List<Map> dataList = table.createQuery().list(param);
            return new ResponseMessage(true, dataList);
        } catch (Exception e) {
            return new ResponseMessage(false, e);
        }
    }

    @RequestMapping("/{plan_id}")
    @AccessLogger("获取查询方案信息")
    @Authorize
    public Object plan(@PathVariable("plan_id") String plan_id) {
        try {
            //当前登陆用户持有的角色
            User user = WebUtil.getLoginUser();
            List<UserRole> userRoles = user.getUserRoles();
            List<String> roleIdList = new LinkedList<>();
            for (UserRole userRole : userRoles) {
                roleIdList.add(userRole.getRole_id());
            }
            QueryParam param = new QueryParam();
            //角色id IN
            param.where("role_id$IN", roleIdList)
                    .where("plan_id", plan_id);
            param.include("plan.*");//指定查询字段
            Table table = dataBase.getTable(plan_role_table);//查角色关联表
            Map data = table.createQuery().single(param);
            if (data == null) return new ResponseMessage(false, "无此方案");
            return new ResponseMessage(true, data.get("plan"));
        } catch (Exception e) {
            return new ResponseMessage(false, e);
        }
    }


}

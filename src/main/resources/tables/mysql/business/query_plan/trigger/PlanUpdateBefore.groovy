package tables.mysql.business.query_plan.trigger

import java.sql.Timestamp;
import org.webbuilder.web.core.utils.RandomUtil;
import org.webbuilder.sql.param.insert.InsertParam;
import org.webbuilder.sql.param.delete.DeleteParam;

//设置默认值
param.set("update_date",new Timestamp(System.currentTimeMillis()));
def u_id = param.getData().get("u_id");
//添加关联信息
def table = dataBase.getTable("s_query_plan_role");
def insert = table.createInsert();
def data = param.getData();
def plan_role = data.get("plan_role");
if (plan_role instanceof java.util.Collection) {
    //删除之前所有的信息
    table.createDelete().delete(new DeleteParam().where([plan_id:u_id]));
    //新增
    for(Map<String,Object> plan_r : plan_role){
        plan_r.put("u_id",RandomUtil.randomChar());
        plan_r.put("plan_id",u_id);
        def param_2 = new InsertParam();
        param_2.values(plan_r)
        insert.insert(param_2);
    }
}
return true;
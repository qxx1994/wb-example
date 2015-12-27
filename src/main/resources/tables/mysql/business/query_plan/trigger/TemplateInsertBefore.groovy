package tables.mysql.business.query_plan.trigger

import org.webbuilder.web.core.utils.WebUtil

import java.sql.Timestamp

//设置默认值
param.value("create_time", new Timestamp(System.currentTimeMillis()));
param.value("creator_id", WebUtil.getLoginUser().getU_id());
param.value("status", "1");

return true;
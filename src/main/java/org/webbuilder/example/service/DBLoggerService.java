package org.webbuilder.example.service;

import com.alibaba.fastjson.JSON;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.webbuilder.sql.DataBase;
import org.webbuilder.sql.Table;
import org.webbuilder.sql.param.insert.InsertParam;
import org.webbuilder.web.core.logger.LoggerService;
import org.webbuilder.web.po.logger.LogInfo;

import javax.annotation.Resource;
import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by 浩 on 2015-11-23 0023.
 */
public class DBLoggerService implements LoggerService {

    @Resource
    private DataBase dataBase;

    private String tableName = "s_logger";

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    private Map<String, Object> baseLog = new HashMap<>();

    public DBLoggerService() {
        InetAddress ia = null;
        try {
            ia = ia.getLocalHost();
            baseLog.put("server_name", ia.getHostName());
            baseLog.put("server_ip", ia.getHostAddress());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void log(LogInfo logInfo) throws Exception {
        try {
            if (logInfo.getReferer() == null) {
                logInfo.setReferer(logInfo.getRequest_url());
            }
            logInfo.setResponse_content("--");
            Map<String, Object> data = transBean2Map(logInfo);
            data.putAll(baseLog);
            if (logInfo.getRequest_time() != 0) {
                data.put("request_time", new Date(logInfo.getRequest_time()));
                data.put("response_time", new Date(logInfo.getResponse_time()));
                data.put("use_time", logInfo.getUse_time());
            } else {
                data.remove("request_time");
                data.remove("response_time");
            }
            Table table = dataBase.getTable(tableName);
            if (table == null) {
                logger.warn("logger table is not found!");
                logger.info(JSON.toJSONString(logInfo));
            } else {
                table.createInsert().insert(new InsertParam().values(data));
            }
        } catch (Exception e) {
            logger.error(JSON.toJSONString(logInfo));
            logger.error("insert logger error", e);
        }
    }

    @Override
    public List<LogInfo> search(Map<String, Object> conditions) throws Exception {
        return null;
    }

    @Override
    public int total(Map<String, Object> conditions) throws Exception {
        return 0;
    }

    private static final Map<String, Method> cache = new ConcurrentHashMap<>();

    public static Map<String, Object> transBean2Map(Object obj) {
        if (obj == null) {
            return null;
        }
        Map<String, Object> map = new HashMap<>();
        try {
            if (cache.size() == 0) {
                BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
                PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
                for (PropertyDescriptor property : propertyDescriptors) {
                    String key = property.getName();
                    // 过滤class属性
                    if (!key.equals("class")) {
                        // 得到property对应的getter方法
                        Method getter = property.getReadMethod();
                        cache.put(key, getter);
                        Object value = getter.invoke(obj);
                        map.put(key, value);
                    }
                }
            } else {
                for (Map.Entry<String, Method> entry : cache.entrySet()) {
                    Object value = entry.getValue().invoke(obj);
                    map.put(entry.getKey(), value);
                }
            }
        } catch (Exception e) {
            System.out.println("transBean2Map Error " + e);
        }
        return map;
    }

    public void setBaseLog(Map<String, Object> baseLog) {
        this.baseLog.putAll(baseLog);
    }
}

package org.webbuilder.example.controller.api;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.webbuilder.web.core.aop.logger.AccessLogger;
import org.webbuilder.web.core.authorize.annotation.Authorize;
import org.webbuilder.web.core.bean.ResponseMessage;
import org.webbuilder.web.service.form.DefaultTableFactory;

import javax.annotation.Resource;

/**
 * Created by 浩 on 2015-11-18 0018.
 */
@RestController
@AccessLogger("初始化自定义表")
public class TableInitController {
    @Resource(name = "defaultTableFactory")
    private DefaultTableFactory defaultTableFactory;

    @RequestMapping("/initTable")
    @Authorize(role = "admin")
    public Object initTable() {
        defaultTableFactory.init();
        return new ResponseMessage(true, "初始化完成");
    }
}

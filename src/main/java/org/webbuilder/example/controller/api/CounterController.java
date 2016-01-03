package org.webbuilder.example.controller.api;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.webbuilder.utils.storage.counter.Counter;
import org.webbuilder.web.core.aop.logger.AccessLogger;
import org.webbuilder.web.core.authorize.annotation.Authorize;
import org.webbuilder.web.core.bean.ResponseMessage;
import org.webbuilder.web.core.exception.BusinessException;

import javax.annotation.Resource;

/**
 * Created by 浩 on 2015-11-25 0025.
 */
@RestController
@Authorize
@AccessLogger("计数器")
public class CounterController {

    @Resource
    private Counter counter;

    /**
     * 获取系统指定日期的访问次数
     *
     * @param date 日期 格式为yyyy-MM-dd
     * @return 响应信息
     */
    @RequestMapping("/access/counter/{date}")
    @AccessLogger("获取访问次数")
    public Object accessCounter(@PathVariable("date") String date) {
        long count = counter.count("success_".concat(date));
        return new ResponseMessage(true, count);
    }

    /**
     * 获取系统指定日期的登陆次数
     *
     * @param date 日期 格式为yyyy-MM-dd
     * @return 响应信息
     */
    @AccessLogger("获取登陆次数")
    @RequestMapping("/login/counter/{date}")
    public Object loginCounter(@PathVariable("date") String date) {
        long count = counter.count("login_".concat(date));
        return new ResponseMessage(true, count);
    }

}

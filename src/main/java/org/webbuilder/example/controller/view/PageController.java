package org.webbuilder.example.controller.view;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.webbuilder.web.core.authorize.annotation.Authorize;
import org.webbuilder.web.core.utils.WebUtil;
import org.webbuilder.web.po.user.User;
import org.webbuilder.web.service.config.ConfigService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by 浩 on 2015-11-18 0018.
 */
@Controller
public class PageController {
    @Resource
    private ConfigService configService;

    @RequestMapping(value = "/**")
    @Authorize
    public ModelAndView index(HttpServletRequest request) {
        String path = request.getRequestURI();
        String content = request.getContextPath();
        if (path.startsWith(content)) {
            path = path.substring(content.length() + 1);
        }
        if (path.contains("."))
            path = path.split("[.]")[0];
        if (!path.equals("go_login") && !path.equals("login") && WebUtil.getLoginUser(request) == null) {
            path = "go_login";
        }
        ModelAndView modelAndView = new ModelAndView(path);
        Map<String, Object> sessionAttr =new HashMap<>();
        Enumeration<String> enumeration = request.getSession().getAttributeNames();
        while (enumeration.hasMoreElements()) {
            String name = enumeration.nextElement();
            sessionAttr.put(name, request.getSession().getAttribute(name));
        }
        modelAndView.addObject("param", WebUtil.getParams(request));
        modelAndView.addObject("basePath", WebUtil.getBasePath(request));
        modelAndView.addObject("config", configService);
        return modelAndView;
    }
}

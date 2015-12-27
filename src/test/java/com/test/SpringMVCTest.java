package com.test;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import org.webbuilder.web.core.utils.WebUtil;
import org.webbuilder.web.core.utils.http.session.HttpSessionManager;
import org.webbuilder.web.po.user.User;
import org.webbuilder.web.service.user.UserService;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;

@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:config/web/spring-mvc.xml"})
@WebAppConfiguration
public class SpringMVCTest extends AbstractJUnit4SpringContextTests {

    @Resource
    private WebApplicationContext wac;

    private MockMvc mvc;

    @Resource
    private UserService userService;

    @Resource
    private HttpSessionManager httpSessionManager;

    @Resource
    private MockHttpSession session = new MockHttpSession();

    @Before
    public void setup() throws Exception {
        this.mvc = webAppContextSetup(this.wac).build();
        //模拟登陆
        User user = userService.selectByUserName("admin");
        Assert.assertNotNull(user);
        user.initRoleInfo();
        session.setAttribute("user", user);
        httpSessionManager.addUser(user.getU_id(), session);
    }

    @Test
    public void selectUser() throws Exception {
        String str = mvc
                .perform(
                        get("/user").session(session)
                                .characterEncoding("UTF-8")
                                .param("key", "{\"id\":\"admin\"}")
                                .param("includes", "[\"username\"]")
                                .contentType(MediaType.APPLICATION_JSON)
                ).andReturn().getResponse().getContentAsString();
        JSONObject jsonObject = JSON.parseObject(str);
        System.out.println(str);
        Assert.assertEquals(jsonObject.get("total"), 2);

    }

    @Test
    public void selectForm() throws Exception {
        String str = mvc
                .perform(
                        get("/cf/s_query_plan").session(session)
                                .characterEncoding("UTF-8")
                                .contentType(MediaType.APPLICATION_JSON)
                ).andReturn().getResponse().getContentAsString();
        System.out.println(str);
    }
}
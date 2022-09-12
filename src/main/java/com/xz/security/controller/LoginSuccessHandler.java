package com.xz.security.controller;

import com.xz.security.captcha.CaptchaAuthenticationDetails;
import com.xz.security.dao.UserMapper;
import com.xz.security.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component("loginSuccessHandler")
public class LoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    @Autowired
    private UserMapper userMapper;

    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        //记录相关的用户信息,如上次登录时间
        String name = authentication.getName();
        Map<String,Object> param=new HashMap<>();
        param.put("loginname", name);
        User user = userMapper.getUser(param);
        user.setFailureLogin(0);
        user.setSucceedLogin(user.getSucceedLogin() + 1);
        user.setLastLoginTime(new Date());
        user.setLastLoginIP(((CaptchaAuthenticationDetails) authentication.getDetails()).getRemoteAddress());

        userMapper.loginUpdateUser(user);

        //调用父类的方法把用户引导到未登录前要去的页面
        super.onAuthenticationSuccess(request,response,authentication);
    }
}
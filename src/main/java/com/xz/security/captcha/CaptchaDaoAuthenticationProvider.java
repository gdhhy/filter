package com.xz.security.captcha;

import com.xz.security.dao.UserMapper;
import com.xz.security.pojo.User;
import com.xz.util.Hmac;
import nl.captcha.Captcha;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.*;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class CaptchaDaoAuthenticationProvider extends DaoAuthenticationProvider {
    @Autowired
    private UserMapper userMapper;
    @Resource
    private Properties configs;
  /*  @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
      //  return super.authenticate(authentication);

        *//*user.setFailureLogin(0);
        user.setSucceedLogin(user.getSucceedLogin() + 1);
        user.setLastLoginTime(new Date());
        user.setLastLoginIP(((WebAuthenticationDetails) authentication.getDetails()).getRemoteAddress());
        userMapper.loginUpdateUser(user);*//*

        //return new UsernamePasswordAuthenticationToken(user, authentication.getCredentials(), user.getAuthorities()); //直接返回，就不做验证码校验
        return super.authenticate(authentication);//没这句，不执行后面的additionalAuthenticationChecks
    }*/

    @Override
    protected void additionalAuthenticationChecks(UserDetails userDetails,
                                                  UsernamePasswordAuthenticationToken token)
            throws AuthenticationException {
        //System.out.println(" token.getCredentials().toString() = " +    token.getCredentials().toString());//这是密码
        //super.additionalAuthenticationChecks(userDetails, token); //use this line :bad credentials , why?
        //先校验验证码，
        Object obj = token.getDetails();
        if (!(obj instanceof CaptchaAuthenticationDetails)) {
            throw new InsufficientAuthenticationException("没找到验证码");//Captcha details not found
        }

        CaptchaAuthenticationDetails captchaDetails = (CaptchaAuthenticationDetails) obj;
        Captcha captcha = captchaDetails.getCaptcha();
        //System.out.println("captcha 57 = " + captcha);
        if (captcha != null) {
            String expected = captcha.getAnswer();
            String actual = captchaDetails.getAnswer();
            if (!expected.equals(actual))
                throw new BadCredentialsException("验证码不匹配。"); //Captcha not match
        }

        //传统的密码校验
        User user = (User) userDetails;
        if (user.getLoginName() == null) {
            throw new UsernameNotFoundException("用户名不存在");
        }

        if (user.getFailureLogin() > 4) {
            user.setFailureLogin(user.getFailureLogin() + 1);
            userMapper.loginUpdateUser(user);

            throw new LockedException("登录失败次数太多，请联系管理员解锁");
        }
        if (!user.getPassword().equals(Hmac.sha1(token.getCredentials().toString().getBytes(), configs.getProperty("application_name").getBytes()))) {
            user.setFailureLogin(user.getFailureLogin() + 1);
            userMapper.loginUpdateUser(user);

            throw new BadCredentialsException("密码错误");
        }
        if (user.getAuthorities() == null || user.getAuthorities().size() == 0) {
            throw new AuthenticationCredentialsNotFoundException("未设置授权，请联系管理员处理。");
        }
        //todo 用户锁定、登录IP 限制等等
    }

}

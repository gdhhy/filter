package com.xz.security.controller;

import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.event.AbstractAuthenticationFailureEvent;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.RequestContextListener;
import org.springframework.web.context.request.ServletRequestAttributes;

public class AuthenticationResultListener implements
        ApplicationListener<AbstractAuthenticationFailureEvent> {

    @Override
    public void onApplicationEvent(AbstractAuthenticationFailureEvent event) {
        HttpSession session = getSession();
        AtomicInteger counter = (AtomicInteger) session.getAttribute("counter");
        counter.incrementAndGet();
    }

    /**
     *  <listener>
     *         <listener-class>org.springframework.web.context.request.RequestContextListener</listener-class>
     *     </listener>
     * else is NullPoiterException
     * @return
     */
    private HttpSession getSession() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
      /*  System.out.println("attributes = " + attributes);
        System.out.println("attributes = " + attributes.getRequest());*/
        return attributes.getRequest().getSession(false);
    }
    @Bean
    public RequestContextListener requestContextListener(){
        return new RequestContextListener();
    }

}
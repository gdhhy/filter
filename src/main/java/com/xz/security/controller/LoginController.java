package com.xz.security.controller;

import com.xz.security.captcha.CaptchaGenerator;
import com.xz.security.captcha.CaptchaUtils;
import com.xz.security.dao.UserMapper;
import com.xz.security.pojo.User;
import nl.captcha.Captcha;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.atomic.AtomicInteger;

@Controller
@RequestMapping("/")
@SessionAttributes("counter")
public class LoginController {
    @Autowired
    private JdbcTokenRepositoryImpl jdbcTokenRepository;
    @Autowired
    private UserMapper userMapper;
    private static final int MAX_NOCAPTCHA_TRIES = 1;
    @Autowired
    private CaptchaGenerator captchaGenerator;
  //  AtomicInteger failureCounter=;

    //private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    private static Logger logger = LogManager.getLogger(LoginController.class);
    @Resource
    private Properties configs;

    @RequestMapping(value = "/username", method = RequestMethod.GET)
    @ResponseBody
    public String currentUserName(Principal principal) {
        return principal.getName();
    }

    @ModelAttribute("counter")
    public AtomicInteger failureCounter() {
        return new AtomicInteger(0);
    }

    @RequestMapping(value = "/loginPage", method = RequestMethod.GET)
    public String loginPage(@RequestParam(value = "error", required = false) String error, ModelMap model, HttpServletRequest request, HttpSession session) {
        // logger.debug("url function = loginPage");
        /*logger.debug("getPathInfo" + request.getPathInfo());
        logger.debug("getParameterMap" + request.getParameterMap().toString());*/
        //logger.debug("model" + model.toString());//model{content=/admin/users.jsp}
        //logger.debug("getAuthorities" + SecurityContextHolder.getContext().getAuthentication().getAuthorities());//仅仅登录前的 ROLE_ANONYMOUS，无意义
        if (SecurityContextHolder.getContext().getAuthentication() != null) {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            if (principal instanceof UserDetails) {
                logger.debug("已登录");
                model.addAttribute("loginSucceed", true);
                model.addAttribute("loginName", ((UserDetails) principal).getUsername());
                /*if (((UserDetails) principal).getAuthorities().contains(new SimpleGrantedAuthority("DOCTOR"))) {
                    model.addAttribute("mainUrl", "ext5/doctor/index.jspa");
                } else*/
                model.addAttribute("mainUrl", "index.jspa");
            }
        }
        if (error != null) {
            model.addAttribute("errMsg", getErrorMessage(request));
        }

        model.addAttribute("systemTitle", configs.getProperty("title"));
        /*model.addAttribute("systemTitle2", "系统登录");*/
        AtomicInteger counter = (AtomicInteger) model.get("counter");
        if (counter.intValue() >= MAX_NOCAPTCHA_TRIES) {
            Captcha captcha = captchaGenerator.createCaptcha(200, 50);

            session.setAttribute("captcha", captcha);
            //System.out.println("login captcha = " + captcha);
            model.addAttribute("captchaEnc", CaptchaUtils.encodeBase64(captcha));
        }
        return "/loginPage";
    }

    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(@RequestParam(value = "content", defaultValue = "/admin/hello.html") String contentUrl, ModelMap model, HttpServletRequest request, HttpSession session) {
        model.addAttribute("content", contentUrl);
        Object loginObject = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (loginObject instanceof UserDetails)
            return "/index";
        else {
            return loginPage(null, model, request, session);
        }
    }

    /* @RequestMapping(value = "/menu", method = RequestMethod.GET)
     public String menu(ModelMap model) {
         //model.addAttribute("user", getPrincipal());
         return "/admin/sidebar";
     }
 */
    @RequestMapping(value = "/navbar", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String navbar(ModelMap model) {
        String loginname = getPrincipal();

        Map<String, Object> param = new HashMap<>();
        param.put("loginname", loginname);
        User user = userMapper.getUser(param);
        model.addAttribute("user", user);

        return "/admin/navbar";
    }

    @RequestMapping(value = "/users", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String users(ModelMap model) {
        String loginname = getPrincipal();

        Map<String, Object> param = new HashMap<>();
        param.put("loginname", loginname);
        User user = userMapper.getUser(param);
        model.addAttribute("user", user);

        return "/admin/users";
    }

   /* @RequestMapping(value = "/admin/menu", method = RequestMethod.GET)
    public ModelAndView menu() {
        return new ModelAndView("/admin/menu", null);
    }*/

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
        logger.debug("logoutPage");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            jdbcTokenRepository.removeUserTokens(auth.getName());
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "redirect:/loginPage.jspa?logout";
    }

    private String getPrincipal() {
        String userName;
        //Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        //logger.debug("auth:" + auth);
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            //logger.debug("UserDetails");
            userName = ((UserDetails) principal).getUsername();
        } else {
            //logger.debug("principal:" + principal);
            userName = principal.toString();
        }
        return userName;
    }

    private String getErrorMessage(HttpServletRequest request) {
        Exception exception = (Exception) request.getSession().getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
        if (exception != null)
            return exception.getMessage();
        return "";
        /*if (exception instanceof BadCredentialsException) {
            error = "Invalid username and password!";
        } else if (exception instanceof UsernameNotFoundException) {
            error = exception.getMessage();
        } else if (exception instanceof CredentialExpiredException) {
            error = exception.getMessage();
        } else if (exception instanceof DisabledException) {
            error = exception.getMessage();
        } else if (exception instanceof LockedException) {
            error = exception.getMessage();
        } else {
            error = "Invalid username and password!";
        }*/
    }

}
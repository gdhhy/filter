package com.xz.security.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.xz.security.dao.UserMapper;
import com.xz.security.pojo.User;
import com.xz.util.Hmac;
import com.xz.util.Ognl;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@Controller
@RequestMapping("/rbac")
public class UserController {
    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    Logger logger = LogManager.getLogger(UserController.class);
    @Autowired
    private UserMapper userMapper;

    @Resource
    private Properties configs;

    @ResponseBody
    @RequestMapping(value = "/listUser", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listUser(@RequestParam(value = "createUserID", required = false) String createUserID) {
        Map<String, Object> param = new HashMap<>();
        param.put("createUserID", createUserID);
        List<User> user = userMapper.selectUser(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", user);
        result.put("iTotalRecords", user.size());
        result.put("iTotalDisplayRecords", user.size());

        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/showUser", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String showUser(@RequestParam(value = "userID", required = false) Integer userID) {
        Map<String, Object> param = new HashMap<>();
        param.put("userID", userID);
        User user = userMapper.getUser(param);

        return gson.toJson(user);
    }

    @ResponseBody
    @Transactional
    @RequestMapping(value = "/saveUser", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveUser(@ModelAttribute("user") User user) {
        System.out.println("user = " + user);
        Map<String, Object> map = new HashMap<>();
        int result;
        map.put("title", "????????????");
        logger.debug("getTogetherTime=" + user.getUsername());
        if (Ognl.isNotEmpty(user.getPassword())) {
            user.setPassword(Hmac.sha1(user.getPassword().getBytes(), configs.getProperty("application_name").getBytes()));
        }

       /* userMapper.deleteUserRole(user.getUserID());
        if (user.getRoleIDs().length > 0) {
            List<Map<String, Object>> param = new ArrayList<>();
            for (int roleID : user.getRoleIDs()) {
                Map<String, Object> userRole = new HashMap<>();
                userRole.put("userID", user.getUserID());
                userRole.put("roleID", roleID);
                param.add(userRole);
            }
            userMapper.setUserRole(param);
        }*/

        if (user.getUserID() != null)
            result = userMapper.updateUser(user);
        else
            result = userMapper.insertUser(user);
        map.put("succeed", result > 0);

        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "/deleteUser", method = RequestMethod.POST)
    public String deleteUser(@RequestParam("userID") int userID) {
        int result = userMapper.deleteUser(userID);//????????????-1, ????????????0

        Map<String, Object> map = new HashMap<>();
        map.put("succeed", result > 0);
        map.put("affectedRowCount", result);

        return gson.toJson(map);
    }


    /*private String returnJson(List user) {
        Map<String, Object> result = new HashMap<>();
        result.put("data", user);
        result.put("iTotalRecords", user.size());
        result.put("iTotalDisplayRecords", user.size());

        return gson.toJson(result);
    }*/
}

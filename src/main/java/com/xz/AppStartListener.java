package com.xz;

import com.xz.rbac.web.DeployRunning;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.LoggerContext;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.File;
import java.io.IOException;
import java.util.Timer;

/**
 * 配置到应用服务器启动时自动加载，环境变量和配置文件初始化<p>
 *
 * @author 黄海晏
 * Date: 2009-11-19
 * Time: 22:19:41
 */
public class AppStartListener implements ServletContextListener {
    private Timer timer;


    public void contextInitialized(ServletContextEvent event) {
        /*try {
            new Config();
        } catch (Exception e) {
            e.printStackTrace();
        }*/
        String deploy_dir = event.getServletContext().getRealPath(File.separator);
        if (!deploy_dir.endsWith(File.separator)) deploy_dir += File.separator;
        DeployRunning.setDir(deploy_dir);

        LoggerContext context = (LoggerContext) LogManager.getContext(false);
        File log4jFile = new File(deploy_dir + "WEB-INF" + File.separator + "classes" + File.separator + "log4j2.xml");
        if (!log4jFile.exists()) {
            System.out.println("!!!!!!!!没找到log4j2的配置文件!!!!!!!");
        } else
            try {
                context.setConfigLocation(log4jFile.toURI());
                System.out.println("log4j2配置 = " + log4jFile.getCanonicalPath());
            } catch (IOException e) {
                e.printStackTrace();
            }


        //  Config.setAppPathRoot(class_root);
      /*  String log_dir = deploy_dir + "WEB-INF" + File.separator + "logs";
        File file = new File(log_dir);// String 中文版;
        if (!file.isDirectory())
            file.mkdirs();
        else
            //System.out.println("日志目录已存在");
            System.out.println("log4j日志目录 = " + log_dir);
        System.setProperty("LOG_DIR", log_dir);*/


        timer = new Timer(false);
        // timer.schedule(new UserSessionTimer(), 10000, 2000);//10秒后，每隔2秒
        //  System.setSecurityManager(new RMISecurityManager());
    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        timer.cancel();
    }
}

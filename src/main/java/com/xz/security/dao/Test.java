package com.xz.security.dao;

import com.xz.security.pojo.User;
import org.springframework.context.support.AbstractXmlApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Created by hhy on 17-5-8.
 */
public class Test {
    /*  private static SqlSessionFactory sqlSessionFactory;

      private static Reader reader;

      static {
          try {
              Reader reader = Resources.getResourceAsReader("mybatis.xml");
              sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
  // 由于使用了注解，所以在主配置文件没有mapper，需要在代码里显示注册该mapper接口
  //            sqlSessionFactory.getConfiguration().addMapper(UserMapper.class);
          } catch (IOException e) {
              e.printStackTrace();
          }
      }

      public static void main(String[] args) {
          testAddUser();
      }
      public static void testAddUser() {
          User u = new User();
          u.setUsername("dongtian4");
          u.setPassword("asdfadsf");
          SqlSession session = sqlSessionFactory.openSession();
          try {
              UserMapper userDAO = session.getMapper(UserMapper.class);
              UserDao service=new UserDao(userDAO);
              service.saveUser(u);
          } finally {
              session.close();
          }
      }*/
    public static void main(String[] args) {
        /*String deploy_dir = Resources.getRealPath(File.separator);
        String log_dir = deploy_dir + "WEB-INF" + File.separator + "logs";
        File file = new File(log_dir);// String 中文版;
        if (!file.isDirectory())
            file.mkdirs();
        else
            //System.out.println("日志目录已存在");
            System.out.println("log4j日志目录 = " + log_dir);*/
        System.setProperty("LOG_DIR", "~");

        AbstractXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        //UserDao userDao = (UserDao) context.getBean("userDao");
        User u = new User();
        u.setUsername("dongtian");
        u.setPassword("5463245624");
        //userDao.saveUser(u);
    }
}

package com.xz.util;

import java.lang.reflect.Array;
import java.util.Collection;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 2004-6-7
 * Time: 17:27:11
 * To change this template use File | Settings | File Templates.
 * 17种正则表达式
 * "^\\d+$"　　//非负整数（正整数 + 0）
 * "^[0-9]*[1-9][0-9]*$"　　//正整数
 * "^((-\\d+)|(0+))$"　　//非正整数（负整数 + 0）
 * "^-[0-9]*[1-9][0-9]*$"　　//负整数
 * "^-?\\d+$"　　　　//整数
 * "^\\d+(\\.\\d+)?$"　　//非负浮点数（正浮点数 + 0）
 * "^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$"　　//正浮点数
 * "^((-\\d+(\\.\\d+)?)|(0+(\\.0+)?))$"　　//非正浮点数（负浮点数 + 0）
 * "^(-(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*)))$"　　//负浮点数
 * "^(-?\\d+)(\\.\\d+)?$"　　//浮点数
 * "^[A-Za-z]+$"　　//由26个英文字母组成的字符串
 * "^[A-Z]+$"　　//由26个英文字母的大写组成的字符串
 * "^[a-z]+$"　　//由26个英文字母的小写组成的字符串
 * "^[A-Za-z0-9]+$"　　//由数字和26个英文字母组成的字符串
 * "^\\w+$"　　//由数字、26个英文字母或者下划线组成的字符串
 * "^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$"　　　　//email地址
 * "^[a-zA-z]+://(\\w+(-\\w+)*)(\\.(\\w+(-\\w+)*))*(\\?\\S*)?$"　　//url
 * 这个日期正则表达式支持
 * YYYY-MM-DD
 * YYYY/MM/DD
 * YYYY_MM_DD
 * YYYY.MM.DD的形式
 * ((^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(10|12|0?[13578])([-\/\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(11|0?[469])([-\/\._])(30|[12][0-9]|0?
 * [1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(0?2)([-\/\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([3579][26]00)([-\/\._])(0?2)
 * ([-\/\._])(29)$)|(^([1][89][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^
 * ([2-9][0-9][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][13579][26])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][13579][26])([-\/\._])(0?2)([-\/\._])(29)$))
 */
public class Verify {
    //static RE email=new RE("^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$");
    //static RE notNegativeInt=new RE("^\\d+$");
    static Pattern numberPattern = Pattern.compile("^\\d+$");
    static Pattern letterPattern = Pattern.compile("^[A-Za-z]+$");
    static Pattern emailPattern = Pattern.compile("^(([\\w-]+[\\.[\\w-]+]*@[\\w-]+[\\.[\\w-]+]+)[;|,]?)+$");
    static Pattern positiveIntPattern = Pattern.compile("^[0-9]*[1-9][0-9]*$");
    static Pattern negativeIntPattern = Pattern.compile("^-[0-9]*[1-9][0-9]*$");
    static Pattern positiveFloatPattern = Pattern.compile("^\\d+(\\.\\d+)?$");
    static Pattern shortDate = Pattern.compile("((^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(10|12|0?[13578])([-\\/\\._])(3[01]|[12][0-9]|0?[1-9])$)|" +
            "(^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(11|0?[469])([-\\/\\._])(30|[12][0-9]|0?[1-9])$)|" +
            "(^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(0?2)([-\\/\\._])(2[0-8]|1[0-9]|0?[1-9])$)|" +
            "(^([2468][048]00)([-\\/\\._])(0?2)([-\\/\\._])(29)$)|" +
            "(^([3579][26]00)([-\\/\\._])(0?2)([-\\/\\._])(29)$)|" +
            "(^([1][89][0][48])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|" +
            "(^([2-9][0-9][0][48])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|" +
            "(^([1][89][2468][048])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|" +
            "(^([2-9][0-9][2468][048])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|" +
            "(^([1][89][13579][26])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|" +
            "(^([2-9][0-9][13579][26])([-\\/\\._])(0?2)([-\\/\\._])(29)$))");

    public static boolean validEmail(String str) {
        if (str == null) return false;
        Matcher m = emailPattern.matcher(str);
        return m.find();
    }

    public static boolean validNumber(String str) {
        if (str == null) return false;
        Matcher m = numberPattern.matcher(str);
        return m.find();
    }

    public static boolean validLetter(String str) {
        if (str == null) return false;
        Matcher m = letterPattern.matcher(str);
        return m.find();
    }

    public static boolean validPositiveInt(String str) {
        if (str == null) return false;
        Matcher m = positiveIntPattern.matcher(str);
        return m.find();
    }

    public static boolean validFloat(String str) {
        if (str == null) return false;
        Matcher m = positiveFloatPattern.matcher(str);
        return m.find();
    }

    public static boolean validNegativeInt(String str) {
        if (str == null) return false;
        Matcher m = negativeIntPattern.matcher(str);
        return m.find();
    }

    public static boolean validShortDate(String str) {
        if (str == null) return false;
        Matcher m = shortDate.matcher(str);
        return m.find();
    }

    /*  public static void main(String[] args) {
        //Pattern datePattern = Pattern.compile("^[0-9]4*(\\.|\\-|/)[1-9]2(\\.|\\-|/)[0-9]2*$");
        Pattern datePattern = Pattern.compile("((^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(10|12|0?[13578])([-\\/\\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\\d{2})|([2-9]\\d{3}))
        ([-\\/\\._])(11|0?[469])([-\\/\\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(0?2)([-\\/\\._])
        (2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([3579][26]00)([-\\/\\._])(0?2)([-\\/\\._])
        (29)$)|(^([1][89][0][48])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][0][48])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^
        ([1][89][2468][048])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][2468][048])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|
        (^([1][89][13579][26])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][13579][26])([-\\/\\._])(0?2)([-\\/\\._])(29)$))");
        Matcher m = datePattern.matcher("2010.12.31");
        System.out.println("date=" + m.find());
        Pattern medicaIdPattern = Pattern.compile("^[1-9]\\d{4}$");
        m = medicaIdPattern.matcher("20101");
        System.out.println("mid=" + m.find());
        m = positiveIntPattern.matcher("20101");
        System.out.println("int=" + m.find());
        if (true) return;
        Pattern pattern = Pattern.compile("^[a-z0-9-]+.huanghaiyan.com$");
        m = pattern.matcher("www.huanghaiyan.com");
        System.out.println("m.find() = " + m.find());
        m = pattern.matcher("gzhhy1.huanghaiyan.com");
        System.out.println("m.find() = " + m.find());
        String k = "1";
        System.out.println("validPositiveInt(k); = " + validPositiveInt(k));

    }*/
    /* public static void main(String[] args) {
      System.out.println("hello");
      //Pattern regex=Pattern.compile("【.+?】");
      String s="【注意】asd<br/>[性状]</br>为白色或微 <br/> 【注意】</Font>对<br/>（1）对青霉【注意】</div>" ;
    *//*  Matcher m=regex.matcher(s);
      while(m.find()){
          System.out.println("匹配：" + m.group(0));

          //System.out.println("m.groupCount() = " + m.groupCount());
          for(int i=0;i<m.groupCount();i++)
              System.out.println("m.group("+i+") = " + m.group(i));
      }
      System.out.println(" finish " );*//*
     // s=s.replaceAll("(【.{1,5}?】)(?!</)","<font color='blue'>$1</font>"); -----------OK
      s=s.replaceAll("((【|\\[).{1,5}?(】|\\]))(?!((?i)</font>|(?i)</div>|(?i)</span>))","<font color='blue'>$1</font>");
      System.out.println("s = " + s);

  }*/
    public static void main(String[] args) {
        System.out.println("2012-12-03 = " + validShortDate("20112-12-03"));
        System.out.println("2012-12-03 = " + validShortDate("2012-12-03"));

        /* //Pattern regex = Pattern.compile("(?:【生产企业】|【生产单位】|\\[生产企业\\]|生产企业: |【厂家】|【生 产 企 业】)\\s*(?:[\\u4E00-\\u9FA5]{0,4}：)?(.{2,60})\n?");
      Pattern regex = Pattern.compile("(?:【生(?:.{1,6}?)】|【厂家】|【企业名称】|\\[生产企业\\]|生产企业[:：]|企业名称[:：])" +
              "\\s*(?:[\\u4E00-\\u9FA5]{1,6}[:：])?(.{2,100}?)(?:\n|\r|【|$|:)");
    //  Pattern regex=Pattern.compile("(?:生产企业:)\\s*(.+)(?:\n|$)");
      String s = "【批准文号】 进口药品注册证号 H20070323\n" +
              "生产企业： DAIICHI SANKYO PROPHARMA CO., LTD.";
     //  String s=" 【批准文号】国药准字 Z31020068 ?<br/><br/>【生产企业】 <br/>企业名称：上海和黄药 业有限公司 <br/>生产地址：上海市真南路2098号 <br/>邮政编码：200331<br/>";
      //String s = "生产企业:   上海罗氏制药有限公司\nasdasdfasdf";
      s = s.replaceAll("<br>|<br/>|<br />|<p>|</p>", "\n");
      s = StringUtils.replaceHtml(s);
      System.out.println("s = " + s);

      Matcher m = regex.matcher(s);
      while (m.find()) {
          System.out.println("m.groupCount() = " + m.groupCount());
          for (int i = 1; i <= m.groupCount(); i++)
              System.out.println(m.group(i));
      }
      System.out.println(" finish1 ");*/
    }
    /* public static void main(String[] args) {
        Pattern regex=Pattern.compile("^[\\u4E00-\\u9FA5][\\u4E00-\\u9FA5|\\w]*$");
        String s="最快adffas_d32214中国";
        Matcher m=regex.matcher(s);
        if(m.find())
            System.out.println("found");

    }*/


    /**
     * test for Map,Collection,String,Array isEmpty dedecms.com
     *
     * @param o
     * @return
     */
    public static boolean isEmpty(Object o) throws IllegalArgumentException {
        if (o == null) return true;

        if (o instanceof String) {
            if (((String) o).length() == 0) {
                return true;
            }
        } else if (o instanceof Collection) {
            if (((Collection) o).isEmpty()) {
                return true;
            }
        } else if (o.getClass().isArray()) {
            if (Array.getLength(o) == 0) {
                return true;
            }
        } else if (o instanceof Map) {
            if (((Map) o).isEmpty()) {
                return true;
            }
        } else {
            return false;
        }

        return false;
    }

    /**
     * test for Map,Collection,String,Array isNotEmpty
     *
     * @param o
     * @return
     */
    public static boolean isNotEmpty(Object o) {
        return !isEmpty(o);
    }

    public static boolean validPattern(String regular, String string) {
        Pattern pattern = Pattern.compile(regular);
        Matcher m = pattern.matcher(string);
        return m.find();
    }
}

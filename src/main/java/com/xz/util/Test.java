package com.xz.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created with IntelliJ IDEA.
 * User: hhy
 * Date: 13-5-11
 * Time: 下午11:24
 */
public class Test {
    public static void main(String[] args) {
        Pattern p = Pattern.compile("^\\d+(\\.//d+)?$");
        Matcher matcher = p.matcher("0.7986463620981388");

        System.out.println("matcher.matches() = " +matcher.find());
        System.out.println("matcher.matches() = " +matcher.matches());
    }
}

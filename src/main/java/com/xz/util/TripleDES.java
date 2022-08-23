package com.xz.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.IvParameterSpec;

public class TripleDES {

    //【生成密钥】
    public static String createSecretKey() {
        return "70EAB07CECAE4C313BBA3707E6E6A2FE5201CD0B6D58A707";
        /* String key = null;
       try {
           // 生成一个可信任的随机数源
           SecureRandom sr = new SecureRandom();
           //为我们选择的DES算法生成一个KeyGenerator对象
           KeyGenerator kg = KeyGenerator.getInstance("DES");
           kg.init(sr);
           //生成密钥
           Key ke = kg.generateKey();
           byte[] bytK1 = ke.getEncoded();
           ke = kg.generateKey();
           byte[] bytK2 = ke.getEncoded();
           ke = kg.generateKey();
           byte[] bytK3 = ke.getEncoded();
           key = getByteStr(bytK1) + getByteStr(bytK2) + getByteStr(bytK3);
           //将密钥数据保存为文件供以后使用，其中key
       } catch (Exception e) {
           e.printStackTrace();
       }
       return key;*/
    }

    public static byte[] tripleEncrypt(byte[] bytP) throws Exception {
        return tripleEncrypt(bytP,createSecretKey());
    }
    public static byte[] tripleEncrypt(byte[] bytP, String key) throws Exception {
        byte[] res = null;
        if (key.length() == 48) {
            byte[] bytK1 = getKeyByStr(key.substring(0, 16));
            byte[] bytK2 = getKeyByStr(key.substring(16, 32));
            byte[] bytK3 = getKeyByStr(key.substring(32, 48));
            res = encrypt(encrypt(encrypt(bytP, bytK1), bytK2), bytK3);
        } else {
            System.out.println("密码错误");
        }
        return res;
    }

    //【用密钥加密】
    public static byte[] encrypt(byte[] bytP, byte[] key) throws Exception {
        //System.out.println(key);
        Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
        DESKeySpec desKeySpec = new DESKeySpec(key);
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
        SecretKey secretKey = keyFactory.generateSecret(desKeySpec);
        IvParameterSpec iv = new IvParameterSpec(key);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, iv);
        return cipher.doFinal(bytP);
    }
    public static byte[] tripleDecrypt(byte[] bytP) throws Exception{
       return tripleDecrypt(bytP,createSecretKey());
    }

    public static byte[] tripleDecrypt(byte[] bytP, String key) throws Exception {
        byte[] res = null;
        if (key.length() == 48) {
            byte[] bytK1 = getKeyByStr(key.substring(0, 16));
            byte[] bytK2 = getKeyByStr(key.substring(16, 32));
            byte[] bytK3 = getKeyByStr(key.substring(32, 48));
            res = decrypt(decrypt(decrypt(bytP, bytK3), bytK2), bytK1);
        } else {
            System.out.println("密码错误");
        }
        return res;
    }

    //【用密钥解密】
    public static byte[] decrypt(byte[] bytE, byte[] key) throws Exception {
        Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
        DESKeySpec desKeySpec = new DESKeySpec(key);
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
        SecretKey secretKey = keyFactory.generateSecret(desKeySpec);
        IvParameterSpec iv = new IvParameterSpec(key);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, iv);
        return cipher.doFinal(bytE);
    }


    public static void main(String[] args) throws Exception {
        /*File fileIn = new File("d:\\test.txt");
        FileInputStream fis = new FileInputStream(fileIn);
        byte[] bytIn = new byte[(int) fileIn.length()];
        for (int i = 0; i < fileIn.length(); i++) {
            bytIn[i] = (byte) fis.read();
        }
        fis.close();*/
        byte[] bytIn = "id=cn=yjyadmin,cn=users,dc=ctbri,dc=com,dc=cn;uid=yjyadmin;givenName=null;subsystem=gdcnoa".getBytes();
        System.out.println("加密前:" + new String(bytIn));
        //加密
        String key = createSecretKey();
        key = "70EAB07CECAE4C313BBA3707E6E6A2FE5201CD0B6D58A707";
        System.out.println("密钥:" + key);
        byte[] enuser = tripleEncrypt(bytIn, key);
        System.out.println("加密后:" + getByteStr(enuser));
        byte[] deuser = tripleDecrypt(enuser, key);
        System.out.println("解密后:" + new String(deuser));
    }

    private static String getByteStr(byte[] byt) {
        String strRet = "";
        for (int i = 0; i < byt.length; i++) {
            //System.out.println(byt[i]);
            strRet += getHexValue((byt[i] & 240) / 16);
            strRet += getHexValue(byt[i] & 15);
        }
        return strRet;
    }


    /**
     * 输入密码的字符形式，返回字节数组形式。
     * 如输入字符串：AD67EA2F3BE6E5AD
     * 返回字节数组：{173,103,234,47,59,230,229,173}
     */
    private static byte[] getKeyByStr(String str) {
        byte[] bRet = new byte[str.length() / 2];
        for (int i = 0; i < str.length() / 2; i++) {
            Integer itg = 16 * getChrInt(str.charAt(2 * i)) + getChrInt(str.charAt(2 * i + 1));
            bRet[i] = itg.byteValue();
        }
        return bRet;
    }

    private static String getHexValue(int s) {
        String sRet = null;
        switch (s) {
            case 0:
                sRet = "0";
                break;
            case 1:
                sRet = "1";
                break;
            case 2:
                sRet = "2";
                break;
            case 3:
                sRet = "3";
                break;
            case 4:
                sRet = "4";
                break;
            case 5:
                sRet = "5";
                break;
            case 6:
                sRet = "6";
                break;
            case 7:
                sRet = "7";
                break;
            case 8:
                sRet = "8";
                break;
            case 9:
                sRet = "9";
                break;
            case 10:
                sRet = "A";
                break;
            case 11:
                sRet = "B";
                break;
            case 12:
                sRet = "C";
                break;
            case 13:
                sRet = "D";
                break;
            case 14:
                sRet = "E";
                break;
            case 15:
                sRet = "F";
        }
        return sRet;
    }

    /**
     * 计算一个16进制字符的10进制值
     * 输入：0-F
     */
    private static int getChrInt(char chr) {
        int iRet = 0;
        if (chr == "0".charAt(0)) iRet = 0;
        if (chr == "1".charAt(0)) iRet = 1;
        if (chr == "2".charAt(0)) iRet = 2;
        if (chr == "3".charAt(0)) iRet = 3;
        if (chr == "4".charAt(0)) iRet = 4;
        if (chr == "5".charAt(0)) iRet = 5;
        if (chr == "6".charAt(0)) iRet = 6;
        if (chr == "7".charAt(0)) iRet = 7;
        if (chr == "8".charAt(0)) iRet = 8;
        if (chr == "9".charAt(0)) iRet = 9;
        if (chr == "A".charAt(0)) iRet = 10;
        if (chr == "B".charAt(0)) iRet = 11;
        if (chr == "C".charAt(0)) iRet = 12;
        if (chr == "D".charAt(0)) iRet = 13;
        if (chr == "E".charAt(0)) iRet = 14;
        if (chr == "F".charAt(0)) iRet = 15;
        return iRet;
    }
}
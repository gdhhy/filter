package com.xz.util;

import javax.swing.text.DefaultFormatterFactory;
import javax.swing.text.NumberFormatter;
import java.text.NumberFormat;
import java.text.ParseException;
import java.math.BigDecimal;

/**
 * User: 黄海晏
 * Date: 2009-6-19
 * Time: 0:12:27
 */
public class DataFormat {
    public static DefaultFormatterFactory currencyFactory;
    public static DefaultFormatterFactory longCurrencyFactory;
    public static DefaultFormatterFactory percentFactory;
    public static NumberFormat currencyDisplay;
    public static NumberFormat longCurrencyDisplay;
    public static NumberFormat currencyEdit;
    public static NumberFormat longCurrencyEdit;
    public static NumberFormat percentDisplay;
    public static NumberFormat percentEdit;
    public static NumberFormat payment;
    public static NumberFormatter percentEditFormatter;
    public static DataFormat _instance = null;

    public static DataFormat getInstance() {
        if (_instance == null)
            _instance = new DataFormat();
        return _instance;
    }

    private DataFormat() {
        currencyDisplay = NumberFormat.getCurrencyInstance();//获得货币的格式化实例
        currencyDisplay.setMinimumFractionDigits(2);//设置小数部分的最小位数，默认为0
        currencyDisplay.setMaximumFractionDigits(2);//设置小数部分的最大位数，默认为0
        /*    currency3Display=(NumberFormat)currencyDisplay.clone();
        currency3Display.setMaximumFractionDigits(3);
        currency4Display=(NumberFormat)currencyDisplay.clone();
        currency4Display.setMaximumFractionDigits(4);*/

        currencyEdit = NumberFormat.getNumberInstance();//获得数字的格式化实例
        currencyEdit.setMinimumFractionDigits(2);//设置小数部分的最小位数 ，默认为0
        currencyEdit.setMaximumFractionDigits(2);//设置小数部分的最大位数，默认为0

        longCurrencyDisplay = NumberFormat.getCurrencyInstance();//获得货币的格式化实例
        longCurrencyDisplay.setMinimumFractionDigits(2);//设置小数部分的最小位数，默认为0
        longCurrencyDisplay.setMaximumFractionDigits(4);//设置小数部分的最大位数，默认为0

        longCurrencyEdit = NumberFormat.getNumberInstance();//获得数字的格式化实例
        longCurrencyEdit.setMinimumFractionDigits(2);//设置小数部分的最小位数 ，默认为0
        longCurrencyEdit.setMaximumFractionDigits(4);//设置小数部分的最大位数，默认为0

        percentDisplay = NumberFormat.getPercentInstance();
        percentDisplay.setMinimumFractionDigits(1);//默认小数部分最大为0

        percentEdit = NumberFormat.getNumberInstance();
        percentEdit.setMinimumFractionDigits(1);//默认小数部分最大为0

        payment = NumberFormat.getCurrencyInstance();//获得货币的格式化实例

        percentEditFormatter =//百分比的编辑格式
                new NumberFormatter(percentEdit) {
                    public String valueToString(Object o)
                            throws ParseException {
                        Number number = (Number) o;
                        if (number != null) {
                            double d = number.doubleValue() * 100.0;
                            number = new Double(d);
                        }
                        return super.valueToString(number);
                    }

                    public Object stringToValue(String s)
                            throws ParseException {
                        Number number = (Number) super.stringToValue(s);
                        if (number != null) {
                            double d = number.doubleValue() / 100.0;
                            number = new Double(d);
                        }
                        return number;
                    }
                };
        percentFactory = new DefaultFormatterFactory(
                new NumberFormatter(percentDisplay),
                new NumberFormatter(percentDisplay),
                percentEditFormatter);
        currencyFactory = new DefaultFormatterFactory(new NumberFormatter(currencyDisplay),//总数量默认的格式
                new NumberFormatter(payment),//总数量显示时的格式
                new NumberFormatter(currencyEdit));//总数量编辑时的格式
        longCurrencyFactory = new DefaultFormatterFactory(new NumberFormatter(longCurrencyDisplay),//总数量默认的格式
                new NumberFormatter(longCurrencyDisplay),//总数量显示时的格式
                new NumberFormatter(longCurrencyEdit));//总数量编辑时的格式
    }

    public DefaultFormatterFactory getLongCurrencyFormat() {
        return longCurrencyFactory;
    }

    public DefaultFormatterFactory getCurrencyFormat() {
        return currencyFactory;
    }

    public DefaultFormatterFactory getPercentFormat() {
        return percentFactory;
    }

    public NumberFormatter getPercentEditFormatter() {
        return percentEditFormatter;
    }

    public NumberFormat getCurrencyDisplayFormat() {
        return currencyDisplay;
    }

    public NumberFormat getCurrencyEditFormat() {
        return currencyEdit;
    }

    public NumberFormat getPercentDisplayFormat() {
        return percentDisplay;
    }

    public NumberFormat getPercentEditFormat() {
        return percentEdit;
    }

    public NumberFormat getPaymentFormat() {
        return payment;
    }

    public NumberFormat getCurrencyDisplay() {
        return currencyDisplay;
    }

    public NumberFormat getCurrencyEdit() {
        return currencyEdit;
    }

    public DefaultFormatterFactory getCurrencyFactory() {
        return currencyFactory;
    }

    public DefaultFormatterFactory getLongCurrencyFactory() {
        return longCurrencyFactory;
    }

    public NumberFormat getLongCurrencyDisplay() {
        return longCurrencyDisplay;
    }

    public NumberFormat getLongCurrencyEdit() {
        return longCurrencyEdit;
    }

    public NumberFormat getPayment() {
        return payment;
    }

    public NumberFormat getPercentDisplay() {
        return percentDisplay;
    }

    public NumberFormat getPercentEdit() {
        return percentEdit;
    }

    public DefaultFormatterFactory getPercentFactory() {
        return percentFactory;
    }

    public static void main(String[] args) {
        BigDecimal dec = new BigDecimal(12.33232);
        dec.setScale(2);
        System.out.println("dec = " + dec);
    }
}


package com.xz.util;


import java.math.BigDecimal;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-11-7
 * Time: 下午9:17
 */
public class StatMath {

    /**
     * 对集合某列求和，然后计算占比例
     *
     * @param collection
     * @param sumField   求和字段
     * @param ratioField 比例字段
     */
    @SuppressWarnings("unchecked")
    public static void sumAndCalcRatio(Collection<HashMap<String, Object>> collection, String sumField, String ratioField) {
        Double sum = 0.0;
        for (HashMap map : collection)
            sum += map.get(sumField) != null ? ((Number) map.get(sumField)).doubleValue() : 0;
        for (HashMap map : collection)
            if (map.get(sumField) != null && ((Number) map.get(sumField)).doubleValue() > 0.00001)
                map.put(ratioField, new BigDecimal(((Number) map.get(sumField)).doubleValue() / sum).divide(new BigDecimal(1.0), 8, BigDecimal.ROUND_HALF_UP).doubleValue());
            else
                map.put(ratioField, 0.0);
    }

    /**
     * 对集合计算两列比例
     *
     * @param collection
     * @param numeratorField   分子
     * @param denominatorField 分母
     * @param ratioField       结果
     */
    @SuppressWarnings("unchecked")
    public static void ratio(Collection<HashMap<String, Object>> collection, String numeratorField, String denominatorField, String ratioField) {
        for (HashMap map : collection) {
            Double numerator = map.get(numeratorField) != null ? ((Number) map.get(numeratorField)).doubleValue() : 0;
            Double denominator = map.get(denominatorField) != null ? ((Number) map.get(denominatorField)).doubleValue() : 0;
            if (denominator > 0)
                map.put(ratioField, numerator / denominator);
            else
                map.put(ratioField, 0.0);

        }
    }

    /**
     * 对集合计算两列比例
     *
     * @param collection
     * @param sumField   求和字段
     */
    @SuppressWarnings("unchecked")
    public static void sum(Collection<HashMap<String, Object>> collection, String num1Field, String num2Field, String sumField) {
        for (HashMap map : collection) {
            Double d1 = map.get(num1Field) != null ? ((Number) map.get(num1Field)).doubleValue() : 0;
            Double d2 = map.get(num2Field) != null ? ((Number) map.get(num2Field)).doubleValue() : 0;
            map.put(sumField, d1 + d2);
        }
    }

    /**
     * 计算集合某类的合计
     *
     * @param collection
     * @param field
     * @return 列合计
     */
    public static double sum(Collection<HashMap<String, Object>> collection, String field) {
        Double sum = 0.0;
        for (HashMap map : collection)
            sum += map.get(field) != null ? ((Number) map.get(field)).doubleValue() : 0.0;

        return sum;
    }

    /**
     * 对subtotalKey相同值，计算小计
     *
     * @param list
     * @param subtotalKey
     * @param fields      需要计算小计的字段列表
     * @return 小计直接插入到原来集合
     */
    public static Collection<HashMap<String, Object>> subtotal(List<HashMap<String, Object>> list, String subtotalKey, String fields[]) {
        if (list.size() == 0) return list;

        Object pre = null;
        Double sum[] = new Double[fields.length];

        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).get(subtotalKey) != null && list.get(i).get(subtotalKey).equals(pre)) {  //相同，求和
                for (int j = 0; j < fields.length; j++)
                    sum[j] += list.get(i).get(fields[j]) != null ? ((Number) list.get(i).get(fields[j])).doubleValue() : 0.0;
            } else { //存入小计
                HashMap<String, Object> subtotal = new HashMap<String, Object>(fields.length + 1);
                subtotal.put(subtotalKey, "小计");
                subtotal.put("rowspan", 1);
                for (int j = 0; j < fields.length; j++)
                    subtotal.put(fields[j], sum[j]);

                if (i > 0)
                    list.add(i++, subtotal);

                pre = list.get(i).get(subtotalKey);
                for (int j = 0; j < fields.length; j++)
                    sum[j] = list.get(i).get(fields[j]) != null ? ((Number) list.get(i).get(fields[j])).doubleValue() : 0.0;
            }
        }
        return list;
    }

    public static Collection<HashMap<String, Object>> subtotal(List<HashMap<String, Object>> list, String subtotalKey, String totalNameKey, String fields[]) {
        if (list.size() == 0) return list;

        Object pre = null;
        Double sum[] = new Double[fields.length];

        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).get(subtotalKey) != null && list.get(i).get(subtotalKey).equals(pre)) {  //相同，求和
                for (int j = 0; j < fields.length; j++)
                    sum[j] += list.get(i).get(fields[j]) != null ? ((Number) list.get(i).get(fields[j])).doubleValue() : 0.0;
            } else { //存入小计
                HashMap<String, Object> subtotal = new HashMap<String, Object>(fields.length + 1);
                subtotal.put(totalNameKey, "小计");
                subtotal.put("rowspan", 1);
                for (int j = 0; j < fields.length; j++) {
                    subtotal.put(fields[j], sum[j]);
                    sum[j] = 0.0;
                }
                if (i > 0)
                    list.add(i++, subtotal);

                pre = list.get(i).get(subtotalKey);
            }
        }
        return list;
    }

    /**
     * 计算合计，增加在集合的最后
     *
     * @param collection
     * @param summaryKey 需要放置“合计”字样的列名
     * @param fields     需要计算合计的字段
     * @return 增加了合计的集合
     */
    public static Collection<HashMap<String, Object>> sum(Collection<HashMap<String, Object>> collection, String summaryKey, String fields[]) {
        if (collection.size() == 0) return collection;
        HashMap<String, Object> summary = new HashMap<String, Object>(fields.length + 1);
        summary.put(summaryKey, "总计");

        for (String field : fields) {
            Double sum = 0.0;
            for (HashMap map : collection) {
                sum += map.get(field) != null ? ((Number) map.get(field)).doubleValue() : 0.0;
            }
            //logger.debug("sum = " + sum);
            summary.put(field, sum);
        }
        collection.add(summary);
        return collection;
    }

    /**
     * 与上函数相同，todo 用反射实现
     *
     * @param collection
     * @param summaryKey
     * @param fields
     * @return
     */
    public static Collection<HashMap<String, Object>> sum(Collection<HashMap<String, Object>> collection, String summaryKey, String fields[], Class sumType[]) {
        if (collection.size() == 0) return collection;
        HashMap<String, Object> summary = new HashMap<String, Object>(fields.length + 1);
        summary.put(summaryKey, "<B>总计</B>");

        for (String field : fields) {
            double sum = 0.0;
            for (HashMap map : collection) {
                sum += map.get(field) != null ? ((Integer) map.get(field)).doubleValue() : 0.0;
            }
            //logger.debug("sum = " + sum);
            summary.put(field, sum);
        }

        collection.add(summary);
        return collection;
    }

    public static double average(Collection<HashMap<String, Object>> collection, String field) {
        Double sum = 0.0;
        for (HashMap map : collection)
            sum += map.get(field) != null ? ((Number) map.get(field)).doubleValue() : 0.0;

        return sum / collection.size();
    }
}

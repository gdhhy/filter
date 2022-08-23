package com.xz;

/**
 * Created by IntelliJ IDEA.
 * @author 黄海晏
 * Date: 2006-10-19
 * Time: 15:33:25
 */

import java.util.ArrayList;
import java.util.HashMap;

public class FindableList<E> extends ArrayList<E> {
    public FindableList() {
        super();
    }

    public int find(Comparable object) {//与indexOf()不同,此方法只按某值查找
        int index = 0;
        while (index < this.size()) {
            if (object.compareTo((this.get(index))) == 0)
                return index;
            index++;
        }

        return -1;
    }

    public E find(HashMap map, String key) {//与indexOf()不同,此方法只按某值查找
        //  int index = 0;
        for (E object : this) {
            if (map.get(key).equals(((HashMap) object).get(key)))
                return object;
        }

        return null;
    }
}

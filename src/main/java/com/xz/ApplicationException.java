package com.xz;

import java.io.PrintStream;
import java.io.PrintWriter;

/**
 * Created by IntelliJ IDEA.
 * @author 黄海晏
 * Date: 2003-5-22
 * Time: 22:11:24
 */
public class ApplicationException extends Exception {

    private Throwable nestedThrowable = null;

    public ApplicationException() {
        super();
    }

    public ApplicationException(String msg) {
        super(msg);
    }

    public ApplicationException(Throwable nestedThrowable) {
        this.nestedThrowable = nestedThrowable;
    }

    public ApplicationException(String msg, Throwable nestedThrowable) {
        super(msg);
        this.nestedThrowable = nestedThrowable;
    }

    public void printStackTrace() {
        super.printStackTrace();
        if (nestedThrowable != null) {
            nestedThrowable.printStackTrace();
        }
    }

    public void printStackTrace(PrintStream ps) {
        super.printStackTrace(ps);
        if (nestedThrowable != null) {
            nestedThrowable.printStackTrace(ps);
        }
    }

    public void printStackTrace(PrintWriter pw) {
        super.printStackTrace(pw);
        if (nestedThrowable != null) {
            nestedThrowable.printStackTrace(pw);
        }
    }
}

package utils;

import java.util.regex.Pattern;

public class Validation {

    // Regex kiểm tra định dạng email và số điện thoại Việt Nam (10 chữ số, bắt đầu bằng 0)
    private static final String EMAIL_REGEX = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    private static final String PHONE_REGEX = "^0[0-9]{9}$";
    // Tên đăng nhập: 4-20 ký tự, chỉ gồm chữ cái, chữ số và dấu gạch dưới
    private static final String USERNAME_REGEX = "^[a-zA-Z0-9_]{4,20}$";

    /**
     * Kiểm tra chuỗi rỗng hoặc chỉ chứa khoảng trắng
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Ép kiểu chuỗi sang int an toàn, trả về defaultValue nếu có lỗi
     */
    public static int parseInt(String value, int defaultValue) {
        if (isEmpty(value)) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Ép kiểu chuỗi sang double an toàn, trả về defaultValue nếu có lỗi
     */
    public static double parseDouble(String value, double defaultValue) {
        if (isEmpty(value)) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Kiểm tra định dạng Email
     */
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) {
            return false;
        }
        return Pattern.matches(EMAIL_REGEX, email.trim());
    }

    /**
     * Kiểm tra định dạng Số điện thoại (10 số, bắt đầu bằng 0)
     */
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) {
            return false;
        }
        return Pattern.matches(PHONE_REGEX, phone.trim());
    }

    /**
     * Kiểm tra định dạng Username (4-20 ký tự, không chứa ký tự đặc biệt)
     */
    public static boolean isValidUsername(String username) {
        if (isEmpty(username)) {
            return false;
        }
        return Pattern.matches(USERNAME_REGEX, username.trim());
    }

    /**
     * Kiểm tra độ dài tối thiểu của mật khẩu
     */
    public static boolean isValidPassword(String password, int minLength) {
        if (isEmpty(password)) {
            return false;
        }
        return password.trim().length() >= minLength;
    }
}
package lintCode;

public class Solution {
    /**
     * @param number: A 3-digit number.
     * @return: Reversed number.
     */
    public static int reverseInteger(int number) {
        return Integer.valueOf(new StringBuffer(String.valueOf(number)).reverse().toString());
    }
    
    public static void main(String[] args) {
        System.out.println(reverseInteger(650));
    }
}
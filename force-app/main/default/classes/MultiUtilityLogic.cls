public class MultiUtilityLogic {
    
    // Returns reversed string
    public static String reverseString(String s) {
        if (s == null) return null;
        String result = '';
        for (Integer i = s.length() - 1; i >= 0; i--) {
            result += s.substring(i, i + 1);
        }
        return result;
    }
    
    // Checks if string is palindrome (case-insensitive)
    public static Boolean isPalindrome(String s) {
        if (s == null) return false;
        String lower = s.toLowerCase();
        return lower == reverseString(lower);
    }
    
    // Converts list of strings to uppercase
    public static List<String> toUpperCaseList(List<String> input) {
        List<String> output = new List<String>();
        if (input == null) return output;
        for (String s : input) {
            output.add(s != null ? s.toUpperCase() : null);
        }
        return output;
    }
    
    // Returns a list of even numbers from input list
    public static List<Integer> filterEvenNumbers(List<Integer> nums) {
        List<Integer> evens = new List<Integer>();
        if (nums == null) return evens;
        for (Integer n : nums) {
            if (n != null && Math.Mod(n,2) == 0) evens.add(n);
        }
        return evens;
    }
    
    // Sum of all numbers in the list
    public static Integer sumList(List<Integer> nums) {
        Integer total = 0;
        if (nums == null) return total;
        for (Integer n : nums) {
            if (n != null) total += n;
        }
        return total;
    }
    
    // Returns map of string length keyed by the string itself
    public static Map<String, Integer> stringLengths(List<String> strs) {
        Map<String, Integer> map1 = new Map<String, Integer>();
        if (strs == null) return map1;
        for (String s : strs) {
            map1.put(s, s != null ? s.length() : 0);
        }
        return map1;
    }
    
    // Returns true if string contains any digit
    public static Boolean containsDigit(String s) {
        if (String.isBlank(s)) return false;
        for (Integer i = 0; i < s.length(); i++) {
            String ch = s.substring(i, i + 1);
            if (ch >= '0' && ch <= '9') return true;
        }
        return false;
    }
    
    // Removes null or blank strings from list
    public static List<String> removeBlankStrings(List<String> input) {
        List<String> output = new List<String>();
        if (input == null) return output;
        for (String s : input) {
            if (!String.isBlank(s)) {
                output.add(s);
            }
        }
        return output;
    }
    
    // Finds the max number in the list, returns null if empty
    public static Integer maxNumber(List<Integer> nums) {
        if (nums == null || nums.isEmpty()) return null;
        Integer maxVal = nums[0];
        for (Integer n : nums) {
            if (n != null && n > maxVal) {
                maxVal = n;
            }
        }
        return maxVal;
    }
}
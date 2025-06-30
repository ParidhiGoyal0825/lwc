public class PalindromeString implements Queueable {
    private List<String> data;

    public PalindromeString(List<String> data) {
        this.data = data;
    }

    public void execute(QueueableContext context) {
        if (data == null || data.isEmpty()) {
            System.debug('No data provided.');
            return;
        }

        // Clean data
        List<String> cleaned = removeBlankStrings(data);

        // Reverse each string
        List<String> reversed = reverseAll(cleaned);

        // Filter numeric strings only
        List<String> numericStrings = filterNumericStrings(cleaned);

        // Convert numeric strings to Integers
        List<Integer> numbers = convertToIntegers(numericStrings);

        // Sum and average
        Integer totalSum = sum(numbers);
        Decimal avg = average(numbers);

        // Check palindrome for each cleaned string
        Map<String, Boolean> palindromeMap = new Map<String, Boolean>();
        for (String s : cleaned) {
            palindromeMap.put(s, isPalindrome(s));
        }

        // Log results
        System.debug('Cleaned Data: ' + cleaned);
        System.debug('Reversed Data: ' + reversed);
        System.debug('Numeric Strings: ' + numericStrings);
        System.debug('Numbers: ' + numbers);
        System.debug('Sum: ' + totalSum);
        System.debug('Average: ' + avg);
        System.debug('Palindrome Map: ' + palindromeMap);
    }

    private List<String> removeBlankStrings(List<String> input) {
        List<String> output = new List<String>();
        for (String s : input) {
            if (!String.isBlank(s)) output.add(s.trim());
        }
        return output;
    }

    private List<String> reverseAll(List<String> input) {
        List<String> reversed = new List<String>();
        for (String s : input) {
            reversed.add(reverseString(s));
        }
        return reversed;
    }

    private String reverseString(String s) {
        String result = '';
        for (Integer i = s.length() - 1; i >= 0; i--) {
            result += s.substring(i, i + 1);
        }
        return result;
    }

    private List<String> filterNumericStrings(List<String> input) {
        List<String> numeric = new List<String>();
        for (String s : input) {
            if (isNumeric(s)) numeric.add(s);
        }
        return numeric;
    }

    private Boolean isNumeric(String s) {
        if (String.isBlank(s)) return false;
        for (Integer i = 0; i < s.length(); i++) {
            String ch = s.substring(i, i + 1);
            if (ch < '0' || ch > '9') return false;
        }
        return true;
    }

    private List<Integer> convertToIntegers(List<String> input) {
        List<Integer> ints = new List<Integer>();
        for (String s : input) {
            try {
                ints.add(Integer.valueOf(s));
            } catch (Exception e) {
                // ignore invalid numbers
            }
        }
        return ints;
    }

    private Integer sum(List<Integer> nums) {
        Integer total = 0;
        for (Integer n : nums) {
            total += n;
        }
        return total;
    }

    private Decimal average(List<Integer> nums) {
        if (nums.isEmpty()) return 0;
        return Decimal.valueOf(sum(nums)) / nums.size();
    }

    private Boolean isPalindrome(String s) {
        if (s == null) return false;
        String lower = s.toLowerCase();
        return lower == reverseString(lower);
    }
}
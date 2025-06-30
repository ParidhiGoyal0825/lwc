public class MultiLogicQueueable implements Queueable {
    private List<String> data;

    public MultiLogicQueueable(List<String> data) {
        this.data = data;
    }

    public void execute(QueueableContext context) {
        if (data == null || data.isEmpty()) {
            System.debug('No data provided.');
            return;
        }

        // Clean and prepare data
        List<String> cleanedData = cleanStrings(data);

        // Filter strings that have numbers only
        List<String> numericStrings = filterNumericStrings(cleanedData);

        // Convert numeric strings to integers
        List<Integer> numbers = convertToIntegers(numericStrings);

        // Calculate sum and average
        Integer totalSum = sum(numbers);
        Decimal avg = average(numbers);

        // Get strings with length > 3
        List<String> longStrings = filterByLength(cleanedData, 3);

        // Reverse all strings
        List<String> reversed = reverseAll(cleanedData);

        // Check if each string contains vowels
        Map<String, Boolean> containsVowelsMap = containsVowelsMap(cleanedData);

        // Log the results for demo
        System.debug('Sum: ' + totalSum);
        System.debug('Average: ' + avg);
        System.debug('Long strings (>3 chars): ' + longStrings);
        System.debug('Reversed strings: ' + reversed);
        System.debug('Vowel presence: ' + containsVowelsMap);
    }

    // Removes nulls, blanks and trims strings
    private List<String> cleanStrings(List<String> input) {
        List<String> output = new List<String>();
        for (String s : input) {
            if (!String.isBlank(s)) {
                output.add(s.trim());
            }
        }
        return output;
    }

    // Keeps strings with digits only
    private List<String> filterNumericStrings(List<String> input) {
        List<String> nums = new List<String>();
        for (String s : input) {
            if (isNumeric(s)) {
                nums.add(s);
            }
        }
        return nums;
    }

    // Helper: checks if string is numeric (digits only)
    private Boolean isNumeric(String s) {
    if (String.isBlank(s)) return false;
    for (Integer i = 0; i < s.length(); i++) {
        String ch = s.substring(i, i + 1);
        if (ch < '0' || ch > '9') return false;
    }
    return true;
}
    // Converts list of numeric strings to integers
    private List<Integer> convertToIntegers(List<String> numericStrings) {
        List<Integer> ints = new List<Integer>();
        for (String s : numericStrings) {
            try {
                ints.add(Integer.valueOf(s));
            } catch (Exception e) {
                // Skip invalid numbers
            }
        }
        return ints;
    }

    // Sum integers
    private Integer sum(List<Integer> nums) {
        Integer total = 0;
        for (Integer n : nums) {
            total += n;
        }
        return total;
    }

    // Calculate average
    private Decimal average(List<Integer> nums) {
        if (nums.isEmpty()) return 0;
        return Decimal.valueOf(sum(nums)) / nums.size();
    }

    // Filter strings by minimum length
    private List<String> filterByLength(List<String> input, Integer minLength) {
        List<String> filtered = new List<String>();
        for (String s : input) {
            if (s.length() > minLength) {
                filtered.add(s);
            }
        }
        return filtered;
    }

    // Reverse all strings in list
    private List<String> reverseAll(List<String> input) {
        List<String> reversed = new List<String>();
        for (String s : input) {
            reversed.add(reverseString(s));
        }
        return reversed;
    }

    // Reverse a single string
    private String reverseString(String s) {
        String result = '';
        for (Integer i = s.length() - 1; i >= 0; i--) {
            result += s.substring(i, i + 1);
        }
        return result;
    }

    // Returns a map of string to boolean whether it contains vowels
    private Map<String, Boolean> containsVowelsMap(List<String> input) {
        Map<String, Boolean> map1 = new Map<String, Boolean>();
        for (String s : input) {
            map1.put(s, containsVowel(s));
        }
        return map1;
    }

    // Checks if string contains at least one vowel (a,e,i,o,u)
    private Boolean containsVowel(String s) {
        if (String.isBlank(s)) return false;
        String lower = s.toLowerCase();
        for (String v : new List<String>{'a','e','i','o','u'}) {
            if (lower.contains(v)) return true;
        }
        return false;
    }
}
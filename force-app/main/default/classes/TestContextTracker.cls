public class TestContextTracker {
public static Integer runCount = 0;
    
    public static Integer calculateFactorial(Integer num) {
        if (num == 0) {
            return 1;
        } else {
            return num * calculateFactorial(num - 1);
        }
    }
    public static Boolean isPrime(Integer num) {
        if (num <= 1) {
            return false;
        }
        for (Integer i = 2; i <= Math.sqrt(num); i++) {
            if (Math.mod(num,i) == 0) {
                return false;
            }
        }
        return true;
    }

    public static Integer sumDigits(Integer num) {
        Integer sum = 0;
        while (num > 0) {
            sum += Math.Mod(num, 10);
            num = num / 10;
        }
        return sum;
    }

    public static String reverseString(String input) {
        String reversed = '';
        for (Integer i = input.length() - 1; i >= 0; i--) {
            reversed += input.substring(i, i + 1);
        }
        return reversed;
    }

    public static Boolean isPalindrome(String input) {
        String reversed = reverseString(input);
        return input == reversed;
    }

    public static Integer fibonacci(Integer index) {
        if (index <= 1) {
            return index;
        } else {
            return fibonacci(index - 1) + fibonacci(index - 2);
        }
    }

    public static String convertToBase(Integer num, Integer base) {
        String result = '';
        while (num > 0) {
            Integer remainder = Math.mod(num, base);
            result = String.valueOf(remainder) + result;
            num = num / base;
        }
        return result == '' ? '0' : result;
    }

    public static Integer findGCD(Integer a, Integer b) {
        while (b != 0) {
            Integer temp = b;
            b = Math.mod(a, b);
            a = temp;
        }
        return a;
    }

    public static Integer findLCM(Integer a, Integer b) {
        return (a * b) / findGCD(a, b);
    }

    public static Integer power(Integer base, Integer exponent) {
        Integer result = 1;
        for (Integer i = 0; i < exponent; i++) {
            result *= base;
        }
        return result;
    }

    public static Boolean isEven(Integer num) {
        return Math.mod(num, 2) == 0;
    }

    // Method to check if a number is odd
    public static Boolean isOdd(Integer num) {
        return Math.mod(num, 2) != 0;
    }

    // Method to convert a number to Roman numeral
    public static String toRoman(Integer num) {
        String[] romanSymbols = new String[] {
            'I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M'
        };
        Integer[] values = new Integer[] { 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000 };
        
        String result = '';
        for (Integer i = values.size() - 1; i >= 0; i--) {
            while (num >= values[i]) {
                result += romanSymbols[i];
                num -= values[i];
            }
        }
        return result;
    }
   
    public static Boolean isPositive(Integer num) {
        return num > 0;
    }

    public static Boolean isNegative(Integer num) {
        return num < 0;
    }

    public static Integer countVowels(String input) {
        Integer count = 0;
        for (Integer i = 0; i < input.length(); i++) {
            String ch = input.substring(i, i + 1).toLowerCase();
            if ('aeiou'.contains(ch)) count++;
        }
        return count;
    }

    public static String repeatString(String input, Integer times) {
        String result = '';
        for (Integer i = 0; i < times; i++) {
            result += input;
        }
        return result;
    }

    public static Boolean isLeapYear(Integer year) {
        return (Math.mod(year, 4) == 0 && Math.mod(year, 100) != 0) || (Math.mod(year, 400) == 0);
    }
     // New additions
    public static Boolean isPalindromeNumber(Integer num) {
        return String.valueOf(num) == reverseString(String.valueOf(num));
    }

    public static Integer countWords(String input) {
        return input.trim().split('\\s+').size();
    }

    public static Boolean containsOnlyDigits(String input) {
        return Pattern.matches('\\d+', input);
    }
    
public static List<String> sortStrings(List<String> input) {
    input.sort();
    return input;
}

public static List<String> removeDuplicates(List<String> input) {
    Set<String> unique = new Set<String>(input);
    return new List<String>(unique);
}

public static List<String> filterByKeyword(List<String> input, String keyword) {
    List<String> result = new List<String>();
    for (String s : input) {
        if (s.containsIgnoreCase(keyword)) {
            result.add(s);
        }
    }
    return result;
}

public static String joinStrings(List<String> input, String delimiter) {
    return String.join(input, delimiter);
}

public static List<String> toUpperCaseList(List<String> input) {
    List<String> result = new List<String>();
    for (String s : input) {
        result.add(s.toUpperCase());
    }
    return result;
}

public static Boolean isValidEmail(String email) {
    return Pattern.matches('^[\\w.-]+@[\\w.-]+\\.\\w+$', email);
}

public static Integer countWord(String input) {
    if (String.isBlank(input)) return 0;
    return input.trim().split('\\s+').size();
}

public static Integer findMax(List<Integer> nums) {
    if (nums == null || nums.isEmpty()) return null;
    Integer max = nums[0];
    for (Integer n : nums) {
        if (n > max) max = n;
    }
    return max;
}

public static Integer findMin(List<Integer> nums) {
    if (nums == null || nums.isEmpty()) return null;
    Integer min = nums[0];
    for (Integer n : nums) {
        if (n < min) min = n;
    }
    return min;
}

public static Boolean isNumeric(String input) {
    return Pattern.matches('^\\d+$', input);
}

public static Integer countCharacter(String input, String character) {
    Integer count = 0;
    for (Integer i = 0; i < input.length(); i++) {
        if (input.substring(i, i + 1) == character) count++;
    }
    return count;
}

public static List<Integer> reverseList(List<Integer> nums) {
    List<Integer> reversed = new List<Integer>();
    for (Integer i = nums.size() - 1; i >= 0; i--) {
        reversed.add(nums[i]);
    }
    return reversed;
}


public static String capitalizeWords(String input) {
    List<String> words = input.toLowerCase().split(' ');
    for (Integer i = 0; i < words.size(); i++) {
        if (words[i].length()!=0) {
            words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
        }
    }
    return String.join(words, ' ');
}

// Method to check if a number is a perfect square
public static Boolean isPerfectSquare(Double num) {
    Double sqrt = Math.floor(Math.sqrt(num));
    return sqrt * sqrt == num;
}


public static Decimal average(List<Integer> nums) {
    if (nums == null || nums.isEmpty()) return 0;
    Integer total = 0;
    for (Integer n : nums) total += n;
    return Decimal.valueOf(total) / nums.size();
}
   
public static Boolean isAlpha(String input) {
    return Pattern.matches('^[a-zA-Z]+$', input);
}


public static String removeWhitespace(String input) {
    return input.replaceAll('\\s+', '');
}


public static List<Integer> flattenListOfLists(List<List<Integer>> listOfLists) {
    List<Integer> flattened = new List<Integer>();
    for (List<Integer> sublist : listOfLists) {
        flattened.addAll(sublist);
    }
    return flattened;
}


public static Map<String, Integer> charFrequency(String input) {
    Map<String, Integer> freq = new Map<String, Integer>();
    for (Integer i = 0; i < input.length(); i++) {
        String ch = input.substring(i, i+1);
        freq.put(ch, freq.get(ch) == null ? 1 : freq.get(ch) + 1);
    }
    return freq;
}

// Method to get the middle element(s) of a list
public static List<Integer> middleElements(List<Integer> nums) {
    Integer size = nums.size();
    if (size == 0) return new List<Integer>();
    if (Math.mod(size,2) == 1) {
        return new List<Integer>{nums[size/2]};
    } else {
        return new List<Integer>{nums[(size/2)-1], nums[size/2]};
    }
}

// Method to check if two lists contain the same elements (order does not matter)
public static Boolean areListsEqualIgnoringOrder(List<Integer> list1, List<Integer> list2) {
    if (list1 == null || list2 == null) return false;
    if (list1.size() != list2.size()) return false;
    Map<Integer, Integer> counts = new Map<Integer, Integer>();
    for (Integer n : list1) {
        counts.put(n, counts.get(n) == null ? 1 : counts.get(n) + 1);
    }
    for (Integer n : list2) {
        if (!counts.containsKey(n) || counts.get(n) == 0) return false;
        counts.put(n, counts.get(n) - 1);
    }
    return true;
}
}
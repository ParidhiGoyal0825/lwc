@isTest
public class TestContextTrackerTest {

    @isTest static void testCalculateFactorial() {
        System.assertEquals(1, TestContextTracker.calculateFactorial(0));
        System.assertEquals(6, TestContextTracker.calculateFactorial(3));
        System.assertEquals(120, TestContextTracker.calculateFactorial(5));
    }

    @isTest static void testIsPrime() {
        System.assertEquals(false, TestContextTracker.isPrime(1));
        System.assertEquals(true, TestContextTracker.isPrime(7));
        System.assertEquals(false, TestContextTracker.isPrime(9));
    }

    @isTest static void testSumDigits() {
        System.assertEquals(6, TestContextTracker.sumDigits(123));
        System.assertEquals(0, TestContextTracker.sumDigits(0));
    }

    @isTest static void testReverseString() {
        System.assertEquals('dcba', TestContextTracker.reverseString('abcd'));
        System.assertEquals('', TestContextTracker.reverseString(''));
    }

    @isTest static void testIsPalindrome() {
        System.assertEquals(true, TestContextTracker.isPalindrome('madam'));
        System.assertEquals(false, TestContextTracker.isPalindrome('hello'));
    }

    @isTest static void testFibonacci() {
        System.assertEquals(0, TestContextTracker.fibonacci(0));
        System.assertEquals(1, TestContextTracker.fibonacci(1));
        System.assertEquals(5, TestContextTracker.fibonacci(5));
    }

    @isTest static void testConvertToBase() {
        System.assertEquals('10', TestContextTracker.convertToBase(2, 2));
        System.assertEquals('0', TestContextTracker.convertToBase(0, 10));
        System.assertEquals('1001', TestContextTracker.convertToBase(9, 2));
    }

    @isTest static void testFindGCD() {
        System.assertEquals(6, TestContextTracker.findGCD(54, 24));
        System.assertEquals(1, TestContextTracker.findGCD(17, 13));
    }

    @isTest static void testFindLCM() {
        System.assertEquals(216, TestContextTracker.findLCM(54, 24));
        System.assertEquals(221, TestContextTracker.findLCM(13, 17));
    }

    @isTest static void testPower() {
        System.assertEquals(16, TestContextTracker.power(2, 4));
        System.assertEquals(1, TestContextTracker.power(5, 0));
    }

    @isTest static void testIsEven() {
        System.assertEquals(true, TestContextTracker.isEven(10));
        System.assertEquals(false, TestContextTracker.isEven(3));
    }

    @isTest static void testIsOdd() {
        System.assertEquals(true, TestContextTracker.isOdd(5));
        System.assertEquals(false, TestContextTracker.isOdd(4));
    }

    @isTest static void testToRoman() {
        System.assertEquals('I', TestContextTracker.toRoman(1));
        System.assertEquals('IV', TestContextTracker.toRoman(4));
        System.assertEquals('MCMXCIV', TestContextTracker.toRoman(1994));
    }

    @isTest static void testIsPositive() {
        System.assertEquals(true, TestContextTracker.isPositive(10));
        System.assertEquals(false, TestContextTracker.isPositive(-5));
        System.assertEquals(false, TestContextTracker.isPositive(0));
    }

    @isTest static void testIsNegative() {
        System.assertEquals(true, TestContextTracker.isNegative(-1));
        System.assertEquals(false, TestContextTracker.isNegative(0));
        System.assertEquals(false, TestContextTracker.isNegative(10));
    }

    @isTest static void testCountVowels() {
        System.assertEquals(5, TestContextTracker.countVowels('aeiou'));
        System.assertEquals(2, TestContextTracker.countVowels('Hello'));
        System.assertEquals(0, TestContextTracker.countVowels('xyz'));
    }

    @isTest static void testRepeatString() {
        System.assertEquals('abcabcabc', TestContextTracker.repeatString('abc', 3));
        System.assertEquals('', TestContextTracker.repeatString('xyz', 0));
    }

    @isTest static void testIsLeapYear() {
        System.assertEquals(true, TestContextTracker.isLeapYear(2020));
        System.assertEquals(false, TestContextTracker.isLeapYear(1900));
        System.assertEquals(true, TestContextTracker.isLeapYear(2000));
    }

    @isTest static void testIsPalindromeNumber() {
        System.assertEquals(true, TestContextTracker.isPalindromeNumber(121));
        System.assertEquals(false, TestContextTracker.isPalindromeNumber(123));
    }

    @isTest static void testCountWords() {
        System.assertEquals(3, TestContextTracker.countWords('Hello World Test'));
        System.assertEquals(1, TestContextTracker.countWords('Hello'));
        System.assertEquals(1, TestContextTracker.countWords('     '));
    }

    @isTest static void testContainsOnlyDigits() {
        System.assertEquals(true, TestContextTracker.containsOnlyDigits('123456'));
        System.assertEquals(false, TestContextTracker.containsOnlyDigits('123abc'));
        System.assertEquals(false, TestContextTracker.containsOnlyDigits(''));
    }

    @isTest static void testRunCountVariable() {
    TestContextTracker.runCount = 5;
    System.assertEquals(5, TestContextTracker.runCount);
    TestContextTracker.runCount++;
    System.assertEquals(6, TestContextTracker.runCount);
}
    @isTest static void testSortStrings() {
    List<String> input = new List<String>{'banana', 'apple', 'cherry'};
    List<String> expected = new List<String>{'apple', 'banana', 'cherry'};
    System.assertEquals(expected, TestContextTracker.sortStrings(input));
}

@isTest static void testRemoveDuplicates() {
    List<String> input = new List<String>{'apple', 'banana', 'apple', 'cherry'};
    List<String> result = TestContextTracker.removeDuplicates(input);
    System.assertEquals(3, result.size());
    System.assert(result.contains('apple'));
    System.assert(result.contains('banana'));
    System.assert(result.contains('cherry'));
}

@isTest static void testFilterByKeyword() {
    List<String> input = new List<String>{'Salesforce', 'Apex', 'Flow', 'Admin'};
    List<String> result = TestContextTracker.filterByKeyword(input, 'a');
    System.assertEquals(3, result.size()); // Salesforce, Apex, Admin
}

@isTest static void testJoinStrings() {
    List<String> input = new List<String>{'one', 'two', 'three'};
    String result = TestContextTracker.joinStrings(input, '-');
    System.assertEquals('one-two-three', result);
}

@isTest static void testToUpperCaseList() {
    List<String> input = new List<String>{'a', 'b', 'c'};
    List<String> expected = new List<String>{'A', 'B', 'C'};
    System.assertEquals(expected, TestContextTracker.toUpperCaseList(input));
}

    @isTest static void testIsValidEmail() {
        System.assertEquals(true, TestContextTracker.isValidEmail('test@example.com'));
        System.assertEquals(false, TestContextTracker.isValidEmail('invalid-email'));
    }

    @isTest static void testCountWord() {
        System.assertEquals(3, TestContextTracker.countWord('This is Apex'));
        System.assertEquals(0, TestContextTracker.countWord('    '));
    }

    @isTest static void testFindMax() {
        List<Integer> nums = new List<Integer>{1, 5, 3, 9, 2};
        System.assertEquals(9, TestContextTracker.findMax(nums));
        System.assertEquals(null, TestContextTracker.findMax(new List<Integer>()));
    }

    @isTest static void testFindMin() {
        List<Integer> nums = new List<Integer>{1, 5, 3, -1, 2};
        System.assertEquals(-1, TestContextTracker.findMin(nums));
        System.assertEquals(null, TestContextTracker.findMin(null));
    }

    @isTest static void testIsNumeric() {
        System.assertEquals(true, TestContextTracker.isNumeric('12345'));
        System.assertEquals(false, TestContextTracker.isNumeric('12a45'));
    }

    @isTest static void testCountCharacter() {
        System.assertEquals(3, TestContextTracker.countCharacter('hello world', 'l'));
        System.assertEquals(0, TestContextTracker.countCharacter('abcdef', 'z'));
    }

    @isTest static void testReverseList() {
        List<Integer> input = new List<Integer>{1, 2, 3, 4};
        List<Integer> expected = new List<Integer>{4, 3, 2, 1};
        System.assertEquals(expected, TestContextTracker.reverseList(input));
    }

    @isTest static void testCapitalizeWords() {
        System.assertEquals('Hello World', TestContextTracker.capitalizeWords('hello world'));
        System.assertEquals('Salesforce Apex', TestContextTracker.capitalizeWords('sALESFORCE aPEX'));
    }

    @isTest
static void testIsPerfectSquare() {
    // Perfect square
    System.assertEquals(true, TestContextTracker.isPerfectSquare((Double)16), '16 is a perfect square');

    // Non-perfect square
    System.assertEquals(false, TestContextTracker.isPerfectSquare((Double)20), '20 is not a perfect square');

    // Zero
    System.assertEquals(true, TestContextTracker.isPerfectSquare((Double)0), '0 is a perfect square');

    // Large perfect square
    System.assertEquals(true, TestContextTracker.isPerfectSquare((Double)1000000), '1,000,000 is a perfect square');

    // Not a perfect square
    System.assertEquals(false, TestContextTracker.isPerfectSquare((Double)2), '2 is not a perfect square');
}


    @isTest static void testAverage() {
        List<Integer> nums = new List<Integer>{2, 4, 6, 8};
        System.assertEquals(5, TestContextTracker.average(nums));
        System.assertEquals(0, TestContextTracker.average(new List<Integer>()));
    }

    // Now test the utility methods you posted outside the class

    @IsTest
    static void testIsAlpha() {
        System.assertEquals(true, TestContextTracker.isAlpha('abcXYZ'));
        System.assertEquals(false, TestContextTracker.isAlpha('abc123'));
        System.assertEquals(false, TestContextTracker.isAlpha(''));
    }

    @IsTest
    static void testRemoveWhitespace() {
        System.assertEquals('abc123', TestContextTracker.removeWhitespace(' a b c 1 2 3 '));
        System.assertEquals('', TestContextTracker.removeWhitespace('     '));
    }

    @IsTest
    static void testFlattenListOfLists() {
        List<List<Integer>> listOfLists = new List<List<Integer>>{
            new List<Integer>{1,2}, 
            new List<Integer>{3,4}
        };
        List<Integer> flattened = TestContextTracker.flattenListOfLists(listOfLists);
        System.assertEquals(new List<Integer>{1,2,3,4}, flattened);
    }

    @IsTest
    static void testCharFrequency() {
        Map<String, Integer> freq = TestContextTracker.charFrequency('aabbc');
        System.assertEquals(2, freq.get('a'));
        System.assertEquals(2, freq.get('b'));
        System.assertEquals(1, freq.get('c'));
    }

    @IsTest
    static void testMiddleElements() {
        System.assertEquals(new List<Integer>{2}, TestContextTracker.middleElements(new List<Integer>{1,2,3}));
        System.assertEquals(new List<Integer>{2,3}, TestContextTracker.middleElements(new List<Integer>{1,2,3,4}));
        System.assertEquals(new List<Integer>(), TestContextTracker.middleElements(new List<Integer>()));
    }

    @IsTest
    static void testAreListsEqualIgnoringOrder() {
        System.assertEquals(true, TestContextTracker.areListsEqualIgnoringOrder(new List<Integer>{1,2,3}, new List<Integer>{3,2,1}));
        System.assertEquals(false, TestContextTracker.areListsEqualIgnoringOrder(new List<Integer>{1,2}, new List<Integer>{1,2,3}));
        System.assertEquals(false, TestContextTracker.areListsEqualIgnoringOrder(null, new List<Integer>{1}));
    }
}
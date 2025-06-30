@isTest
private class TestMultiUtilityLogic {

    @isTest static void testReverseString() {
        System.assertEquals('cba', MultiUtilityLogic.reverseString('abc'));
        System.assertEquals(null, MultiUtilityLogic.reverseString(null));
        System.assertEquals('', MultiUtilityLogic.reverseString(''));
    }

    @isTest static void testIsPalindrome() {
        System.assert(MultiUtilityLogic.isPalindrome('Level'));
        System.assert(!MultiUtilityLogic.isPalindrome('Test'));
        System.assert(!MultiUtilityLogic.isPalindrome(null));
    }

    @isTest static void testToUpperCaseList() {
        List<String> input = new List<String>{'a', 'b', null};
        List<String> result = MultiUtilityLogic.toUpperCaseList(input);
        System.assertEquals('A', result[0]);
        System.assertEquals('B', result[1]);
        System.assertEquals(null, result[2]);
    }

    @isTest static void testFilterEvenNumbers() {
        List<Integer> nums = new List<Integer>{1, 2, 3, 4, null};
        List<Integer> evens = MultiUtilityLogic.filterEvenNumbers(nums);
        System.assertEquals(2, evens.size());
        System.assert(evens.contains(2));
        System.assert(evens.contains(4));
    }

    @isTest static void testSumList() {
        List<Integer> nums = new List<Integer>{1, 2, null, 3};
        Integer total = MultiUtilityLogic.sumList(nums);
        System.assertEquals(6, total);
    }

    @isTest static void testStringLengths() {
        List<String> strs = new List<String>{'abc', '', null};
        Map<String, Integer> lengths = MultiUtilityLogic.stringLengths(strs);
        System.assertEquals(3, lengths.get('abc'));
        System.assertEquals(0, lengths.get(''));
        System.assertEquals(0, lengths.get(null));
    }

    @isTest static void testContainsDigit() {
        System.assert(MultiUtilityLogic.containsDigit('abc123'));
        System.assert(!MultiUtilityLogic.containsDigit('abcdef'));
        System.assert(!MultiUtilityLogic.containsDigit(null));
        System.assert(!MultiUtilityLogic.containsDigit(''));
    }

    @isTest static void testRemoveBlankStrings() {
        List<String> input = new List<String>{'a', ' ', '', null, 'b'};
        List<String> result = MultiUtilityLogic.removeBlankStrings(input);
        System.assertEquals(2, result.size());
        System.assert(result.contains('a'));
        System.assert(result.contains('b'));
    }

    @isTest static void testMaxNumber() {
        List<Integer> nums = new List<Integer>{1, 5, 3, null, 7};
        Integer maxVal = MultiUtilityLogic.maxNumber(nums);
        System.assertEquals(7, maxVal);

        System.assertEquals(null, MultiUtilityLogic.maxNumber(new List<Integer>()));
        System.assertEquals(null, MultiUtilityLogic.maxNumber(null));
    }
}
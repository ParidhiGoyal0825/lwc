@isTest
public class TextContextTrackerTest {

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
}
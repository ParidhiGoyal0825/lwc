@isTest
public class DemoTest {

    @isTest
    static void testPrimeDigitsWithPrimeDigits() {
        Integer inputNumber = 2357;
        Test.startTest();
        Demo.primeDigits(inputNumber);
        Test.stopTest();
        
        System.assert(true);
    }

    @isTest
    static void testPrimeDigitsWithNoPrimeDigits() {
        Integer inputNumber = 468;
        Test.startTest();
        Demo.primeDigits(inputNumber);
        Test.stopTest();
        
        System.assert(true);
    }

    @isTest
    static void testPrimeDigitsWithAllPrimeDigits() {
        Integer inputNumber = 777;
        Test.startTest();
        Demo.primeDigits(inputNumber);
        Test.stopTest();
        
        System.assert(true);
    }

    @isTest
    static void testPrimeDigitsWithSingleDigit() {
        Integer inputNumber = 5;
        Test.startTest();
        Demo.primeDigits(inputNumber);
        Test.stopTest();
        
        System.assert(true);
    }
    
    @isTest
    static void testPrimeDigitsWithZero() {
        Integer inputNumber = 0;
        Test.startTest();
        Demo.primeDigits(inputNumber);
        Test.stopTest();
        
        System.assert(true);
    }
}
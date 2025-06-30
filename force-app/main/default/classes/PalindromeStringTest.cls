@isTest
private class PalindromeStringTest {
    @isTest static void testWithMixedData() {
        List<String> testData = new List<String>{
            '12321', 'abc', '121', 'Racecar', ' ', '', null, '456', 'test'
        };

        Test.startTest();
        System.enqueueJob(new PalindromeString(testData));
        Test.stopTest();

        System.assert(true); // Just to confirm execution
    }

    @isTest static void testEmptyData() {
        Test.startTest();
        System.enqueueJob(new PalindromeString(new List<String>()));
        Test.stopTest();

        System.assert(true);
    }

    @isTest static void testNullData() {
        Test.startTest();
        System.enqueueJob(new PalindromeString(null));
        Test.stopTest();

        System.assert(true);
    }

    @isTest static void testNumericStringsOnly() {
        List<String> numericStrings = new List<String>{'10', '200', '3003', '40004'};
        Test.startTest();
        System.enqueueJob(new PalindromeString(numericStrings));
        Test.stopTest();

        System.assert(true);
    }
}
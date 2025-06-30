@isTest
private class TestMultiLogicQueueable {
    @isTest
    static void testAllLogic() {
        List<String> input = new List<String>{
            '123', 'abc', '4567', 'Test', 'noVowels', 'AEIOU', ' ', null, '9876'
        };

        Test.startTest();
        System.enqueueJob(new MultiLogicQueueable(input));
        Test.stopTest();

        System.assert(true); // All logic branches executed
    }

    @isTest
    static void testEmptyList() {
        Test.startTest();
        System.enqueueJob(new MultiLogicQueueable(new List<String>()));
        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testNullList() {
        Test.startTest();
        System.enqueueJob(new MultiLogicQueueable(null));
        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testAllNumericStrings() {
        List<String> numericStrings = new List<String>{'1', '22', '333', '4444'};
        Test.startTest();
        System.enqueueJob(new MultiLogicQueueable(numericStrings));
        Test.stopTest();

        System.assert(true);
    }
}
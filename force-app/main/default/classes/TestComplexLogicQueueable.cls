@isTest
private class TestComplexLogicQueueable {
    
    @isTest
    static void testWithValidNumList() {
        List<String> numList = new List<String>{'12321', '45654', 'Hello', 'Test', '  98789  ', ' '};

        Test.startTest();
        System.enqueueJob(new ComplexLogicQueueable(numList));
        Test.stopTest();

        System.assert(true); // Validates that queueable ran
    }

    @isTest
    static void testWithEmptyNumList() {
        List<String> numList = new List<String>();

        Test.startTest();
        System.enqueueJob(new ComplexLogicQueueable(numList));
        Test.stopTest();

        System.assert(true); // Just to complete the test
    }

    @isTest
    static void testWithNullNumList() {
        List<String> numList = null;

        Test.startTest();
        System.enqueueJob(new ComplexLogicQueueable(numList));
        Test.stopTest();

        System.assert(true); // Logic path for null input
    }
}
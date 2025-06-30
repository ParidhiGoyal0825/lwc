@isTest
private class recordFetcherTest {
    
    @testSetup
    static void setupData() {
        // Create test Opportunities
        Opportunity opp1 = new Opportunity(
            Name = 'Original Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(10),
            Amount = 10000
        );

        Opportunity opp2 = new Opportunity(
            Name = 'Cloned Opportunity',
            StageName = 'Proposal/Price Quote',
            CloseDate = System.today().addDays(20),
            Amount = 12000
        );

        insert new List<Opportunity>{opp1, opp2};
    }

    @isTest
    static void testGetRecords() {
        Test.startTest();
        List<SObject> records = recordFetcher.getRecords('Opportunity', 'Id, Name');
        Test.stopTest();
        System.assertNotEquals(0, records.size(), 'Expected some Opportunity records');
    }

    @isTest
    static void testSearchRecords() {
        Opportunity testOpp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        
        Test.startTest();
        List<SObject> results = recordFetcher.searchRecords('Opportunity', 'Name', 'Original');
        Test.stopTest();

        System.assertNotEquals(0, results.size(), 'Expected at least one result from search');
    }

    @isTest
    static void testGetRecordData() {
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity ORDER BY CreatedDate ASC LIMIT 2];
        Id originalId = opportunities[0].Id;
        Id clonedId = opportunities[1].Id;

        Test.startTest();
        Map<String, Map<String, String>> resultMap = recordFetcher.getRecordData(originalId, clonedId);
        Test.stopTest();

        System.assert(resultMap.containsKey('original'), 'Original record data missing');
        System.assert(resultMap.containsKey('cloned'), 'Cloned record data missing');
        System.assertEquals(4, resultMap.get('original').size(), 'Expected 4 fields in original map');
    }

   @isTest
static void testSearchRecordsWithInvalidInputs() {
    Boolean thrown = false;
    try {
        recordFetcher.searchRecords('', '', '');
    } catch (Exception e) {
        thrown = true;
        System.assert(e instanceof AuraHandledException, 'Expected AuraHandledException');
    }
    System.assert(thrown, 'Exception should have been thrown for invalid inputs');
}
    

   @isTest
static void testGetRecordsWithInvalidInputs() {
    Boolean exceptionThrown = false;
    try {
        recordFetcher.getRecords(null, null);  // explicitly null to trigger the check
    } catch (AuraHandledException e) {
        exceptionThrown = true;
    }
    System.assert(exceptionThrown, 'Expected AuraHandledException to be thrown');
}
}
@isTest
private class TestCloneOpportunitiesQueueable {
    @isTest
    static void testCloning() {
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Prospecting', CloseDate=Date.today().addDays(30), Amount=1000);
        insert opp;

        Test.startTest();
        System.enqueueJob(new CloneOpportunitiesQueueable(new List<Id>{opp.Id}));
        Test.stopTest();

        List<Opportunity> results = [SELECT Name FROM Opportunity WHERE Name LIKE 'Test Opp%'];
        System.assertEquals(2, results.size()); // Original + Clone
    }
}
@isTest
public class AsynchronousApexHandlerTest {
    @isTest
    static void testBatchExecution() {
        // Step 1: Create test Opportunity records
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 0; i < 10; i++) {
            oppList.add(new Opportunity(
                Name = 'Test Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        insert oppList;

        // Step 2: Execute the batch class
        Test.startTest();
        AsynchronousApexHandler batch = new AsynchronousApexHandler();
        Database.executeBatch(batch, 200); // batch size of 5
        Test.stopTest();

        // Step 3: Query updated records and assert LeadSource is 'Web'
        List<Opportunity> updatedOpps = [SELECT Id, LeadSource FROM Opportunity];
        for (Opportunity opp : updatedOpps) {
            System.assertEquals('Web', opp.LeadSource, 'LeadSource should be updated to Web');
        }
    }
}
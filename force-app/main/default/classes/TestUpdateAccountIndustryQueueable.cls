@isTest
private class TestUpdateAccountIndustryQueueable {
    @isTest
    static void testQueueableExecution() {
        // Create test Accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;

        // Extract IDs for queueable input
        List<Id> accountIds = new List<Id>();
        for (Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }

        // Enqueue the Queueable Job
        Test.startTest();
        System.enqueueJob(new UpdateAccountIndustryQueueable(accountIds, 'Technology'));
        Test.stopTest();

        // Validate the update
        List<Account> updatedAccounts = [SELECT Id, Industry FROM Account WHERE Id IN :accountIds];
        for (Account acc : updatedAccounts) {
            System.assertEquals('Technology', acc.Industry);
        }
    }
}
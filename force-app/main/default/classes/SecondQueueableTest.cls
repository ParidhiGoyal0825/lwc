@isTest
public class SecondQueueableTest {
@isTest
    static void testQueueable() {
        // Create test accounts
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        // Collect the Ids
        List<Id> accountIds = new List<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        // Enqueue the Queueable job
        Test.startTest();
        System.enqueueJob(new SecondQueueable(accountIds, 'Updated by Queueable'));
        Test.stopTest();

        // Verify the update
        List<Account> updatedAccounts = [SELECT Description FROM Account WHERE Id IN :accountIds];
        for (Account acc : updatedAccounts) {
            System.assertEquals('Updated by Queueable', acc.Description);
        }
    }
}
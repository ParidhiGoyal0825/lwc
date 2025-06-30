@isTest
public class FirstQueueableTest {
    @isTest
    static void testContactTitleUpdater() {
        // Create test accounts
        Account acc1 = new Account(Name = 'Test Account 1', Industry = 'Technology');
        Account acc2 = new Account(Name = 'Test Account 2', Industry = null);
        insert new List<Account>{ acc1, acc2 };

        // Create contacts related to accounts
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc1.Id);
        Contact con2 = new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = acc2.Id);
        insert new List<Contact>{ con1, con2 };

        List<Id> accIds = new List<Id>{ acc1.Id, acc2.Id };

        // Enqueue the job
        Test.startTest();
        System.enqueueJob(new FirstQueueable(accIds));
        Test.stopTest();

        // Verify titles updated
        List<Contact> updated = [SELECT Title, Account.Industry FROM Contact WHERE Id IN :new List<Id>{con1.Id, con2.Id}];
        for (Contact c : updated) {
            if (c.Account.Industry != null) {
                System.assertEquals('Expert in ' + c.Account.Industry, c.Title);
            } else {
                System.assertEquals('General Contact', c.Title);
            }
        }
    }
}
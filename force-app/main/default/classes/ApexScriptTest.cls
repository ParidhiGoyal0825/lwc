@isTest
public class ApexScriptTest {

    @isTest
    static void testGetContacts() {
        // Create test Accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;

        // Create test Contacts and link to the Accounts
        List<Contact> testContacts = new List<Contact>();
        for (Account acc : testAccounts) {
            for (Integer j = 0; j < 2; j++) {
                testContacts.add(new Contact(FirstName = 'Test', LastName = 'Contact ' + j, AccountId = acc.Id));
            }
        }
        insert testContacts;

        // Call the method
        Test.startTest();
        ApexScript.getContacts();
        Test.stopTest();

        // Optionally assert something if applicable (e.g., that debug log contains expected data)
        // However, since this method only logs data, there's nothing to assert unless it is refactored to return a value.
    }
}
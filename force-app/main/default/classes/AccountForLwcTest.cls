@isTest
private class AccountForLwcTest {

    @testSetup
    static void setupTestData() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            testAccounts.add(new Account(
                Name = 'Test Account ' + i,
                Industry = 'Technology',
                Website = 'https://test' + i + '.com',
                Phone = '123-456-789' + i
            ));
        }
        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 2; i++) {
            testContacts.add(new Contact(
                FirstName = 'Contact',
                LastName = 'Test ' + i,
                Email = 'contact' + i + '@example.com',
                AccountId = testAccounts[0].Id
            ));
        }
        insert testContacts;
    }

    @isTest
    static void testGetAccounts() {
        Test.startTest();
        List<Account> accounts = AccountforLwc.getAccounts();
        Test.stopTest();

        System.assertNotEquals(null, accounts);
        System.assert(accounts.size() > 0);
    }

    @isTest
    static void testGetAccountsNoRecords() {
        delete [SELECT Id FROM Account];

        Test.startTest();
        List<Account> accounts = AccountforLwc.getAccounts();
        Test.stopTest();

        System.assertEquals(null, accounts);
    }

    @isTest
    static void testUpdateAccountDetails() {
        List<Account> accList = [SELECT Id, Name FROM Account LIMIT 1];
        accList[0].Name = 'Updated Name';

        Test.startTest();
        String result = AccountforLwc.updatedAccountDetails(accList);
        Test.stopTest();

        System.assertEquals('Records updated successfully', result);
        Account updated = [SELECT Name FROM Account WHERE Id = :accList[0].Id];
        System.assertEquals('Updated Name', updated.Name);
    }

    @isTest
    static void testUpdateAccountDetailsException() {
        List<Account> accList = [SELECT Id, Name FROM Account LIMIT 1];
        accList[0].Name = '';  // Invalid update, causing a validation error

        Test.startTest();
        try {
            AccountforLwc.updatedAccountDetails(accList);
            System.assert(false, 'Exception should have been thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Error updating records'));
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteOperationList() {
        List<Account> accountsToDelete = [SELECT Id FROM Account LIMIT 1];
        List<Id> idsToDelete = new List<Id>{ accountsToDelete[0].Id };

        Test.startTest();
        AccountforLwc.deleteOperationList(idsToDelete);
        Test.stopTest();

        Account deletedAcc = [SELECT Id, IsDeleted FROM Account WHERE Id = :idsToDelete[0] ALL ROWS];
        System.assertEquals(true, deletedAcc.IsDeleted);
    }

    @isTest
    static void testDeleteOperationListException() {
        List<Account> accountsToDelete = [SELECT Id FROM Account LIMIT 1];
        List<Id> idsToDelete = new List<Id>{ accountsToDelete[0].Id };

        delete accountsToDelete;

        Test.startTest();
        try {
            AccountforLwc.deleteOperationList(idsToDelete);
            System.assert(false, 'Exception should have been thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Error deleting records'));
        }
        Test.stopTest();
    }

    @isTest
    static void testGetContact() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        List<Contact> contacts = AccountforLwc.getContact(acc.Id);
        Test.stopTest();

        System.assertNotEquals(null, contacts);
        System.assert(contacts.size() > 0);
        System.assertEquals(acc.Id, contacts[0].AccountId);
    }

    @isTest
    static void testGetContactNoRecords() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        delete [SELECT Id FROM Contact WHERE AccountId = :acc.Id];

        Test.startTest();
        List<Contact> contacts = AccountforLwc.getContact(acc.Id);
        Test.stopTest();

        System.assertEquals(0, contacts.size());
    }
}
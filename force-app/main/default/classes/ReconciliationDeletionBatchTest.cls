@isTest
private class ReconciliationDeletionBatchTest {

    @testSetup
    static void setupTestData() {
        // Create a User for test and insert
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(
            Alias = 'tuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser' + DateTime.now().getTime() + '@example.com',
            userActive__c = true // Assuming this custom field exists on User
        );
        insert u;
    }

    @isTest
    static void testBatchExecution() {
        // Fetch the user created in @testSetup
        User testUser = [SELECT Id, userActive__c FROM User WHERE Alias = 'tuser' LIMIT 1];

        Account acc = new Account(Name = 'Test Account', OwnerId = testUser.Id);
        insert acc;

        // Create Reconciliation records that meet deletion criteria (without CreatedDate override yet)
        List<Reconcillation__c> recs = new List<Reconcillation__c>();

        recs.add(new Reconcillation__c(
            Account_lr__c = acc.Id,
            Status_p__c = 'New Pending',
            Source_p__c = 'Online'
        ));
        recs.add(new Reconcillation__c(
            Account_lr__c = acc.Id,
            Status_p__c = 'New Pending',
            Source_p__c = 'Online'
        ));
        insert recs;

        // Override CreatedDate AFTER insert to simulate old records
        Test.setCreatedDate(recs[0].Id, System.now().addDays(-31));
        Test.setCreatedDate(recs[1].Id, System.now().addDays(-40));

        // Run batch
        Test.startTest();
        ReconciliationDeletionBatch batch = new ReconciliationDeletionBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify reconciliations deleted
        Integer countRecs = [SELECT count() FROM Reconcillation__c WHERE Id IN :recs];
        System.assertEquals(0, countRecs, 'Reconciliation records should be deleted');

        // Verify Account deleted
        Integer countAcc = [SELECT count() FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, countAcc, 'Account should be deleted');

        // Verify User deactivated
        User u = [SELECT userActive__c FROM User WHERE Id = :testUser.Id];
        System.assertEquals(false, u.userActive__c, 'User should be deactivated');
    }
}
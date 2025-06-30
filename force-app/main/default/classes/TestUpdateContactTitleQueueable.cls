@isTest
private class TestUpdateContactTitleQueueable {
    @isTest
    static void testUpdateTitle() {
        Contact c = new Contact(FirstName='Test', LastName='Contact');
        insert c;

        Test.startTest();
        System.enqueueJob(new UpdateContactTitleQueueable(new List<Id>{c.Id}, 'Developer'));
        Test.stopTest();

        Contact updated = [SELECT Title FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Developer', updated.Title);
    }
}
@isTest
public class ContactTest {

    @isTest
    static void testUpdateAmount() {
        // Step 1: Create an Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Step 2: Create a Contact related to the Account
        Contact contact = new Contact(FirstName = 'Test', LastName = 'User', AccountId = acc.Id);
        insert contact;

        // Step 3: Create an Opportunity related to the Account
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            CloseDate = Date.today().addDays(10),
            StageName = 'Prospecting',
            Amount = 1000
        );
        insert opp;

        // Step 4: Link Contact and Opportunity via OpportunityContactRole
        OpportunityContactRole ocr = new OpportunityContactRole(
            OpportunityId = opp.Id,
            ContactId = contact.Id,
            Role = 'Decision Maker'
        );
        insert ocr;

        // Step 5: Simulate Contact update
        contact.FirstName = 'Updated';
        List<Contact> updatedContacts = new List<Contact>{ contact };
        Map<Id, Contact> oldMap = new Map<Id, Contact>{ contact.Id => contact };

        // Step 6: Run test
        Test.startTest();
        ContactHandler.updateAmount(updatedContacts, oldMap);
        Test.stopTest();

        // Step 7: Verify that Account has updated Total_Opportunity_Amount__c
        Account updatedAcc = [SELECT Id, Total_Opportunity_Amount__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1000, updatedAcc.Total_Opportunity_Amount__c);
    }
}
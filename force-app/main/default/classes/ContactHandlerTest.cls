@isTest
private class ContactHandlerTest {
    @isTest
    static void createContact() {
        // Create an Account
        Account acc = new Account(Name = 'test');
        insert acc;

        // Create a Contact linked to the Account
        Contact con = new Contact(
            LastName = 'test',
            Phone = '14862',
            AccountId = acc.Id // Associate Contact with Account
        );
        insert con;

        // Create Opportunities linked to the Account
        Opportunity opp = new Opportunity(
            Name = 'test',
            CloseDate = Date.newInstance(2025, 03, 26),
            Amount = 150,
            StageName = 'Closed Won',
            AccountId = acc.Id // Associate Opportunity with Account
        );
        insert opp;

        Opportunity opp1 = new Opportunity(
            Name = 'test',
            CloseDate = Date.newInstance(2025, 03, 26),
            Amount = 14,
            StageName = 'Closed Won',
            AccountId = acc.Id // Associate Opportunity with Account
        );
        insert opp1;

        // Associate Contact with BOTH Opportunities using OpportunityContactRole
        OpportunityContactRole oppR1 = new OpportunityContactRole(
            ContactId = con.Id,
            OpportunityId = opp.Id,
            Role = 'Decision Maker'
        );
        insert oppR1;

        OpportunityContactRole oppR2 = new OpportunityContactRole(
            ContactId = con.Id,
            OpportunityId = opp1.Id,
            Role = 'Influencer' // Role can be any valid value
        );
        insert oppR2;

        // Update the Contact's phone number to trigger handler
        con.Phone = '18642';
        update con;

        // Retrieve the updated Account to check roll-up summary field
        Account accRetrieved = [SELECT Id, Name, Total_Opportunity_Amount__c FROM Account WHERE Id = :acc.Id];

        // Validate if the Account's Total Opportunity Amount is updated correctly
        System.assertEquals(164, accRetrieved.Total_Opportunity_Amount__c, 'Total Opportunity Amount is incorrect.');
    }
}
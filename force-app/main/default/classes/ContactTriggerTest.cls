@isTest
private class ContactTriggerTest {

    @isTest
    static void testContactUpdateTriggersOpportunityAmountRollup() {
        // Step 1: Create a test Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Step 2: Create a test Contact linked to the Account
        Contact con = new Contact(
            LastName = 'Test Contact',
            Phone = '1111111111',
            AccountId = acc.Id
        );
        insert con;

        // Step 3: Create two Opportunities linked to the Account
        Opportunity opp1 = new Opportunity(
            Name = 'Opportunity 1',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 200,
            AccountId = acc.Id
        );

        Opportunity opp2 = new Opportunity(
            Name = 'Opportunity 2',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 300,
            AccountId = acc.Id
        );

        insert new List<Opportunity>{ opp1, opp2 };

        // Step 4: Link the Contact to both Opportunities using OpportunityContactRole
        OpportunityContactRole ocr1 = new OpportunityContactRole(
            ContactId = con.Id,
            OpportunityId = opp1.Id,
            Role = 'Decision Maker'
        );

        OpportunityContactRole ocr2 = new OpportunityContactRole(
            ContactId = con.Id,
            OpportunityId = opp2.Id,
            Role = 'Influencer'
        );

        insert new List<OpportunityContactRole>{ ocr1, ocr2 };

        // Step 5: Update the Contact to trigger the trigger and handler
        con.Phone = '2222222222';
        update con;

        // Step 6: Verify that the Account's Total_Opportunity_Amount__c is correct (200 + 300)
        Account updatedAcc = [SELECT Id, Total_Opportunity_Amount__c FROM Account WHERE Id = :acc.Id];

        System.assertEquals(
            500,
            updatedAcc.Total_Opportunity_Amount__c,
            'The Account\'s Total_Opportunity_Amount__c should reflect the sum of related Opportunities.'
        );
    }
}
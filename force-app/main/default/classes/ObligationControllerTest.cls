@isTest
private class ObligationControllerTest {

    
    private static Applicant__c createApplicant() {
        Applicant__c applicant = new Applicant__c(Name = 'Test Applicant');
        insert applicant;
        return applicant;
    }

   
    @isTest
    static void testGetObligations() {
        Applicant__c applicant = createApplicant();  // Create an Applicant record

        // Create Obligation__c records and reference the Applicant record
        List<Obligation__c> obligations = new List<Obligation__c>();
        for (Integer i = 0; i < 5; i++) {
            obligations.add(new Obligation__c(
                Name = 'Obligation ' + i,
                Account_Type__c = 'Personal Loan',
                Bureau_Imputed_EMI__c = 100,
                Calculated_MOB__c = 12,
                Credit_Card_Utilization__c = 20,
                Current_Balance__c = 5000,
                Declared_EMI__c = 200,
                EMI_Start_Date__c = Date.today().addMonths(-6),
                EMI_Type__c = 'Bureau',
                Exclude_Reason__c = '',
                Exposure_Type__c = 'Unsecured',
                Select_BT_Action__c = 'Exclude"',
                Financier_Name__c = 'Tata Capital',
                Loan_Account_Number__c = 'LN' + i,
                Sanctioned_Loan_Amount__c = 10000,
                Obligation_to_be_considered__c = 'Yes',
                Ownership_Type__c = 'Joint',
                Open_Date__c = Date.today(),
                Applicant_Type__c = applicant.Id
            ));
        }
        insert obligations;

        // Test the getObligations() method
        Test.startTest();
        List<Obligation__c> results = ObligationController.getObligations();
        Test.stopTest();

        System.assert(results.size() > 0, 'There should be at least one obligation.');
    }

    // Test the updateObligations() method
    @isTest
    static void testUpdateObligations() {
        Applicant__c applicant = createApplicant();  // Create an Applicant record

        // Create an Obligation record
        Obligation__c ob = new Obligation__c(
            Name = 'Test Obligation',
            Account_Type__c = 'Personal Loan',
            Bureau_Imputed_EMI__c = 120,
            Exposure_Type__c = 'Secured',
            Sanctioned_Loan_Amount__c = 8000,
            Current_Balance__c = 4000,
            Ownership_Type__c = 'Joint',
            Open_Date__c = Date.today(),
            Applicant_Type__c = applicant.Id,
            EMI_Start_Date__c = Date.today().addMonths(-6),
            Obligation_to_be_considered__c = 'Yes'
        );
        insert ob;

        // Update the Obligation record
        ob.Bureau_Imputed_EMI__c = 150;
        
        Test.startTest();
        ObligationController.updateObligations(new List<Obligation__c>{ob});
        Test.stopTest();

        // Verify that the record was updated
        Obligation__c updated = [SELECT Bureau_Imputed_EMI__c FROM Obligation__c WHERE Id = :ob.Id];
        System.assertEquals(150, updated.Bureau_Imputed_EMI__c, 'The Bureau Imputed EMI should be updated.');
    }

    // Test the getTableColumns() method
    @isTest
    static void testGetTableColumns() {
        // Test the getTableColumns() method (mock data in Custom Metadata)
        Test.startTest();
        List<Map<String, Object>> columns = ObligationController.getTableColumns();
        Test.stopTest();

        System.assertNotEquals(columns.size(), 0, 'There should be at least one column configuration.');
    }

    @isTest
static void testGetObligationSummary() {
    // Step 1: Create an Opportunity record for the test
    Opportunity opp = new Opportunity(
        Name = 'Test Opportunity',
        StageName = 'Prospecting',
        CloseDate = Date.today().addMonths(1),
        AccountId = null  
    );
    insert opp;

    
    Applicant__c applicant = new Applicant__c(
        Name = 'Test Applicant',
        OpportunityId__c = opp.Id  
    );
    insert applicant;  

   
    List<Obligation__c> obligations = new List<Obligation__c>();
    for (Integer i = 0; i < 5; i++) {
        obligations.add(new Obligation__c(
            Name = 'Obligation ' + i,
            Account_Type__c = 'Personal Loan',
            Bureau_Imputed_EMI__c = 100,
            Calculated_MOB__c = 12,
            Credit_Card_Utilization__c = 20,
            Current_Balance__c = 5000,
            Declared_EMI__c = 200,
            EMI_Start_Date__c = Date.today().addMonths(-6),
            EMI_Type__c = 'Bureau',
            Exclude_Reason__c = '',
            Exposure_Type__c = 'Unsecured',
            Select_BT_Action__c = 'Exclude"',
            Financier_Name__c = 'Tata Capital',
            Loan_Account_Number__c = 'LN' + i,
            Sanctioned_Loan_Amount__c = 10000,
            Obligation_to_be_considered__c = 'Yes',
            Ownership_Type__c = 'Joint',
            Open_Date__c = Date.today(),
            Applicant_Type__c = applicant.Id  
        ));
    }
    insert obligations;


    Test.startTest();
    Map<String, Object> summary = ObligationController.getObligationSummary(applicant.OpportunityId__c);  // Use the OpportunityId from Applicant
    Test.stopTest();

    System.assert(summary.containsKey('columns'), 'Summary should contain columns.');
    System.assert(summary.containsKey('data'), 'Summary should contain data.');
}
}
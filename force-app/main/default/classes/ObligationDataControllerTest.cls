@isTest
public class ObligationDataControllerTest {
// Helper method to create an Applicant record
    private static Applicant__c createApplicant() {
        Applicant__c applicant = new Applicant__c(Name = 'Test Applicant');
        insert applicant;
        return applicant;
    }

    // Test the getObligations() method
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
}
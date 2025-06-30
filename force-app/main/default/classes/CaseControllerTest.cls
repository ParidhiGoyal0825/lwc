@isTest
public class CaseControllerTest {
    
    @testSetup
    static void setupTestData() {
        List<Case> cases = new List<Case>{
            new Case(Subject='Test Case One', Status='New', Priority='Medium'),
            new Case(Subject='Urgent Issue', Status='Working', Priority='High'),
            new Case(Subject='Low Priority Case', Status='Escalated', Priority='Low')
        };
        insert cases;
    }

    @isTest
    static void testGetFilteredCases_withSearchKey() {
        Test.startTest();
        List<Case> result = CaseController.getFilteredCases('Urgent', null, null);
        Test.stopTest();
        
        System.assertNotEquals(0, result.size(), 'Expected to find cases with "Urgent" in the subject');
        System.assert(result[0].Subject.contains('Urgent'));
    }

    @isTest
    static void testGetFilteredCases_withPriorityAndStatusFilter() {
        Test.startTest();
        List<Case> result = CaseController.getFilteredCases('', 'High', 'Working');
        Test.stopTest();
        
        System.assertEquals(1, result.size(), 'Should return 1 case with High priority and Working status');
        System.assertEquals('High', result[0].Priority);
        System.assertEquals('Working', result[0].Status);
    }

    @isTest
    static void testGetFilteredCases_withOnlyPriority() {
        Test.startTest();
        List<Case> result = CaseController.getFilteredCases('', 'Low', null);
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Should return 1 case with Low priority');
        System.assertEquals('Low', result[0].Priority);
    }

    @isTest
    static void testGetFilteredCases_withOnlyStatus() {
        Test.startTest();
        List<Case> result = CaseController.getFilteredCases('', null, 'New');
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Should return 1 case with status New');
        System.assertEquals('New', result[0].Status);
    }

    @isTest
    static void testUpdateCaseStatus() {
        List<Case> toUpdate = [SELECT Id, Status FROM Case WHERE Status = 'New' LIMIT 1];
        toUpdate[0].Status = 'Closed';

        Test.startTest();
        CaseController.updateCaseStatus(toUpdate);
        Test.stopTest();

        Case updated = [SELECT Status FROM Case WHERE Id = :toUpdate[0].Id];
        System.assertEquals('Closed', updated.Status);
    }
}
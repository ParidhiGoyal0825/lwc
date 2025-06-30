@isTest
public class CaseAssignmentServiceHandlerTest {

    @testSetup
    static void setupData() {
        // Create test agents
        List<Agent__c> agents = new List<Agent__c>();
        for (Integer i = 0; i < 3; i++) {
            agents.add(new Agent__c(Name = 'Agent ' + i, Workload__c = 5));
        }
        insert agents;

        // Create test cases (unassigned)
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 6; i++) {
            cases.add(new Case(Subject = 'Test Case ' + i));
        }
        insert cases;
    }

    @isTest
    static void testCaseAssignment() {
        // Get unassigned case IDs
        List<Case> unassignedCases = [SELECT Id FROM Case WHERE Agent__c = NULL];
        Set<Id> caseIds = new Set<Id>();
        for (Case c : unassignedCases) {
            caseIds.add(c.Id);
        }

        // Enqueue job
        Test.startTest();
        CaseAssignmentServiceHandler.assignCasesAsync(caseIds);
        Test.stopTest(); // Ensures async job runs

        // Verify that cases are assigned
        List<Case> updatedCases = [SELECT Id, Agent__c FROM Case WHERE Id IN :caseIds];
        for (Case c : updatedCases) {
            System.assertNotEquals(null, c.Agent__c, 'Case should be assigned to an agent');
        }
    }
}
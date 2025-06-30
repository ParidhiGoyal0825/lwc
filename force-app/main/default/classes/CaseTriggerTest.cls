@isTest
public class CaseTriggerTest {

    @testSetup
    static void setupData() {
        // Create 3 agents with a workload limit of 5 each
        List<Agent__c> agents = new List<Agent__c>();
        for (Integer i = 0; i < 3; i++) {
            agents.add(new Agent__c(Name = 'Agent ' + i, Workload__c = 5));
        }
        insert agents;
    }

    @isTest
    static void testTriggerAssignsCases() {
        // Insert 6 new unassigned cases - this should invoke the trigger
        List<Case> newCases = new List<Case>();
        for (Integer i = 0; i < 6; i++) {
            newCases.add(new Case(Subject = 'Trigger Test Case ' + i));
        }

        Test.startTest();
        insert newCases; // This should fire the trigger and enqueue the job
        Test.stopTest(); // This ensures the async job executes

        // Verify that all cases have been assigned an agent
        List<Case> assignedCases = [SELECT Id, Agent__c FROM Case WHERE Id IN :newCases];
        for (Case c : assignedCases) {
            System.assertNotEquals(null, c.Agent__c, 'Case should be assigned to an agent by the trigger logic.');
        }
    }
}
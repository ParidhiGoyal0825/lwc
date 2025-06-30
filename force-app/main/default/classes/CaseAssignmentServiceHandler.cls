public class CaseAssignmentServiceHandler {

    public static void assignCasesAsync(Set<Id> caseIds) {
        System.enqueueJob(new AssignCasesJob(caseIds));
    }

    public class AssignCasesJob implements Queueable {
        private Set<Id> caseIds;

        public AssignCasesJob(Set<Id> caseIds) {
            this.caseIds = caseIds;
        }

        public void execute(QueueableContext context) {
            List<Case> unassignedCases = [
                SELECT Id 
                FROM Case 
                WHERE Id IN :caseIds AND Agent__c = NULL
            ];

            List<Agent__c> agents = [
                SELECT Id, Workload__c 
                FROM Agent__c
            ];

            Map<Id, Integer> currentAssignments = new Map<Id, Integer>();
            for (AggregateResult ar : [
                SELECT Agent__c agentId, COUNT(Id) caseCount
                FROM Case
                WHERE Agent__c != NULL
                GROUP BY Agent__c
            ]) {
                currentAssignments.put((Id) ar.get('agentId'), (Integer) ar.get('caseCount'));
            }

            for (Case c : unassignedCases) {
                Agent__c selectedAgent = null;
                Integer minLoad = 100000; // move inside the loop!

                for (Agent__c agent : agents) {
                    Integer currentLoad = currentAssignments.get(agent.Id);
                    currentLoad = (currentLoad == null) ? 0 : currentLoad;

                    if (currentLoad < agent.Workload__c && currentLoad < minLoad) {
                        selectedAgent = agent;
                        minLoad = currentLoad;
                    }
                }

                if (selectedAgent != null) {
                    c.Agent__c = selectedAgent.Id;
                    currentAssignments.put(selectedAgent.Id, minLoad + 1);
                }
            }

            if (!unassignedCases.isEmpty()) {
                update unassignedCases;
            }
        }
    }
}
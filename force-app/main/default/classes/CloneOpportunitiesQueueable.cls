public class CloneOpportunitiesQueueable implements Queueable {
    private List<Id> opportunityIds;

    public CloneOpportunitiesQueueable(List<Id> opportunityIds) {
        this.opportunityIds = opportunityIds;
    }

    public void execute(QueueableContext context) {
        List<Opportunity> originalOpps = [SELECT Name, CloseDate, StageName, Amount FROM Opportunity WHERE Id IN :opportunityIds];
        List<Opportunity> clones = new List<Opportunity>();

        for (Opportunity opp : originalOpps) {
            Opportunity clone = opp.clone(false);
            clone.Name = opp.Name + ' (Clone)';
            clones.add(clone);
        }

        if (!clones.isEmpty()) {
            insert clones;
        }
    }
}
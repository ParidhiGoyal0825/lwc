public class SecondQueueable implements Queueable {
    private List<Id> accountIds;
    private String newDescription;

    public SecondQueueable(List<Id> accountIds, String newDescription) {
        this.accountIds = accountIds;
        this.newDescription = newDescription;
    }

    public void execute(QueueableContext context) {
        List<Account> accountsToUpdate = [SELECT Id, Description FROM Account WHERE Id IN :accountIds];
        for (Account acc : accountsToUpdate) {
            acc.Description = newDescription;
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
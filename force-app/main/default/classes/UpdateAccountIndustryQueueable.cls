public class UpdateAccountIndustryQueueable implements Queueable {
    private List<Id> accountIds;
    private String newIndustry;

    public UpdateAccountIndustryQueueable(List<Id> accountIds, String newIndustry) {
        this.accountIds = accountIds;
        this.newIndustry = newIndustry;
    }

    public void execute(QueueableContext context) {
        List<Account> accountsToUpdate = [SELECT Id, Industry FROM Account WHERE Id IN :accountIds];

        for (Account acc : accountsToUpdate) {
            acc.Industry = newIndustry;
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
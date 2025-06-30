public class FirstQueueable implements Queueable {
    private List<Id> accountIds;

    public FirstQueueable(List<Id> accountIds) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id, Industry FROM Account WHERE Id IN :accountIds];
        Map<Id, String> industryMap = new Map<Id, String>();
        for (Account acc : accounts) {
            industryMap.put(acc.Id, acc.Industry);
        }

        List<Contact> contactsToUpdate = [SELECT Id, AccountId, Title FROM Contact WHERE AccountId IN :accountIds];
        for (Contact con : contactsToUpdate) {
            String industry = industryMap.get(con.AccountId);
            con.Title = industry != null ? 'Expert in ' + industry : 'General Contact';
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}
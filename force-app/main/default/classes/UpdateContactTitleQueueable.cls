public class UpdateContactTitleQueueable implements Queueable {
    private List<Id> contactIds;
    private String newTitle;

    public UpdateContactTitleQueueable(List<Id> contactIds, String newTitle) {
        this.contactIds = contactIds;
        this.newTitle = newTitle;
    }

    public void execute(QueueableContext context) {
        List<Contact> contacts = [SELECT Id, Title FROM Contact WHERE Id IN :contactIds];
        for (Contact con : contacts) {
            con.Title = newTitle;
        }
        if (!contacts.isEmpty()) {
            update contacts;
        }
    }
}
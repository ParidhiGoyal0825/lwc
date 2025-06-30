public class ReconciliationDeletionScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        // Run the batch job with a scope size of 200
        Database.executeBatch(new ReconciliationDeletionBatch(), 200);
    }
}
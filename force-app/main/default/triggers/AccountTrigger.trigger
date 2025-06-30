trigger AccountTrigger on Account (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        // FetchingCsvData myBatchObject = new FetchingCsvData(Trigger.New);
        // Database.executeBatch(myBatchObject);
        AccountHandler.updating(Trigger.new);
    }
}
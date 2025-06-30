public class AsynchronousApexHandler implements Database.Batchable<SObject>, Database.Stateful {

    
    public Integer recordCount=0;
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator([SELECT Id, Name FROM Opportunity]);
        
    }
    public void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
       
        for (Opportunity opp : oppList) {
           opp.LeadSource='Web';  
        }
        
        update oppList;
        recordCount=recordCount+oppList.size();
        
    }

    
    public void finish(Database.BatchableContext BC) {
    System.debug(recordCount);
    
    }
}
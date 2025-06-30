public class ContactHandler {
   public static void updateAmount(List<Contact> newContacts,Map<Id, Contact> oldMap) {
        Set<Id> conId= new Set<Id>();
       for(Contact con: newContacts){
           conId.add(con.Id);
       }
      List<OpportunityContactRole> contactRoles=[Select Id,ContactId, OpportunityId from OpportunityContactRole where ContactId IN :conId];
        Set<Id> oppId= new Set<Id>();
       for(OpportunityContactRole conR: contactRoles){
           oppId.add(conR.OpportunityId);
       }
            AggregateResult[] result=[Select AccountId, Sum(Amount) totalSum from Opportunity where Id IN :oppId Group By AccountId];
            List<Account> accList= new List<Account>();
       for(AggregateResult r: result){
           Id accountId= (Id)r.get('AccountId');
           Decimal total= (Decimal)r.get('totalSum');
           Account acc=new Account(Id= accountId, Total_Opportunity_Amount__c= total);
           accList.add(acc);
       }
       update accList;
    }
}
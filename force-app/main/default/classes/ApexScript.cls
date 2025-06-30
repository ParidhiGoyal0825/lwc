public class ApexScript {
    public static void getContacts() {
        // Assuming these contacts already exist in your org
        List<Account> accList=[Select Id, Name,(Select Id, Name from Contacts) from Account limit 5];
        Map<Id,List<Contact>> accMap= new Map<Id,List<Contact>>();
        for(Account acc: accList){
            if(!accMap.containsKey(acc.Id)){
                accMap.put(acc.Id, new List<Contact>());
            }
            accMap.get(acc.Id).addAll(acc.Contacts);
        }
        for(Id accId: accMap.KeySet()){
            System.debug(accId + ' ' + accMap.get(accId));
        }
    }
}
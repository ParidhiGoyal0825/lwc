public with sharing class AccountforLwc {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        List<Account> accList = new List<Account>([SELECT Id, Name, Industry, Website, Phone FROM Account]);
        if(!accList.isEmpty())
        {
            return accList;
        }
        return null;
    }

  @AuraEnabled
public static String updatedAccountDetails(List<Account> accData) {
    try {
        update accData;
        return 'Records updated successfully';
    } catch (DmlException e) {
        // Wrap DML errors into a user-friendly message
        throw new AuraHandledException('Error updating records: ' + e.getMessage());
    } catch (Exception e) {
        // Catch all other exceptions
        throw new AuraHandledException('Unexpected error: ' + e.getMessage());
    }
}

    @AuraEnabled
public static void deleteOperationList(List<Id> accIds) {
    try {
        List<Account> delAccList = [SELECT Id FROM Account WHERE Id IN :accIds];
        if (!delAccList.isEmpty()) {
            delete delAccList;
        }
    } catch (DmlException e) {
        // Wrap DML errors into a user-friendly message
        throw new AuraHandledException('Error deleting records: ' + e.getMessage());
    } catch (Exception e) {
        // Catch all other exceptions
        throw new AuraHandledException('Unexpected error: ' + e.getMessage());
    }
}
        @AuraEnabled
        public static List<Contact> getContact(Id accId) {
            return([Select Name, Email, AccountId from Contact where AccountId =:accId]);
    }
}
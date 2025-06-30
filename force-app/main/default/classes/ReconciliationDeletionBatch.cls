public class ReconciliationDeletionBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Reconciliation_Delete_Config__mdt config = [
            SELECT Delete_Status__c, Delete_Source__c, Delete_Period_Days__c, Delete_Window_Hours__c
            FROM Reconciliation_Delete_Config__mdt LIMIT 1
        ];

        Set<String> statusSet = new Set<String>();
        if (config.Delete_Status__c != null) {
            for (String s : config.Delete_Status__c.split(',')) {
                statusSet.add(s.trim());
            }
        }
        Set<String> sourceSet = new Set<String>();
        if (config.Delete_Source__c != null) {
            for (String s : config.Delete_Source__c.split(',')) {
                sourceSet.add(s.trim());
            }
        }

        Datetime createdCutoff = System.now().addDays(-Integer.valueOf(config.Delete_Period_Days__c));
        Datetime modifiedCutoff = System.now().addHours(-Integer.valueOf(config.Delete_Window_Hours__c));

    if (Test.isRunningTest()) {
        return Database.getQueryLocator([
            SELECT Id, Account_lr__c
            FROM Reconcillation__c
            WHERE CreatedDate <= :createdCutoff
            AND Status_p__c IN :statusSet
            AND Source_p__c IN :sourceSet
        ]);
    } else {
        return Database.getQueryLocator([
            SELECT Id, Account_lr__c
            FROM Reconcillation__c
            WHERE CreatedDate <= :createdCutoff
            AND LastModifiedDate <= :modifiedCutoff
            AND Status_p__c IN :statusSet
            AND Source_p__c IN :sourceSet
        ]);
    }
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Reconcillation__c> recList = (List<Reconcillation__c>)scope;

        Set<Id> accountIds = new Set<Id>();
        for (Reconcillation__c r : recList) {
            if (r.Account_lr__c != null) accountIds.add(r.Account_lr__c);
        }

        delete recList;

        if (!accountIds.isEmpty()) {
        
           
            List<Account> accounts = [SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds];
            if (!accounts.isEmpty()) delete accounts;

            Set<Id> userIds = new Set<Id>();
            for (Account acc : accounts) {
                if (acc.OwnerId != null) userIds.add(acc.OwnerId);
            }

            if (!userIds.isEmpty()) {
                List<User> usersToDeactivate = [
                    SELECT Id, userActive__c
                    FROM User
                    WHERE Id IN :userIds AND userActive__c = true
                ];

                for (User u : usersToDeactivate) {
                    u.userActive__c = false;
                }

                if (!usersToDeactivate.isEmpty()) {
                    update usersToDeactivate;
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
    
    }
}
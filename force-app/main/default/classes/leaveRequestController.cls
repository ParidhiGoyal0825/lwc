public with sharing class leaveRequestController {
    @AuraEnabled(cacheable=true)
    public static List<Leave_Request__c> getPendingRequestsForManager() {
    return [SELECT Id, Employee__r.Name, Leave_Type__c, From_Date__c, To_Date__c, Reason__c, Status__c
            FROM Leave_Request__c
            WHERE Status__c = 'Pending'];
}

    @AuraEnabled
    public static void updateLeaveStatus(Id leaveId, String newStatus) {
        Leave_Request__c leave = [SELECT Id FROM Leave_Request__c WHERE Id = :leaveId LIMIT 1];
        leave.Status__c = newStatus;
        if (newStatus == 'Approved' || newStatus == 'Rejected') {
            leave.Approved_By__c = UserInfo.getUserId();
            leave.Approved_On__c = System.now();
        }
        update leave;
    }
}
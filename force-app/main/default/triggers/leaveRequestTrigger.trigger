trigger leaveRequestTrigger on Leave_Request__c (before insert) {
    for (Leave_Request__c leave : Trigger.new) {
        leave.Status__c = 'Pending';
    }
}
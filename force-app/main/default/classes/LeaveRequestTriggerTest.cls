@isTest
public class LeaveRequestTriggerTest {
    @isTest
    static void testLeaveRequestTriggerSetsPendingStatus() {
        // Create a Leave Request record with required fields
        Leave_Request__c leaveRequest = new Leave_Request__c(
            Leave_Type__c = 'Sick',
            From_Date__c = Date.today(),
            To_Date__c = Date.today().addDays(3),
            Reason__c = 'Family trip'
            // Do not set Status__c, as the trigger should do it
        );

        // Insert the record (this will invoke the before insert trigger)
        insert leaveRequest;

        // Retrieve the inserted record to verify trigger behavior
        Leave_Request__c result = [
            SELECT Status__c FROM Leave_Request__c WHERE Id = :leaveRequest.Id
        ];

        // Assert that the trigger correctly set the status to 'Pending'
        System.assertEquals('Pending', result.Status__c, 'Trigger should set Status__c to Pending');
    }
}
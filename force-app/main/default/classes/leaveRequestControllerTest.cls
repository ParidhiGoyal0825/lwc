@isTest
public class leaveRequestControllerTest {

    @testSetup
    static void setupTestData() {
      
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User testUser = new User(
            Alias = 'tuser',
            Email='testuser@example.com',
            EmailEncodingKey='UTF-8',
            LastName='Test',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/New_York',
            Username='testuser' + DateTime.now().getTime() + '@example.com'
        );
        insert testUser;

        
        Leave_Request__c leaveRequest1 = new Leave_Request__c(
            Employee__c = testUser.Id,
            Leave_Type__c = 'Sick',
            From_Date__c = Date.today(),
            To_Date__c = Date.today().addDays(2),
            Reason__c = 'Flu',
            Status__c = 'Pending'
        );

        Leave_Request__c leaveRequest2 = new Leave_Request__c(
            Employee__c = testUser.Id,
            Leave_Type__c = 'Sick',
            From_Date__c = Date.today().addDays(3),
            To_Date__c = Date.today().addDays(5),
            Reason__c = 'Holiday',
            Status__c = 'Pending'
        );

        insert new List<Leave_Request__c>{ leaveRequest1, leaveRequest2 };
    }

    @isTest
    public static void testGetPendingRequestsForManager() {
        Test.startTest();
        List<Leave_Request__c> pendingRequests = leaveRequestController.getPendingRequestsForManager();
        Test.stopTest();

        System.assert(pendingRequests.size() > 0, 'There should be pending leave requests.');
        for (Leave_Request__c req : pendingRequests) {
            System.assertEquals('Pending', req.Status__c, 'Leave request should have Pending status.');
        }
    }

    @isTest
public static void testUpdateLeaveStatus() {
    
    Leave_Request__c request = [
        SELECT Id, Status__c, Approved_By__c, Approved_On__c 
        FROM Leave_Request__c 
        LIMIT 1
    ];

    Test.startTest();
    leaveRequestController.updateLeaveStatus(request.Id, 'Approved');
    Test.stopTest();

   
    Leave_Request__c updatedRequest = [
        SELECT Status__c, Approved_By__c, Approved_On__c 
        FROM Leave_Request__c 
        WHERE Id = :request.Id
    ];

   
    System.assertEquals('Approved', updatedRequest.Status__c, 'Status should be Approved.');
    System.assert(updatedRequest.Approved_By__c != null, 'Approved_By__c should be populated.');
    System.assert(updatedRequest.Approved_On__c != null, 'Approved_On__c should be populated.');
}
}
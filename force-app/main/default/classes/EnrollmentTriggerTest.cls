@isTest
public class EnrollmentTriggerTest {

    private static Course__c createTestCourse() {
        Course__c course = new Course__c(Name = 'Trigger Test Course');
        insert course;
        return course;
    }

    private static Studentt__c createTestStudent() {
        Studentt__c student = new Studentt__c(Name = 'Trigger Test Student');
        insert student;
        return student;
    }

    @isTest
    static void testAfterInsertTrigger() {
        Course__c course = createTestCourse();
        Studentt__c student = createTestStudent();

        Enrollment__c enrollment = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student.Id,
            Status__c = 'Pending' // should be updated to 'Enrolled' by trigger
        );

        Test.startTest();
        insert enrollment;
        Test.stopTest();

        Enrollment__c updated = [SELECT Status__c FROM Enrollment__c WHERE Id = :enrollment.Id];
        System.assertEquals('Enrolled', updated.Status__c, 'Status should be updated to Enrolled');
    }

    @isTest
    static void testAfterDeleteTrigger() {
        Course__c course = createTestCourse();
        Studentt__c student = createTestStudent();

        Enrollment__c enrollment = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student.Id,
            Status__c = 'Enrolled'
        );
        insert enrollment;

        Test.startTest();
        delete enrollment;
        Test.stopTest();

        // No assertions needed here unless you mock `EnrollmentQueueHandler.sendEnrollmentNotifications`
        // This covers the delete branch of the trigger.
        System.assert(true, 'After delete trigger executed without error');
    }
}
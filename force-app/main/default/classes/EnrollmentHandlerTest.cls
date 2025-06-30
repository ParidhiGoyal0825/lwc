@isTest
public class EnrollmentHandlerTest {

    private static Course__c createTestCourse() {
        Course__c course = new Course__c(Name = 'Test Course');
        insert course;
        return course;
    }

    private static Studentt__c createTestStudent() {
        Studentt__c student = new Studentt__c(Name = 'Test Student');
        insert student;
        return student;
    }

    @isTest
    public static void testProcessEnrollments() {
        Course__c course = createTestCourse();
        Studentt__c student = createTestStudent();

        Enrollment__c newEnrollment = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student.Id,
            Status__c = 'Pending'
        );
        insert newEnrollment;

        Enrollment__c oldEnrollment = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student.Id,
            Status__c = 'Enrolled'
        );
        insert oldEnrollment;

        Test.startTest();
        List<Enrollment__c> newList = [SELECT Id, Status__c, Course__c, Studentt__c FROM Enrollment__c WHERE Id = :newEnrollment.Id];
        List<Enrollment__c> oldList = [SELECT Id, Status__c, Course__c, Studentt__c FROM Enrollment__c WHERE Id = :oldEnrollment.Id];
        EnrollmentHandler.processEnrollments(newList, oldList);
        Test.stopTest();

        Enrollment__c updated = [SELECT Status__c FROM Enrollment__c WHERE Id = :newEnrollment.Id];
        System.assertEquals('Enrolled', updated.Status__c);
    }
}
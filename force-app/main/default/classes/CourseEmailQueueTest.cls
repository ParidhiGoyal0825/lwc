@isTest
public class CourseEmailQueueTest {
    @isTest
    static void testCourseEmailQueue() {
        // Create Instructor
        Instructor__c instructor = new Instructor__c(
            Name = 'John Smith',
            Email__c = 'instructor@example.com'
        );
        insert instructor;

        // Create Students
        Studentt__c student1 = new Studentt__c(
            Name = 'Alice Johnson',
            Email__c = 'alice@example.com'
        );
        Studentt__c student2 = new Studentt__c(
            Name = 'Bob Brown',
            Email__c = 'bob@example.com'
        );
        insert new List<Studentt__c>{ student1, student2 };

        // Create Course
        Course__c course = new Course__c(
            Name = 'Math 101',
            Start_Date__c = Date.today().addDays(7),
            End_Date__c = Date.today().addDays(30),
            Instructor__c = instructor.Id
        );
        insert course;

        // Create Enrollments
        Enrollment__c enrollment1 = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student1.Id
        );
        Enrollment__c enrollment2 = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student2.Id
        );
        insert new List<Enrollment__c>{ enrollment1, enrollment2 };

        Test.startTest();
        Set<Id> courseIds = new Set<Id>{ course.Id };
        System.enqueueJob(new CourseEmailQueue(courseIds));
        Test.stopTest();

        // Basic assertions
        Course__c insertedCourse = [SELECT Name FROM Course__c WHERE Id = :course.Id];
        System.assertEquals('Math 101', insertedCourse.Name);

        // Optionally verify that some email activity occurred
        System.assert(Limits.getEmailInvocations() > 0, 'Emails should have been sent.');
    }
}
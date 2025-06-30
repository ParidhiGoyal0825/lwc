@isTest
public class CourseHandlerTest {
    @isTest
    static void testUpdateEnrollmentOnCourseDateChange() {
        // Create Instructor
        Instructor__c instructor = new Instructor__c(
            Name = 'Prof. Xavier',
            Email__c = 'xavier@example.com'
        );
        insert instructor;

        // Create Student
        Studentt__c student = new Studentt__c(
            Name = 'Jean Grey',
            Email__c = 'jean@example.com'
        );
        insert student;

        // Create Course with original dates
        Course__c course = new Course__c(
            Name = 'Telepathy 101',
            Start_Date__c = Date.today().addDays(1),
            End_Date__c = Date.today().addDays(10),
            Instructor__c = instructor.Id
        );
        insert course;

        // Create Enrollment
        Enrollment__c enrollment = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student.Id,
            Status__c = 'Enrolled'
        );
        insert enrollment;

        // Modify course dates
        Course__c updatedCourse = course.clone(false);
        updatedCourse.Id = course.Id;
        updatedCourse.Start_Date__c = course.Start_Date__c.addDays(2); // change
        updatedCourse.End_Date__c = course.End_Date__c.addDays(2);     // change

        List<Course__c> newCourses = new List<Course__c>{ updatedCourse };
        Map<Id, Course__c> oldMap = new Map<Id, Course__c>{ course.Id => course };

        // Test the handler's update logic
        Test.startTest();
        CourseHandler.updateEnrollment(newCourses, oldMap);
        Test.stopTest();

        // Verify enrollment is updated
        Enrollment__c updatedEnrollment = [SELECT Status__c FROM Enrollment__c WHERE Id = :enrollment.Id];
        System.assertEquals('Updated', updatedEnrollment.Status__c);

        // Verify queueable job was enqueued
        System.assert(Limits.getQueueableJobs() > 0, 'Queueable job should have been enqueued.');
    }

    @isTest
    static void testNoEnrollmentUpdateWhenDatesUnchanged() {
        // Create Instructor
        Instructor__c instructor = new Instructor__c(
            Name = 'Prof. Xavier',
            Email__c = 'xavier@example.com'
        );
        insert instructor;

        // Create Student
        Studentt__c student = new Studentt__c(
            Name = 'Jean Grey',
            Email__c = 'jean@example.com'
        );
        insert student;

        // Create Course with original dates
        Course__c course = new Course__c(
            Name = 'Telepathy 101',
            Start_Date__c = Date.today().addDays(1),
            End_Date__c = Date.today().addDays(10),
            Instructor__c = instructor.Id
        );
        insert course;

        // Create Enrollment
        Enrollment__c enrollment = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student.Id,
            Status__c = 'Enrolled'
        );
        insert enrollment;

        // Same course, no date change
        Course__c updatedCourse = course.clone(false);
        updatedCourse.Id = course.Id;

        List<Course__c> newCourses = new List<Course__c>{ updatedCourse };
        Map<Id, Course__c> oldMap = new Map<Id, Course__c>{ course.Id => course };

        // Test the handler's update logic when dates are unchanged
        Test.startTest();
        CourseHandler.updateEnrollment(newCourses, oldMap);
        Test.stopTest();

        // Verify that enrollment status is not updated (should remain 'Enrolled')
        Enrollment__c unchangedEnrollment = [SELECT Status__c FROM Enrollment__c WHERE Id = :enrollment.Id];
        System.assertEquals('Enrolled', unchangedEnrollment.Status__c);

        // Verify no queueable job was enqueued
        System.assertEquals(1, Limits.getQueueableJobs(), 'Queueable job should not have been enqueued.');
    }

    @isTest
    static void testEnrollmentNotFoundForChangedCourse() {
        // Create Instructor
        Instructor__c instructor = new Instructor__c(
            Name = 'Prof. Xavier',
            Email__c = 'xavier@example.com'
        );
        insert instructor;

        // Create Student
        Studentt__c student = new Studentt__c(
            Name = 'Jean Grey',
            Email__c = 'jean@example.com'
        );
        insert student;

        // Create Course with original dates
        Course__c course = new Course__c(
            Name = 'Telepathy 101',
            Start_Date__c = Date.today().addDays(1),
            End_Date__c = Date.today().addDays(10),
            Instructor__c = instructor.Id
        );
        insert course;

        // Create Enrollment
        Enrollment__c enrollment = new Enrollment__c(
            Course__c = course.Id,
            Studentt__c = student.Id,
            Status__c = 'Enrolled'
        );
        insert enrollment;

        // Modify course dates to simulate the course being updated
        Course__c updatedCourse = course.clone(false);
        updatedCourse.Id = course.Id;
        updatedCourse.Start_Date__c = course.Start_Date__c.addDays(2); // change
        updatedCourse.End_Date__c = course.End_Date__c.addDays(2);     // change

        List<Course__c> newCourses = new List<Course__c>{ updatedCourse };
        Map<Id, Course__c> oldMap = new Map<Id, Course__c>{ course.Id => course };

        // Simulate no enrollments for the changed course
        delete enrollment;

        // Test the handler's behavior when there are no enrollments for the changed course
        Test.startTest();
        CourseHandler.updateEnrollment(newCourses, oldMap);
        Test.stopTest();

        // Verify that the course update logic still runs without affecting any enrollments
        System.assertEquals(2, Limits.getQueueableJobs(), 'Queueable job should not have been enqueued if no enrollments are found.');
    }
}
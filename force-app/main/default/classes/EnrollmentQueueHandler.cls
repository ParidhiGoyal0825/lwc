public class EnrollmentQueueHandler implements Queueable, Database.AllowsCallouts {
    private List<Enrollment__c> enrollments;
    private String actionType; // 'ENROLLED' or 'UNENROLLED'

    public EnrollmentQueueHandler(List<Enrollment__c> enrollmentsToNotify, String actionType) {
        this.enrollments = enrollmentsToNotify;
        this.actionType = actionType;
    }

    public void execute(QueueableContext context) {
        Set<Id> studentIds = new Set<Id>();
        Set<Id> courseIds = new Set<Id>();

        for (Enrollment__c e : enrollments) {
            if (e.Studentt__c != null) studentIds.add(e.Studentt__c);
            if (e.Course__c != null) courseIds.add(e.Course__c);
        }

        Map<Id, Studentt__c> studentMap = new Map<Id, Studentt__c>(
            [SELECT Id, Name, Email__c FROM Studentt__c WHERE Id IN :studentIds]
        );

        Map<Id, Course__c> courseMap = new Map<Id, Course__c>(
            [SELECT Id, Name, Instructor__r.Name, Instructor__r.Email__c
             FROM Course__c WHERE Id IN :courseIds]
        );

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Map<Id, List<String>> instructorToStudents = new Map<Id, List<String>>();

        for (Enrollment__c e : enrollments) {
            Studentt__c student = studentMap.get(e.Studentt__c);
            Course__c course = courseMap.get(e.Course__c);

            if (student != null && student.Email__c != null && course != null) {
                String subject = (actionType == 'ENROLLED') ? 'You are Enrolled: ' : 'You are Unenrolled: ';
                String body = 'Hi ' + student.Name + ',\n\nYou have been ' +
                              ((actionType == 'ENROLLED') ? 'enrolled in ' : 'unenrolled from ') +
                              'the course "' + course.Name;

                Messaging.SingleEmailMessage studentEmail = new Messaging.SingleEmailMessage();
                studentEmail.setToAddresses(new List<String>{ student.Email__c });
                studentEmail.setSubject(subject + course.Name);
                studentEmail.setPlainTextBody(body);
                emails.add(studentEmail);
            }

            if (course != null && course.Instructor__r != null && course.Instructor__r.Email__c != null) {
                if (!instructorToStudents.containsKey(course.Id)) {
                    instructorToStudents.put(course.Id, new List<String>());
                }
                if (student != null) {
                    instructorToStudents.get(course.Id).add(student.Name);
                }
            }
        }

        // Instructor emails
        for (Id courseId : instructorToStudents.keySet()) {
            Course__c course = courseMap.get(courseId);
            List<String> studentNames = instructorToStudents.get(courseId);

            String actionText = (actionType == 'ENROLLED') ? 'enrolled in' : 'unenrolled from';

            String body = 'Hello ' + course.Instructor__r.Name + ',\n\nThe following student(s) have been ' +
                          actionText + ' your course "' + course.Name ;

            Messaging.SingleEmailMessage instructorEmail = new Messaging.SingleEmailMessage();
            instructorEmail.setToAddresses(new List<String>{ course.Instructor__r.Email__c });
            instructorEmail.setSubject('Enrollment Update: ' + course.Name);
            instructorEmail.setPlainTextBody(body);
            emails.add(instructorEmail);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    public static void sendEnrollmentNotifications(List<Enrollment__c> enrollments, String actionType) {
        System.enqueueJob(new EnrollmentQueueHandler(enrollments, actionType));
    }
}
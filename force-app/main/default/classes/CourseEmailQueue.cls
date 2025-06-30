public class CourseEmailQueue implements Queueable {

    private Set<Id> courseIds;

    public CourseEmailQueue(Set<Id> courseIds) {
        this.courseIds = courseIds;
    }

    public void execute(QueueableContext context) {
        // Step 1: Get Courses with Instructor
        List<Course__c> courses = [
            SELECT Id, Name, Start_Date__c, End_Date__c,
                   Instructor__r.Email__c, Instructor__r.Name
            FROM Course__c
            WHERE Id IN :courseIds
        ];

        Map<Id, Course__c> courseMap = new Map<Id, Course__c>();
        for (Course__c c : courses) {
            courseMap.put(c.Id, c);
        }

        // Step 2: Get Enrolled Students via Enrollment__c
        List<Enrollment__c> enrollments = [
            SELECT Course__c, Studentt__r.Email__c, Studentt__r.Name
            FROM Enrollment__c
            WHERE Course__c IN :courseIds
        ];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        // Step 3: Send email to Students
        for (Enrollment__c e : enrollments) {
            Course__c c = courseMap.get(e.Course__c);
            String studentEmail = e.Studentt__r.Email__c;

            if (studentEmail != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { studentEmail });
                mail.setSubject('Schedule Updated: ' + c.Name);
                mail.setPlainTextBody(
                    'Dear ' + e.Studentt__r.Name + ',\n\n' +
                    'The schedule for the course "' + c.Name + '" has been updated.\n' +
                    'Start Date: ' + String.valueOf(c.Start_Date__c) + '\n' +
                    'End Date: ' + String.valueOf(c.End_Date__c) + '\n\n' +
                    'Please check the updated details in your student portal.\n\nThank you.'
                );
                emails.add(mail);
            }
        }

        // Step 4: Send email to Instructor
        for (Course__c c : courses) {
            if (c.Instructor__r.Email__c != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { c.Instructor__r.Email__c });
                mail.setSubject('Course Schedule Changed: ' + c.Name);
                mail.setPlainTextBody(
                    'Dear ' + c.Instructor__r.Name + ',\n\n' +
                    'The schedule for your course "' + c.Name + '" has been updated.\n' +
                    'New Start Date: ' + String.valueOf(c.Start_Date__c) + '\n' +
                    'New End Date: ' + String.valueOf(c.End_Date__c) + '\n\n' +
                    'Please log in to review the changes.\n\nBest regards.'
                );
                emails.add(mail);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}
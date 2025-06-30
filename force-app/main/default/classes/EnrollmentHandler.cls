public class EnrollmentHandler {
    public static void processEnrollments(List<Enrollment__c> newEnrollments, List<Enrollment__c> oldEnrollments) {
        List<Enrollment__c> enrollmentsToUpdate = new List<Enrollment__c>();

        if (newEnrollments != null) {
            for (Enrollment__c e : newEnrollments) {
                if (e.Status__c != 'Enrolled') {
                    enrollmentsToUpdate.add(new Enrollment__c(
                        Id = e.Id,
                        Status__c = 'Enrolled'
                    ));
                }
            }
//send email if student is enrolled
            if (!newEnrollments.isEmpty()) {
                EnrollmentQueueHandler.sendEnrollmentNotifications(newEnrollments, 'ENROLLED');
            }
        }
//send email if student is removed
        if (oldEnrollments != null && !oldEnrollments.isEmpty()) {
            EnrollmentQueueHandler.sendEnrollmentNotifications(oldEnrollments, 'UNENROLLED');
        }
//update status if enrolled
        if (!enrollmentsToUpdate.isEmpty()) {
            update enrollmentsToUpdate;
        }
    }
}
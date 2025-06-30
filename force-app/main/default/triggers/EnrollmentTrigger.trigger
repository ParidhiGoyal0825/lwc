trigger EnrollmentTrigger on Enrollment__c (after insert,after delete) {
    if(Trigger.isInsert && Trigger.isAfter){
    EnrollmentHandler.processEnrollments(Trigger.new,NULL);
        }
    if(Trigger.isDelete && Trigger.isAfter){
        EnrollmentHandler.processEnrollments(NULL,Trigger.old);
}

}
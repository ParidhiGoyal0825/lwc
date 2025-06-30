trigger CourseTrigger on Course__c (after update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            CourseHandler.updateEnrollment(Trigger.New, Trigger.oldMap);
        }
    }
}
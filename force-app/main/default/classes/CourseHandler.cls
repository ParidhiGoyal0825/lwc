public class CourseHandler {
    public static void updateEnrollment(List<Course__c> newCourses, Map<Id, Course__c> oldCourseMap){
         Set<Id> changedCourseIds = new Set<Id>();
         // add changecourseId
        
        for (Course__c newCourse : newCourses) {
            Course__c oldCourse = oldCourseMap.get(newCourse.Id);

            if (newCourse.Start_Date__c != oldCourse.Start_Date__c ||
                newCourse.End_Date__c != oldCourse.End_Date__c) {
                changedCourseIds.add(newCourse.Id);
            }
        }

        if (changedCourseIds.isEmpty()) {
            return; 
        }

        
        List<Enrollment__c> enrollmentsToUpdate = [
            SELECT Id, Course__c, Status__c
            FROM Enrollment__c
            WHERE Course__c IN :changedCourseIds
        ];

       
        for (Enrollment__c e : enrollmentsToUpdate) {
            e.Status__c = 'Updated';
        }

        if (!enrollmentsToUpdate.isEmpty()) {
            update enrollmentsToUpdate;
        }
         System.enqueueJob(new CourseEmailQueue(changedCourseIds));
    }
    }
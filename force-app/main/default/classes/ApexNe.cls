public class ApexNe {
   //Ques 8(5)
  /* public static void updateCompletion(List<Task__c> taskList) {
    Set<Id> subIds = new Set<Id>();
    Set<Id> projectIds = new Set<Id>();

    // Collect parent task IDs and project IDs
    for (Task__c t : taskList) {
        if (t.Task__c != null) {
            subIds.add(t.Task__c);
        }
        if (t.Project__c != null) {
            projectIds.add(t.Project__c);
        }
    }

        Map<Id, List<Task__c>> parentMap = new Map<Id, List<Task__c>>();
    if (!subIds.isEmpty()) {
        for (Task__c sub : [
            SELECT Completion_Percentage__c, Task__c 
            FROM Task__c 
            WHERE Task__c IN :subIds
        ]) {
            if (!parentMap.containsKey(sub.Task__c)) {
                parentMap.put(sub.Task__c, new List<Task__c>());
            }
            parentMap.get(sub.Task__c).add(sub);
        }
    }

 
    List<Task__c> parentUpdate = new List<Task__c>();
    for (Id parentId : parentMap.keySet()) {
        List<Task__c> subTasks = parentMap.get(parentId);
        Decimal total = 0;
        
        for (Task__c sub : subTasks) {
            total += sub.Completion_Percentage__c;
        }

        Decimal avgCompletion = subTasks.size() > 0 ? total / subTasks.size() : 0;
        parentUpdate.add(new Task__c(Id = parentId, Completion_Percentage__c = avgCompletion));
    }

    if (!parentUpdate.isEmpty()) {
        update parentUpdate;
    }

    // Bulk query for all tasks related to projects
    Map<Id, List<Task__c>> projectMap = new Map<Id, List<Task__c>>();
    if (!projectIds.isEmpty()) {
        for (Task__c task : [
            SELECT Completion_Percentage__c, Project__c 
            FROM Task__c 
            WHERE Project__c IN :projectIds
        ]) {
            if (!projectMap.containsKey(task.Project__c)) {
                projectMap.put(task.Project__c, new List<Task__c>());
            }
            projectMap.get(task.Project__c).add(task);
        }
    }

    // Prepare projects to update
    List<Project__c> projectsUpdate = new List<Project__c>();
    for (Id projectId : projectMap.keySet()) {
        List<Task__c> projectTasks = projectMap.get(projectId);
        Decimal total = 0;

        for (Task__c task : projectTasks) {
            total += task.Completion_Percentage__c;
        }

        Decimal avgCompletion = projectTasks.size() > 0 ? total / projectTasks.size() : 0;
        projectsUpdate.add(new Project__c(Id = projectId, Completion_Percentage__c = avgCompletion));
    }

    if (!projectsUpdate.isEmpty()) {
        update projectsUpdate;
    }
}*/
}
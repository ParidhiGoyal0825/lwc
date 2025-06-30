public with sharing class CaseController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getFilteredCases(String searchKey, String priorityFilter, String statusFilter) {
        String baseQuery = 'SELECT Id, CaseNumber, Subject, Status, Priority, CreatedDate FROM Case WHERE IsClosed = false';
        
        if(searchKey!=''&& searchKey!=null){
            string key = '%'+searchKey+'%';
            return [SELECT Id, CaseNumber, Subject, Description, Status, Priority, CreatedDate 
            FROM Case 
            WHERE isClosed=false AND Subject LIKE :key 
            WITH SECURITY_ENFORCED];
        }
        
        if (String.isNotBlank(priorityFilter)) {
            baseQuery += ' AND Priority = :priorityFilter';
        }
        
        if (String.isNotBlank(statusFilter)) {
            baseQuery += ' AND Status = :statusFilter';
        }
        
        baseQuery += ' ORDER BY CreatedDate DESC';
        
        return Database.query(baseQuery);
    }
    @AuraEnabled
public static void updateCaseStatus(List<Case> updatedCases) {
    update updatedCases;
}
}
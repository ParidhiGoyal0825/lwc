public with sharing class CaseTask {

    public class CaseNode {
        @AuraEnabled public Id Id;
        @AuraEnabled public String CaseNumber;
        @AuraEnabled public String ContactName;
        @AuraEnabled public String Subject;
        @AuraEnabled public String Status;
        @AuraEnabled public String Priority;
        @AuraEnabled public DateTime CreatedDate;
        @AuraEnabled public String OwnerAlias;
        @AuraEnabled public Id ParentId;
    }

    @AuraEnabled(cacheable=true)
    public static List<CaseNode> getImmediateChildCases(Id parentCaseId) {
        List<CaseNode> result = new List<CaseNode>();

        for (Case c : [
            SELECT Id, CaseNumber, Contact.Name, Subject, Status, Priority, CreatedDate, Owner.Alias, ParentId
            FROM Case
            WHERE ParentId = :parentCaseId
            ORDER BY CreatedDate ASC
        ]) {
            CaseNode node = new CaseNode();
            node.Id = c.Id;
            node.CaseNumber = c.CaseNumber;
            node.ContactName = c.Contact != null ? c.Contact.Name : '';
            node.Subject = c.Subject;
            node.Status = c.Status;
            node.Priority = c.Priority;
            node.CreatedDate = c.CreatedDate;
            node.OwnerAlias = c.Owner != null ? c.Owner.Alias : '';
            node.ParentId = c.ParentId;

            result.add(node);
        }

        return result;
    }

    @AuraEnabled
    public static CaseNode getCaseById(Id caseId) {
        Case c = [
            SELECT Id, CaseNumber, Contact.Name, Subject, Status, Priority, CreatedDate, Owner.Alias, ParentId
            FROM Case
            WHERE Id = :caseId
            LIMIT 1
        ];

        CaseNode node = new CaseNode();
        node.Id = c.Id;
        node.CaseNumber = c.CaseNumber;
        node.ContactName = c.Contact != null ? c.Contact.Name : '';
        node.Subject = c.Subject;
        node.Status = c.Status;
        node.Priority = c.Priority;
        node.CreatedDate = c.CreatedDate;
        node.OwnerAlias = c.Owner != null ? c.Owner.Alias : '';
        node.ParentId = c.ParentId;

        return node;
    }

    @AuraEnabled
    public static void deleteCaseById(Id caseId) {
        try {
            delete [SELECT Id FROM Case WHERE Id = :caseId];
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting case: ' + e.getMessage());
        }
    }
   
}
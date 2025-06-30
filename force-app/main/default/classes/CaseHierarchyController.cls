public with sharing class CaseHierarchyController {
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
        @AuraEnabled public Boolean hasChildren;
    }

    @AuraEnabled(cacheable=true)
    public static List<CaseNode> getImmediateChildCases(Id parentCaseId) {
        Map<Id, Integer> childMap = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT ParentId pid, COUNT(Id) cnt FROM Case WHERE ParentId != null GROUP BY ParentId
        ]) {
            childMap.put((Id)ar.get('pid'), (Integer)ar.get('cnt'));
        }

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
            node.hasChildren = childMap.containsKey(c.Id);
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
        node.hasChildren = false;
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

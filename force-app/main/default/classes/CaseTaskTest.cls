@isTest
public class CaseTaskTest {
@isTest
    static void testGetImmediateChildCases_withHierarchy() {
        Case rootCase = new Case(
            Subject = 'Root Case',
            Origin = 'Phone',
            Status = 'New'
        );
        insert rootCase;

        
        Case child1 = new Case(
            Subject = 'Child Case 1',
            Origin = 'Web',
            Status = 'New',
            ParentId = rootCase.Id
        );
        insert child1;

        Case grandChild = new Case(
            Subject = 'Grandchild Case',
            Origin = 'Email',
            Status = 'New',
            ParentId = child1.Id
        );
        insert grandChild;

        Test.startTest();

        List<Case> childrenOfRoot = CaseTask.getImmediateChildCases(rootCase.Id);
        System.assert(childrenOfRoot.size() == 1);
        System.assert(childrenOfRoot[0].Id == child1.Id);

        
        List<Case> childrenOfChild1 = CaseTask.getImmediateChildCases(child1.Id);
        System.assert(childrenOfChild1.size() == 1);
        System.assert(childrenOfChild1[0].Id == grandChild.Id);

        List<Case> childrenOfGrandChild = CaseTask.getImmediateChildCases(grandChild.Id);
        System.assert(childrenOfGrandChild.isEmpty());

        Test.stopTest();
    }
}
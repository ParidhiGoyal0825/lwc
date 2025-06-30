@isTest
public class LeadHandlerTest {
    @isTest
    public static void leadCreate(){
        List<Lead> leadList= new List<Lead>();
        for(Integer i=1;i<=5;i++){
            Lead l=new Lead();
            l.LeadSource='Web';
            l.LastName = 'test' + i;
                l.Company = 'test' + i;
            leadList.add(l);
        }
        Test.startTest();
        insert leadList;
        Test.stopTest();
        List<Lead> lList= [Select Rating from Lead where Id =:leadList[0].Id];
        System.assertEquals('Cold', lList[0].Rating);
    }
}
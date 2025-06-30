@isTest
public class ApexTestClass {
@isTest
    static void evenNum(){
        List<List<Integer>> a= ApexScript.evenList(new List<Integer>{2,4,5,6,2});
          List<List<Integer>> b = new List<List<Integer>>{
            new List<Integer>{2,4,6,2},   // Even numbers
            new List<Integer>{5}           // Odd numbers
        };
        System.assertEquals(b,a,'not correct');
    }
}
@RestResource(urlMapping='/myclass/*')
global class MyApiController {
   /* @HttpPost
    global static string dataCreation(string name, string rating){
        Account acc = new Account();
        acc.Name = name;
        acc.Rating = rating;
        insert acc;
        return acc.Id;
    }*/
    
    @HttpDelete
    global static String updateAcc(){
        RestRequest req = RestContext.request;
        string accId = req.params.get('Id');
        try{
        Account updateAcc = [SELECT Id, Name FROM Account
                             WHERE Id=:accId];
        delete updateAcc;
            return accId;
        }
        catch(Exception e){
            return 'error deleting account' + e.getMessage();
        }
    }
}
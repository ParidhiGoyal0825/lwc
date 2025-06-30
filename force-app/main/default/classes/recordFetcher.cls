public with sharing class recordFetcher {
    @AuraEnabled
    public static List<SObject> getRecords(String objectName, String fieldsCSV) {
        if (String.isBlank(objectName) || String.isBlank(fieldsCSV)) {
            throw new AuraHandledException('Object name and fields are required.');
        }
        String soql = 'SELECT ' + fieldsCSV + ' FROM ' + objectName + ' LIMIT 50';
        return Database.query(soql);
    }
    @AuraEnabled(cacheable=true)
   public static List<SObject> searchRecords(String objectApiName, String searchField, String searchKeyword) {
       if(String.isBlank(objectApiName) || String.isBlank(searchField) || String.isBlank(searchKeyword)) {
           throw new AuraHandledException('All parameters are required.');
       }

       String query = 'SELECT Id, ' + searchField + ' FROM ' + objectApiName +
                      ' WHERE ' + searchField + ' LIKE \'%' + searchKeyword + '%\' LIMIT 10';

       return Database.query(query);
   }
   @AuraEnabled(cacheable=true)
    public static Map<String, Map<String, String>> getRecordData(Id originalId, Id clonedId) {
        Map<String, Map<String, String>> result = new Map<String, Map<String, String>>();

        // Safely query the original Opportunity
        List<Opportunity> originals = [
            SELECT Id, Name, StageName, CloseDate, Amount
            FROM Opportunity
            WHERE Id = :originalId
            LIMIT 1
        ];
        List<Opportunity> cloneds = [
            SELECT Id, Name, StageName, CloseDate, Amount
            FROM Opportunity
            WHERE Id = :clonedId
            LIMIT 1
        ];

        if (originals.isEmpty() || cloneds.isEmpty()) {
            throw new AuraHandledException('One or both Opportunity records not found.');
        }

        Opportunity original = originals[0];
        Opportunity cloned = cloneds[0];

        Map<String, String> originalMap = new Map<String, String>{
            'Name' => original.Name,
            'StageName' => original.StageName,
            'CloseDate' => original.CloseDate != null ? String.valueOf(original.CloseDate) : '',
            'Amount' => original.Amount != null ? String.valueOf(original.Amount) : ''
        };

        Map<String, String> clonedMap = new Map<String, String>{
            'Name' => cloned.Name,
            'StageName' => cloned.StageName,
            'CloseDate' => cloned.CloseDate != null ? String.valueOf(cloned.CloseDate) : '',
            'Amount' => cloned.Amount != null ? String.valueOf(cloned.Amount) : ''
        };

        result.put('original', originalMap);
        result.put('cloned', clonedMap);
        return result;
    }
}
public with sharing class OpportunityChartController {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<Opportunity>> getOpportunityData(String accountId) {
        try{
            Map<String, List<Opportunity>> opportunityData = new Map<String, List<Opportunity>>();

            List<Opportunity> lastQuarterOpps = [
                SELECT Id, Name, StageName, CloseDate, IsClosed, IsWon, Amount, Probability
                FROM Opportunity
                WHERE AccountId = :accountId
                AND CloseDate = LAST_QUARTER
                //AND CloseDate <= :lastQuarterEndDate
                ORDER BY CloseDate DESC
            ];
            opportunityData.put('lastQuarterOpportunities', lastQuarterOpps);

            List<Opportunity> nextQuarterOpps = [
                SELECT Id, Name, StageName, CloseDate, IsClosed, IsWon, Probability
                FROM Opportunity
                WHERE AccountId = :accountId
                AND CloseDate = NEXT_QUARTER
                //AND CloseDate <= :nextQuarterEndDate
                ORDER BY CloseDate ASC
            ];
            opportunityData.put('nextQuarterOpportunities', nextQuarterOpps);

            return opportunityData;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}
public with sharing class ApiConfig {

    @AuraEnabled(cacheable=true)
    public static API_Configuration__c getConfig() {
        return API_Configuration__c.getOrgDefaults(); // default org-level setting
    }

    @AuraEnabled
    public static void saveConfig(String endpointUrl, String refreshToken, String clientId, String clientSecret) {
        API_Configuration__c config = API_Configuration__c.getOrgDefaults();
        if (config == null) {
            config = new API_Configuration__c();
        }
        config.Endpoint_URL__c = endpointUrl;
        config.Refresh_Token__c = refreshToken;
        config.Client_ID__c = clientId;
        config.Client_Secret__c = clientSecret;
        upsert config;
    }
}
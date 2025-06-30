public with sharing class ObligationController {

    public class SummaryRowWrapper {
        @AuraEnabled public String groupName;
        @AuraEnabled public Decimal Secured;
        @AuraEnabled public Decimal Unsecured;
        @AuraEnabled public Decimal SanctionedAmount;
        @AuraEnabled public Decimal CurrentBalance;
        @AuraEnabled public Decimal SecuredUnsecuredExposure;
        @AuraEnabled public Decimal TotalGroupExposure;
        @AuraEnabled public Decimal ProductExposure;
        @AuraEnabled public Decimal Utilisation;
    }

    @AuraEnabled(cacheable=true)
    public static List<Obligation__c> getObligations() {
        try {
            return [
                SELECT 
                Id, Name, Account_Type__c, Applicant_Type__c, Applicant_Type__r.Name, Bureau_Imputed_EMI__c, Calculated_MOB__c,
                Credit_Card_Utilization__c, Current_Balance__c, Declared_EMI__c, EMI_Start_Date__c,
                EMI_Type__c, Exclude_Reason__c, Exposure_Type__c, Financier_Name__c, Last_Paid_Date__c,
                Loan_Account_Number__c, Obligation_to_be_considered__c, Open_Date__c, Ownership_Type__c,
                Product__c, Repayment_Tenure_Bureau__c, Sanctioned_Loan_Amount__c, Select_BT_Action__c,
                Source__c, Status__c, User_Remarks__c
            FROM Obligation__c LIMIT 49999
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching obligations: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateObligations(List<Obligation__c> obligations) {
        if (obligations == null || obligations.isEmpty()) {
            throw new AuraHandledException('No obligations provided for update.');
        }
        update obligations;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getTableColumns() {
        List<Map<String, Object>> columns = new List<Map<String, Object>>();
        
        try {
            List<Obligation_Column_Config_mdt__mdt> columnMetadata = [
                SELECT Label, Field_API_Name__c, Type__c, Editable__c, Order__c, 
                       Is_Relationship_Field__c, Relationship_Field_Path__c
                FROM Obligation_Column_Config_mdt__mdt
                ORDER BY Order__c
            ];
              if (columnMetadata.isEmpty()) {
                throw new AuraHandledException('No column Metadata.');
            }
            for (Obligation_Column_Config_mdt__mdt col : columnMetadata) {
                if (col == null) continue;

                Map<String, Object> column = new Map<String, Object>{
                    'label' => col.Label,
                    'fieldName' => col.Is_Relationship_Field__c != null && col.Is_Relationship_Field__c
                                   ? col.Relationship_Field_Path__c
                                   : col.Field_API_Name__c
                };
                
                if (String.isNotBlank(col.Type__c)) {
                    column.put('type', col.Type__c);
                }
                
                if (col.Editable__c != null && col.Editable__c) {
                    column.put('editable', true);
                }
                
                columns.add(column);
            }
            
           
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving column configuration: ' + e.getMessage());
        }
        
        return columns;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getObligationSummary(Id oppId) {
        try {
            if (oppId == null) {
                throw new AuraHandledException('Opportunity Id is required.');
            }

            List<Exposure_Column_Config__mdt> columnConfigs = [
                SELECT Label__c, Field_Name__c, Type__c, Sort_Order__c
                FROM Exposure_Column_Config__mdt
                ORDER BY Sort_Order__c ASC
            ];

            List<Map<String, Object>> columns = new List<Map<String, Object>>();
            for (Exposure_Column_Config__mdt config : columnConfigs) {
                if (config == null) continue;

                columns.add(new Map<String, Object>{
                    'label' => config.Label__c,
                    'fieldName' => config.Field_Name__c,
                    'type' => config.Type__c,
                    'sortOrder' => config.Sort_Order__c
                });
            }

            
            List<Obligation__c> obligations = [
                SELECT Exposure_Type__c, Sanctioned_Loan_Amount__c, Current_Balance__c,
                       Applicant_Type__r.RecordType.Name
                FROM Obligation__c
                WHERE Applicant_Type__r.OpportunityId__c = :oppId
            ];

            Map<String, SummaryRowWrapper> summaryMap = new Map<String, SummaryRowWrapper>();

            for (Obligation__c ob : obligations) {
                if (ob == null) continue;

                String groupName = (ob.Applicant_Type__r != null && ob.Applicant_Type__r.RecordType != null)
                    ? ob.Applicant_Type__r.RecordType.Name
                    : 'Unknown';

                if (!summaryMap.containsKey(groupName)) {
                    SummaryRowWrapper newEntry = new SummaryRowWrapper();
                    newEntry.groupName = groupName;
                    newEntry.Secured = 0;
                    newEntry.Unsecured = 0;
                    newEntry.SanctionedAmount = 0;
                    newEntry.CurrentBalance = 0;
                    summaryMap.put(groupName, newEntry);
                }

                SummaryRowWrapper entry = summaryMap.get(groupName);

                Decimal balance = ob.Current_Balance__c != null ? ob.Current_Balance__c : 0;
                Decimal sanctioned = ob.Sanctioned_Loan_Amount__c != null ? ob.Sanctioned_Loan_Amount__c : 0;

                if (ob.Exposure_Type__c != null && ob.Exposure_Type__c == 'Secured') {
                    entry.Secured += balance;
                } else if (ob.Exposure_Type__c != null && ob.Exposure_Type__c == 'Unsecured') {
                    entry.Unsecured += balance;
                }

                entry.SanctionedAmount += sanctioned;
                entry.CurrentBalance += balance;
            }

            List<SummaryRowWrapper> summaryList = new List<SummaryRowWrapper>();
            SummaryRowWrapper totalRow = new SummaryRowWrapper();
            totalRow.groupName = 'Total';
            totalRow.Secured = 0;
            totalRow.Unsecured = 0;
            totalRow.SanctionedAmount = 0;
            totalRow.CurrentBalance = 0;

            for (SummaryRowWrapper row : summaryMap.values()) {
                if (row == null) continue;

                row.SecuredUnsecuredExposure = (row.Secured != null ? row.Secured : 0) + (row.Unsecured != null ? row.Unsecured : 0);
                row.TotalGroupExposure = row.SecuredUnsecuredExposure;
                row.ProductExposure = row.Secured;
                row.Utilisation = row.SanctionedAmount > 0 ? (row.CurrentBalance / row.SanctionedAmount) : 0;

                totalRow.Secured += row.Secured;
                totalRow.Unsecured += row.Unsecured;
                totalRow.SanctionedAmount += row.SanctionedAmount;
                totalRow.CurrentBalance += row.CurrentBalance;

                summaryList.add(row);
            }

            totalRow.SecuredUnsecuredExposure = totalRow.Secured + totalRow.Unsecured;
            totalRow.TotalGroupExposure = totalRow.SecuredUnsecuredExposure;
            totalRow.ProductExposure = totalRow.Secured;
            totalRow.Utilisation = totalRow.SanctionedAmount > 0 ? (totalRow.CurrentBalance / totalRow.SanctionedAmount) : 0;

            summaryList.add(totalRow);

            return new Map<String, Object>{
                'columns' => columns,
                'data' => summaryList
            };

        } catch (Exception e) {
            throw new AuraHandledException('Error fetching obligation summary: ' + e.getMessage());
        }
    }

}
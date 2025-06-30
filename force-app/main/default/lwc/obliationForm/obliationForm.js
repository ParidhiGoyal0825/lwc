import { LightningElement, wire, track, api } from 'lwc';
import { refreshApex } from "@salesforce/apex";

import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import OBLIGATION_OBJECT from '@salesforce/schema/Obligation__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getObligations from '@salesforce/apex/obligationDataController.getObligations';
import FINANCIER_FIELD from '@salesforce/schema/Obligation__c.Financier_Name__c';
import SELECT_BT_FIELD from '@salesforce/schema/Obligation__c.Select_BT_Action__c';
import EXCLUDE_REASON_FIELD from '@salesforce/schema/Obligation__c.Exclude_Reason__c';
import EXPOSURE_TYPE_FIELD from '@salesforce/schema/Obligation__c.Exposure_Type__c';
import OBLIGATION_CONSIDERED from '@salesforce/schema/Obligation__c.Obligation_to_be_considered__c';
import { updateRecord } from 'lightning/uiRecordApi';
import getObligationSummary from '@salesforce/apex/obligationDataController.getObligationSummary';

// Datatable Columns
const COLUMNS = [
     { label: 'Applicant Type', fieldName: 'Applicant_Type_Name' },
    { label: 'Account Type', fieldName: 'Account_Type__c', editable: true },
    { label: 'Source', fieldName: 'Source__c' },
    { label: 'Ownership Type', fieldName: 'Ownership_Type__c' },
    { label: 'Open Date', fieldName: 'Open_Date__c', type: 'date' },
      {
        label: 'Financier Name', fieldName: 'Financier_Name__c', editable: true,
        type: 'customPicklist',
        fieldName: FINANCIER_FIELD.fieldApiName,
        typeAttributes: {
            options: { fieldName: 'financierOptions' },
            value: { fieldName: FINANCIER_FIELD.fieldApiName },
            context: { fieldName: 'Id' }, // Pass the record Id as context
            rowId: { fieldName: 'Id' } // Pass the record Id as context
        }
    },

    { label: 'Loan Account Number', fieldName: 'Loan_Account_Number__c', editable: true },
    { label: 'Sanctioned Amount', fieldName: 'Sanctioned_Amount__c', type: 'currency' },
    { label: 'Current Balance', fieldName: 'Current_Balance__c', type: 'currency' },
    { label: 'Bureau/Imputed EMI', fieldName: 'Bureau_Imputed_EMI__c', type: 'currency' },
    { label: 'EMI Type', fieldName: 'EMI_Type__c' },
    { label: 'Declared EMI', fieldName: 'Declared_EMI__c', type: 'currency', editable: true },
    {
        label: 'Select BT Option', fieldName: 'Select_BT_Action__c', editable: true,
        type: 'customPicklist',
        fieldName: SELECT_BT_FIELD.fieldApiName,
        typeAttributes: {
            options: { fieldName: 'selectBTOptions' },
            value: { fieldName: SELECT_BT_FIELD.fieldApiName },
            context: { fieldName: 'Id' }, // Pass the record Id as context
rowId: { fieldName: 'Id' }
        }
    },

    {
        label: 'Exclude Reason', fieldName: 'Exclude_Reason__c',
        type: 'customPicklist',
       fieldName: EXCLUDE_REASON_FIELD.fieldApiName,
        editable: true,
        typeAttributes: {
            options: { fieldName: 'excludeReasonOptions' },
            value: { fieldName: EXCLUDE_REASON_FIELD.fieldApiName },
            context: { fieldName: 'Id' },
            rowId: { fieldName: 'Id' } // Pass the record Id as context

        }
    },

    {
        label: 'Exposure Type', fieldName: 'Exposure_Type__c',
        type: 'customPicklist',
        editable: true,
        fieldName: EXPOSURE_TYPE_FIELD.fieldApiName,
        typeAttributes: {
            options: { fieldName: 'exposureTypeOptions' },
            value: { fieldName: EXPOSURE_TYPE_FIELD.fieldApiName },
            context: { fieldName: 'Id' },
            rowId: { fieldName: 'Id' } // Pass the record Id as context
        }
    },

    {
        label: 'Obligation Considered', fieldName: 'Obligation_to_be_considered__c', type: 'customPicklist',
        editable: true,
         fieldName: OBLIGATION_CONSIDERED.fieldApiName,
        typeAttributes: {
            options: { fieldName: 'obligationConsideredOptions' },
            value: { fieldName: OBLIGATION_CONSIDERED.fieldApiName },
            context: { fieldName: 'Id' },
            rowId: { fieldName: 'Id' } // Pass the record Id as context
        }
    }

];
const SUMMARY_COLUMNS = [
    { label: 'Summary', fieldName: 'recordTypeName' },
    { label: 'Overall Unsecured Exposure', fieldName: 'unsecuredExposure', type: 'currency' },
    { label: 'Overall Secured Exposure', fieldName: 'securedExposure', type: 'currency' },
    { label: 'Overall Secured & Unsecured Exposure', fieldName: 'totalExposure', type: 'currency' },
    { label: 'Total Group Exposure', fieldName: 'groupExposure', type: 'currency' },
    { label: 'Product Exposure (TCL - PL & OD)', fieldName: 'productExposure', type: 'currency' },
    { label: 'Total Credit Card Sanctioned Amount', fieldName: 'ccSanctionedAmount', type: 'currency' },
    { label: 'Credit Card Balance', fieldName: 'currentBalance', type: 'currency' },
    { label: 'Credit Card Utilisation', fieldName: 'ccUtilisation', type: 'percent' }
];
export default class ObligationForm extends LightningElement {
    @api recordId;
    isModalOpen = false;
    fields = [];
    summaryColumns=SUMMARY_COLUMNS;
    @track draftValues = [];
    // Obligation data and columns
    @track columns = COLUMNS;
    obligations = [];
    picklistValues = {}; // To store picklist values
    wiredObligationsRes; // Just to refresh when obligation form publish data
    wiredSummary;
    summaryData;
    // Wire to fetch object information for field list
    // @wire(getObjectInfo, { objectApiName: OBLIGATION_OBJECT })
    // objectInfo({ data, error }) {

    //     if (data) {
    //         this.fields = Object.keys(data.fields).filter((fieldName) => fieldName.endsWith('__c'));
    //     } else if (error) {
    //         console.error('Error fetching object info:', error);
    //     }
    // }
    connectedCallback() {
        console.log('recordId is: ', this.recordId);
      }
      
    // @wire(getObligationSummary, { oppId: '$recordId' })
    // wiredSummary(result) {
    //     this.wiredSummary = result;
    //     const { error, data } = result;
    //     this.wiredSummaryResult = data;
    //     if (data) {
    //         this.processSummaryData(data);
    //     }
    //     console.log("sdfsdf",JSON.stringify(result));
    // }
//     processSummaryData(data) {
//         this.summaryData = Object.keys(data).map(recordType => {
//          const summary = data[recordType];
//          const unsecuredExposure = summary.Unsecured || 0;
//          const securedExposure = summary.Secured || 0;
//          const totalExposure = unsecuredExposure + securedExposure;
//          const groupExposure = summary.SanctionedAmount || 0;
//          const productExposure = summary.SanctionedAmount || 0; // Adjust as per your logic
//          const ccSanctionedAmount = summary.CreditCardSanctionedAmount || 0; // Placeholder, adjust as per your logic
//          const currentBalance = summary.CreditCardBalance || 0; // Placeholder, adjust as per your logic
//          const ccUtilisation = (currentBalance *100)/ ccSanctionedAmount;

//          return {
//              id: recordType,
//              recordTypeName: recordType, // Using RecordType Name
//              unsecuredExposure,
//              securedExposure,
//              totalExposure,
//              groupExposure,
//              productExposure,
//              ccSanctionedAmount,
//              currentBalance,
//              ccUtilisation
//          };
//      });
//      console.log("sdfsdf",JSON.stringify(this.summaryData));
     

//      const total = this.summaryData.reduce(
//          (acc, row) => ({
             
//              unsecuredExposure: acc.unsecuredExposure + row.unsecuredExposure,
//              securedExposure: acc.securedExposure + row.securedExposure,
//              ccSanctionedAmount: acc.ccSanctionedAmount + row.ccSanctionedAmount,
//              currentBalance: acc.currentBalance + row.currentBalance
//          }),
//          { unsecuredExposure: 0, securedExposure: 0, ccSanctionedAmount: 0, currentBalance: 0 }
//      );
//      total.productExposure = this.summaryData[0].productExposure + this.summaryData[1].productExposure;
//      total.groupExposure = this.summaryData[0].groupExposure + this.summaryData[1].groupExposure;
//      total.recordTypeName = 'Total';
//      total.totalExposure = total.unsecuredExposure + total.securedExposure;
//      total.ccUtilisation = total.ccSanctionedAmount > 0 ? total.currentBalance / total.ccSanctionedAmount : 0;
//      this.summaryData = [...this.summaryData, total]
//  }
//     handleChange(event) {
//         const detail = event.detail.value;
//         console.log('Detail:', JSON.stringify(detail));

//     }
//     handleSave(event) {
//     const { draftValues } = event.detail;
//     console.log('Draft Values:', JSON.stringify(draftValues));

//     const recordsToUpdate = draftValues.map((draftValue) => {
//         // Ensure draftValue contains the correct structure
//         return updateRecord({ fields: { ...draftValue } });
//     });

//     Promise.all(recordsToUpdate)
//         .then((res) => {
//             this.dispatchEvent(
//                 new ShowToastEvent({
//                     title: 'Success',
//                     message: 'Obligation updated successfully',
//                     variant: 'success'
//                 })
//             );
//             this.draftValues = [];
//             refreshApex(this.wiredObligationsRes);
//         })
//         .catch((error) => {
//             this.dispatchEvent(
//                 new ShowToastEvent({
//                     title: 'Error updating obligation',
//                     message: error.body?.message || 'Unknown error',
//                     variant: 'error'
//                 })
//             );
//         });
// }
//     // Get Picklist values by Record Type dynamically using @wire
//    @wire(getPicklistValuesByRecordType, { objectApiName: 'Obligation__c', recordTypeId: '012000000000000AAA' })
// handleWiredPickListValues({ data, error }) {
//     if (data) {
//         this.picklistValues = {
//             financierOptions: this.getPicklistValues(data.picklistFieldValues, FINANCIER_FIELD.fieldApiName),
//             selectBTOptions: this.getPicklistValues(data.picklistFieldValues, SELECT_BT_FIELD.fieldApiName),
//             excludeReasonOptions: this.getPicklistValues(data.picklistFieldValues, EXCLUDE_REASON_FIELD.fieldApiName),
//             exposureTypeOptions: this.getPicklistValues(data.picklistFieldValues, EXPOSURE_TYPE_FIELD.fieldApiName),
//             obligationConsideredOptions: this.getPicklistValues(data.picklistFieldValues, OBLIGATION_CONSIDERED.fieldApiName)
//         };

//         // Only update obligations once all picklist values are set
//         this.obligations = this.obligations.map(obligation => ({
//             ...obligation,
//             financierOptions: this.picklistValues.financierOptions || [],
//             selectBTOptions: this.picklistValues.selectBTOptions || [],
//             excludeReasonOptions: this.picklistValues.excludeReasonOptions || [],
//             exposureTypeOptions: this.picklistValues.exposureTypeOptions || [],
//             obligationConsideredOptions: this.picklistValues.obligationConsideredOptions || []
//         }));
//     } else if (error) {
//         console.error('Error getting picklist values', error);
//     }
// }
//     // Helper function to extract picklist values
//     getPicklistValues(data, fieldApiName) {
//         const field = data[fieldApiName];
//         return field && field.values ? field.values.map((p) => ({
//             label: p.label,
//             value: p.value
//         })) : [];
//     }


//     // Fetch Obligations from Apex
//   @wire(getObligations)
//     wiredObligations(result) {
//         this.wiredResult = result;
//         if (result.data) {
//             this.obligations = result.data.map(record => ({
//                 ...record,
//                 Applicant_Type_Name: record.Applicant_Type__r ? record.Applicant_Type__r.Name : '',
//             }));
//         } else if (result.error) {
//             console.error('Error fetching obligations:', result.error);
//         }
// }

//     // Open/Close Modal
//     handleClick() {
//         this.isModalOpen = !this.isModalOpen;
//     }

//     // Success Handler for Form Submission
//     handleSuccess(event) {
//         const recordId = event.detail.id;
//         console.log('Obligation created with Id:', recordId);

//         // Publish Update
//         const payload = {
//             obligationId: recordId
//         };
//         // Close modal
//         this.isModalOpen = false;
//         // Refresh the datatable
//         refreshApex(this.wiredObligationsRes);
//         // Show success toast
//         this.dispatchEvent(
//             new ShowToastEvent({
//                 title: 'Success',
//                 message: 'Obligation record created successfully',
//                 variant: 'success'
//             })
//         );
//     }

}
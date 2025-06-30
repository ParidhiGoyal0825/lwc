import { LightningElement, track, wire,api } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

// Object Schema
import OBLIGATION_OBJECT from '@salesforce/schema/Obligation__c';
import EXCLUDE_REASON_FIELD from '@salesforce/schema/Obligation__c.Exclude_Reason__c';
import EXPOSURE_TYPE_FIELD from '@salesforce/schema/Obligation__c.Exposure_Type__c';
import SELECT_BT_ACTION_FIELD from '@salesforce/schema/Obligation__c.Select_BT_Action__c';
import OBLIGATION_TO_BE_CONSIDERED_FIELD from '@salesforce/schema/Obligation__c.Obligation_to_be_considered__c';
import FINANCIER_NAME_FIELD from '@salesforce/schema/Obligation__c.Financier_Name__c';  // Added this

// Apex Methods
import getObligations from '@salesforce/apex/ObligationController.getObligations';
import updateObligations from '@salesforce/apex/ObligationController.updateObligations';
import getTableColumns from '@salesforce/apex/ObligationController.getTableColumns';
import getObligationSummary from '@salesforce/apex/ObligationController.getObligationSummary';

export default class ObligationTask extends LightningElement {
    isModalOpen = false;

    @track obligations = [];
    wiredObligationsResult;
    draftValues = [];

    baseColumns = [];
    columns = [];

    excludeReasonOptions;
    exposureTypeOptions;
    selectBTActionOptions;
    obligationToBeConsideredOptions;
    financierNameOptions;  // Added this for Financier Name picklist

    @wire(getObjectInfo, { objectApiName: OBLIGATION_OBJECT })
    objectInfo;

    // Exclude Reason Picklist
    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: EXCLUDE_REASON_FIELD
    })
    wiredExcludeReasonPicklist({ error, data }) {
        if (data) {
            this.excludeReasonOptions = data.values.map(option => ({
                label: option.label,
                value: option.value
            }));
            this.injectPicklistOptions();
            this.processColumns();
        } else if (error) {
            console.error('Error loading Exclude Reason picklist values:', error);
        }
    }

    // Exposure Type Picklist
    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: EXPOSURE_TYPE_FIELD
    })
    wiredExposureTypePicklist({ error, data }) {
        if (data) {
            this.exposureTypeOptions = data.values.map(option => ({
                label: option.label,
                value: option.value
            }));
            this.injectPicklistOptions();
            this.processColumns();
        } else if (error) {
            console.error('Error loading Exposure Type picklist values:', error);
        }
    }

    // Select BT Action Picklist
    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: SELECT_BT_ACTION_FIELD
    })
    wiredSelectBTActionPicklist({ error, data }) {
        if (data) {
            this.selectBTActionOptions = data.values.map(option => ({
                label: option.label,
                value: option.value
            }));
            this.injectPicklistOptions();
            this.processColumns();
        } else if (error) {
            console.error('Error loading Select BT Action picklist values:', error);
        }
    }

    // Obligation To Be Considered Picklist
    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: OBLIGATION_TO_BE_CONSIDERED_FIELD
    })
    wiredObligationToBeConsideredPicklist({ error, data }) {
        if (data) {
            this.obligationToBeConsideredOptions = data.values.map(option => ({
                label: option.label,
                value: option.value
            }));
            this.injectPicklistOptions();
            this.processColumns();
        } else if (error) {
            console.error('Error loading Obligation To Be Considered picklist values:', error);
        }
    }

    // Financier Name Picklist (Newly Added)
    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: FINANCIER_NAME_FIELD
    })
    wiredFinancierNamePicklist({ error, data }) {
        if (data) {
            this.financierNameOptions = data.values.map(option => ({
                label: option.label,
                value: option.value
            }));
            this.injectPicklistOptions();
            this.processColumns();
        } else if (error) {
            console.error('Error loading Financier Name picklist values:', error);
        }
    }

    // Table Columns
    @wire(getTableColumns)
    wiredColumns({ data, error }) {
        if (data) {
            this.baseColumns = data;
            this.processColumns();
        } else if (error) {
            console.error('Error fetching columns:', error);
            this.showToast('Error', 'Failed to load table columns: ' + error.body.message, 'error');
        }
    }

    // Get Obligations
    @wire(getObligations)
    wiredObligations(result) {
        this.wiredObligationsResult = result;
        if (result.data) {
            this.obligations = result.data.map(o => ({
                ...o,
                Applicant_Type_Name: o.Applicant_Type__r?.Name
            }));
            this.injectPicklistOptions();
        } else if (result.error) {
            console.error('Error fetching obligations:', result.error);
            this.showToast('Error', 'Failed to load obligations', 'error');
        }
    }

    // Inject Picklist Options into Obligations
    injectPicklistOptions() {
        if (!this.obligations || !this.excludeReasonOptions || !this.exposureTypeOptions || !this.selectBTActionOptions || !this.obligationToBeConsideredOptions || !this.financierNameOptions) {
            return;
        }

        this.obligations = this.obligations.map(obj => ({
            ...obj,
            excludeReasonOptions: this.excludeReasonOptions,
            exposureTypeOptions: this.exposureTypeOptions,
            selectBTActionOptions: this.selectBTActionOptions,
            obligationToBeConsideredOptions: this.obligationToBeConsideredOptions,
            financierNameOptions: this.financierNameOptions  // Added this line
        }));
    }

    // Process Columns for Picklist Fields
    processColumns() {
        if (!this.baseColumns || !this.excludeReasonOptions || !this.exposureTypeOptions || !this.selectBTActionOptions || !this.obligationToBeConsideredOptions || !this.financierNameOptions) {
            return;
        }

        this.columns = this.baseColumns.map(column => {
            if (column.fieldName === 'Exclude_Reason__c' && column.editable) {
                return {
                    ...column,
                    type: 'picklistColumn',
                    typeAttributes: {
                        placeholder: 'Choose a reason',
                        options: { fieldName: 'excludeReasonOptions' },
                        value: { fieldName: 'Exclude_Reason__c' },
                        context: { fieldName: 'Id' }
                    }
                };
            }
            if (column.fieldName === 'Exposure_Type__c' && column.editable) {
                return {
                    ...column,
                    type: 'picklistColumn',
                    typeAttributes: {
                        placeholder: 'Choose a type',
                        options: { fieldName: 'exposureTypeOptions' },
                        value: { fieldName: 'Exposure_Type__c' },
                        context: { fieldName: 'Id' }
                    }
                };
            }
            if (column.fieldName === 'Select_BT_Action__c' && column.editable) {
                return {
                    ...column,
                    type: 'picklistColumn',
                    typeAttributes: {
                        placeholder: 'Choose an action',
                        options: { fieldName: 'selectBTActionOptions' },
                        value: { fieldName: 'Select_BT_Action__c' },
                        context: { fieldName: 'Id' }
                    }
                };
            }
            if (column.fieldName === 'Obligation_to_be_considered__c' && column.editable) {
                return {
                    ...column,
                    type: 'picklistColumn',
                    typeAttributes: {
                        placeholder: 'Choose an option',
                        options: { fieldName: 'obligationToBeConsideredOptions' },
                        value: { fieldName: 'Obligation_to_be_considered__c' },
                        context: { fieldName: 'Id' }
                    }
                };
            }
            if (column.fieldName === 'Financier_Name__c' && column.editable) {  // Added check for Financier Name
                return {
                    ...column,
                    type: 'picklistColumn',
                    typeAttributes: {
                        placeholder: 'Choose a financier',
                        options: { fieldName: 'financierNameOptions' },
                        value: { fieldName: 'Financier_Name__c' },
                        context: { fieldName: 'Id' }
                    }
                };
            }
            return column;
        });
    }

    // Fields for Filtering
    get fields() {
        if (this.objectInfo.data) {
            const fields = this.objectInfo.data.fields;
            return Object.keys(fields).filter(f => f.endsWith('__c') || f === 'Name');
        }
        return [];
    }

    // Toggle Modal
    handleModalToggle() {
        this.isModalOpen = !this.isModalOpen;
    }

    // Success Handler
    handleSuccess(event) {
        this.showToast('Success', 'Obligation created successfully', 'success');
        this.refreshData();
        this.isModalOpen = false;
    }

    // Save Handler
    handleSave(event) {
        const updatedFields = event.detail.draftValues;

        updateObligations({ obligations: updatedFields })
            .then(() => {
                this.showToast('Success', 'Obligations updated successfully', 'success');
                this.draftValues = [];
                //return refreshApex(this.wiredObligationsResult);
                return this.refreshData();
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    // Refresh Data
    refreshData() {
        refreshApex(this.wiredObligationsResult);
        refreshApex(this.summaryResult);
    }

    // Toast Message
    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }

@track summaryColumns = [];
@track summaryRows = [];
@api recordId;
 
@wire(getObligationSummary, { oppId: '$recordId' })
wiredSummary(result) {
    console.log('wiredSummary');
    console.log(result);
    this.summaryResult = result;
    console.log('result is :'+JSON.stringify(result));

    
    // const { error, data } =result;
    //     this.summaryResult=result;
    //     console.log("data is:" + data);
        
    // if (data) {
    //     const metadataColumns = data.columns;
    //     const summaryData = data.data;

    //     // Set columns dynamically
    //     this.summaryColumns = metadataColumns.map(col => {
    //         let columnDef = {
    //             label: col.label,
    //             fieldName: col.fieldName,
    //             type: col.type
    //         };

    //        /* if (col.type === 'number') {
    //             columnDef.typeAttributes = { currencyCode: 'USD' };
    //         } else if (col.type === 'percent') {
    //             columnDef.typeAttributes = { maximumFractionDigits: 2 };
    //         }*/

    //         return columnDef;
    //     });

    //     // Build rows
    //     this.summaryRows = Object.keys(summaryData).map(group => {
    //         const entry = summaryData[group];
    //         const totalExposure = (entry.Secured || 0) + (entry.Unsecured || 0);
    //         const utilisation = entry.SanctionedAmount > 0
    //             ? entry.CurrentBalance / entry.SanctionedAmount
    //             : 0;

    //         return {
    //             group: group,
    //             Unsecured: entry.Unsecured,
    //             Secured: entry.Secured,
    //             SecuredUnsecuredExposure: totalExposure,
    //             TotalGroupExposure: totalExposure,
    //             ProductExposure: entry.Secured,
    //             SanctionedAmount: entry.SanctionedAmount,
    //             CurrentBalance: entry.CurrentBalance,
    //             Utilisation: utilisation
    //         };
    //     });

    //     // Add total row
    //     const total = this.summaryRows.reduce((acc, row) => {
    //         acc.Unsecured += row.Unsecured;
    //         acc.Secured += row.Secured;
    //         acc.SanctionedAmount += row.SanctionedAmount;
    //         acc.CurrentBalance += row.CurrentBalance;
    //         return acc;
    //     }, { group: 'Total', Unsecured: 0, Secured: 0, SanctionedAmount: 0, CurrentBalance: 0 });

    //     total.SecuredUnsecuredExposure = total.Unsecured + total.Secured;
    //     total.TotalGroupExposure = total.SecuredUnsecuredExposure;
    //     total.ProductExposure = total.Secured;
    //     total.Utilisation = total.SanctionedAmount > 0 ? (total.CurrentBalance / total.SanctionedAmount) : 0;

    //     this.summaryRows.push(total);
    // } else if (error) {
    //     console.error('Error fetching summary:', error);
    // }
}
}
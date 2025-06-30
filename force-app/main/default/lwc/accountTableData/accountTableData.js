import { LightningElement, track,wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountforLwc.getAccounts';
import delAccounts from '@salesforce/apex/AccountforLwc.deleteOperationList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'Account Name', fieldName: 'Name', editable: true },
    { label: 'Website', fieldName: 'Website', editable: true },
  
];
export default class AccountTableData extends LightningElement {
    columns = columns;
    @track data = [];
    @track saveDraftValue = [];
    selectedRows = [];

    wResult;

    @wire(getAccounts)
    accountData(result) {
        this.wResult = result;
        if (result.data) {
            this.data = result.data;
        } else if (result.error) {
            console.error('Error fetching data:', result.error);
        }
    }

    handleRowsSelection(event) {
        this.selectedRows = event.detail.selectedRows;
        console.log('Selected rows:', this.selectedRows);
    }

    handleDeleteButton() {
        const selectedIds = this.selectedRows.map(row => row.Id);
        this.isLoading = true;
    
        delAccounts({ accIds: selectedIds })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'deleted successfully',
                    variant: 'success'
                }));
               refreshApex(this.wResult);
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error deleting',
                    message: error.body.message || 'Unknown error',
                    variant: 'error'
                }));
            })
            .finally(() => {
                this.isLoading = false;
                this.isDeleteDisabled = true;
            });
    }
    

    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        this.isLoading = true;
    
        updatedAccountDetails({ accData: updatedFields })
            .then(result => {
                this.saveDraftValue = [];
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Records updated successfully',
                    variant: 'success'
                }));
                return refreshApex(this.wResult);
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error updating records',
                    message: error.body.message || 'Unknown error',
                    variant: 'error'
                }));
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}
import { LightningElement, api, wire } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const FIELDS = [
    'Account.Name',
    'Account.Phone',
    'Account.Type',
    'Account.Website'];

export default class SldsTask extends LightningElement {
    @api recordId;
    isEditFormVisible=false;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
        account;


    handleEdit() {
        this.isEditFormVisible = true;
    }

    handleCancel() {
        this.isEditFormVisible = false;
    }

    handleSuccess(){
        this.isEditFormVisible=false;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record Updated Successfully!!',
                variant: 'success',
            }),
        );
    }
}
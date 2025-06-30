import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseCreator extends LightningElement {
   

    handleSuccess() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Case Created',
                variant: 'success'
            })
        );
    }
    handleError(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creating Case',
                message: event.detail.message,
                variant: 'error'
            })
        );
    }
}
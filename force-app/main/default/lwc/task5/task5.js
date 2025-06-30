import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Task5 extends LightningElement {
    showToast() {
        const evt = new ShowToastEvent({
            title: 'Success!',
            message: 'This is a toast message.',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}
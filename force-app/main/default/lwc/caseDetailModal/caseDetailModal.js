import { LightningElement, api } from 'lwc';

export default class CaseDetailModal extends LightningElement {
    @api isOpen;
    @api caseRecord;

    closeModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}
import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class NewCaseModal extends LightningElement {
    @api parentCaseId;

    subject = '';
    status = 'New';
    priority = 'Medium';

    statusOptions = [
        { label: 'New', value: 'New' },
        { label: 'Working', value: 'Working' },
        { label: 'Escalated', value: 'Escalated' },
        { label: 'Closed', value: 'Closed' }
    ];

    priorityOptions = [
        { label: 'High', value: 'High' },
        { label: 'Medium', value: 'Medium' },
        { label: 'Low', value: 'Low' }
    ];

    handleChange(event) {
        const field = event.target.dataset.field;
        this[field.toLowerCase()] = event.detail.value || event.target.value;
    }

    async handleSave() {
        const detail = {
            parentCaseId: this.parentCaseId,
            Subject: this.subject,
            Status: this.status,
            Priority: this.priority
        };
        this.dispatchEvent(new CustomEvent('createsuccess', { detail }));
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    close() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}
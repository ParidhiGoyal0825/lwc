import { LightningElement } from 'lwc';
import sendEmail from '@salesforce/apex/EmailController.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class NewEmail extends LightningElement {
    modalSizeClass = '';
    isModalOpen = false;

    showCc = false;
    showBcc = false;

    toRecipients = [];
    ccRecipients = [];
    bccRecipients = [];

    subject = '';
    body = '';

    toInputValue = '';
    ccInputValue = '';
    bccInputValue = '';

    toTouched = false;
    showToError = false;

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.modalSizeClass = '';
        this.toRecipients = [];
        this.ccRecipients = [];
        this.bccRecipients = [];
        this.subject = '';
        this.body = '';
        this.toInputValue = '';
        this.ccInputValue = '';
        this.bccInputValue = '';
        this.showCc = false;
        this.showBcc = false;
        this.toTouched = false;
        this.showToError = false;
    }

    toggleCc() {
        this.showCc = !this.showCc;
    }

    toggleBcc() {
        this.showBcc = !this.showBcc;
    }

    minimizeModal() {
        this.modalSizeClass = 'minimized';
    }

    maximizeModal() {
        this.modalSizeClass = 'maximized';
    }

    get computedModalClass() {
        return `compose-container ${this.modalSizeClass}`;
    }

    get toInputClass() {
        return this.showToError ? 'slds-has-error' : '';
    }

    handleChange(event) {
        const field = event.target.dataset.field;
        if (field) {
            this[field] = event.detail.value;

            if (field === 'toInputValue' && this.toTouched) {
                const inputValue = this.toInputValue.trim();
                const validateEmailRegex = /^\S+@\S+\.\S+$/;
                this.showToError = !validateEmailRegex.test(inputValue);
            }
        }
    }

    handleBlur(event) {
        const fieldType = event.target.dataset.fieldType;
        if (fieldType === 'to') {
            this.toTouched = true;
            const inputValue = this.toInputValue.trim();
            const validateEmailRegex = /^\S+@\S+\.\S+$/;
            this.showToError = !inputValue || !validateEmailRegex.test(inputValue);
        }
    }

    handleKeyUp(event) {
        const fieldType = event.target.dataset.fieldType;
        const inputValueField = `${fieldType}InputValue`;
        const recipientListField = `${fieldType}Recipients`;

        const inputValue = this[inputValueField];

        if (event.key === 'Enter' && inputValue && inputValue.trim() !== '') {
            const validateEmailRegex = /^\S+@\S+\.\S+$/;
            if (!validateEmailRegex.test(inputValue)) {
                this[inputValueField] = '';
                return this.dispatchEvent(new ShowToastEvent({
                    title: "Email Validation",
                    message: "Please provide a valid email!",
                    variant: "error"
                }));
            }
            this[recipientListField] = [...this[recipientListField], inputValue.trim()];
            this[inputValueField] = '';
            if (fieldType === 'to') {
                this.showToError = false;
            }
        }
    }

    handleRemoveRecipient(event) {
        const valueToRemove = event.target.dataset.value;
        const field = event.target.dataset.field;
        this[field] = this[field].filter(email => email !== valueToRemove);
    }

    sendEmail() {
        sendEmail({
            to: this.toRecipients.join(','),
            cc: this.ccRecipients.join(','),
            bcc: this.bccRecipients.join(','),
            subject: this.subject,
            body: this.body
        })
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Email sent!',
                    variant: 'success'
                })
            );
            this.closeModal();
        })
        .catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body?.message || 'Unknown error',
                    variant: 'error'
                })
            );
        });
    }
}
import { LightningElement, api, track } from 'lwc';
import sendEmail from '@salesforce/apex/EmailController.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FileEmail extends LightningElement {
    @api recordId;
    @track editors = [{id: 1}];
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
    attachments = [];
    hideTools=true;
    openModal() { this.isModalOpen = true; }
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
        this.attachments = [];
    }
    isEmojiPickerClicked = false;
 emojiList = [
        '😀','😃','😄','😁','😆','😅','😂','🤣','😊','😇','🙂','🙃','😉','😌','😍','🥰','😘','😗','😙','😚',
        '😋','😛','😜','🤪','😝','🤑','🤗','🤭','🤫','🤔','🤐','🤨','😐','😑','😶','😏','😒','🙄','😬','🤥',
        '😌','😔','😪','🤤','😴','😷','🤒','🤕','🤢','🤮','🤧','🥵','🥶','🥴','😵','🤯','🤠','🥳','😎','🤓',
        '🧐','😕','😟','🙁','☹️','😮','😯','😲','😳','🥺','😦','😧','😨','😰','😥','😢','😭','😱','😖','😣',
        '😞','😓','😩','😫','😤','😡','😠','🤬','😈','👿','💀','☠️','💩','🤡','👹','👺','👻','👽','👾','🤖',
        '💋','💌','💘','💝','💖','💗','💓','💞','💕','💟','❣️','💔','❤️','🧡','💛','💚','💙','💜','🖤','🤍',
        '🤎','💯','💢','💥','💫','💦','💨','🕳️','👋','🤚','🖐️','✋','🖖','👌','🤌','🤏','✌️','🤞','🤟','🤘'
    ];


    toggleEmojiPicker(e) {
        this.isEmojiPickerClicked = !this.isEmojiPickerClicked;
    }

    handleEmojiClick(e) {
        this.body += ' ' + e.target.dataset.emoji + ' '; // Adds space before/after emoji
    }

    handleEmojiClick(e) {
        const emoji = e.target.dataset.emoji;
        this.body += ' ' + emoji + ' ';
        const bodyTextarea = this.template.querySelector('[data-id="emailBody"]');
        if (bodyTextarea) {
            bodyTextarea.value = this.body;
        }
    }
    allCategories =  [
        'FORMAT_FONT',
        'FORMAT_TEXT',
        'FORMAT_BODY',
        'ALIGN_TEXT',
        'INSERT_CONTENT',
        'REMOVE_FORMATTING'
    ];
    get disabledCategoriesString() {
        return this.hideTools ? this.allCategories.join(',') : 'INSERT_CONTENT';
    }
    toggleEditText(e) {
        console.log(this.hideTools);
        console.log(this.body);
        this.editors = [{id: Date.now()}];
        this.hideTools = !this.hideTools;
    }
    toggleCc() { this.showCc = !this.showCc; }
    toggleBcc() { this.showBcc = !this.showBcc; }
    minimizeModal() { this.modalSizeClass = 'minimized'; }
    maximizeModal() { this.modalSizeClass = 'maximized'; }

    get computedModalClass() {
        return `compose-container ${this.modalSizeClass}`;
    }

    handleChange(event) {
        const field = event.target.dataset.field;
        if (field) {
            this[field] = event.target.value;
            if (field === 'toInputValue' && this.toTouched) {
                this.showToError = !this.validateEmail(this.toInputValue);
            }
        }
    }

    handleBlur(event) {
        if (event.target.dataset.fieldType === 'to') {
            this.toTouched = true;
            this.showToError =  this.toInputValue && this.toInputValue.length > 0 && !this.validateEmail(this.toInputValue);
        }
    }

    handleKeyUp(event) {
        const fieldType = event.target.dataset.fieldType;
        const inputValueField = `${fieldType}InputValue`;
        const recipientListField = `${fieldType}Recipients`;
        const inputValue = this[inputValueField]?.trim();

        if (event.key === 'Enter' && inputValue) {
            if (this.validateEmail(inputValue)) {
                this[recipientListField] = [...this[recipientListField], inputValue];
                this[inputValueField] = '';
                if(this[inputValueField]=='') this.showToError=false;
                if (fieldType === 'to') this.showToError = false;
            } else {
                if (fieldType === 'to') this.showToError = true;
                this.dispatchEvent(new ShowToastEvent({
                    title: "Email Validation",
                    message: "Please provide a valid email!",
                    variant: "error"
                }));
            }
        }
    }

    handleRemoveRecipient(event) {
        const valueToRemove = event.target.dataset.value;
        const field = event.target.dataset.field;
        this[field] = this[field].filter(email => email !== valueToRemove);
    }

    handleRemoveFile(event) {
        const fileId = event.target.dataset.fileId;
        this.attachments = this.attachments.filter(file => file.id !== fileId);
    }

    handleFileChange(event) {
        const files = event.target.files;
        if (files.length > 0) {
            const file = files[0];
            const reader = new FileReader();
            reader.onloadend = () => {
                const base64Data = reader.result.split(',')[1];
                const id = file.name + file.type;
                const newFile = {
                    id,
                    fileName: file.name,
                    fileType: file.type,
                    base64Data
                };
                this.attachments = [...this.attachments, newFile];
            };
            reader.readAsDataURL(file);
        }
    }

    handleFileUpload() {
        const uploader = this.template.querySelector('.uploader');
        if (uploader) {
            uploader.click();
        }
    }

    sendEmail() {
        if (this.toRecipients.length === 0) {
            return this.dispatchEvent(new ShowToastEvent({
                title: "To Address",
                message: "To address is required! Please provide the recipient address!",
                variant: "error"
            }));
        }
    
       
        if (this.toInputValue.trim() !== '' || this.ccInputValue.trim() !== '' || this.bccInputValue.trim() !== '') {
            return this.dispatchEvent(new ShowToastEvent({
                title: "Incomplete Data",
                message: "Please verify and complete the incomplete information!",
                variant: "warning"
            }));
        }
    
        sendEmail({
            to: this.toRecipients.join(','),
            cc: this.ccRecipients.join(','),
            bcc: this.bccRecipients.join(','),
            subject: this.subject, // subject still sent, but no validation
            body: this.body,
            jsonFiles: JSON.stringify(this.attachments)
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

    validateEmail(email) {
        return /^\S+@\S+\.\S+$/.test(email);
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
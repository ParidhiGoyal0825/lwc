import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LEAVE_REQUEST_CHANNEL from '@salesforce/messageChannel/leaveRequestChannel__c';
import { publish, MessageContext } from 'lightning/messageService';


export default class LeaveRequestFormPublisher extends LightningElement {
    @wire(MessageContext) messageContext;

  handleSuccess(event) {
    const recordId = event.detail.id;
    this.dispatchEvent(new ShowToastEvent({
      title: 'Success',
      message: 'Leave Request submitted!',
      variant: 'success'
    }));

    publish(this.messageContext, LEAVE_REQUEST_CHANNEL, {
      recordId,
      action: 'created'
    });
  }
}
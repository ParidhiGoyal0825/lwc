import { LightningElement, wire, track } from 'lwc';
import getPendingRequestsForManager from '@salesforce/apex/leaveRequestController.getPendingRequestsForManager';
import updateLeaveStatus from '@salesforce/apex/leaveRequestController.updateLeaveStatus';
import { refreshApex } from '@salesforce/apex';
import LEAVE_REQUEST_CHANNEL from '@salesforce/messageChannel/leaveRequestChannel__c';
import { subscribe, MessageContext } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class LeaveRequestTableSubscriber extends LightningElement {
    @track leaveRequests = [];
  wiredResult;

  columns = [
    { label: 'Employee', fieldName: 'Employee__r.Name' },
    { label: 'Leave Type', fieldName: 'Leave_Type__c' },
    { label: 'From', fieldName: 'From_Date__c', type: 'date' },
    { label: 'To', fieldName: 'To_Date__c', type: 'date' },
    { label: 'Reason', fieldName: 'Reason__c' },
    {
      type: 'button', typeAttributes: {
        label: 'Approve', name: 'approve', variant: 'brand'
      }
    },
    {
      type: 'button', typeAttributes: {
        label: 'Reject', name: 'reject', variant: 'destructive'
      }
    }
  ];

  @wire(getPendingRequestsForManager)
  wiredRequests(result) {
    this.wiredResult = result;
    if (result.data) this.leaveRequests = result.data;
  }

  @wire(MessageContext) messageContext;
  connectedCallback() {
    subscribe(this.messageContext, LEAVE_REQUEST_CHANNEL, () => refreshApex(this.wiredResult));
  }

  async handleRowAction(event) {
    const status = event.detail.action.name === 'approve' ? 'Approved' : 'Rejected';
    try {
      await updateLeaveStatus({ leaveId: event.detail.row.Id, newStatus: status });
      this.dispatchEvent(new ShowToastEvent({
        title: 'Success',
        message: `Leave ${status}`,
        variant: 'success'
      }));
      await refreshApex(this.wiredResult);
    } catch (error) {
      console.error(error);
    }
  }
}
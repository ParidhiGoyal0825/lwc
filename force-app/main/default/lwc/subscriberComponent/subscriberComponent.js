import { LightningElement,api, wire } from 'lwc';
import MyMessageChannel from '@salesforce/messageChannel/myfirstChannel__c';
import { MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
export default class SubscriberComponent extends LightningElement {
    @api value = '';
    subscription = null;

    @wire(MessageContext) messageContext;

    connectedCallback() {
        this.handelSubscribe();
    }

    disconnectedCallback() {
        this.handelUnsubscribe();
    }

    handelSubscribe() {
        if (!this.subscription) {
            this.subscription =subscribe(this.messageContext,MyMessageChannel, (parameter) => {
                        this.value = parameter.value;
                    });
        }
    }
    handelUnsubscribe() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
}
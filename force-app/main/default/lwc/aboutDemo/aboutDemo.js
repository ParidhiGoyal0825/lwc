import { LightningElement,api,wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountforLwc.getAAllccounts';
export default class AboutDemo extends LightningElement {
    @api recordId;
    @wire (getAccounts) accounts;
}
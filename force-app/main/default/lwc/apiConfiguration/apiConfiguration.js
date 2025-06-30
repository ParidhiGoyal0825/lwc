import { LightningElement, wire, track } from 'lwc';
import getConfig from '@salesforce/apex/ApiConfig.getConfig';
import saveConfig from '@salesforce/apex/ApiConfig.saveConfig';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ApiConfiguration extends LightningElement {
   @track endpointUrl = '';
    @track refreshToken = '';
    @track clientId = '';
    @track clientSecret = '';

    @wire(getConfig)
    wiredConfig({ error, data }) {
        if (data) {
            this.endpointUrl = data.Endpoint_URL__c || '';
            this.refreshToken = data.Refresh_Token__c || '';
            this.clientId = data.Client_ID__c || '';
            this.clientSecret = data.Client_Secret__c || '';
        } else if (error) {
            console.error('Error loading config:', error);
        }
    }

    handleChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleSave() {
        saveConfig({
            endpointUrl: this.endpointUrl,
            refreshToken: this.refreshToken,
            clientId: this.clientId,
            clientSecret: this.clientSecret
        })
        .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Configuration saved successfully!',
                variant: 'success'
            }));
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            }));
        });
    }
}
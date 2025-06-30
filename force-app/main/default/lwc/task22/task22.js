import { LightningElement, track } from 'lwc';
import getRecords from '@salesforce/apex/recordFetcher.getRecords';
export default class Task22 extends LightningElement {
    @track objectName = '';
    @track fieldsCSV = '';
    @track columns = [];
    @track records = [];

    handleObjectChange(event) {
        this.objectName = event.detail.value;
    }

    handleFieldsChange(event) {
        this.fieldsCSV = event.detail.value;
    }

    async loadRecords() {
        if (!this.objectName || !this.fieldsCSV) {
            alert('Please enter both object name and fields.');
            return;
        }

        const fieldList = this.fieldsCSV.split(',').map(f => f.trim());
        this.columns = fieldList.map(f => ({
            label: f,
            fieldName: f,
            type: 'text'
        }));

        try {
            const data = await getRecords({
                objectName: this.objectName,
                fieldsCSV: this.fieldsCSV
            });
            this.records = data;
        } catch (error) {
            console.error(error);
            alert('Error loading records. Check object and field names.');
        }
    }
}
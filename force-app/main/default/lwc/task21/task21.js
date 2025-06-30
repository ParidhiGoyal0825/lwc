import { LightningElement, track } from 'lwc';
import getRecordData from '@salesforce/apex/recordFetcher.getRecordData';
export default class Task21 extends LightningElement {
    @track originalRecordId = '';
    @track clonedRecordId = '';
    @track fieldDiffs = [];
    @track error;

    handleOriginalRecordChange(event) {
        this.originalRecordId = event.target.value;
    }

    handleClonedRecordChange(event) {
        this.clonedRecordId = event.target.value;
    }

    get areRecordsSelected() {
        return this.originalRecordId && this.clonedRecordId;
    }

    async compareRecords() {
        try {
            const result = await getRecordData({
                originalId: this.originalRecordId,
                clonedId: this.clonedRecordId
            });
            this.fieldDiffs = this.compareRecordsData(result.original, result.cloned);
            this.error = undefined;
        } catch (error) {
            console.error('Error:', error);
            this.error = error.body ? error.body.message : error.message;
            this.fieldDiffs = [];
        }
    }

    compareRecordsData(original, cloned) {
        let differences = [];
        for (let field in original) {
            if (original[field] !== cloned[field]) {
                differences.push({
                    fieldName: field,
                    originalValue: original[field] || '---',
                    clonedValue: cloned[field] || '---'
                });
            }
        }
        return differences;
    }
}
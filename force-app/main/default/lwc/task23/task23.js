import { LightningElement, track } from 'lwc';
import searchRecords from '@salesforce/apex/recordFetcher.searchRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Task23 extends LightningElement {
    @track objectApiName = '';
   @track searchField = '';
   @track searchKeyword = '';
   @track results = [];
   @track selectedLabel = '';

   // Input field handlers
   handleObjectChange(event) {
       this.objectApiName = event.target.value;
   }

   handleFieldChange(event) {
       this.searchField = event.target.value;
   }

   handleKeywordChange(event) {
       this.searchKeyword = event.target.value;
   }

   // Search button click
   handleSearch() {
       if (this.objectApiName && this.searchField && this.searchKeyword) {
           searchRecords({
               objectApiName: this.objectApiName,
               searchField: this.searchField,
               searchKeyword: this.searchKeyword
           })
               .then(data => {
                   // Preprocess results: Add displayLabel
                   this.results = data.map(record => ({
                       ...record,
                       displayLabel: record[this.searchField] || 'No Label'
                   }));
                   if (this.results.length === 0) {
                       this.showToast('No Results', 'No matching records found.', 'info');
                   }
               })
               .catch(error => {
                   this.showToast('Error', error.body.message, 'error');
                   console.error('Error:', error);
               });
       } else {
           this.showToast('Validation Error', 'Please fill all fields.', 'warning');
       }
   }

   // When user clicks on a result
   handleSelect(event) {
       const recordId = event.currentTarget.dataset.id;
       const selectedRecord = this.results.find(rec => rec.Id === recordId);
       this.selectedLabel = selectedRecord ? selectedRecord.displayLabel : '';
       this.showToast('Selected', `You selected: ${this.selectedLabel}`, 'success');
   }

   // Toast helper
   showToast(title, message, variant) {
       this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
   }
}
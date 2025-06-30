import { LightningElement, track } from 'lwc';
import getFilteredCases from '@salesforce/apex/CaseController.getFilteredCases';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateCaseStatus from '@salesforce/apex/CaseController.updateCaseStatus';
export default class OpenCasesTable extends LightningElement {
    @track draftValues = [];
    @track cases = [];
    @track searchKey = '';
    @track priorityFilter = '';
    @track statusFilter = '';
    @track sortedBy = '';
    @track sortedDirection = '';
    @track isModalOpen = false;
    @track selectedCase = {};

    columns = [
        { label: 'Case Number', fieldName: 'CaseNumber', type: 'text' }, // not sortable
        { label: 'Subject', fieldName: 'Subject', type: 'text' },         // not sortable
        { label: 'Priority', fieldName: 'Priority', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: true, editable: true },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', sortable: true },
        {
            type: 'button',
            typeAttributes: {
                label: 'View',
                name: 'view_details',
                title: 'View Details',
                variant: 'base'
            }
        }
    ];

    connectedCallback() {
        this.loadCases();
    }

    loadCases() {
        getFilteredCases({
            searchKey: this.searchKey,
            priorityFilter: this.priorityFilter,
            statusFilter: this.statusFilter
        })
        .then(result => {
            this.cases = result;
            if (this.sortedBy) {
                this.sortData(this.sortedBy, this.sortedDirection);
            }
        })
        .catch(error => {
            console.error('Error fetching cases:', error);
        });
    }
    handleModalClose() {
        this.isModalOpen = false;
    }
    handleSearchChange(event) {
        this.searchKey = event.target.value;
        this.loadCases();
    }

    handlePriorityFilterChange(event) {
        this.priorityFilter = event.target.value;
        this.loadCases();
    }
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
    
        if (actionName === 'view_details') {
            this.selectedCase = row;
            this.isModalOpen = true;
        }
    }
    handleStatusFilterChange(event) {
        this.statusFilter = event.target.value;
        this.loadCases();
    }


    get priorityOptions() {
        return [
            { label: 'All', value: '' },
            { label: 'High', value: 'High' },
            { label: 'Medium', value: 'Medium' },
            { label: 'Low', value: 'Low' }
        ];
    }
    handleSave(event) {
        const updatedFields = event.detail.draftValues;
    
        updateCaseStatus({ updatedCases: updatedFields })
            .then(() => {
                this.showToast('Success', 'Case status updated successfully', 'success');
                this.draftValues = [];
                return this.loadCases(); // Reload data
            })
            .catch(error => {
                console.error(error);
                this.showToast('Error', 'Error updating case status', 'error');
            });
    }
    
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(evt);
    }
    get statusOptions() {
        return [
            { label: 'All', value: '' },
            { label: 'New', value: 'New' },
            { label: 'In Progress', value: 'In Progress' },
            { label: 'Closed', value: 'Closed' }
        ];
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        
        // Allow sort only for Priority, Status, CreatedDate
        if (fieldName === 'Priority' || fieldName === 'Status' || fieldName === 'CreatedDate') {
            this.sortedBy = fieldName;
            this.sortedDirection = sortDirection;
            this.sortData(fieldName, sortDirection);
        }
    }

    sortData(field, direction) {
        const sorted = [...this.cases].sort((a, b) => {
            let valA = a[field];
            let valB = b[field];

            if (valA === null) valA = '';
            if (valB === null) valB = '';

            if (field === 'CreatedDate') {
                valA = new Date(valA);
                valB = new Date(valB);
            } else {
                valA = valA.toString().toLowerCase();
                valB = valB.toString().toLowerCase();
            }

            let comparison = 0;
            if (valA > valB) {
                comparison = 1;
            } else if (valA < valB) {
                comparison = -1;
            }
            return direction === 'asc' ? comparison : comparison * -1;
        });

        this.cases = sorted;
    }

}
import { LightningElement, api, track } from 'lwc';
import getImmediateChildCases from '@salesforce/apex/CaseTask.getImmediateChildCases';
import getCaseById from '@salesforce/apex/CaseTask.getCaseById';
import deleteCaseById from '@salesforce/apex/CaseTask.deleteCaseById';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseHierarchy extends LightningElement {
    @api recordId;
    @track rows = [];
    @track showCreateModal = false;
    @track showEditModal = false;
    @track currentParentId;
    @track editRecordId;

    deletedCaseIds = new Set();

    columns = [
        { label: 'Case Number', fieldName: 'CaseNumber' },
        { label: 'Contact Name', fieldName: 'ContactName' },
        { label: 'Subject', fieldName: 'Subject' },
        { label: 'Status', fieldName: 'Status' },
        { label: 'Priority', fieldName: 'Priority' },
        { label: 'Created Date', fieldName: 'CreatedDate' },
        { label: 'Owner Alias', fieldName: 'OwnerAlias' },
        { label: 'Actions', fieldName: 'Actions', isAction: true }
    ];

    connectedCallback() {
        getCaseById({ caseId: this.recordId })
            .then(c => {
                const root = this.flattenCase(c, 0, c.ParentId);
                this.rows = [root];
                this.rows = [...this.rows];
            })
            .catch(error => {
                this.toast('Error loading root case', error.body?.message || error.message, 'error');
            });
    }

    loadRootCase() {
        getImmediateChildCases({ parentCaseId: null })
            .then(cases => {
                const root = cases.find(c => c.Id === this.recordId);
                if (root) {
                    this.rows[0] = this.flattenCase(root, 0, null);
                    this.rows = [...this.rows];
                }
            })
            .catch(error => {
                this.toast('Error', error.body?.message || error.message, 'error');
            });
    }

    handleToggle(event) {
        const caseId = event.currentTarget.dataset.id;
        const index = this.rows.findIndex(r => r.Id === caseId);
        const parent = this.rows[index];

        if (parent.expanded) {
            this.rows = this.rows.filter(row => !this.isDescendantOf(row, caseId));
            this.rows[index].expanded = false;
            this.rows = [...this.rows];
        } else {
            let children = this.rows.filter(r => r.parentId === caseId);
            if (children.length === 0) {
                getImmediateChildCases({ parentCaseId: caseId })
                    .then(fetched => {
                        const filtered = fetched.filter(c => !this.deletedCaseIds.has(c.Id));
                        children = filtered.map(c => this.flattenCase(c, parent.level + 1, caseId));
                        const updatedRows = [...this.rows];
                        updatedRows.splice(index + 1, 0, ...children);
                        updatedRows[index].expanded = true;
                        updatedRows[index].childrenLoaded = true;
                        this.rows = updatedRows;
                    })
                    .catch(error => {
                        this.toast('Error loading children', error.body?.message || error.message, 'error');
                    });
            } else {
                this.rows.splice(index + 1, 0, ...children);
                this.rows[index].expanded = true;
                this.rows = [...this.rows];
            }
        }
    }

    handleActionSelect(event) {
        const caseId = event.currentTarget.dataset.id;
        const action = event.detail.value;

        if (action === 'new') {
            this.currentParentId = caseId;
            this.showCreateModal = true;
        } else if (action === 'edit') {
            this.editRecordId = caseId;
            this.showEditModal = true;
        } else if (action === 'delete') {
            this.deleteCase(caseId);
        } else if (action === 'email') {
            this.handleSendEmail({ currentTarget: { dataset: { id: caseId } } });
        }
    }

    deleteCase(caseId) {
        deleteCaseById({ caseId })
            .then(() => {
                this.deletedCaseIds.add(caseId);
                this.rows = this.rows.filter(row => row.Id !== caseId && row.parentId !== caseId);
                this.rows = [...this.rows];
                this.toast('Deleted', 'Case removed', 'success');
            })
            .catch(error => {
                this.toast('Delete Failed', error.body?.message || error.message, 'error');
            });
    }

    closeCreateModal() {
        this.showCreateModal = false;
    }

    closeEditModal() {
        this.showEditModal = false;
    }

    handleCreateSuccess(event) {
        this.showCreateModal = false;
        const newCaseId = event.detail.id;
        const parentId = this.currentParentId;

        const parentIndex = this.rows.findIndex(r => r.Id === parentId);
        if (parentIndex === -1) return;

        const parentRow = this.rows[parentIndex];
        const parentLevel = parentRow.level;

        getImmediateChildCases({ parentCaseId: parentId })
            .then(updatedChildren => {
                const childrenRows = updatedChildren
                    .filter(child => !this.deletedCaseIds.has(child.Id))
                    .map(child => this.flattenCase(child, parentLevel + 1, parentId));

                const newRows = this.rows.filter(r => r.parentId !== parentId);
                newRows.splice(parentIndex + 1, 0, ...childrenRows);
                newRows[parentIndex].expanded = true;
                newRows[parentIndex].childrenLoaded = true;

                this.rows = [...newRows];
            })
            .catch(err => {
                this.toast('Error', err.body?.message || err.message, 'error');
            });
    }

    handleEditSuccess(event) {
        this.showEditModal = false;
        const updatedId = event.detail.id;

        const rowIndex = this.rows.findIndex(r => r.Id === updatedId);
        if (rowIndex === -1) return;

        const level = this.rows[rowIndex].level;
        const parentId = this.rows[rowIndex].parentId;

        getCaseById({ caseId: updatedId })
            .then(updatedCase => {
                const newRow = this.flattenCase(updatedCase, level, parentId);
                const updatedRows = [...this.rows];
                updatedRows.splice(rowIndex, 1, newRow);
                this.rows = updatedRows;
            })
            .catch(err => {
                this.toast('Error', err.body?.message || err.message, 'error');
            });
    }

    flattenCase(c, level, parentId) {
        return {
            Id: c.Id,
            CaseNumber: c.CaseNumber,
            ContactName: c.ContactName || '',
            Subject: c.Subject,
            Status: c.Status,
            Priority: c.Priority,
            CreatedDate: this.formatDate(c.CreatedDate),
            OwnerAlias: c.OwnerAlias || '',
            level,
            expanded: false,
            childrenLoaded: false,
            parentId
        };
    }
// Twesthhkjkjhk
    isDescendantOf(row, ancestorId) {
        while (row && row.parentId) {
            if (row.parentId === ancestorId) return true;
            row = this.rows.find(r => r.Id === row.parentId);
        }
        return false;
    }
formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are 0-based
    const year = date.getFullYear();
    return `${day}/${month}/${year}`; // Format: dd/MM/yyyy
}
    get computedRows() {
        return this.rows.map(row => {
            const displayCells = this.columns.map(col => {
                const isCaseLink = col.fieldName === 'CaseNumber';
                return col.isAction
                    ? { isAction: true, rowId: row.Id, key: `${row.Id}_action` }
                    : {
                        value: row[col.fieldName] || '',
                        isAction: false,
                        isLink: isCaseLink,
                        url: isCaseLink ? `/lightning/r/Case/${row.Id}/view` : null,
                        key: `${row.Id}_${col.fieldName}`
                    };
            });

            let rowClass = '';
            switch ((row.Priority || '').toLowerCase()) {
                case 'high': rowClass = 'priority-high'; break;
                case 'medium': rowClass = 'priority-medium'; break;
                case 'low': rowClass = 'priority-low'; break;
            }

            return {
                ...row,
                displayCells,
                rowClass,
                icon: row.expanded ? 'utility:chevrondown' : 'utility:chevronright',
                buttonClass: `slds-m-left_x-small indent-level-${row.level}`
            };
        });
    }

    toast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
import { LightningElement, api } from 'lwc';
export default class TestCMP extends LightningElement {
    @api recordId;

    connectedCallback() {
        console.log('record found :: ', this.recordId);
    }
}
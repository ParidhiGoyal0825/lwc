import { LightningElement } from 'lwc';

export default class Task2 extends LightningElement {
    firstName = '';
    lastName = '';
    emailName = '';
    phoneNumber = '';
    titledescription = '';

    handleChange(event) {

        if (event.target.name === 'First Name') {
            this.firstName = event.target.value;
        } else if (event.target.name === 'Last Name') {
            this.lastName = event.target.value;
        } else if (event.target.name === 'email') {
            this.emailName = event.target.value;
        } else if (event.target.name === 'Phone Number') {
            this.phoneNumber = event.target.value;
        } else if (event.target.name === 'title') {
            this.titledescription = event.target.value;
        }
    }
}
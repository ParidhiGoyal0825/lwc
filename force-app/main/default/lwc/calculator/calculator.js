import { LightningElement } from 'lwc';

export default class Calculator extends LightningElement {
    num1 = 0;
    num2 = 0;
    result = 0;

    numChange(event) {
        if (event.target.name === 'num1') {
            this.num1 = parseFloat(event.target.value);
        } else if (event.target.name === 'num2') {
            this.num2 = parseFloat(event.target.value);
        }
    }

    add() {
        this.result = this.num1 + this.num2;
    }

    subtract() {
        this.result = this.num1 - this.num2;
    }

    multiply() {
        this.result = this.num1 * this.num2;
    }

    divide() {
        if (this.num2 !== 0) {
            this.result = this.num1 / this.num2;
        } else {
            this.result = 'Cannot divide by zero';
        }
    }
}
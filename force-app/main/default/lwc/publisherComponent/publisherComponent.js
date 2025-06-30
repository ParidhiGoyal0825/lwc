import { LightningElement,wire} from 'lwc';
import getAccounts from '@salesforce/apex/AccountforLwc.getAccounts';
import MyMessageChannel from'@salesforce/messageChannel/myfirstChannel__c';
import { MessageContext, publish }from 'lightning/messageService';
export default class PublisherComponent extends LightningElement {
    value;
    myArr=[];

    @wire(MessageContext) messageContext;

    @wire(getAccounts) getAcc({data,error}){
        if(data){
            let arr=[];
            for(let i=0;i<data.length;i++){
                arr.push({label:data[i].Name,value:data[i].Id});
            }
            this.myArr=arr;
        }
        else if(error){
            console.log(error);
        }
    }

    handleChange(event){
        this.value=event.target.value;
        // code to publish the data
        let payload = {value: this.value};
        publish(this.messageContext,MyMessageChannel, payload)
        }
    

    get options(){
        return this.myArr;
    }
}
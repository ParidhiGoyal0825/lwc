import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountforLwc.getAccounts';
import getContact from '@salesforce/apex/AccountforLwc.getContact';
const columns=[
    {label: 'Id',fieldName: 'Id'},
   {label: 'Contact name',fieldName: 'LastName'},
    {label: 'Email',fieldName: 'Email',type:'email'}
 ]
export default class Task10 extends LightningElement {
    @track columns=columns;
   data;
   value;
   myArr=[];

 
   @wire(getAccounts)allAcc({data,error}){
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
       getContact({accId:this.value}).then(data=>{
           this.data=data;
       }).catch(error=>{
           console.log(error);
        })
}

get options(){
    return this.myArr;
}
}
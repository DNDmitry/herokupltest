import { LightningElement,api,wire, track } from 'lwc';
import getLastContact from '@salesforce/apex/NewestContactByAccount.getLastContact';

import getHelloMessage from '@salesforce/apex/MessageMaker.getHelloMessage';

 
export default class RecordIdExample extends LightningElement {
      @track cardTitle = 'Newest contact';
      @api recordId;
      @wire(getLastContact, {accId:'$recordId' })
      contact;

      @wire(getHelloMessage,{accId:'$recordId'})
      message;


}
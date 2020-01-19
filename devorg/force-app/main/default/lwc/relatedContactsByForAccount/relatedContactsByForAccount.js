/* eslint-disable no-alert */
/* eslint-disable no-console */
import { LightningElement, wire, track, api } from 'lwc';
import getContactsByAccount from '@salesforce/apex/CuteContactController.getContactsByAccount';
import { updateRecord, createRecord } from 'lightning/uiRecordApi';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

const COLUMNS = [
    { label: 'First Name', fieldName: 'FirstName', editable: true },
    { label: 'Last Name', fieldName: 'LastName', editable: true },
    { label: 'Title', fieldName: 'Title', editable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'phone', editable: true },
    { label: 'Email', fieldName: 'Email', type: 'email', editable: true }
];

export default class RelatedContactsByForAccount extends LightningElement {
    @track columns = COLUMNS;
    @track draftValues = [];
    @api recordId;    
    @track recordsCount = 0;

    selectedRecords = [];
    @track isDeleteButtonDisabled = true;

    @wire(getContactsByAccount, {accountId:'$recordId'})
    contacts;

    handleSave(event) {

        const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);            
            return { fields };
        });
        
        let promises = new Set();
        for(let i = 0; i < recordInputs.length; i++){
            if(JSON.stringify(recordInputs[i].fields.Id).includes('row-')){
                delete recordInputs[i].fields.Id;
                recordInputs[i].fields.AccountId = this.recordId;
                recordInputs[i].apiName = CONTACT_OBJECT.objectApiName;
                promises.add(createRecord(recordInputs[i]))
            }
            else{              
                promises.add(updateRecord(recordInputs[i]));
            }
        }

        Promise.all(promises).then(records => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contacts updated',
                    variant: 'success'
                })
            );
            this.draftValues = [];
            return refreshApex(this.contacts);
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });        
    }

    
    addContact(){
        let newContact = {Id:"",FirstName:"",LastName:"",Title:"",Phone:"",Email:""}
        this.contacts.data = [...this.contacts.data, newContact];
    }

    getSelectedRecords(event) {
        const selectedRows = event.detail.selectedRows;        
        this.recordsCount = event.detail.selectedRows.length;
        let conIds = new Set();

        for (let i = 0; i < selectedRows.length; i++) {
            conIds.add(selectedRows[i].Id);
        }
        this.selectedRecords = Array.from(conIds);
        if(this.recordsCount > 0){
            this.isDeleteButtonDisabled = false;
        }
        else{
            this.isDeleteButtonDisabled = true;
        }
    }

    deleteContacts(){
        if(this.selectedRecords){
            let promises = new Set();
            for(let i = 0; i < this.selectedRecords.length; i++){
                promises.add(deleteRecord(this.selectedRecords[i]));
            }
        
            Promise.all(promises).then(records =>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact deleted',
                        variant: 'success'
                    })
                );                
                this.selectedRecords = [];
                this.isDeleteButtonDisabled = true;
                return refreshApex(this.contacts);
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            }); 
        }
    }

}
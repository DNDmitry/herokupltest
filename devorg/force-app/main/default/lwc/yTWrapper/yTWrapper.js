import { LightningElement,api } from 'lwc';

export default class YTWrapper extends LightningElement {
    @api ytId;
    changeYTId(event){
        this.ytId = event.target.value;
    }
}
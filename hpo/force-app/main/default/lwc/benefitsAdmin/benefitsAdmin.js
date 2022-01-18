import { LightningElement, wire, api } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import BENEFIT_OBJECT from '@salesforce/schema/Benefit__c';
import TYPE_FIELD from '@salesforce/schema/Benefit__c.Type__c';
import createUpdateMetadata from '@salesforce/apex/createUpdateMetadataUtils.createUpdateMetadata';
import fetchBenefitSettings from '@salesforce/apex/CreateUpdateMetadataUtils.fetchBenefitSettings';

export default class BenefitsAdmin extends LightningElement {
    addBenefit;
    deleteBenefit;
    donationAmount;
    benefitsSelected = [];
    numberRecords = [];
    dollarValues = [];
    isExecuting = false;

    @wire(getObjectInfo, { objectApiName: BENEFIT_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: TYPE_FIELD } )
    pickListValues;

    @wire(fetchBenefitSettings)
    benefitSettings;

    handleAddInput(e) {
        this.addBenefit = e.target.value; //oncommit doesn't return detail params
    }

    handleAddBenefit() {
        //TODO 
        alert('The following benefit would be added: ' + this.addBenefit);
        this.addBenefit = null;
    }

    handleDeleteBenefit(e) {
        // TODO 
        alert('The following benefit would be deleted: ' + this.deleteBenefit);
        this.deleteBenefit = null;
    }

    getDonationAmount(e) {
        this.donationAmount = e.target.value;
    }

    getBenefitsSelected(e) {
        var exists = false;
        for (var i=0; i < this.benefitsSelected.length; i++) {
            e.target.label == this.benefitsSelected[i].label ? exists = true : null;
        }
        if (exists == false) {
            this.benefitsSelected.push( {'label':e.target.label, 'value':e.detail.checked} );
        } else {
            // get input in list and change value
        }
    }

    getNumberRecords(e) {
        var exists = false;
        for (var i=0; i < this.numberRecords.length; i++) {
            e.target.name == this.numberRecords[i].label ? exists = true : null;
        }
        if (exists == false) {
            this.numberRecords.push( {'label':e.target.name, 'value':e.target.value} ); //oncommit doesn't return detail params
        } else {
            // get input in list and change value
        }
    }

    getDollarValues(e) {
        var exists = false;
        for (var i=0; i < this.dollarValues.length; i++) {
            e.target.name == this.dollarValues[i].label ? exists = true : exists = false;
        }
        if (exists == false) {
            this.dollarValues.push( {'label':e.target.name, 'value':e.target.value} ); //oncommit doesn't return detail params
        } else {
            // get input in list and change value
        }
    }

    @api async handleSubmit() {    
        if (this.isExecuting) {
            return;
        }

        this.isExecuting = true;

        var donationAmount = this.donationAmount;
        var donAmtStr = Math.round(donationAmount).toString();
        var label;
        var apiName;
        var fullName;
        var isActive;
        var number;
        var dollarValue;

        for (var obj of this.benefitsSelected) {
            label = obj['label'];
            apiName = label.split(' ').join('') + 'At' + donAmtStr;
            fullName = 'Benefit_Setting' + '.' + apiName;

            isActive = true;

            for (var obj of this.numberRecords) {
                obj['label'] == label ? number = obj['value'] : null;
            }
            
            for (var obj of this.dollarValues) {
                obj['label'] == label ? dollarValue = obj['value'] : null;
            }

            // doing less efficient deploy to try to resolve internal server error 500
            var wrapper = {
                fullName: fullName,
                label: label,
                isActive: isActive, 
                numberRecords: number, 
                dollarValue: dollarValue,
                donationAmount: donationAmount
            };

            await createUpdateMetadata({wrapperJSON:JSON.stringify(wrapper)})
                .then(result => {
                    // TODO dispatch event with spinner
                })
                .catch(error => {
                    // TODO dispatch event with spinner
                });            
        }

        // clear properties for next time
        this.donationAmount = null;
        this.benefitsSelected = [];
        this.numberRecords = [];
        this.dollarValues = [];
        
        //TODO reset inputs

        this.isExecuting = false;
    }
}
({
    removeMultiplePhaseRec: function (component) {
        component.getEvent("CPFApplicationFinAcctobeclosed").setParams({
            "RowIndex" : component.get("v.rowindex")
        }).fire();
    },
    
    
    addAccount : function(component, event) {
        var facacountlist = component.get("v.newFacilityAccountMulti");
        facacountlist.push({
            'sobjectType' : 'Application_Financial_Account__c',
            'Existing_Number__c' : '',
            'Existing_Account_Number__c' : '',
            'Outstanding_Balance__c' : '',
            'Balance_as_at__c' : '',
            'Account_to_be_closed__c' : 'No',
            'Phase_Number__c' : component.get('v.accItem.Phase_Number__c'),
        });
        component.set("v.newFacilityAccountMulti",facacountlist);
    },
    AddOtherFees : function(component, event) {
        var otherFeesdetails = component.get("v.newFeesOtherFaciMulti");
        otherFeesdetails.push({
            'sobjectType' : 'Application_Fees__c',
            'Phase_Number__c' : component.get('v.accItem.Phase_Number__c'),
            'Type__c':'Facility'
            
            
        });
        component.set("v.newFeesOtherFaciMulti",otherFeesdetails);
    },
    AddOtherFeesbtn : function(component, event) {
        var otherFeesdetails = component.get("v.newFeesOtherFeesMulti");
        otherFeesdetails.push({
            'sobjectType' : 'Application_Fees__c',
            'Include_other_fee_in_total_facility__c':'No',
            'Phase_Number__c' : component.get('v.accItem.Phase_Number__c'),
            'Type__c':'Fees Details'
            
        });
        component.set("v.newFeesOtherFeesMulti",otherFeesdetails);
    },
})
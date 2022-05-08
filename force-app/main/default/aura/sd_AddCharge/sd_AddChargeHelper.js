({
    createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.chargeList");
        RowItemList.push({
            'sobjectType': 'Charge__c',
            'Charge_Account_No__c': '',
            'Charge_Amount__c': '',
            'Transaction_Code__c': '',
            'Corp_Code__c':'',
            'Cost_Centre__c':'',
            'Sub_ledger__c':'',
            'CR_Ref__c':'',
            'DR_Ref__c':'',
            'CR_Account_No__c':'',
            'Effective_Date__c':'',
            'Case__c':component.get("v.recordId")
            
            
        });
        // set the updated list to attribute (contactList) again    
        component.set("v.chargeList", RowItemList);
    },
    // helper function for check if first Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
        var allContactRows = component.get("v.chargeList");
        
        for(var i =0;i<allContactRows.length;i++){
            if(!allContactRows[i].Charge_Account_No__c){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "INCOMPLETE!",
                    "message": "Missing Charge Account No# on row "+(i+1),
                    "type":"error"
                });
                toastEvent.fire();
                
                return false;
            }
            if(!allContactRows[i].Charge_Amount__c){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "INCOMPLETE!",
                    "message": "Missing Charge amount on row "+(i+1),
                    "type":"error"
                });
                toastEvent.fire();
                return false;
            }
            if(!allContactRows[i].Cost_Centre__c){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "INCOMPLETE!",
                    "message": "Missing cost centre on row "+(i+1),
                    "type":"error"
                });
                toastEvent.fire();
                return false;
            }
            if(!allContactRows[i].CR_Ref__c){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "INCOMPLETE!",
                    "message": "Missing CR Ref on row "+(i+1),
                    "type":"error"
                });
                toastEvent.fire();
                return false;
            }
            if(!allContactRows[i].DR_Ref__c){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "INCOMPLETE!",
                    "message": "Missing DR Ref on row "+(i+1),
                    "type":"error"
                });
                toastEvent.fire();
                return false;
            }
            if(!allContactRows[i].Effective_Date__c){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "INCOMPLETE!",
                    "message": "Missing Effective Date on row "+(i+1),
                    "type":"error"
                });
                toastEvent.fire();
                return false;
            }
        }
        
        return isValid;
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("TheSpinner1");
        $A.util.removeClass(spinner, "slds-hide");
         $A.util.addClass(spinner, "slds-show");
    },
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("TheSpinner1");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        
    }
})
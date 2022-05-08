({
    doInit : function(component, event, helper) {
        helper.checkIsClaim(component, event, helper);        
    },
    handleChangeCategory: function(component, event, helper) {
        var cat = component.find('Category__c').get('v.value');
        if(cat!= null && cat == 'Claims'){
            component.set('v.isClaim',true);            
        } 
        else
            component.set('v.isClaim',false);
    },
    handleOnSubmit: function(component, event, helper) {
        //helper.hideSpinner(component);
    },
    handleOnSuccess : function(component, event, helper) {
        alert("handle On Success");
        var toastEvent = helper.getToast("Success!","Case has been updated Successfully", "success",helper);
        toastEvent.fire();
    },
    
    handleNext : function(component, event, helper) {
        debugger;
        component.find("caseRecordLoader").reloadRecord();
        var c = component.get('v.refreshCaseRecord');
        component.set('v.accountId',c['AccountId']);
        component.set('v.caseOwnerId',c['OwnerId']);
        debugger;
        helper.showSpinner(component);
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        helper.updateCase(component, event, helper);
    },
    
    updateCase : function(component, event, helper) {
        
    },
    getFieldValues:function(component, event, helper) {
        
        let ele = event.getSource();
        let fieldName = ele.get("v.fieldName") ; 
        let fieldValue =  ele.get("v.value") ; 
        debugger;
        var caseDetails = component.get('v.myNewCase');
        caseDetails[fieldName] = fieldValue;
        if(fieldName == 'Category__c'){
            if(fieldValue!= null && fieldValue == 'Claims'){
                component.set('v.isClaim',true);
                
            } 
            else
                component.set('v.isClaim',false);
        }

        component.set('v.myNewCase',caseDetails);
        helper.fetchPickListVal(component, 'Related_Business_Area__c', 'businessArea', component.get("v.myNewCase.Related_Business_Area__c"));
        
    },
    setArea:function(component, event, helper) {
        debugger;
        component.set('v.myNewCase.Related_Business_Area__c', component.get('v.caseArea'));
        helper.fetchPickListVal(component, 'Related_Business_Area__c', 'businessArea', v.myNewCase.Related_Business_Area__c);
        
    }
})
({
    handleLoad : function(component, event, helper) {
        var opportunityRecordTypeId = component.find('recordTypeId').get('v.value');
        component.set('v.opportunityRecordTypeId', opportunityRecordTypeId);
    },

    handleSubmit : function(component, event, helper) {
        helper.showSpinner(component);
    },

    handleSuccess : function(component, event, helper) {
        // Call link banker once the form details are saved
        helper.LinkBanker(component, event, helper);
    },

    handleError : function(component, event, helper) {
        helper.hideSpinner(component); //hide the spinner

        var componentName = 'controlOfficerLinkingBankerDetails';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.fireToast("Error!", "There has been an error saving the data.", "error");
    },
     
    renderFields: function(component, event, helper) {
        
        var officerType = component.find("cntrlOfficerType");
         console.log('officerType'+officerType);
        var officervalue = officerType.get("v.value");
         console.log('officervalue'+officervalue);

        
        if (officervalue == "CM – CREDIT ANALYST COMMERCIAL BANK"   || officervalue == "CA – CREDIT ANALYST SME BANKING" || officervalue == "BM – BRANCH MANAGER"){
            component.set("v.renderfields", true);

        }   
     
        else{
            component.set("v.renderfields", false);

  }
    }
})
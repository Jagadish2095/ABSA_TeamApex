({ 
    doInit: function(component, event, helper) {
        //helper.getOpportunityRecordTypesList(component);
    },

    handleComponentEvent: function(component, event, helper) {
        var eventValue = event.getParam("accountValue");
        if(component.get("v.accountChecked") == false && eventValue != null && eventValue != '' && eventValue != undefined){
        	component.set("v.accountData", eventValue); 
            component.set("v.accountChecked", true); 
        }
    },

    finish: function(component, event, helper) {
        //Update opportunity record with client
        helper.createNewAccount(component);  
    }

})
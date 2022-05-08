({
               doInit : function(component, event, helper) {
                              
               },
    redirectOpportunity: function(component, event, helper) {
        var oppId =  component.get("v.caseRecord.Opportunity__c");
        console.log('opppId---'+oppId);     
        var navEvt = $A.get("e.force:navigateToSObject"); //redirect to parent opportunity
        navEvt.setParams({
            "recordId": oppId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    }
})
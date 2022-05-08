({
    redirectToAccount : function (component, event, helper) {
     var accId =  component.get("v.accountSelected.Id");
            var navEvt = $A.get("e.force:navigateToSObject"); //redirect to parent opportunity
            navEvt.setParams({
                "recordId": accId,
                "slideDevName": "detail"
            });
            navEvt.fire();
            
    }
});
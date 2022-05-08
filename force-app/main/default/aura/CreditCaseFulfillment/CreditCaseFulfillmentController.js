({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner", false);
       
    },
    handleOnLoad :function(component, event, helper){
         var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") { // on load of case record get product specific fields
       
        var caseId =  component.get("v.recordId");
        
        var productname =  component.get("v.caseRecord.Product__c");
       
        var action = component.get("c.getProductFields");     
        action.setParams({
            "productname": productname
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var results = response.getReturnValue();
                console.log("results " + JSON.stringify(results));
                 component.set("v.fieldnames",results);
                 component.set("v.showSpinner", false);
                
            }else{
                var erros =response.getError();
                console.log("Failed with state: " + JSON.stringify(erros));
                                 component.set("v.showSpinner", false);
            }
            
        });
        
        $A.enqueueAction(action);
        }
        
        
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
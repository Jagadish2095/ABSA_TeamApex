({
    loadData: function(component, event, helper) {
        var action = component.get("c.getEcasadate");
        var caseId = component.get("v.caseId");
        action.setParams({
            'caseId': caseId
        })
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            console.log('state>>>'+state);
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                component.set('v.wrapperList',response);
            }
            else{
                //  alert('response.getReturnValue()>>'+response.getReturnValue());
                component.set('v.iscasaReferenceNumber',false);
                
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    }
    
    
})
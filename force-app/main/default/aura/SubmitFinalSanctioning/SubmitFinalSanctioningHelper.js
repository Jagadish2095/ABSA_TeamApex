({
	// function automatic called by aura:waiting event  
    showSpinner: function (component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event 
    hideSpinner: function (component, event, helper) {
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    getReqProd : function(component, event, helper) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getRequestedProduct");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            if (state === "SUCCESS") {
                
                console.log('respRequested Product : '+ JSON.stringify(respDecison));
                component.set("v.dataReqProd", respDecison);
                
            } else if (state === "ERROR"){
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In Getting Decision Summary: " + JSON.stringify(response),
                    "type":"error"
                });
                toastEvent.fire();
                
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        if (row.System_Decision__c=='Accepted' && row.Final_Decision__c=='Accepted') {
            actions.push({
                'label': 'Not Taken Up',
                //'iconName': 'utility:warning',
                'name': 'Not Taken Up'
            });
        } else if(row.System_Decision__c=='Declined' && row.Final_Decision__c=='Declined'){
            actions.push({
                'label': 'Withdraw',
              //  'iconName': 'utility:error',
                'name': 'Withdraw'
            });
        }
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
})
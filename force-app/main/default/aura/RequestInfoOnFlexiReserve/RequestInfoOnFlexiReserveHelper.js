({
        //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    getAccountInfoHelper : function(component, event, helper) {
        var action = component.get("c.getAccountInfo");
        action.setParams({caseId:component.get("v.recordId"),
                          accountId : component.get('v.selectedAccountNumber')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var responseMap =response.getReturnValue();
                if(responseMap.StatusCode != 200){
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": responseMap.message,
                        "type":"error"
                    });                    
                }else if(responseMap.StatusCode == 200){ 
                    if( responseMap.MLviewComprehensiveDetailsV1Response.mlp047o.errsec != null){
                         toastEvent.setParams({
                            "title": "Error!",
                            "message": responseMap.MLviewComprehensiveDetailsV1Response.mlp047o.errmsg,
                            "type":"error"
                        });
                    }else{              
                        component.set('v.accountInfoResponse',responseMap); 
                    }
                }
                
            } else if(state === "ERROR"){
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
            } else{
                
            }
            toastEvent.fire();
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    getNHAccountInfoHelper : function(component, event, helper) { 
        var action = component.get("c.getNHAccountInfo");
        action.setParams({ accountNumber : component.get('v.selectedAccountNumber')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var responseMap =response.getReturnValue();
                if(responseMap.statusCode != 200){
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": responseMap.message,
                        "type":"error"
                    });                    
                }else if(responseMap.statusCode == 200){                                  
                        component.set('v.accountNHInfoResponse',responseMap); 
                        this.getAccountInfoHelper(component, event, helper);
                }
                
            } else if(state === "ERROR"){
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
            } else{
                
            }
            toastEvent.fire();
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    caseCurrentCaseHelper : function(component, event, helper){
         var action = component.get("c.caseClose");
        action.setParams({caseId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var caseResponse = response.getReturnValue();
                debugger;
                if(caseResponse.isSuccess == 'true'){
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Case successfully closed!",
                        "type":"success"
                    });
                    
                    $A.get('e.force:refreshView').fire();
                }else{
                     toastEvent.setParams({
                        "title": "Error!",
                        "message": caseResponse.errorMessage,
                        "type":"error"
                    });  
                }
                
            }else if(state === "ERROR"){
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
            } 
            
            toastEvent.fire();
        });
        
        $A.enqueueAction(action);
        
    }
})
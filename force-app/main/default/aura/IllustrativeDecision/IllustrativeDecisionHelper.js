({
	getSubmissionHist : function(component, event, helper) {
		
	var oppId = component.get("v.recordId");
        var action = component.get("c.GetSubmissionHistory");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var respHist = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(respHist)){
                
                    console.log('respHist'+ JSON.stringify(respHist));
                    component.set("v.dataHistory", respHist);
                }
                
            } else if (state === "ERROR"){
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } 
              
            }
                
        });
        
        $A.enqueueAction(action);
    }, 
    
    
    getDecisionSum  : function(component, event, helper) {
		
	var oppId = component.get("v.recordId");
        var action = component.get("c.GetDecisionSummary");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            if (state === "SUCCESS") {
            if (!$A.util.isEmpty(respDecison)){
            component.set("v.stage4Response", respDecison);
            //component.set("v.decisionTime", string.valueOf(respDecison[0].ILST_Decision_Time__c));
            }
        
            } else if (state === "ERROR"){
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }
            }
                
        });
        
        $A.enqueueAction(action);
    },
    getDecTime: function(component, event, helper) {
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getDecisionTime");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var respDecisonTime = response.getReturnValue();
            console.log('respDecisonTime: '+ JSON.stringify(respDecisonTime));
            component.set("v.decisionTime", respDecisonTime);
        });
        $A.enqueueAction(action);
    },
    getRequestedProducts  : function(component, event, helper) {
		
	var oppId = component.get("v.recordId");
        var action = component.get("c.getRequestedProduct");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(respDecison)){
                    console.log('respDecison'+ JSON.stringify(respDecison));
                    console.log('Id'+respDecison[0].Id);
                    console.log('product_amount__c'+respDecison[0].Product_Amount__c);
                    console.log('product_type__c'+respDecison[0].Application_Product_Parent__r.Product_Type__c);
            component.set("v.dataReqProd", respDecison);
            }
            } else if (state === "ERROR"){
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }
            }
                
        });
        
        $A.enqueueAction(action);
    },
    
    
    getReasonsAndExceptions  : function(component, event, helper) {
		
	var oppId = component.get("v.recordId");
        var action = component.get("c.GetReasonsAndExceptions");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('reasonList'+respDecison['ReasonList']);
                if (!$A.util.isEmpty(respDecison['ReasonList'])){
            component.set("v.ReasonList", respDecison['ReasonList']);
            }
            if (!$A.util.isEmpty(respDecison['ReasonDescriptionList'])){
            component.set("v.ReasonDescriptionList", respDecison['ReasonDescriptionList']);
        }
            if (!$A.util.isEmpty(respDecison['ExceptionList'])){
            component.set("v.ExceptionList", respDecison['ExceptionList']);
        }
        if (!$A.util.isEmpty(respDecison['ExceptionDescriptionList'])){
            component.set("v.ExceptionDescriptionList", respDecison['ExceptionDescriptionList']);
             }
            } else if (state === "ERROR"){
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } 
                
                
            }
                
        });
        
        $A.enqueueAction(action);
    },
    
    amend : function(component, event, helper) {
		
	var oppId = component.get("v.recordId");
        var action = component.get("c.reprocess");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Kindly reprocess the application",
                    "type":"success"
                });
                toastEvent.fire();
                component.set('v.radioGrpValue','');
                component.set('v.refresh', false);   
                
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
                
               
                
            }
                
        });
        
        $A.enqueueAction(action);
    },
    submitStage : function(component, event, helper) {
		
	var oppId = component.get("v.recordId");
        console.log('bb');
        var action = component.get("c.submit");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            console.log('submit'+respDecison);
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Illustrative Decision Submitted Successfully",
                    "type":"success"
                });
                toastEvent.fire();
             component.set('v.radioGrpValue','');
             component.set('v.submit', false);    
                
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
                
               
                
            }
                
        });
        
        $A.enqueueAction(action);
    },
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})
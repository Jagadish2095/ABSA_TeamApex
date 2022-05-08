({
    doInit: function(component, event, helper) {
        
        helper.createObjectData(component, event);
    },
    Split: function(component, event, helper) {
        
        helper.showSpinner(component);
        
        if (helper.validateRequired(component, event)) {
            
            var action = component.get("c.splitCase");
            
            var caselist = component.get("v.caseList");
            
            var strJSON = JSON.stringify(caselist);
            
            console.log('Case List : ' + caselist);
            
            action.setParams({
                "jsonString": strJSON,
                "parentCaseId" : component.get("v.recordId")
            });
            
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "title": "Case Split",
                        "message": "Case split successfully",
                        "type":"success"
                    });
                    
                    toastEvent.fire();
                    
                    helper.hideSpinner(component);
                    
                    component.set("v.caseList", []);
                    
                    helper.createObjectData(component, event);
                    
                    $A.get("e.force:refreshView").fire();
                    
                }else if(state === "ERROR"){
                    
                    var message = '';
                    var errors = response.getError();
                    if (errors) {
                        for(var i=0; i < errors.length; i++) {
                            for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                                message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                            }
                            if(errors[i].fieldErrors) {
                                for(var fieldError in errors[i].fieldErrors) {
                                    var thisFieldError = errors[i].fieldErrors[fieldError];
                                    for(var j=0; j < thisFieldError.length; j++) {
                                        message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                    }
                                }
                            }
                            if(errors[i].message) {
                                message += (message.length > 0 ? '\n' : '') + errors[i].message;
                            }
                        }
                    }else{
                        message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                    }
                    
                    // show Error message
                    var toastEvent = helper.getToast("Error!", message, "Error");
                    toastEvent.fire();
                    
                    helper.hideSpinner(component);
                }else{
                    
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "There was an error splitting the case",
                        "type":"error"
                    });
                    
                    toastEvent.fire();
                    
                    helper.hideSpinner(component);
                    
                    component.set("v.caseList", []);
                    
                    helper.createObjectData(component, event);

                }
            });
            
            $A.enqueueAction(action);
        }
    },
    addNewRow: function(component, event, helper) {
        helper.createObjectData(component, event);
    },
    removeDeletedRow: function(component, event, helper) {
        
        var index = event.getParam("indexVar");
        
        var allRowsList = component.get("v.caseList");
        allRowsList.splice(index, 1);
        
        component.set("v.caseList", allRowsList);
    }
})
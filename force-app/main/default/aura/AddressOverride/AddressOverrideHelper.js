({
    //Method to get Address details based on edit
    getAddressRecordDetails : function(component, event, helper) {
        var action = component.get("c.getAddressDetails");  //get all address
        action.setParams({
            addressRecId : component.get("v.recordId")
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var addressReturned = response.getReturnValue();
                
                if(addressReturned != null) {
                    component.set("v.addressRecord",addressReturned); 
                    component.set("v.addressRecId",addressReturned.id);
                    
                }
            }
        });     
        
        $A.enqueueAction(action);
    },
    
    //Method to get Client Type of parent Account
    getParentRecordDetails : function(component, event, helper) {
        var parentValue = event.getParam('arguments');
        var recId;
        
        if(parentValue) {
            console.log('In param');
            recId = parentValue.accId;//params
            component.set("v.accRecId",recId);
        } else if (component.get("v.recordId") != null ) {
            console.log('In recordId');
            recId = component.get("v.recordId");
            component.set("v.contactRecId",recId);
        } else {
            console.log('In getParentId');
            
            var pageRef = component.get("v.pageReference");
            var state = pageRef.state; // state holds any query params
            var base64Context = state.inContextOfRef;
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
            }
            var addressableContext = JSON.parse(window.atob(base64Context));
            component.set("v.parentRecordId", addressableContext.attributes.recordId);
            console.log('parentvalue : ' + addressableContext.attributes.recordId);
            recId = addressableContext.attributes.recordId;
            
            /*var value = this.getParameterByName(component , event, 'inContextOfRef');
            var context = JSON.parse(window.atob(value));
            component.set("v.parentRecordId", context.attributes.recordId);
            console.log('parentvalue : ' + context.attributes.recordId);*/
        }
        
        console.log("recordId : " + component.get("v.recordId"));
        
        var action = component.get("c.getClientType");  //get all address
        action.setParams({
            recordId : recId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var clientTypeReturned = response.getReturnValue();
                
                if(clientTypeReturned != null) {
                    component.set("v.accountClientType",clientTypeReturned); 
                    component.set("v.addressRecord.Client_Entity_Type__c",clientTypeReturned); 
                }
                
                console.log('accountClientType : ' + component.get("v.accountClientType"));
            }
        });     
        
        $A.enqueueAction(action);
    },
    
    //Insert or Update existing Address
    upsertAddressRecord : function (component, event, helper) {
        component.set("v.addressRecord.Account__c", component.get("v.accRecId"));
        var newAddressRecord = component.get("v.addressRecord");
        var parentId = component.get("v.parentRecordId");
        var addressId = component.get("v.addressRecId");
        
        var addressTypeVal = component.get("v.addressRecord.Address_Type__c");
        if(!addressTypeVal) {
            var toast = this.getToast('Required field', 'Address Type is required', 'error');
            toast.fire();
            return null;
        }
        
        //Calling the Apex Function to create Contact
        var createAddressAction = component.get("c.createNewAddress");
        
        if(addressId != null) {
            //Setting the Apex Parameter
            createAddressAction.setParams({
                parentRecId: parentId,
                existingAddress: newAddressRecord
            });
        } else {
            //Setting the Apex Parameter
            createAddressAction.setParams({
                parentRecId: parentId,
                newAddress: newAddressRecord
            }); 
        }

        //Setting the Callback
        createAddressAction.setCallback(this, function(response) {
            var stateCase = response.getState();
            if (stateCase === "SUCCESS") {
                var addressUpdated = response.getReturnValue();
                
                if(addressUpdated != null) {
                    var toastEvent = helper.getToast("Success!", 'Address successfully created', "Success");
                    toastEvent.fire();
                    
                    //Close component
                     this.closeComponent(component,event, helper);
                    
                    //Navigate to Address
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": addressUpdated.Id
                    });
                    navEvt.fire();
                    
                } 
                
            } else if (stateCase === "ERROR") {
                var message = "";
                var errors = response.getError();
                if (errors) {
                    for (var i = 0; i < errors.length; i++) {
                        for (
                            var j = 0;
                            errors[i].pageErrors && j < errors[i].pageErrors.length;
                            j++
                        ) {
                            message +=
                                (message.length > 0 ? "\n" : "") +
                                errors[i].pageErrors[j].message;
                        }
                        if (errors[i].fieldErrors) {
                            for (var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for (var j = 0; j < thisFieldError.length; j++) {
                                    message +=
                                        (message.length > 0 ? "\n" : "") +
                                        thisFieldError[j].message;
                                }
                            }
                        }
                        if (errors[i].message) {
                            message += (message.length > 0 ? "\n" : "") + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? "\n" : "") + "Unknown error";
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        //adds the server-side action to the queue
        $A.enqueueAction(createAddressAction);
    },
    
    closeComponent : function (component, event, helper) {
     var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.isSubtab({
                tabId: response.tabId
            })
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
   
    },
    
    //Function to show toast for Errors/Warning/Success
      getToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
    
        toastEvent.setParams({
          title: title,
          message: msg,
          type: type
        });
    
        return toastEvent;
      },
    
})
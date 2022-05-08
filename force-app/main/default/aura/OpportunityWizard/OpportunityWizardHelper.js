({
    //Gets a list of opportunity record types
    getOpportunityRecordTypesList: function(component) {
        
        var action = component.get("c.getOpportunityRecordTypesMap");
        var opts = [];
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                for (var key in response.getReturnValue()) {
                    
                    opts.push({
                        class: "optionClass",
                        label: key,
                        value: response.getReturnValue()[key]
                    });
                    
                }
                
                component.set("v.opportunityRecordTypesList", opts);
                component.set("v.selectedOpportunityRecordTypeId", component.get("v.opportunityRecordTypesList")[0].value);
                component.set("v.selectedOpportunityRecordTypeName", component.get("v.opportunityRecordTypesList")[0].label);
                this.getSelectedOpportunityRecordTypeFields(component);
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                
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
    
    //Gets a list of fields associated with a particular record type for dynamically generating the opportunity form
    getSelectedOpportunityRecordTypeFields: function(component) {
        
        var action = component.get("c.getSelectedOpportunityRecordTypeFields");
        
        action.setParams({
            recordTypeName: component.get("v.selectedOpportunityRecordTypeName")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log('Opportunity Rec Type fields : '+JSON.stringify(response.getReturnValue()));
                component.set("v.opportunityFields", response.getReturnValue());
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                
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
    
    //Dynamically generates required fields for recordEdit form depending on opportunity record type selected
    generateFormInputFields: function(component) {
        
        if ( component.get("v.bodya").length === 0 && component.get("v.bodyb").length === 0){
            var value={};
            for (var i = 0; i < component.get("v.opportunityFields").length; i ++) {
                //Added By Divya
                let fieldName =	component.get("v.opportunityFields")[i];
                let disable = null;
                if(fieldName == 'AccountId')
                {
                    //value =component.get("v.accountData").Id;
                     value.AccountId = component.get("v.accountData").Id;
                    component.set("v.Oppty",value);
                }
                else if(fieldName == 'StageName' && component.get("v.selectedOpportunityRecordTypeName") == 'Investment Opportunity')
                {
                   value.StageName = "New";
                   disable = true;
                   component.set("v.Oppty",value);
                    
                }
                else if(fieldName == 'ReferredByUser__c' || fieldName == 'OwnerId')
                {
                   //value = $A.get("$SObjectType.CurrentUser.Id"); 
                    value[fieldName] = $A.get("$SObjectType.CurrentUser.Id");
                    component.set("v.Oppty",value);
                }
                 if(fieldName != 'IsPrivate')
                 {
                      $A.createComponent(
                    "lightning:inputField",
                    {
                        "aura:id":fieldName,
                        "fieldName": fieldName,
                       	 "value": component.getReference("v.Oppty."+fieldName),
                        "disabled":disable
                    },
                    function(newInputField, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            //Determine which side to play the fields
                            if ((i + 1) & 1) {
                                
                                var body = component.get("v.bodya");
                                
                                body.push(newInputField);
                                component.set("v.bodya", body);
                                
                            } else {
                                
                                var body = component.get("v.bodyb");
                                
                                body.push(newInputField);
                                component.set("v.bodyb", body);
                                
                            }
                            
                        }
                        else if (status === "INCOMPLETE") {
                            
                            console.log("No response from server or client is offline.")
                        }
                            else if (status === "ERROR") {
                                
                                console.log("Error: " + errorMessage);
                                
                            }
                    }
                );
             }
              if(fieldName == 'IsPrivate')
             {
                  $A.createComponent(
                    "lightning:inputField",
                    {
                        "fieldName": fieldName,
                        "disabled":disable
                    },
                    function(newInputField, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            //Determine which side to play the fields
                            if ((i + 1) & 1) {
                                
                                var body = component.get("v.bodya");
                                
                                body.push(newInputField);
                                component.set("v.bodya", body);
                                
                            } else {
                                
                                var body = component.get("v.bodyb");
                                
                                body.push(newInputField);
                                component.set("v.bodyb", body);
                            }
                        }
                        else if (status === "INCOMPLETE") {
                            
                            console.log("No response from server or client is offline.")
                        }
                            else if (status === "ERROR") {
                                
                                console.log("Error: " + errorMessage);
                                
                            }
                    }
                );
             }
                
                //                break;
                
            }
           
        }
        
        component.set("v.showSpinner", false);
        
    },
    
    //Creates the selected client with a CIF number
    createClientCIF: function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.createClient");
        
        action.setParams({
            accountData: component.get("v.accountData")
        });
        
        action.setCallback(this, function(response) {
            
            var resp = response.getReturnValue();
            
            var state = response.getState();
            if (state === "SUCCESS") {
                if(resp.includes('Success')){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Client has been selected successfully",
                        "type":"success"
                    });
                    toastEvent.fire();
                } else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": resp,
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            } else {
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An unknow error has occured, please contact an administrator",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    
    //Updates the opportunity with the selected client
    updateOpportunity: function(component) {
        
        var action = component.get("c.updateOpportunity");
        action.setParams({
            oppId: component.get("v.recordId"),
            accountData: component.get("v.accountData"),
            productData: component.get("v.productData"),
            adviserId: component.get("v.selectedAdviserId"),
            siteId: component.get("v.selectedSiteId"),
            willDetailString: component.get("v.productDataDetails"),
            willBankingDetailsString: component.get("v.productDataBankingDetails"),
            willAssetsLiabilitiesString: component.get("v.productDataAssetsLiabilities"),
            willType: component.get("v.willTypeValue")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                
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
    
    getWillDetails: function(component) {
        
        var action = component.get("c.getWillDetails");
        
        action.setParams({
            productData: component.get("v.productData")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                component.set("v.productDataDetails", response.getReturnValue());
                this.getWillBankingDetails(component);
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                
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
    
    getWillBankingDetails: function(component) {
        
        var action = component.get("c.getWillBankingDetails");
        
        action.setParams({
            productData: component.get("v.productData")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.productDataBankingDetails", response.getReturnValue());
                this.getWillAssetsLiabilities(component);
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                
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
    
    getWillAssetsLiabilities: function(component) {
        
        var action = component.get("c.getWillAssetsLiabilities");
        
        action.setParams({
            productData: component.get("v.productData")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.productDataAssetsLiabilities", response.getReturnValue());
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                
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
    
    //Deletes the opportunity record if process is cancelled
    deleteOpportunity: function(component) {
        
        var action = component.get("c.deleteOpportunity");
        
        action.setParams({
            oppId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                
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
    //Added By Divya
    getAccountId: function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getAccountRecordId");
        
        action.setParams({
            caseId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log('Account Id is '+ response.getReturnValue());
                component.set("v.accrecordId",response.getReturnValue());
                //component.find("accountlookup").set("v.value",component.get("v.accrecordId"));
                component.set("v.showSpinner", false);
            }
            else if (state === "ERROR") {
                
                var errors = response.getError();
                
                if (errors) {
                    
                    if (errors[0] && errors[0].message) {
                        
                        console.log("Error message: " +
                                    errors[0].message);
                        
                    }
                } else {
                    
                    console.log("Unknown error");
                    
                }
                
                component.set("v.showSpinner", false);
            }
            
        });
        
        $A.enqueueAction(action);
    }
})
({      
    getAccountDetails: function (component) {
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAccountData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                //this.showSpinner(component);
                
                component.set("v.account", response.getReturnValue());
                component.set("v.selectedIdType", component.get("v.account.ID_Type__pc"));
                component.set("v.selectedClientType", component.get("v.account.Client_Type__c"));
                component.set("v.selectedNationality", component.get("v.account.Nationality__pc"));
                component.set("v.selectedCountryResidence", component.get("v.account.Country_of_Residence__pc"));
                component.set("v.selectedCountryBirth", component.get("v.account.Country_of_Birth__pc"));
                component.set("v.selectedCountryRegistration", component.get("v.account.Country_of_Registration__c"));
                
                var oppId2 = component.get("v.recordId");
                var action2 = component.get("c.getPartcicpantAccountData");
                action2.setParams({
                    "oppId": oppId
                });
                
                
                action2.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.participantAccountList", response.getReturnValue());
                    }else {
                        console.log("Failed with state: " + state);
                    }
                    this.hideSpinner(component);
                });
                $A.enqueueAction(action2);
            }else {
                console.log("Failed with state: " + state);
                this.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },
    
    checkOnInitValidity: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAccountRecordType");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.accountRecordType", resp);
                
                component.set("v.showSpinner", true);
                
                var action = component.get("c.checkInitValidity");
                action.setParams({
                    "oppId": oppId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var validity = response.getReturnValue();
                        if(validity == 'Valid'){
                            component.set("v.showCasaScreen", false);
                            component.set("v.showFinishedScreen", true);
                        }
                        else{
                            component.set("v.showCasaScreen", true);
                            component.set("v.showFinishedScreen", false);
                        }
                    }
                    component.set("v.showSpinner", false);
                });
                $A.enqueueAction(action);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkCasaStatus: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getCasaStatus");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                component.set("v.casaScreeningStatus", validity);        			
            }
        	component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkAccountRecordType: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAccountRecordType");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.accountRecordType", resp);
            }
        	component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    refreshStatus: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.refreshCasaStatus");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'Success'){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "CASA Screening Status has been Successfully Refreshed.",
                        "type":"success"
                    });
                    toastEvent.fire();
                    
                    component.set("v.showCasaScreen", false);
                    component.set("v.showFinishedScreen", true);
                    
                    var a = component.get('c.doInit');
                    $A.enqueueAction(a);
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": response.getReturnValue(),
                        "duration":"15000",
                        "type":"error"
                    });
                    toastEvent.fire();
                } 
            }
            else {
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An error occured while doing the screening process, please try again.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
            $A.get('e.force:refreshView').fire();    
        });
        $A.enqueueAction(action);
    },

    casaScreening: function (component) {
        
        var allValid = component.find('accountForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if (allValid) {
            
            this.showSpinner(component);
            
            var oppId = component.get("v.recordId");
            var account = component.get("v.account");
            var action = component.get("c.updateAccountAndDoCasaScreening");
            action.setParams({
                "oppId": oppId,
                "updatedAccount": account
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue() == 'Success'){
                        // show success notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "CASA Screening completed Successfully.",
                            "type":"success"
                        });
                        toastEvent.fire();
                        
                        component.set("v.showCasaScreen", false);
                        component.set("v.showFinishedScreen", true);
                        
                        var a = component.get('c.doInit');
        				$A.enqueueAction(a);
                    }
                    else{
                        // show error notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": response.getReturnValue(),
                            "duration":"15000",
                            "type":"error"
                        });
                        toastEvent.fire();
                    } 
                }
                else {
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "An error occured while doing the screening process, please try again.",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
                this.hideSpinner(component);
                $A.get('e.force:refreshView').fire();     
            });
            $A.enqueueAction(action);
        }
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.account"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
  
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                if(elementId == 'idType'){
                    component.set("v.idTypeOptions", opts); 
                }
                else if(elementId == 'clientType'){
                    component.set("v.clientTypeOptions", opts); 
                }
                else if(elementId == 'nationality'){
                    component.set("v.nationalityOptions", opts); 
                }
                else if(elementId == 'countryResidence'){
                    component.set("v.countryResidenceOptions", opts); 
                }
                else if(elementId == 'countryBirth'){
                    component.set("v.countryBirthOptions", opts); 
                }
                else if(elementId == 'countryRegistration'){
                    component.set("v.countryRegistrationOptions", opts); 
                }
                this.getAccountDetails(component);
            }
        });
        $A.enqueueAction(action);
    }
})
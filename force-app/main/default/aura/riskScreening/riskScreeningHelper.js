({  
    helperMethod : function() {
		
	},
     
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
                component.set("v.account", response.getReturnValue());
                component.set("v.selectedOccupationCategory", component.get("v.account.Occupation_Category__pc"));
                component.set("v.selectedOccupationStatus", component.get("v.account.Occupation_Status__pc"));
                component.set("v.selectedSourceIncome", component.get("v.account.Income_Source__pc"));
            }
            else {
                console.log("Failed with state: " + state);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    getCountriesTraded: function (component) {
        this.showSpinner(component);

        var oppId = component.get("v.recordId");
        var action = component.get("c.getCountriesTradedData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == null){
                    var defaultValue = ["South Africa"];
                    component.set("v.countriesTradedValues", defaultValue);
                }
                else{
                    component.set("v.countriesTradedValues", response.getReturnValue());
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    checkOnInitValidity: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkInitValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                
                var action = component.get("c.checkCASAValidity");
                action.setParams({
                    "oppId": oppId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var casaValidity = response.getReturnValue();
                        
                        component.set("v.showSpinner", true);
        
                        var oppId = component.get("v.recordId");
                        var action = component.get("c.getCasaStatus");
                        action.setParams({
                            "oppId": oppId
                        });
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var screeningStatus = response.getReturnValue();
                                if(screeningStatus == 'Continue with the process' || screeningStatus == 'Approved'){
                                    component.set("v.casaScreeningStatus", false);
                                    if(casaValidity == 'Valid'){
                                        if(validity == 'Valid'){
                                            component.set("v.showRiskScreen", false);
                                            component.set("v.showFinishedScreen", true);
                                            component.set("v.showCasaNotCompleted", false);
                                        }
                                        else{
                                            component.set("v.showRiskScreen", true);
                                            component.set("v.showFinishedScreen", false);
                                            component.set("v.showCasaNotCompleted", false);
                                        }
                                    }
                                    else{
                                        component.set("v.showRiskScreen", false);
                                        component.set("v.showCasaNotCompleted", true);
                                    }
                                }
                                else{
                                    component.set("v.showRiskScreen", false);
                                    component.set("v.showFinishedScreen", false);
                                    component.set("v.showCasaNotCompleted", false);
                                    component.set("v.casaScreeningStatus", true);
                                }
                            }
                            component.set("v.showSpinner", false);
                        });
                        $A.enqueueAction(action);
                    }
                });
                $A.enqueueAction(action);
                
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
    
    riskRatingData: function (component) {
        component.set("v.showSpinner", true);
        

        var oppId = component.get("v.recordId");
        var action = component.get("c.getRiskRatingData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() != null){
                    component.set("v.opportunity", response.getReturnValue());
                	var riskDate = component.get("v.opportunity.Risk_Rating_Date__c");
                	component.set("v.opportunity.Risk_Rating_Date__c", riskDate.substring(0, 10));
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    riskScreening: function (component) {
        //Check if form is valid
        var allValid;
        if(component.get("v.accountRecordType") == 'Individual Client'){
                allValid = component.find('accountForm').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                inputCmp.focus();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
        }
        else{
            allValid = true;
        }
        
        if (allValid) {
            this.showSpinner(component);
            
            //Replace all occurances of , with ; for multiselect
            if(component.get("v.account.Countries_Traded_With__c") != null || component.get("v.account.Countries_Traded_With__c") != undefined){
                var countries = component.get("v.account.Countries_Traded_With__c").toString();
                var res = countries.replace(/,/g, ';');
                component.set("v.account.Countries_Traded_With__c", res);
            }
            
            var oppId = component.get("v.recordId");
            var account = component.get("v.account");
            var action = component.get("c.updateAccountAndDoRiskScreening");
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
                            "message": "Risk Rating completed Successfully.",
                            "type":"success"
                        });
                        toastEvent.fire();
                        
                        component.set("v.showRiskScreen", false);
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
                            "duration": "15000",
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
                
                if(elementId == 'occupationCategory'){
                    component.set("v.occupationCategoryOptions", opts); 
                }
                else if(elementId == 'occupationStatus'){
                    component.set("v.occupationStatusOptions", opts); 
                }
                else if(elementId == 'sourceIncome'){
                    component.set("v.sourceIncomeOptions", opts); 
                }
                else if(elementId == 'countriesTraded'){
                    component.set("v.countriesTradedOptions", opts); 
                }
                
                this.getAccountDetails(component);
                this.getCountriesTraded(component);
            }
        });
        $A.enqueueAction(action);
    }
})
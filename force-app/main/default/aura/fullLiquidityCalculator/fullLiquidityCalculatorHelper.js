({
    helperMethod : function() {
        
    },
    
    doInit: function(component, event, helper) {
        this.showSpinner(component);
        
        //console.log("record type"+component.get("v.RecordType.Developername"));
        
        this.fetchPickListVal(component, 'Cash_Action__c', 'bankAction');
        this.fetchPickListVal(component, 'Investment_Action__c', 'lispSharesAction');
        this.fetchPickListVal(component, 'Fixed_Properties_Action__c', 'fixedPropertiesAction');
        this.fetchPickListVal(component, 'Life_Policies_Action__c', 'lifePoliciesAction');
        this.fetchPickListVal(component, 'Other_Assets_Action__c', 'otherAssetsAction');
        this.fetchRecordTypeName(component);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getLatestFinancialNeedsAnalysis");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.fna", response.getReturnValue());
                component.set("v.selectedBankValue", component.get("v.fna.Cash_Action__c"));
                component.set("v.selectedLispSharesValue", component.get("v.fna.Investment_Action__c"));
                component.set("v.selectedFixedPropertyValue", component.get("v.fna.Fixed_Properties_Action__c"));
                component.set("v.selectedLifePoliciesValue", component.get("v.fna.Life_Policies_Action__c"));
                component.set("v.selectedOtherAssetsValue", component.get("v.fna.Other_Assets_Action__c"));
                if(component.get("v.fna.Assets__c") > 0){
                    component.set("v.showTotalAssets", true);
                }
                if(component.get("v.fna.Liabilities__c") > 0){
                    component.set("v.showTotalLiabilities", true);
                }
                component.set("v.mustComment", true);
                if(component.get("v.fna.Full_Liquidity__c") == true){
                    component.set("v.showResults", true);
                }
                else{
                    component.set("v.showShortResults", true);
                }
                if(component.get("v.fna.Full_Liquidity__c") == false)
                {
                    this.validateShortMaxAssets(component);
                }
                else{
                    this.validateMaxAL(component);
                }                
            }
            else {
                component.set("v.mustComment", false);                
                component.set("v.showInitialSelect", true);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    newFna: function(component, event, helper) {
        this.showSpinner(component);
        
        if(component.get("v.selectedCalculator") == "fullLiqCalc"){
            var oppId = component.get("v.recordId");
            var action = component.get("c.getLatestFinancialNeedsAnalysis");
            action.setParams({
                "oppId": oppId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.fna", response.getReturnValue());
                    component.set("v.selectedBankValue", component.get("v.fna.Cash_Action__c"));
                    component.set("v.selectedLispSharesValue", component.get("v.fna.Investment_Action__c"));
                    component.set("v.selectedFixedPropertyValue", component.get("v.fna.Fixed_Properties_Action__c"));
                    component.set("v.selectedLifePoliciesValue", component.get("v.fna.Life_Policies_Action__c"));
                    component.set("v.selectedOtherAssetsValue", component.get("v.fna.Other_Assets_Action__c"));
                    if(component.get("v.fna.Assets__c") > 0){
                        component.set("v.showTotalAssets", true);
                    }
                    if(component.get("v.fna.Liabilities__c") > 0){
                        component.set("v.showTotalLiabilities", true);
                    }
                }
                else {
                    console.log("Failed with state: " + state);
                }
                this.hideSpinner(component);
            });
            $A.enqueueAction(action);
            
            if(component.get("v.mustComment") == true){
                component.set("v.showMotivation", true);
            }
            else{
                component.set("v.showAssets", true);
            }
            component.set("v.showInitialSelect", false);
        }
        else{
            component.set("v.showShortAssets", true);
            component.set("v.showInitialSelect", false);            
            this.hideSpinner(component);
        }
    },
    
    saveFna: function(component, event, helper) {
            this.showSpinner(component);            
            var newFna = component.get("v.fna");
            var oppId = component.get("v.recordId");
            console.log(newFna);
            var action = component.get("c.saveFinancialNeedsAnalysis");    
            action.setParams({
                "newFna": newFna,
                "oppId": oppId
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    var name = a.getReturnValue();
                    component.set("v.fna",name);
                    component.set("v.showAssets", false);
                    component.set("v.showLiabilities", false);
                    component.set("v.showResults", true);                    
                    component.set("v.mustComment", true);
                    if(component.get("v.fna.Assets__c") > 0){
                        component.set("v.showTotalAssets", true);
                    }
                    if(component.get("v.fna.Liabilities__c") > 0){
                        component.set("v.showTotalLiabilities", true);
                    }
                    this.validateMaxAL(component);
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error creating FNA. Please try again",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
                this.hideSpinner(component);
            });
            $A.enqueueAction(action)
            $A.get('e.force:refreshView').fire();
    },
    
    saveShortFna: function(component, event, helper) {
            this.showSpinner(component);
            
            var newFna = component.get("v.fna");
            var oppId = component.get("v.recordId");
            console.log(newFna);
            var action = component.get("c.saveShortFinancialNeedsAnalysis");
            action.setParams({
                "newFna": newFna,
                "oppId": oppId
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    var name = a.getReturnValue();
                    component.set("v.fna",name);
                    component.set("v.showShortAssets", false);
                    component.set("v.showShortResults", true);
                    this.validateShortMaxAssets(component);
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error creating FNA. Please try again",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
                this.hideSpinner(component);
            });
            $A.enqueueAction(action)
        $A.get('e.force:refreshView').fire();
    },
    
    validateShortMaxAssets: function(component) {
        this.showSpinner(component);    
        var oppId = component.get("v.recordId");
        var action = component.get("c.getLatestFinancialNeedsAnalysis");
        var recorTypeName = component.get("v.oppRecordType");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.fna", response.getReturnValue());
                if(component.get("v.fna.Assets__c") >= 999999999.01 && recorTypeName == 'Wills'){
                    component.set("v.showShortAssets", true);
                    component.set("v.showShortResults", false);
                    // show error max assest
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "The value of ASSETS has exceeded the MAXIMUM value of 999 999 999.00 – please correct",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else {
                component.set("v.mustComment", false);                
                component.set("v.showInitialSelect", true);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },  
    
    validateMaxAL: function(component) {
        this.showSpinner(component);    
        var oppId = component.get("v.recordId");
        var action = component.get("c.getLatestFinancialNeedsAnalysis");
        var recorTypeName = component.get("v.oppRecordType");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.fna", response.getReturnValue());
                if((component.get("v.fna.Assets__c") >= 999999999.01 || component.get("v.fna.Liabilities__c") >= 999999999.01) && recorTypeName == 'Wills'){
                    component.set("v.showAssets", true);
                    component.set("v.showLiabilities", true);
                    component.set("v.showResults", false);                    
                    component.set("v.mustComment", true);
                    // show error max assest
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "The value of ASSETS or LIABILITIES has exceeded the MAXIMUM value of R 999 999 999.00 – please correct",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else {
                component.set("v.mustComment", false);                
                component.set("v.showInitialSelect", true);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },  
    
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.fna"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                if(elementId == 'bankAction'){
                    component.set("v.bankActionOptions", opts); 
                }
                if(elementId == 'lispSharesAction'){
                    component.set("v.lispSharesActionOptions", opts); 
                }
                if(elementId == 'fixedPropertiesAction'){
                    component.set("v.fixedPropertiesActionOptions", opts); 
                }
                if(elementId == 'lifePoliciesAction'){
                    component.set("v.lifePoliciesActionOptions", opts); 
                }
                if(elementId == 'otherAssetsAction'){
                    component.set("v.otherAssetsOptions", opts); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchRecordTypeName: function(component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getOpportunityRecordType");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.oppRecordType", response.getReturnValue());
                console.log(component.get("v.oppRecordType"));
            }
            else {
                component.set("v.oppRecordType", 'Unknown');
				console.log(component.get("v.oppRecordType"));                
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
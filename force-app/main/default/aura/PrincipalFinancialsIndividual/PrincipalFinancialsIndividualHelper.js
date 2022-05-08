({
    handleInit : function(component) {
        component.set("v.showSpinner", true);
        var opportunityId = component.get("v.opportunityId");
        var accountId = component.get("v.accountId");
        
        if(opportunityId  && accountId){
            var action = component.get("c.getPrincipalAssetsLiabilities");
        
            action.setParams({
                "opportunityId" : opportunityId,
                "accountId" : accountId
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var assetsAndLiabilities = response.getReturnValue();
                    var asAtDate = new Date();
                    asAtDate = $A.localizationService.formatDate(asAtDate, "yyyy-MM-dd");
                    component.set("v.assetsAndLiabilities", assetsAndLiabilities);
                    
                    if(assetsAndLiabilities){
                        this.updateFixedPropertyBranchTotal(component);
                        this.updateFixedPropertyOwnerTotal(component);
                        this.updateLiabilitiesBranchTotal(component);
                        this.updateLiabilitiesOwnerTotal(component);
                        this.updateAssetsBranchTotal(component);
                        this.updateAssetsOwnerTotal(component);
                        component.set("v.disableClientChange", false);
                        
                        if(assetsAndLiabilities[0]){
                            console.log("PrincipalFin: " + JSON.stringify(assetsAndLiabilities[0]));
                            component.set("v.outcomePositive", assetsAndLiabilities[0].Primary_Owner__r.Outcome_positive_Y_N__c);
                            component.set("v.deedsOfficeSearchAvailable", assetsAndLiabilities[0].Primary_Owner__r.Deeds_office_search_available_Y_N__c);
                            component.set("v.dateDeedsOfficeSearch", assetsAndLiabilities[0].Primary_Owner__r.Date_deeds_office_search__c);
                            component.set("v.asAtDate", assetsAndLiabilities[0].Primary_Owner__r.As_at_date__c);
                        }
                    }
                    
                } else {
                    var errors = response.getError();
                    
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.showToast("Error!",errors[0].message,"error");
                        }
                    } else {
                        this.showToast("Error!","Principal Financials unknown error","error");
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
	},
    
    handleSubmit : function(component){
        var clientName = component.get("v.clientName");
        var dateNow = new Date();
        var asAtDate = component.get("v.asAtDate");
        var dateDeedsOfficeSearch = component.get("v.dateDeedsOfficeSearch");
        var deedsOfficeSearchAvailable = component.find("Deeds_office_search_avaialable_Y_N__c").get("v.value");
        var outcomePositive = component.find("Outcome_Positive_Y_N__c").get("v.value");
        var assetsAndLiabilities = component.get("v.assetsAndLiabilities");
        var asAtDateError = false;
        var dateDeedsError = false;
        dateNow = $A.localizationService.formatDate(dateNow, "yyyy-MM-dd");
        asAtDate = $A.localizationService.formatDate(asAtDate, "yyyy-MM-dd");
        
        if(asAtDate > dateNow || !asAtDate){
            asAtDateError = true;
            this.showToast('Error!', 'Please capture As at (date) and use a past date.', 'warning');
        } else {
            asAtDateError = false;
        }
        
        if(dateDeedsOfficeSearch > dateNow){
            dateDeedsError = true;
            this.showToast('Error!', 'Please capture Date deeds office search and use a past date.', 'warning');
        } else {
            dateDeedsError = false;
        }
        
        if(!asAtDateError && !dateDeedsError){
            component.set("v.showSpinner", true);
            var action = component.get("c.upsertAssetsLiabilities");
            
            action.setParams({
                "appAssetLiabilities" : assetsAndLiabilities,
                "deedsOfficeSearch" : deedsOfficeSearchAvailable,
                "dateDeedsOfficeSearch" : dateDeedsOfficeSearch,
                "deedsOutcomePositive" : outcomePositive,
                "asAtDate" : asAtDate
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var responseMsg = response.getReturnValue();
                    
                    if(responseMsg == 'Success'){
                    	var saveMessage = clientName + " financial record saved."
                        this.showToast('Success!', saveMessage, 'success');
                    } else{
                        this.showToast('Error!', responseMsg, 'error');
                    }
                } else {
                    var errors = response.getError();
                    
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.showToast("Error!",errors[0].message,"error");
                        }
                    } else {
                        this.showToast("Error!","Principal Financials unknown error","error");
                    }
                }
                component.set("v.showSpinner", false);
                component.set("v.disableClientChange", false);
            });
            $A.enqueueAction(action);
        }
    },
    
	updateAssetsOwnerTotal : function(component) {
        component.set("v.disableClientChange", true);
        var assetsAndLiabilities = component.get("v.assetsAndLiabilities");
        var assetsOwnerTotal = 0;
        
        if(assetsAndLiabilities){
            for (var i = 0; i < assetsAndLiabilities.length; i++){
                if(assetsAndLiabilities[i].RecordType.Name == 'Asset'){
                    if(assetsAndLiabilities[i].Amount_Owners_Valuation__c){
                        assetsOwnerTotal += this.checkForNaN(assetsAndLiabilities[i].Amount_Owners_Valuation__c);
                    }
                }
            }
        }
        
        var liabilitiesBranchTotal = this.checkForNaN(component.get("v.liabilitiesBranchTotal"));
        
        component.set("v.assetsOwnerTotal", assetsOwnerTotal);
        
        var networthOwnerEstimateCurrent = this.checkForNaN(assetsOwnerTotal) - this.checkForNaN(liabilitiesBranchTotal);
        component.set("v.networthOwnerEstimateCurrent", networthOwnerEstimateCurrent);
        this.setTotal(component, "Net Worth Owner's Estimate", networthOwnerEstimateCurrent);
	},
    
    updateAssetsBranchTotal : function(component) {
        component.set("v.disableClientChange", true);
        var assetsAndLiabilities = component.get("v.assetsAndLiabilities");
        var assetsBranchTotal = 0;
        
        if(assetsAndLiabilities){
            for (var i = 0; i < assetsAndLiabilities.length; i++){
                if(assetsAndLiabilities[i].RecordType.Name == 'Asset'){
                    if(assetsAndLiabilities[i].Amount__c){
                        assetsBranchTotal += this.checkForNaN(assetsAndLiabilities[i].Amount__c);
                    }
                }
            }
        }
        
        var liabilitiesBranchTotal = parseFloat(component.get("v.liabilitiesBranchTotal"));
        
        component.set("v.assetsBranchTotal", assetsBranchTotal);
        this.setTotal(component, "Total Assets", assetsBranchTotal);
        var networthManagerEstimateCurrent = assetsBranchTotal - liabilitiesBranchTotal; 
        component.set("v.networthManagerEstimateCurrent", networthManagerEstimateCurrent);
        this.setTotal(component, "Net Worth Manager's Estimate", networthManagerEstimateCurrent);
	},
    
    updateLiabilitiesOwnerTotal : function(component) {
        component.set("v.disableClientChange", true);
        var assetsAndLiabilities = component.get("v.assetsAndLiabilities");
        var liabilitiesOwnerTotal = 0;
        
        if(assetsAndLiabilities){
            for (var i = 0; i < assetsAndLiabilities.length; i++){
                if(assetsAndLiabilities[i].RecordType.Name == 'Liability'){
                    if(assetsAndLiabilities[i].Amount_Owners_Valuation__c){
                        liabilitiesOwnerTotal += this.checkForNaN(assetsAndLiabilities[i].Amount_Owners_Valuation__c);
                    }
                }
            }
        }
        
        component.set("v.liabilitiesOwnerTotal", liabilitiesOwnerTotal);
        this.setTotal(component, "Total Liabilities", liabilitiesOwnerTotal);
	},
    
    updateLiabilitiesBranchTotal : function(component) {
        component.set("v.disableClientChange", true);
        var assetsAndLiabilities = component.get("v.assetsAndLiabilities");
        var liabilitiesBranchTotal = 0;
        
        if(assetsAndLiabilities){
            for (var i = 0; i < assetsAndLiabilities.length; i++){
                if(assetsAndLiabilities[i].RecordType.Name == 'Liability'){
                    if(assetsAndLiabilities[i].Amount__c){
                        liabilitiesBranchTotal += this.checkForNaN(assetsAndLiabilities[i].Amount__c);
                    }
                }
            }
        }
        
        var assetsOwnerTotal = parseFloat(component.get("v.assetsOwnerTotal"));
        var assetsBranchTotal = parseFloat(component.get("v.assetsBranchTotal"));
        
        var networthOwnerEstimateCurrent = assetsOwnerTotal - liabilitiesBranchTotal;
        var networthManagerEstimateCurrent = assetsBranchTotal - liabilitiesBranchTotal;
        
        component.set("v.liabilitiesBranchTotal",liabilitiesBranchTotal);
        component.set("v.networthOwnerEstimateCurrent",networthOwnerEstimateCurrent);
        component.set("v.networthManagerEstimateCurrent",networthManagerEstimateCurrent);
        this.setTotal(component, "Net Worth Owner's Estimate", networthOwnerEstimateCurrent);
        this.setTotal(component, "Net Worth Manager's Estimate", networthManagerEstimateCurrent);
	},
    
    updateFixedPropertyOwnerTotal : function(component) {
        component.set("v.disableClientChange", true);
        var assetsAndLiabilities = component.get("v.assetsAndLiabilities");
        var fixedPropertyOwnerTotal = 0;
        
        if(assetsAndLiabilities){
            for (var i = 0; i < assetsAndLiabilities.length; i++){
                if(assetsAndLiabilities[i].RecordType.Name == 'Fixed Property Bond' && 
                   (assetsAndLiabilities[i].Type__c == 'Fixed Properties Bonded' || 
                  	assetsAndLiabilities[i].Type__c == 'Fixed Properties Unbonded' || 
                  	assetsAndLiabilities[i].Type__c == 'Fixed Properties Informal' )){
                    if(assetsAndLiabilities[i].Amount_Owners_Valuation__c){
                        fixedPropertyOwnerTotal += this.checkForNaN(assetsAndLiabilities[i].Amount_Owners_Valuation__c);
                    }
                }
            }
        }
        
        component.set("v.fixedPropertyOwnerTotal",fixedPropertyOwnerTotal);
	},
    
    updateFixedPropertyBranchTotal : function(component) {
        component.set("v.disableClientChange", true);
        var assetsAndLiabilities = component.get("v.assetsAndLiabilities");
        var fixedPropertyBranchTotal = 0;
        
        if(assetsAndLiabilities){
            for (var i = 0; i < assetsAndLiabilities.length; i++){
                if(assetsAndLiabilities[i].RecordType.Name == 'Fixed Property Bond' && 
                   (assetsAndLiabilities[i].Type__c == 'Fixed Properties Bonded' || 
                  	assetsAndLiabilities[i].Type__c == 'Fixed Properties Unbonded' || 
                  	assetsAndLiabilities[i].Type__c == 'Fixed Properties Informal' )){
                    if(assetsAndLiabilities[i].Amount__c){
                        fixedPropertyBranchTotal += this.checkForNaN(assetsAndLiabilities[i].Amount__c);
                    }
                }
            }
        }
        
        component.set("v.fixedPropertyBranchTotal",fixedPropertyBranchTotal); 
        this.setTotal(component, "Total Properties", fixedPropertyBranchTotal);
	},
    
    handleDeedsOfficeDetailsChange : function(component){
        component.set("v.disableClientChange", true);
	},
    
    checkForNaN : function(valueToCheck){
        if(isNaN(valueToCheck)){
            return 0;
        } else{
            return parseFloat(valueToCheck);
        }
    }, 
    
    setTotal: function (component, sectionTotal, sectionTotalAmount) {
        var assetsAndLiabilities = component.get("v.assetsAndLiabilities");
        for (var i = 0; i < assetsAndLiabilities.length; i++) {
            if (assetsAndLiabilities[i].Type__c == sectionTotal) {
                assetsAndLiabilities[i].Amount__c = sectionTotalAmount;
            }
        }

        component.set("v.assetsAndLiabilities", assetsAndLiabilities);
    },

    showToast : function(title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title" : title,
            "message" : message,
            "type" : type
        });
        toastEvent.fire();
    }
})
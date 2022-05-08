({
	helperMethod : function() {
		
	},
    
    getMainLifeDetails: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getMainLifeData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.account", data);
            }
        });
        $A.enqueueAction(action);
    },
    
    getSpouseDetails: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getSpouseData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                    component.set("v.spouse", data);
                    if(component.get("v.spouse.RSA_ID_Number__c") == null){
                        component.set("v.spouse.RSA_ID_Number__c", "N/A");
                    }
                    component.set("v.showSpouseDetails", true);
                }
                else{
                    component.set("v.showSpouseDetails", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchQuoteData: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var action = component.get("c.getQuoteLineItemsData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                    var i;
                    var totalMainLifePremium = 0;
                    var totalSpousePremium = 0;
                    for (i = 0; i < data.length; i++) {
                        //Main Life Data Population
                        if(data[i].PricebookEntry.Name.includes('Executor Fees') && !(data[i].PricebookEntry.Name.includes('Spouse'))){
                            component.set("v.mainLifeExecutor", data[i].Policy_Cover__c);
                            totalMainLifePremium += Number(data[i].Premium__c);                        
                        }
                        else if(data[i].PricebookEntry.Name.includes('Estate Bridging') && !(data[i].PricebookEntry.Name.includes('Spouse'))){
                            component.set("v.mainLifeBridging", data[i].Policy_Cover__c);
                            totalMainLifePremium += Number(data[i].Premium__c);
                        }
                        else if(data[i].PricebookEntry.Name.includes('Funeral Benefit') && !(data[i].PricebookEntry.Name.includes('Spouse'))){
                            component.set("v.mainLifeFuneral", data[i].Policy_Cover__c);	
                            totalMainLifePremium += Number(data[i].Premium__c);
                        }
                        
                        //Spouse Data Population
                        if(data[i].PricebookEntry.Name.includes('Executor Fees') && (data[i].PricebookEntry.Name.includes('Spouse'))){
                            component.set("v.spouseExecutor", data[i].Policy_Cover__c);
                            totalSpousePremium += Number(data[i].Premium__c);  
                        }
                        else if(data[i].PricebookEntry.Name.includes('Estate Bridging') && (data[i].PricebookEntry.Name.includes('Spouse'))){
                            component.set("v.spouseBridging", data[i].Policy_Cover__c);	
                            totalSpousePremium += Number(data[i].Premium__c);  
                        }
                        
                        //Policy Fee Data Population
                        if(data[i].PricebookEntry.Name.includes('Policy Fee')){
                            component.set("v.policyFee", data[i].Premium__c);
                        }
                    }
                    component.set("v.mainLifePremium", totalMainLifePremium);
                    component.set("v.spousePremium", totalSpousePremium);

                    //Main Life Data Checks
                    if(component.get("v.mainLifeExecutor") == null){
                        component.set("v.mainLifeExecutor", '0');
                    }
                    if(component.get("v.mainLifeBridging") == null){
                        component.set("v.mainLifeBridging", '0');
                    }
                    if(component.get("v.mainLifeFuneral") == null){
                        component.set("v.mainLifeFuneral", '0');
                    }
                    if(component.get("v.mainLifePremium") == null){
                        component.set("v.mainLifePremium", '0');
                    }
                    
                    //Spouse Data Checks
                    if(component.get("v.spouseExecutor") == null){
                        component.set("v.spouseExecutor", '0');
                    }
                    if(component.get("v.spouseBridging") == null){
                        component.set("v.spouseBridging", '0');
                    }
                    if(component.get("v.spouseFuneral") == null){
                        component.set("v.spouseFuneral", '0');
                    }
                    if(component.get("v.spousePremium") == null){
                        component.set("v.spousePremium", '0');
                    }  
                    
                    if(component.get("v.spousePremium") == 0){
                        component.set("v.showSpousePremium", false);
                    }
                    else{
                        component.set("v.showSpousePremium", true);
                    }
                    
                    this.fetchTotalQuoteData(component);
                    component.set("v.showQuoteDetails", true);
                }
                //Else no quote data found
                else{
                    component.set("v.showQuoteDetails", false);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    fetchTotalQuoteData: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getTotalQuoteData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.quoteTotal", data);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchBeneficiaryData: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getBeneficiaryData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                	component.set("v.dataBeneficiaries", data);
                    component.set("v.showBeneficiaryDetails", true);
                }
                else{
                    component.set("v.showBeneficiaryDetails", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDependantData: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getDependantData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                	component.set("v.dataDependants", data);
                    component.set("v.showDependantDetails", true);
                }
                else{
                    component.set("v.showDependantDetails", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
})
({
    handleInit: function (component, event,helper) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getExistingAccounts");
        var opportunityId = component.get("v.recordId");
        
        action.setParams({
            "opportunityId": opportunityId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var serviceResponse = response.getReturnValue();
                console.log('serviceResponse'+serviceResponse);
                if(serviceResponse != null) {
                    var existingAccounts = serviceResponse['AppFinancials'];
                    console.log('existingAccounts'+JSON.stringify(existingAccounts));
                    var contracts=serviceResponse['Contracts'];
                    console.log('contracts'+JSON.stringify(contracts));
                    component.set("v.existingAccounts", existingAccounts);
                    component.set("v.existingBankGuarantees", serviceResponse['AppFinancials'].length);
                    component.set("v.contracts", contracts);
                    component.set("v.showSpinner", false);
                    this.getManagedAccountsHelper(component);
                }
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    handleOnCheckManageAcc: function (component,event,helper) {
        
        var target = event.getSource();
        var chValue = target.get("v.value"); //is checkbox selected
        var chText = target.get("v.text"); //id of account selected
        var existingAccounts = component.get("v.existingAccounts");
        var managedAccounts = component.get("v.managedAccounts");
        var numSelAccs = component.get("v.mngdExistingBankGuarantees");
        for (var i = 0; i < existingAccounts.length; i++) {
          var chqAcc = existingAccounts[i];
          if (chqAcc != null) {

                if (chqAcc.Id == chText && !chValue) {
                    for(var j = 0; j < managedAccounts.length; j++ ){
                    var chqAccMan = managedAccounts[j];
                    console.log('chqAccMan'+chqAccMan.Id);
                    if(chqAccMan.Id == chText && !chValue){
                    var index = managedAccounts.indexOf(chqAccMan);
                    console.log('index'+index);
                    managedAccounts.splice(index, 1);
                    numSelAccs--;
                    var action = component.get("c.deleteManagedAccount");
                    action.setParams({
            "chText": chText
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var serviceResponse = response.getReturnValue();
                console.log('serviceResponse'+serviceResponse);
                } 
        });
        $A.enqueueAction(action);
                    break;
                }
                    }
                }
                if (chqAcc.Id == chText && chValue) {
                    var index = existingAccounts.indexOf(chqAcc);
                    numSelAccs++;
                    managedAccounts.splice(index,0,chqAcc);
                    component.set("v.enableSlctdAccBtn", false);
                    break;
                }
            }
            
                  
    }
   
        if(numSelAccs == 0){
                component.set("v.enableSlctdAccBtn", true);
                component.set("v.manageAccounts", false);
            }
        
        component.set("v.managedAccounts", managedAccounts);
        console.log('managedAccountska'+JSON.stringify(managedAccounts));
        component.set("v.mngdExistingBankGuarantees", numSelAccs);
        
        /*
        var opportunityId = component.get("v.recordId");
        var checkBoxId = event.target.id;
        var checkBox = document.getElementById(checkBoxId);
        console.log('checkBox'+checkBox);
        console.log('checkBox.checked'+checkBox.checked);
        var checkBoxIndex = String(checkBoxId).split('|')[1];
        var existingAccounts = component.get("v.existingAccounts");
        var managedAccounts = component.get("v.managedAccounts");
        var mngdExistingBankGuarantees = component.get("v.mngdExistingBankGuarantees");
        if(checkBox.checked == true){
            var managedAccount = {Facility_account_number__c: existingAccounts[checkBoxIndex].Facility_account_number__c, Total_contract_balance__c: existingAccounts[checkBoxIndex].Total_contract_balance__c};
            managedAccounts.push(managedAccount);
            mngdExistingBankGuarantees++;
            component.set("v.mngdExistingBankGuarantees", mngdExistingBankGuarantees);
            component.set("v.enableSlctdAccBtn", false);
        }
        else{
            mngdExistingBankGuarantees--;
            component.set("v.mngdExistingBankGuarantees", mngdExistingBankGuarantees);
            var existingAccounts = component.get("v.existingAccounts");
            var managedAccounts = component.get("v.managedAccounts");
            var isAnyAccountSelected = false;
            managedAccounts.splice(checkBoxIndex, 1);
            component.set("v.managedAccounts", managedAccounts);
            if(mngdExistingBankGuarantees == 0){
                component.set("v.enableSlctdAccBtn", true);
                component.set("v.manageAccounts", false);
            }
        }
        */
       
    },
 
    hanldeSelectedAccounts: function (component,event,helper) {
        component.set("v.manageAccounts", true);
    },
    addNewBankAccount: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getApplicationProducts");
        var opportunityId = component.get("v.recordId");
        
        action.setParams({
            "opportunityId": opportunityId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                var newAccounts = component.get("v.newAccounts");
                var newCreditCards = component.get("v.newCreditCards");
                //console.log('responseData'+responseData);
                for(var i in responseData)
                {
                    console.log('tempo'+responseData[i].Temp_Account_Number__c);
                }
                if(responseData && responseData != null){
                    newCreditCards++;
                    newAccounts.push(responseData);
                    component.set("v.newAccounts", newAccounts);
                    for(var i in newAccounts)
                    {
                        //console.log('tempno'+newAccounts[i].Temp_Account_Number__c);
                    }
                    component.set("v.newCreditCards", newCreditCards);
                }
                component.set("v.showSpinner", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("CreditCard: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleSaveAndValidate : function (component,event,helper){
    	//component.set("v.showSpinner", true);
    	var existingAccts=component.get('v.existingAccounts');
        console.log('existingAccts'+JSON.stringify(existingAccts));
        var opportunityId = component.get("v.recordId");
        var managedAccounts = component.get("v.managedAccounts");
        console.log('managedAccounts'+JSON.stringify(managedAccounts));
        var newAccounts = component.get("v.newAccounts");
        console.log('newAccounts'+JSON.stringify(newAccounts));
        var errorMessage=component.get("v.errorMessage");
        //var errorMessageManaged=component.get("v.errorMessageManaged");
        component.set("v.errorMessage",false);
        //var errorMessageManaged=false;
        component.set("v.errorMessageManaged",false);
        var contracts=component.get("v.contracts");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        for(var i in newAccounts){
            
            var fieldVal =newAccounts[i].Facility_review_date__c;
            var startDate = new Date(fieldVal);
            var endDate = new Date(today);
            var days = (startDate-endDate)/8.64e7;
            if(days>365 || days<0){
                component.set('v.errorMessage',true);
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Facility Review Date cannot be greater than 1 year from current date and it cannot be a past date"
            });
             toastEvent.fire();
            }
            console.log('errorMessage'+component.get('v.errorMessage'));
        }
        for(var i in managedAccounts){
            var fieldVal = managedAccounts[i].Requested_review_date__c;
            var startDate = new Date(fieldVal);
            var endDate = new Date(today);
            var days = (startDate-endDate)/8.64e7;
            console.log('days'+days);
            if(days>365 || days<0){
                component.set('v.errorMessageManaged',true);
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Requested Review Date cannot be greater than 1 year from current date and cannot be a past date"
            });
             toastEvent.fire();
            }
            console.log('errorMessageManaged'+component.get('v.errorMessageManaged'));
            
            
        }
        if(!component.get('v.errorMessage') && !component.get('v.errorMessageManaged')){
        var action = component.get("c.saveClass");
        action.setParams({
            "managedAccounts": managedAccounts,
            "newAccounts": newAccounts,
            "opportunityId": opportunityId,
            "contracts": contracts
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var responseData = response.getReturnValue();
            console.log('responseData'+responseData);
            if (state === "SUCCESS") {
                /*
                var error=component.get('v.errorMessage');
                if(error){
                    var toastEvent = this.getToast("Error! ", "Facility Review Date may not be greater than 1 year from current date", "Error");
        		    toastEvent.fire();
                }
                */
                //else{
                var toastEvent = this.getToast("Success! ", "Data saved successfully", "Success");
        		toastEvent.fire();
                 var appEvent = $A.get("e.c:creditOriginationEvent");
                    if (appEvent) {
                        appEvent.setParams({ "sourceComponent": "CheckAndOverdraft" });
                        appEvent.fire();
                    }
                //}
                //component.set("v.showSpinner", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                //component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error" + errors[0].message);
                        this.showToast("Error!", errors[0].message, "error");
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        }
    },
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
        });

        return toastEvent;
    },
    getManagedAccountsHelper: function (component){
        component.set("v.showSpinner", true);
        var action = component.get("c.getManagedLDPAccounts");
        var opportunityId = component.get("v.recordId");

        action.setParams({
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                console.log('responseData'+JSON.stringify(responseData));
                if(responseData && responseData != null){
                    component.set("v.managedAccounts", responseData);
                    console.log('managedAccounts'+JSON.stringify(component.get('v.managedAccounts')));
                    //component.set("v.manageAccounts",true);
                    component.set("v.mngdExistingBankGuarantees", responseData.length);
                    component.set("v.showSpinner", false);
                    this.checkManagedAccounts(component);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Error!", "Credit Card: " + errors[0].message, "error");
                    }
                } else {
                    this.showToast("Error!", "Credit Card: unknown error", "error");
                }
            }
        });
        $A.enqueueAction(action);
    },
        
        checkManagedAccounts : function(component){
        component.set("v.showSpinner", true);
        var existingAccounts = component.get("v.existingAccounts");
        var managedAccounts = component.get("v.managedAccounts");
        var isAnyAccountSelected = false;
        if(existingAccounts && existingAccounts.length > 0 && managedAccounts && managedAccounts.length > 0){
            for(var i = 0; i < existingAccounts.length; i++){
                for(var j = 0; j < managedAccounts.length; j++){
                    if(existingAccounts[i].Facility_account_number__c == managedAccounts[j].Facility_account_number__c){
                        existingAccounts[i].isSelected__c = "true";
                        isAnyAccountSelected = true;
                        
                    }
                }
                console.log('isSelected__c'+existingAccounts[i].isSelected__c);
                
            }
            
        }
       if(isAnyAccountSelected){
            component.set("v.existingAccounts", existingAccounts);
            component.set("v.manageAccounts", true);
        }     
component.set("v.showSpinner", false);
        console.log('existing'+JSON.stringify(component.get('v.existingAccounts')));
    },
    
    getNewAccounts : function(component){
        component.set("v.showSpinner", true);
        var action = component.get("c.getNewAccounts");
        var opportunityId = component.get("v.recordId");

        action.setParams({
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                console.log('res'+JSON.stringify(responseData));
                component.set("v.newAccounts", responseData);
                component.set("v.showSpinner", false);

                if(responseData && responseData != null){
                    component.set("v.newCreditCards", responseData.length);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Error!", "Credit Card: " + errors[0].message, "error");
                    }
                } else {
                    this.showToast("Error!", "Credit Card: unknown error", "error");
                }
            }
        });
        $A.enqueueAction(action);
    },

        saveupdateContract: function (component, event, helper) {
        var target = event.getSource();
        var chValue = target.get("v.value"); //is checkbox selected
        var chText = target.get("v.text"); //id of account selected
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.getUpdatedCon");
        action.setParams({
            "chText": chText,
            "chValue": chValue,
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                component.set('v.contracts',responseData);
                console.log('contracts'+JSON.stringify(component.get('v.contracts')));
            } else if (state === "ERROR") {
                var errors = response.getError();
                
                //component.set("v.showSpinner", false);

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log('error'+errors[0].message);
                        //this.showToast("Error!", "Credit Card: " + errors[0].message, "error");
                    }
                } else {
                    //this.showToast("Error!", "Credit Card: unknown error", "error");
                }
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
     showToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
        });

        toastEvent.fire();
    }
    
})
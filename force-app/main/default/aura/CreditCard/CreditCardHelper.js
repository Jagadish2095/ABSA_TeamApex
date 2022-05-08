({
    getExistingAccounts: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getExistingAccounts");
        var opportunityId = component.get("v.recordId");

        action.setParams({
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                component.set("v.existingAccounts", responseData);
                component.set("v.showSpinner", false);

                if(responseData && responseData != null){
                    this.getManagedAccounts(component);
                    component.set("v.existingCreditCards", responseData.length);
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

    getManagedAccounts: function (component){
        component.set("v.showSpinner", true);
        var action = component.get("c.getManagedAccounts");
        var opportunityId = component.get("v.recordId");

        action.setParams({
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                component.set("v.managedAccounts", responseData);
                component.set("v.showSpinner", false);
                this.checkManagedAccounts(component);

                if(responseData && responseData != null){
                    component.set("v.mngdExistingCreditCards", responseData.length);
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

    checkManagedAccounts : function(component){
        var existingAccounts = component.get("v.existingAccounts");
        var managedAccounts = component.get("v.managedAccounts");
        var isAnyAccountSelected = false;

        if(existingAccounts && existingAccounts.length > 0 && managedAccounts && managedAccounts.length > 0){
            for(var i = 0; i < existingAccounts.length; i++){
                for(var j = 0; j < managedAccounts.length; j++){
                    if(parseInt(existingAccounts[i].accountNumber, 10) == parseInt(managedAccounts[j].accountNumber, 10) && existingAccounts[i].accountNumber != ''){
                        existingAccounts[i].isSelected = "true";
                        isAnyAccountSelected = true;
                    }
                }
            }
        }

        if(isAnyAccountSelected){
            component.set("v.existingAccounts", existingAccounts);
            component.set("v.manageAccounts", true);
        }
    },

    handleOnCheckManageAcc: function (component,event) {
        var opportunityId = component.get("v.recordId");
        var checkBoxId = event.target.id;
        var checkBox = document.getElementById(checkBoxId);
        var checkBoxIndex = String(checkBoxId).split('|')[1];
        var existingAccounts = component.get("v.existingAccounts");
        var managedAccounts = component.get("v.managedAccounts");
        var mngdExistingCreditCards = component.get("v.mngdExistingCreditCards");

        if(checkBox.checked == true){
            var managedAccount = {accountNumber: String(existingAccounts[checkBoxIndex].accountNumber)};
            managedAccount["creditCardLimit"] = existingAccounts[checkBoxIndex].creditCardLimit;
            managedAccount["allocatedLimit"] = existingAccounts[checkBoxIndex].allocatedLimit;
            managedAccount["accBalance"] = existingAccounts[checkBoxIndex].accBalance;
            managedAccount["accStatus"] = existingAccounts[checkBoxIndex].accStatus;
            managedAccount["accStatusDesc"] = existingAccounts[checkBoxIndex].accStatusDesc;
            managedAccount["instalment"] = existingAccounts[checkBoxIndex].instalment;
            managedAccount["serviceFeeAmnt"] = existingAccounts[checkBoxIndex].serviceFeeAmnt;
            managedAccount["interestRate"] = existingAccounts[checkBoxIndex].interestRate;
            managedAccount["interestType"] = existingAccounts[checkBoxIndex].interestType;
            managedAccount["expiryDate"] = existingAccounts[checkBoxIndex].expiryDate;
            managedAccount["product"] = existingAccounts[checkBoxIndex].product;
            managedAccount["subProduct"] = existingAccounts[checkBoxIndex].subProduct;
            managedAccount["requestedCreditCardLimit"] = "0.00";
            managedAccount["campaignCode"] = "";
            managedAccount["recordId"] = "";
            managedAccount["opportunityId"] = opportunityId;

            managedAccounts.push(managedAccount);
            mngdExistingCreditCards++;
            component.set("v.mngdExistingCreditCards", mngdExistingCreditCards);
            component.set("v.enableSlctdAccBtn", false);
        } else{
            mngdExistingCreditCards--;
            component.set("v.mngdExistingCreditCards", mngdExistingCreditCards);
            var accountNumber = existingAccounts[checkBoxIndex].accountNumber;

            var existingAccounts = component.get("v.existingAccounts");
            var managedAccounts = component.get("v.managedAccounts");
            var isAnyAccountSelected = false;
            
            if(existingAccounts && existingAccounts.length > 0 && managedAccounts && managedAccounts.length > 0){
                for(var i = 0; i < existingAccounts.length; i++){
                    for(var j = 0; j < managedAccounts.length; j++){
                        if(parseInt(existingAccounts[i].accountNumber, 10) == parseInt(managedAccounts[j].accountNumber, 10) && existingAccounts[i].accountNumber != '' && managedAccounts[j].recordId != ''){
                            var action = component.get("c.deleteManagedAccount");
                            var appProdId = managedAccounts[j].recordId;
                            
                            action.setParams({
                                "appProdId": appProdId
                            });
                            
                            action.setCallback(this, function (response) {
                                var state = response.getState();
                                
                                if (state === "SUCCESS") {
                                    managedAccounts.splice(checkBoxIndex, 1);
                                    component.set("v.managedAccounts", managedAccounts);
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
                        }
                    }
                }
            }

            if(mngdExistingCreditCards == 0){
                component.set("v.enableSlctdAccBtn", true);
                component.set("v.manageAccounts", false);
            }
        }
    },

    hanldeSelectedAccounts: function (component) {
        component.set("v.manageAccounts", true);
    },

    handleAddNewAccount : function (component){
        component.set("v.showSpinner", true);
        var action = component.get("c.createNewCreditCard");
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

                if(responseData && responseData != null){
                    newCreditCards++;
                    newAccounts.push(responseData);
                    component.set("v.newAccounts", newAccounts);
                    component.set("v.newCreditCards", newCreditCards);
                }
                component.set("v.showSpinner", false);
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

    handleSaveAndValidate : function (component){
        
        var newAccounts = component.get("v.newAccounts");
        var isCreditLimit = false;      //added by Himanshu W-012918 
        for (var i=0; i < newAccounts.length; i++) {
            console.log('newAccounts'+ newAccounts[i]);
            if(parseInt(newAccounts[i].Requested_facility_limit__c) < 10000){
                isCreditLimit = true;
            }
        }
        if(isCreditLimit){
            
            this.showToast("Error! ", "Please enter amount R10,000.00 or more ", "Error");
            
        }else{
            component.set("v.showSpinner", true);
            var action = component.get("c.saveAndValidateData");
            var managedAccounts = component.get("v.managedAccounts");
            
            action.setParams({
                "managedAccounts": JSON.stringify(managedAccounts),
                "newAccounts": JSON.stringify(newAccounts)
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    if(response.getReturnValue){
                        this.showToast("Success! ", "Data saved successfully", "Success");
                    } else {
                        this.showToast("Error! ", "Data saved unsuccessfully", "Error");
                    }	
                    
                    //added by Manish for W-012191
                    var appEvent = $A.get("e.c:creditOriginationEvent");
                    if (appEvent) {
                        appEvent.setParams({ "sourceComponent": "CheckAndOverdraft" });
                        appEvent.fire();
                    }
                    //W-012191 changes end
                    component.set("v.showSpinner", false);
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
        }
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
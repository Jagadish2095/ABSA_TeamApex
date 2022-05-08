({
    /*@ Author: Danie Booysen
 	**@ Date: 25/03/2020
 	**@ Description: Method to show lighting spinner*/
    showSpinner : function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    /*@ Author: Danie Booysen
 	**@ Date: 25/03/2020
 	**@ Description: Method to hide lighting spinner*/
    hideSpinner : function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method that to fetch picklist values from fields*/
    fetchPickListVal: function(component, fieldName, elementId) {

        this.showSpinner(component);
        var action = component.get("c.getSelectOptions");
        action.setParams({
            "objObject": component.get("v.paymentPlan"),
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

                if(elementId == 'accountType'){
                    component.set("v.accTypeOptions", opts);
                }

            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method to set tge picklist value once selected*/
    onPicklistAccTypeChange : function(component, event) {
        component.set("v.paymentPlan.Account_Type__c", event.getSource().get("v.value"));
    },

    /*@ Author: Danie Booysen
 	**@ Date: 25/03/2020
 	**@ Description: Method to validate the banking details provided*/
    validateAcc : function (component){

        this.showSpinner(component);
        var action = component.get("c.checkBankAccount");
        var accountNumber = component.get("v.paymentPlan.Account_Number__c");
        var branchCode = component.get("v.paymentPlan.Branch_Code__c");
        var accountTypeStr = component.get("v.paymentPlan.Account_Type__c");
        var accountType;
        if(accountTypeStr == 'Cheque') {
            accountType = '01';
        }else if(accountTypeStr == 'Savings') {
            accountType = '02';
        }else if(accountTypeStr == 'Transmission') {
            accountType = '03';
        }

        action.setParams({
            "accountNumber": accountNumber,
            "branchCode": branchCode,
            "accountType": accountType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS" ) {
                if (response.getReturnValue()){
                    //Save bank account details on successful validation
                    this.submitPaymentPlan(component);

                    $A.get('e.force:refreshView').fire();

                    var errorMsg = component.find("errorMsg");
                    $A.util.addClass(errorMsg, 'slds-hide');
                }
                else{
                    //Set form status to invalid
                    component.set("v.cmpFormStatus", "invalid");
                    // Show toast
                    //this.fireToast("error", "Error!", component.get("v.paymentPlan.Bank_Name__c") + " invalid bank account details. Please correct before continuing.");
                    var errorMsg = component.find("errorMsg");
                    $A.util.removeClass(errorMsg, 'slds-hide');
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);

    },

    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method to save the banking details provided*/
    submitPaymentPlan : function (component) {

        this.showSpinner(component);
        var action = component.get("c.submitPaymentPlanDetail");
        var accNumber = component.get("v.paymentPlan.Account_Number__c");
        var accType = component.get("v.paymentPlan.Account_Type__c");
        var bankName = component.get("v.paymentPlan.Bank_Name__c");
        var branchCode = component.get("v.paymentPlan.Branch_Code__c");
        var branchName = component.get("v.paymentPlan.Branch_Name__c");
        var name = accType + ' - ' +  accNumber;
        var type = 'Merchant Product';
        var status = 'New';

        action.setParams({
            "opportunityId": component.get( "v.entityId" ),
            "accNumber": accNumber,
            "accType": accType,
            "bankName": bankName,
            "branchCode": branchCode,
            "branchName": branchName,
            "name": name,
            "type": type,
            "status": status,
            "typeOfDetails": component.get("v.bankAccDetailsType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //Set form status to valid
                component.set("v.cmpFormStatus", "valid");
                if (component.get('v.isShowSuccessToast')) {
                    // Show toast
                    this.fireToast("success", "Success!", bankName + " bank account details validated & saved successfully.");
                }

            }else if (state === "ERROR"){
                //Set form status to invalid
                component.set("v.cmpFormStatus", "invalid");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);

                        // Show toast
                        this.fireToast("error", "Error!", "The was an error saving the bank account details. " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            $A.get('e.force:refreshView').fire();
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);

    },

    // J QUEV 2020-05-07
    // Method to validate all fields
    // Called onLoad so does not need to show the errors on the fields
    allFieldsValid: function(component) {

        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");
        var arrayFields = [];

        for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {
            var inputCmp = component.find(arrayAuraIdsToBeValidated[i]);
            if (inputCmp) {
                Array.isArray(inputCmp) ? arrayFields.push.apply(arrayFields, inputCmp) : arrayFields.push(inputCmp);
            }
        }

        // Show error messages if required fields are blank
        var allValid = arrayFields.reduce(function (validFields, inputCmp) {

            var inputCmpValue = inputCmp.get("v.value");
            var inputCmpRequired = inputCmp.get("v.required");
            var inputCmpValid = true;

            if(inputCmpRequired && $A.util.isEmpty(inputCmpValue)){
                inputCmpValid = false;
            }

            return validFields && inputCmpValid;
        }, true);

        //Validate the selected records in the child lookup components
        if($A.util.isEmpty(component.get("v.paymentPlan.Branch_Name__c")) || $A.util.isEmpty(component.get("v.paymentPlan.Bank_Name__c"))){
            allValid = false;
        }

        return allValid;
    },

    /*@ Author: Danie Booysen
 	**@ Date: 12/05/2020
 	**@ Description: Method that fires a toast message(event)*/
     fireToast : function(type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }

})
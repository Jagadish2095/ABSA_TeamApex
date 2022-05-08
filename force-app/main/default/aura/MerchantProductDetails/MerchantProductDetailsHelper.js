({
    getDataForForm: function(component) {

        var selectOptionFields = component.get("v.selectOptionFields");

        var action = component.get("c.getData");
        action.setParams({
            "opportunityIdP": component.get("v.recordId"),
            "applicationProdMerchIdP": component.get("v.applicationProdMerchId"),
            "picklistFieldNameListP": selectOptionFields
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if(responseValue != null){

                    // Set Product Information
                    component.set("v.productDeviceTypeName", responseValue["productName"]);

                    if(responseValue["productClassification"]){
                        component.set('v.productClassificationPopulated', true);

                        if(!component.get("{!v.isFormReadOnly}") && responseValue["productClassification"].includes("Desktop")){
                            component.set("{!v.communicationRequiredIsDisabled}", false);
                        }else{
                            component.set("{!v.communicationRequiredIsDisabled}", true);
                        }
                    }

                    // Set Picklist Values
                    // No Index required because we remove the item from the array after each iteration
                    for(;selectOptionFields.length;){
                        if(responseValue[selectOptionFields[0]] && !String(responseValue[selectOptionFields[0]]).includes('Values')){

                            var options = responseValue[selectOptionFields[0]].split(";");
                            var optionsValues = responseValue[selectOptionFields[0] + 'Values'].split(";");
                            var attributeId = "v.options_" + selectOptionFields[0];
                            component.set(attributeId, this.convertArrayToSelectOptions(options, optionsValues));
                            selectOptionFields.splice(0, 1);
                        }
                    }

                    // Set applicationProdMerchId
                    if(!$A.util.isEmpty(responseValue["applicationProdMerchId"])){
                        component.set("v.applicationProdMerchId", responseValue["applicationProdMerchId"]);

                        // Set Flag to show load is complete
                        component.set("v.isFormPopulated", true);

                        // Reload recordData
                        component.find('recordEditor').reloadRecord();
                    }
                    if (component.get("v.productDeviceTypeName") != '') {
                        this.fieldVisibility(component);
                    }
                    if (component.get("v.productDeviceTypeName") == 'E-Commerce') {
                        component.set("v.cspDisabled", false);
                    }
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    // function to determine Field Visibility - Tinashe M Shoko - 2020-0720
    fieldVisibility: function(component) {
        var action = component.get("c.determineFieldVisibility");
        action.setParams({
            "pName": component.get("v.productDeviceTypeName"),
            "compName": "MerchantProductDetails"
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                for (var i = 0; i<responseValue.length; i++){
                    $A.util.addClass(component.find(responseValue[i].Field_Name__c), "slds-hide");
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "fieldVisibility: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "fieldVisibility: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    convertArrayToSelectOptions: function(optionsArray, optionsValuesArray) {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "--- None ---",
            value: ""
        });

        for (var i = 0; i < optionsArray.length; i++) {
            opts.push({
                class: "optionClass",
                label: optionsArray[i],
                value: optionsValuesArray[i]
            });
        }
        return opts;
    },

    handleSaveRecord: function(component, event, helper) {

        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
                component.set("v.cmpFormStatus", "valid");
                if (component.get('v.isShowSuccessToast')) {
                    helper.fireToast("Success!", "Record has been updated successfully.", "success");
                }
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
                component.set('v.cmpFormStatus', "invalid");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' +
                            JSON.stringify(saveResult.error));
                component.set('v.cmpFormStatus', "invalid");
                var errMsg = "";
                // saveResult.error is an array of errors,
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                helper.fireToast("Error", 'Product Details: ' + errMsg, "error");
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                component.set('v.cmpFormStatus', "invalid");
                helper.fireToast(saveResult.state, 'Product Details: ' + JSON.stringify(saveResult.error), "error");
            }
        }));
    },

    // PJAIN: 20200505
    // Method to validate all fields
    // showErrorFlag - Boolean value to display errors on the field
    // Use case 1:  showErrorFlag would be true when calling this method from save as you would want to display errors
    // Use case 2:  showErrorFlag would be false when calling this method on load to check if the fields are complete to mark the form as ValidToSubmit
    // This version of the method validates lightning:input
    allFieldsValid: function(component, showErrorFlag) {

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
            if (showErrorFlag) {
                inputCmp.showHelpMessageIfInvalid();
            }

            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        return allValid;
    },

    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})
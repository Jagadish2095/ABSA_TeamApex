({
    /*@ Author: Danie Booysen
 	**@ Date: 19/05/2020
 	**@ Description: Method that calls a function in the Apex controller to retrieve the data*/
    getFormData : function(component) {
        var action = component.get("c.getMerchDevices");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    component.set("v.merchantDeviceList", responseValue);
                }
                this.fieldVisibility(component);
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    // function to determine Field Visibility - Tinashe M Shoko - 2020-07-20
    fieldVisibility: function(component) {
        var action = component.get("c.determineFieldVisibility");
        action.setParams({
            "opportunityIdP": component.get("v.recordId"),
            "compName": "MerchantDevice"
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
    
    /*@ Author: Danie Booysen
 	**@ Date: 21/05/2020
 	**@ Description: Method that handles the submit functionality of the deviceForm or deviceForms*/
    submitDeviceForms : function(component, event, helper) {
        if (helper.allFieldsValid(component)) {
            var deviceForm = component.find("deviceForm");
            var deviceFormArr = [];
            Array.isArray(deviceForm) ? deviceFormArr = deviceForm : deviceFormArr.push(deviceForm);

            deviceFormArr.forEach( form =>{
                form.submit();
            });
        } else {
            component.set("v.cmpFormStatus", "invalid");

            if (component.get('v.isShowSuccessToast')) {
                helper.fireToast("error", "Error!", "Please complete all the required fields.");
            }
        }
    },

    // J QUEV 2020-05-07
    // Method to validate all fields
    // Called onLoad so does not need to show the errors on the fields
    // This version of the method validates lightning:inputField
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

        return allValid;
    },

    /*@ Author: Danie Booysen
 	**@ Date: 29/05/2020
     **@ Description: Method that resets the value of an inputField to the original (database value)
     **               This would work if the field is an Array (multiple fields with the same id) of fields or just a single field element*/
    resetFieldValue : function(component){

        let fields = component.get("v.resetFieldsList");
        for(var i = 0; i<fields.length; i++){
            var thisField = component.find(fields[i]);
            var isFieldArray = Array.isArray(thisField);

            if(isFieldArray){
                thisField.forEach(function(field) {
                    if(field){
                        field.reset();
                    }
                });
            }else{
                if(thisField){
                    thisField.reset();
                }
            }
        }
    },

    /*@ Author: Danie Booysen
 	**@ Date: 19/05/2020
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
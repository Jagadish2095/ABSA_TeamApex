({
	getApplicationProductMerchant: function(component) {

        var action = component.get("c.getApplicationProductMerchantId");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if(responseValue != null){
                    component.set("v.applicationProductMerchantId", responseValue);
                    //Test to check if this works to populate the form
                    ///component.set("v.reloadForm", false);
                    //component.set("v.reloadForm", true);
                    this.resetFieldValue(component);
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
 	**@ Date: 05/05/2020
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

    depositMonitoringCheck : function(component) {
        //There is a bug created by hiding and showing the form quickly using aura if.
        //This causes issues with the aura id field. Hence the line of code below
        //https://salesforce.stackexchange.com/questions/281201/error-component-find-get-is-not-a-function-in-lightning
        var isChecked = component.find("appProdMerchDepositMonitoring");
        isChecked = Array.isArray(isChecked) ? isChecked[0].get("v.value") : isChecked.get("v.value");
        component.set("v.depositMonitoringRequired", isChecked);
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
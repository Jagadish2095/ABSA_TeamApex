({
    /*@ Author: Danie Booysen
 	**@ Date: 29/04/2020
 	**@ Description: Method to fetch Application Product-Merchant record id*/
    getApplicationProductMerchant: function(component) {

        var action = component.get("c.getApplicationProductMerchant");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            console.log("response State: " + response.getState());
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                console.log("responseValue: " + responseValue);
                if (responseValue != null && responseValue.Id != null) {
                    component.set("v.applicationProductMerchantId", responseValue.Id);
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

    /*@ Author: Danie Booysen
 	**@ Date: 29/04/2020
 	**@ Description: Method that shows the spinner*/
    showSpinner : function(component, event, helper){
        $A.util.removeClass(component.find("spinner"), "slds-hide");
    },

    /*@ Author: Danie Booysen
 	**@ Date: 29/04/2020
 	**@ Description: Method that hides the spinner*/
    hideSpinner : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
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
 	**@ Date: 04/05/2020
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
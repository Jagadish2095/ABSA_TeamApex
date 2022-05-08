({
	getApplication: function(component) {

        var action = component.get("c.getApplication");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();

                if(responseValue != null){
                    component.set("v.applicationId", responseValue.Id);
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
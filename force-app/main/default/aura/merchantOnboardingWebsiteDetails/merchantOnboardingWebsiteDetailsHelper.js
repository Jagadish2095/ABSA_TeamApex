({
	 //Validate Method
	 //Returns true if all required fields have values
	 allFieldsValid: function(component) {

        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");

        for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {

            var inputField = component.find(arrayAuraIdsToBeValidated[i]);
            var inputFieldValue = Array.isArray(inputField) ? inputField[0].get("v.value") : inputField.get("v.value");

            if(!inputFieldValue){
                return false;
            }
        }
        return true;
    },

    //Fire Lightning toast
    fireToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})
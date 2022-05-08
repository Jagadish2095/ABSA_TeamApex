({
	fetchTranslationValues: function(component, listName, systemName, valueType, direction){
        var action = component.get('c.getTranslationValues');
        component.set("v.showSpinner", true);
        action.setParams({
            'systemName': systemName,
            'valueType': valueType,
            'direction': direction}
                        );
        action.setCallback(this, function(response){
            var mapValues = response.getReturnValue();
            var listValues = [];
            for(var itemValue in mapValues){
                listValues.push({key: itemValue, value: mapValues[itemValue]});
            }
            listValues.sort();
            component.set(listName,listValues);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    ValidateFields: function(component){

        var isValid = true;
        var v_radioTermination = component.find("radioTermination");
		var v_radioTerminationValue = v_radioTermination.get("v.value");
		if (v_radioTerminationValue == 'Yes') {

            var v_existingCoverOption = component.find("existingPolicyCover");
            var v_existingCoverOptionValue = v_existingCoverOption.get("v.value");

            if (v_existingCoverOptionValue == null || v_existingCoverOptionValue == '0') {
                $A.util.addClass(v_existingCoverOption, 'slds-has-error');
                v_existingCoverOption.setCustomValidity("Please enter a value.");
                v_existingCoverOption.reportValidity();
                isValid = false;
            }

            var v_fieldPreviouseinsurer = component.find("fieldPreviouseinsurer");
            var v_fieldPreviouseinsurerValue = v_fieldPreviouseinsurer.get("v.value");

            if (v_fieldPreviouseinsurerValue == null) {
                $A.util.addClass(v_fieldPreviouseinsurer, 'slds-has-error');
                v_fieldPreviouseinsurer.setCustomValidity("Please enter a value.");
                v_fieldPreviouseinsurer.reportValidity();
                isValid = false;
            }

            var v_radioDuration = component.find("radioDuration");
            var v_radioDurationValue = v_radioDuration.get("v.value");

            if (v_radioDurationValue == null) {
                $A.util.addClass(v_radioDuration, 'slds-has-error');
                v_radioDuration.setCustomValidity("Please select a value.");
                v_radioDuration.reportValidity();
                isValid = false;
            }
		}

        return isValid;
    }
})
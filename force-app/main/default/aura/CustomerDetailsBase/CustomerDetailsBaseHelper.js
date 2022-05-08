({
    yesNoOptions: [
        {"label": "Yes", "value": "Yes"},
        {"label": "No", "value": "No"}
    ],

    yesNoUiValue: function(fieldValue) {
		if ($A.util.isUndefinedOrNull(fieldValue)) {
			return "";
		} else if (fieldValue) {
            return "Yes";
        } else {
			return "No";
        }
    },

    listAsStringValue: function(fieldValue) {

        if ($A.util.isUndefinedOrNull(fieldValue) || (fieldValue == "")) {
			return "";
		} else {
            if (Array.isArray(fieldValue)) {
                return fieldValue.join(';');
            }
			return fieldValue;
        }
    },

    stringAsListValue: function(fieldValue, splitChar) {
        if (Array.isArray(fieldValue)) {
            return fieldValue;
        }
        var newList = [];
        if ($A.util.isUndefinedOrNull(fieldValue) || (fieldValue == "")) {
			return newList;
		} else {
            newList = fieldValue.split(splitChar);
			return newList;
        }
    },

    yesNoFieldValue: function(UiValue) {
		if (UiValue == "Yes") {
            return true;
        } else {
			return false;
        }
    },

	yesNoServiceValue: function(UiValue) {
		if (UiValue == "Yes") {
            return "Y";
        } else {
			return "N";
        }
    },

    getYesNoOptions: function(helper) {
        return helper.yesNoOptions;
    },

    isValid: function(callerComponent, componentAuraId) {
        var returnValue = true;
        if (!callerComponent.find(componentAuraId).get("v.validity").valid) {
            callerComponent.find(componentAuraId).showHelpMessageIfInvalid();
            returnValue = false;
        }
        return returnValue;
    },

    handleAddValidation : function(callerComponent, errorMap) {
        for(var componentAuraId in errorMap) {
            this.addValidation(callerComponent, componentAuraId, errorMap[componentAuraId]);
        }
    },

    addValidation : function(callerComponent, componentAuraId, errorMsg) {
        var styleClass= "slds-form-element__help validationCss";
        var errorComponent = callerComponent.find(componentAuraId);
        $A.util.addClass(errorComponent,"slds-has-error");
        var globalId = callerComponent.getGlobalId();
        var elementId = (globalId + "_" + componentAuraId);
        var validationElementId = (elementId + "_Error");
        var errorElement = document.getElementById(elementId)
        var validationElement = document.createElement("div");
        validationElement.setAttribute("id", validationElementId);
        validationElement.setAttribute("class", styleClass);
        validationElement.textContent = errorMsg;
        errorElement.appendChild(validationElement);
    },

    handleRemoveValidation : function(callerComponent, errorMap) {
        for(var componentAuraId in errorMap) {
            this.removeValidation(callerComponent, componentAuraId);
        }
    },

    removeValidation : function(callerComponent, componentAuraId) {
        var globalId = callerComponent.getGlobalId();
        var validationElementId = (globalId + "_" + componentAuraId + "_Error");
        var errorComponent = callerComponent.find(componentAuraId);
        $A.util.removeClass(errorComponent, "slds-has-error");
        if(document.getElementById(validationElementId)) {
            var errorElement = document.getElementById(validationElementId);
            errorElement.parentNode.removeChild(errorElement);
        }
    },

    getSubmitValue: function(givenValue, defaultValue) {
		if ($A.util.isUndefinedOrNull(givenValue)) {
			return defaultValue;
		}
		return givenValue;
    },

    getSubmitValue: function(givenValue, defaultValue, checkValue) {
		if (($A.util.isUndefinedOrNull(givenValue)) || (givenValue == checkValue)) {
			return defaultValue;
		}
		return givenValue;
    },
})
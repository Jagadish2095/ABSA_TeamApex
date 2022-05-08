({
	callApex : function(callerComponent, controllerMethod, actionParameters, successCallback) {
        var action = callerComponent.get(controllerMethod);
        if (actionParameters) {
            action.setParams(actionParameters);
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                successCallback.call(this, callerComponent, response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

	callApex : function(callerComponent, controllerMethod, actionParameters, successCallback, returnValue) {
        var action = callerComponent.get(controllerMethod);
        if (actionParameters) {
            action.setParams(actionParameters);
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                successCallback.call(this, callerComponent, response.getReturnValue(), returnValue);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    callApexPromise : function(callerComponent, controllerMethod, actionParameters) {
        var apexPromise = new Promise( $A.getCallback( function( resolve , reject ) {
            var action = callerComponent.get(controllerMethod);
            if (actionParameters) {
                action.setParams(actionParameters);
            }
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject("Error message: " + errors[0].message);
                        }
                    } else {
                        reject("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }));
        return apexPromise;
    },

    setTranslationParamOutbound : function(systemNameValue, valueTypeValue, objObjectValue, objFieldValue) {
        return {
            systemName: systemNameValue,
            valueType: valueTypeValue,
            direction: "Outbound",
            objObject: { sobjectType: objObjectValue },
            objField: objFieldValue
        };
    },

    setTranslationParamInbound : function(systemNameValue, valueTypeValue, objObjectValue, objFieldValue) {
        return {
            systemName: systemNameValue,
            valueType: valueTypeValue,
            direction: "Inbound",
            objObject: { sobjectType: objObjectValue },
            objField: objFieldValue
        };
    },

    getTranslationValues : function(callerComponent, controllerMethod, actionParameters, componentListName) {
        this.callApex(callerComponent, controllerMethod, actionParameters, this.loadTranslationValues, componentListName);
    },

    loadTranslationValues : function(callerComponent, responseValue, componentListName) {
        if(responseValue){
            var listValues = [];
            for(var itemValue in responseValue) {
                if (responseValue[itemValue] == "valid") {
                    listValues.push(itemValue);
                } else {
                    // Add function to log/mail system admin with missing values
                }
            }
            listValues.sort();
            callerComponent.set(componentListName, listValues);
        }
    },

    addValueToMap : function(callerComponent, componentMap, mapKey, mapValue) {
        if (!$A.util.isUndefinedOrNull(mapValue)) {
            var workingMap = callerComponent.get(componentMap);
            workingMap[mapKey] = mapValue;
            callerComponent.set(componentMap, workingMap);
        }
    },

    getValueFromMap : function(callerComponent, componentMap, mapKey) {
        var workingMap = callerComponent.get(componentMap);
        return workingMap[mapKey];
    },

    getValueFromMapNullCheck : function(callerComponent, componentMap, mapKey) {
        var workingMap = callerComponent.get(componentMap);
        var mapValue = workingMap[mapKey];
        if ($A.util.isUndefinedOrNull(mapValue)) {
            mapValue = "";
        }
        return mapValue;
    },
})
({
	saveOS:function(component, event, helper){
    component.set("v.showSpinner",true);
    var opportunityId = component.get("v.recordId");
    var updateSOList = component.get("v.existingSecurities");
    var action = component.get("c.saveOSec");
        action.setParams({
            "updateSOList": updateSOList
        });
        action.setCallback(this, function (response) {
            console.log(response.getState());
            if (response.getState() == "SUCCESS") {
                component.set("v.showSpinner",false);
                var toastEvent = helper.getToast('Success' + '!','Other Securities Updated Successfully', 'success');
                    toastEvent.fire();
                
            }
            else {
                helper.showError(response, "saveOS");
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    getExistingSecurities: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getSecuritiesOffered");
        console.log("Opp Id " + oppId);
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var data = response.getReturnValue();

                var count = Object.keys(data).length;
                console.log(count);
                var options = [];
                if(count > 0){
                    for(var i = 0; i < data.length; i++){
                        var secProviderName='';
                        if (data[i].hasOwnProperty('Contact__r') == true) {
                            secProviderName = data[i].Contact__r.Name;
                        }
                        if (data[i].hasOwnProperty('Contact__r') == false && data[i].External_Entity_Linked__c == true) {
                            secProviderName = data[i].Account__r.Name;
                        }
                        if (data[i].hasOwnProperty('Contact__r') == false && data[i].External_Entity_Linked__c == false) {
                            secProviderName=data[i].Client_Name__c;
                        }
						data[i].Name = secProviderName;
                }
                
                component.set("v.existingSecurities", data);
                }
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            duration: 10000,
            title: title,
            message: msg,
            type: type
        });
        
        return toastEvent;
    },
    showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }
        
        // show error notification
        var toastEvent = this.getToast("Error: OtherSecurities" + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
})
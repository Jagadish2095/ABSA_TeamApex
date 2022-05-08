({
    getApplication: function(component) {

        var action = component.get("c.getApplication");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();

                if(responseValue != null && responseValue.Id != null){
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

    setTradingAddressField : function(component, event, helper){
        var selectedRows = component.get('v.selectedRows');
        if (selectedRows.length > 0) {
            component.find("tradingAddressField").set("v.value", selectedRows[0].Id);
        }

        if (component.find("tradingAddressField").get("v.value")) {
            component.find('merchantOnboardTradingForm').submit();
        } else {
            component.set("v.cmpFormStatus", "invalid");
            if (component.get('v.isShowSuccessToast')) {
                helper.fireToast("Error!", "Please select a trading address", "error");
            }
        }
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
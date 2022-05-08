({
   generateDocuments : function(component, helper) {
    return new Promise(function(resolve, reject) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.callGenerateDocs");
        action.setParams({
            "oppId" : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnValue = response.getReturnValue();
            component.set("v.showSpinner", false);
            if(state == "SUCCESS"){
                resolve(returnValue);
            }else{
                reject(returnValue);
            }
        });
        $A.enqueueAction(action);
    })
    },

	handleError: function (component, error) {
		var isCalledFromFlow = component.get("v.isCalledFromFlow");
		component.set("v.showError", true);
        component.set("v.status", "Error");
		if (isCalledFromFlow) {
            component.find('branchFlowFooter').set('v.heading', "Please Note:");
            component.find('branchFlowFooter').set('v.message', error);
            component.find('branchFlowFooter').set('v.showDialog', true);
		} else {
            component.set("v.hasProcessStopped", true);
            component.set("v.errorDisplay", true);
            component.set("v.errorMessage", error);
		}
	},

    handleSuccess: function (component) {
		var isCalledFromFlow = component.get("v.isCalledFromFlow");
        component.set("v.showSuccess", true);
        component.set("v.status", "Successful");
		if (isCalledFromFlow) {
            component.set("v.showSuccess", true);
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");
		} else {
            component.set("v.isSuccessful", true);
		}
	}
})
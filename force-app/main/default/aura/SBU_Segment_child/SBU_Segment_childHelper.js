({
    fetchManagerDetails : function(component, event, helper){
        this.showSpinner(component);
        var action = component.get("c.getManagerDetails");
        action.setParams({ managerName : component.get("v.BankerManager") });
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            var res=actionResult.getReturnValue();
            console.log(res);
            if (component.isValid() && state === "SUCCESS") {
                this.hideSpinner(component);
                component.set("v.ManagerBRID",res[0].BRID__c);
                component.set("v.ManagerName",res[0].Name);
                component.set("v.ManagerEmail",res[0].Email);
                component.set("v.ManagerContactNumber",res[0].MobilePhone);

            } else if (state === "ERROR") {
                var errors = res.getError();
                this.getToast("Error", "An error Occurred", "error");
                component.set("v.errorMessage", "An error Occurred: FPSBUSegment.getManagerDetails: " + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
     },
     hideSpinner: function (component) {
		component.set("v.showSpinner", false);
    },

    showSpinner: function (component) {
		component.set("v.showSpinner", true);
    },
    getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
})
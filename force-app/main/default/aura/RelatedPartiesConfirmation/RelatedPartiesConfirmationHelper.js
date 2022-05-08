({
    navHome : function (component, event, helper) {       
        var homeEvent = $A.get("e.force:navigateToURL");
        homeEvent.setParams({
            "url": "/home/home.jsp"
        });        
        homeEvent.fire();
     },
    
    CloseCaseStatus: function (component, event, helper) {
		return new Promise(function (resolve, reject) {
			helper.showSpinner(component);
            var caseId = component.get("v.CaseId");
			var action = component.get("c.closeCase");
			action.setParams({
				caseId: caseId
			});

			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();
				helper.hideSpinner(component);

				if (state == "SUCCESS") {
					helper.fireToast("SUCCESS", "Case status Closed successfully", "success");
					component.set("v.errorMessage", "");
					resolve("success");
				} else if (state == "ERROR") {
					var errors = response.getError();
					reject(errors);
				} else {
					reject(screenRespObj);
				}
			});
			$A.enqueueAction(action);
            
		});
	},
    //Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},
    //Lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},
})
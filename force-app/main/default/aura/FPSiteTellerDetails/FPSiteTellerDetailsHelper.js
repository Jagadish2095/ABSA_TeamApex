({
    getSiteDetailsHelper: function (component, event,helper, siteCode) {
		helper.showSpinner(component);

		var action = component.get("c.fetchSiteDetailsApex");
		action.setParams({
			siteCode: siteCode
		});

		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (respObj.statusCode == 200) {
                        component.set("v.siteDetails",respObj.SIgetSiteDetailsV2Response);
                        var siteDetails = respObj.SIgetSiteDetailsV2Response;
                        console.log("siteDetails==>"+JSON.stringify(siteDetails));

				} else {
					//Fire Error Toast
					helper.getToast("Error", "Error while fetching Site information", "error");
					var errorMessage = '';//JSON.stringify(respObj.SIgetSiteDetailsV2Response.nbsmsgo3);
                    component.set(
						"v.errorMessage",
						"Service error FPSiteTellerDetailsController.fetchSiteDetailsApex: " + 
							"Status: " +
							JSON.stringify(respObj.statusCode) +
							" : " +
							JSON.stringify(respObj.message)+ " : " + errorMessage
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error FPSiteTellerDetailsController.fetchSiteDetailsApex: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			helper.hideSpinner(component);
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
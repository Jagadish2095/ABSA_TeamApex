({
	estatmentDelivey: function (component, event, isEnquiry) {
		component.set("v.showSpinner", true);
		component.set("v.isdisable", true);
		var compEvent = component.getEvent("vasFulfilmentEvent");
		var oppId = component.get("v.opportunityId");
		var productFamily = component.get("v.productFamily");
		var self = this;

		var action = component.get("c.getEStamntDelivery");

		action.setParams({
			oppId: oppId,
			isEnquiry: isEnquiry,
			productFamily: productFamily
		});

		action.setCallback(this, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var respObj = response.getReturnValue();
				if (respObj.statusCode == 200) {
					if (isEnquiry) {
						if (respObj.EImaintainESDDetailsV3Response.eip103o.status == "E" && respObj.EImaintainESDDetailsV3Response.eip103o.prodCode != "0") {
							component.set("v.isdisable", true);
							component.set("v.eStatDeliverySelected", true);
							component.set("v.eStatDeliveryIconName", "utility:success");
							component.set("v.ShowServiceResponse", true);
							component.set("v.ServiceResponse", "The customer is already registered for Electronic Statement Delivery.");
							self.showResponseInRed(component, false);
							//Inform parent component
							compEvent.setParams({
								eStatementInd: "Y"
							});
							compEvent.fire();
						} else {
							component.set("v.isdisable", false);
							component.set("v.eStatDeliverySelected", false);
							component.set("v.eStatDeliveryIconName", "utility:add");
							component.set("v.ShowServiceResponse", false);
							self.showResponseInRed(component, true);
							//Inform parent component
							compEvent.setParams({
								eStatementInd: "N"
							});
							compEvent.fire();
						}
					} else {
						if (respObj.EImaintainESDDetailsV3Response.nbsmsgo.nbrUserErrs != "0") {
							component.set("v.isdisable", false);
							component.set("v.eStatDeliveryIconName", "utility:clear");
							component.set("v.ShowServiceResponse", true);
							component.set(
								"v.ServiceResponse",
								"Something went wrong trying to register for Estatement. Please try again by clicking on the cross icon. \n" +
									respObj.EImaintainESDDetailsV3Response.eip103o.status
							);
							self.showResponseInRed(component, true);
							//Inform parent component
							compEvent.setParams({
								eStatementInd: "N"
							});
							compEvent.fire();
						} else if (respObj.EImaintainESDDetailsV3Response.nbsmsgo.nbrUserErrs == "0") {
							component.set("v.isdisable", true);
							component.set("v.eStatDeliverySelected", true);
							component.set("v.eStatDeliveryIconName", "utility:success");
							component.set("v.ShowServiceResponse", true);
							component.set("v.ServiceResponse", "The customer has successfully registered for Electronic Statement Delivery.");
							self.showResponseInRed(component, false);
							//Inform parent component
							compEvent.setParams({
								eStatementInd: "Y"
							});
							compEvent.fire();
						}
					}
				} else {
					component.set("v.eStatDeliveryIconName", "utility:clear");
					component.set("v.ShowServiceResponse", true);
					component.set("v.isdisable", false);
					if (respObj.status != null && respObj.message != null) {
						component.set("v.ServiceResponse", respObj.status + ": " + respObj.message);
					} else {
						component.set("v.ServiceResponse", "Something went wrong applying for Electronic Statement Delivery.");
					}
					self.showResponseInRed(component, true);
					//Inform parent component
					compEvent.setParams({
						eStatementInd: "N"
					});
					compEvent.fire();
				}
			} else if (state === "ERROR") {
				component.set("v.isdisable", false);
				component.set("v.eStatDeliveryIconName", "utility:clear");
				component.set("v.ShowServiceResponse", true);
				self.showResponseInRed(component, true);
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.ServiceResponse", "Error message: " + errors[0].message);
					} else {
						component.set("v.ServiceResponse", "Something went wrong applying for Electronic Statement Delivery.");
					}
				}
			} else if (state === "INCOMPLETE") {
				component.set("v.ServiceResponse", "Something went wrong applying for Electronic Statement Delivery.");
			}
		});
		$A.enqueueAction(action);
	},
	showResponseInRed: function (component, showAsRed) {
		var responseText = component.find("responseText");
		if (showAsRed) {
			$A.util.addClass(responseText, "error-color");
			$A.util.removeClass(responseText, "success-color");
		} else {
			$A.util.addClass(responseText, "success-color");
			$A.util.removeClass(responseText, "error-color");
		}
	}
});
({
	loadApplicantExposures: function (component, event, helper) {
		var OpportunityId = component.get("v.oppId");
		var action = component.get("c.getApplicationExposures");

		action.setParams({
			"oppID": OpportunityId
		});

		action.setCallback(this, function (res) {
			var state = res.getState();

			if (state === "SUCCESS") {
				var serviceResponse = res.getReturnValue();
				console.log('serviceResponse' + JSON.stringify(serviceResponse));
				if(serviceResponse != null) {
					var ApplicantExposuresData = serviceResponse.applicationExposures;
					var clientName = (ApplicantExposuresData != null ? ApplicantExposuresData[0].Client_Name__c : null);

					var LastModifiedDate = (ApplicantExposuresData != null ? ApplicantExposuresData[0].LastModifiedDate : null);
					component.set("v.lastRefresh", LastModifiedDate);
					component.set("v.clientName", clientName);

					var clientCodesandNames = serviceResponse['clientCodesandNames'];
					component.set("v.ApplicantExposuresData", ApplicantExposuresData);
					component.set("v.clientCodesandNames", clientCodesandNames);
                    console.log('clientCodesandNames::'+JSON.stringify(component.get("v.clientCodesandNames")));
				}
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	}
})
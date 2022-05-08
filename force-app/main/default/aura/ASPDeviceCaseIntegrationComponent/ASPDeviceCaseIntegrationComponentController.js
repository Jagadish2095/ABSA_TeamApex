({
	doInit: function (component, event, helper) {
		var getRequestJSONAction = component.get("c.GetCaseDataString");
		var RecordId = component.get("v.recordId");
		var DocumentScanningData = component.get("v.documentScanningData");
		var CustomerVerificationData = component.get("v.customerVerificationData");
		var CustomerContractData = component.get("v.customerContractData");

		getRequestJSONAction.setParams({
			opportunityID: RecordId,
			customerVerificationData: CustomerVerificationData,
			documentScanningData: DocumentScanningData,
			customerContractData: CustomerContractData
		});
		getRequestJSONAction.setCallback(this, function (response) {
			var RequestMetadata = response.getReturnValue();
			component.set("v.RequestJSON", RequestMetadata);
		});
		$A.enqueueAction(getRequestJSONAction);
	},

	HandleResponse: function (component, event, helper) {
		var ResponseMetadata = event.getParam("responseMetadata");
		component.set("v.CaseData", ResponseMetadata);
		console.log(ResponseMetadata);
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');

        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
            case 'BACK':
                break;
            case 'PAUSE':
                navigate(actionClicked);
                break;
        }
    }
});
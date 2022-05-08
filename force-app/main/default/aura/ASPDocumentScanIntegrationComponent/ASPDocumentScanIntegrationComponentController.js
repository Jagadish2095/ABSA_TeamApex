({
	doInit: function (component, event, helper) {
		var getRequestJSONAction = component.get("c.GetDocumentScanningRequestMetadata");
		var RecordId = component.get("v.recordId");
		var DocumentUptakeProcess = component.get("v.DocumentUptakeProcess");
		var CustomerVerificationData = component.get("v.CustomerVerificationData");
		var isNoneScoredProduct = component.get("v.IsNoneScoredProduct");
		getRequestJSONAction.setParams({
			objectID: RecordId,
			documentUptakeProcess: DocumentUptakeProcess,
			customerVerification: CustomerVerificationData,
			isNoneScored: isNoneScoredProduct
		});

		getRequestJSONAction.setCallback(this, function (response) {
			var RequestMetadata = response.getReturnValue();
			var RequestMetadataObject = JSON.parse(RequestMetadata);
			component.set("v.CustomerId", RequestMetadataObject.IdNumber);
			component.set("v.RequestJSON", RequestMetadata);
		});
		$A.enqueueAction(getRequestJSONAction);
	},

	HandleResponse: function (component, event, helper) {
		var ResponseMetadata = event.getParam("responseMetadata");
		component.set("v.DocumentScanningData", ResponseMetadata);
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
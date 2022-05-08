({
	doInit: function (component, event, helper) {
		var getRequestJSONAction = component.get("c.getDeviceContractRequestMetadata");
		var RecordId = component.get("v.recordId");
		var ContractType = component.get("v.ContractType");
		var ContractData = component.get("v.contractData");
		var PackageName = component.get("v.packageName");
		if (!$A.util.isUndefinedOrNull(ContractData) && ContractData != "") {
			var ContractDataString = JSON.stringify(JSON.parse(ContractData));
		}
		getRequestJSONAction.setParams({
			opportunityID: RecordId,
			contractType: ContractType,
			contractData: ContractDataString,
			featureAndBenefitProduct: PackageName
		});
		getRequestJSONAction.setCallback(this, function (response) {
			var RequestMetadata = response.getReturnValue();
			component.set("v.RequestJSON", RequestMetadata);
		});
		$A.enqueueAction(getRequestJSONAction);
	},

	HandleResponse: function (component, event, helper) {
		var ResponseMetadata = event.getParam("responseMetadata");
		component.set("v.CustomerContractData", ResponseMetadata);
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
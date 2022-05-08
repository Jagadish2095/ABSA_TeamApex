({
	doInit: function (component, event, helper) {
		//  $A.get('e.force:refreshView').fire();
		helper.getValidationfields(component, event, helper);
		helper.forceSolePropAddition(component, event);
		helper.handleLoadResponseData(component);
		helper.handleValidationDetailDisplay(component);
		//  $A.get('e.force:refreshView').fire();
	},

	refreshValidation: function (component, event, helper) {
		helper.getValidationfields(component, event, helper);
		helper.forceSolePropAddition(component, event);
		$A.get('e.force:refreshView').fire();
	},

	submitToPco: function (component, event, helper) {
		//  helper.getValidationfields(component, event, helper);

		console.log('Calling PCO helper');
		var stageId = component.get("v.validationScreen");
		if (stageId == '01' || stageId == '02' || stageId == '03') {
			helper.forceSolePropAddition(component, event);
			helper.getValidationfields(component, event, helper);
		}
		helper.submitToPCORequest(component, event, helper);
	},

})
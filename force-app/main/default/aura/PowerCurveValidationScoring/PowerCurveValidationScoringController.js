({
	doInit: function (component, event, helper) {
		helper.getResponseData(component, event, helper);
	},

	limitChange: function(component, event, helper) {
		var selectedValues=event.getParam("value");
		component.find('productAmount').set('v.value',selectedValues);
	},

	onload: function (component, event, helper) {},

	handleOnSubmit: function (component, event, helper) {
		event.preventDefault();
		var eventFields = event.getParam("fields");
		eventFields['Product_Amount__c'] = component.find('overdraftLimitNewAmountField').get('v.value');
		component.find('reprocessLowerLimitForm').submit(eventFields);
	},

	handleSuccess: function (component, event, helper) {
		var oppId  = component.get("v.recordId");
		var action = component.get("c.updateOpportunity");
		action.setParams({
			"oppId" : oppId,
            "lowerLimit" : component.get("v.preApprovedAmount")
        });
		action.setCallback(this,function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				$A.get('e.force:refreshView').fire();

				helper.pcoCall(component,event,helper);
			}else {
				helper.fireToast("Error", "Error saving Reprocess Lower Limit details!!", "error");
			}
		});
		$A.enqueueAction(action);
	},

	handleRecordError : function(component, event, helper) {
        helper.fireToast("Error", "Error saving Reprocess Lower Limit details!!", "error");
    },
})
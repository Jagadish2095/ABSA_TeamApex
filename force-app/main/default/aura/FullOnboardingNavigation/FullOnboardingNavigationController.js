({
	doInit: function (component, event, helper) {
		console.log("Full Onboarding Opportunity ID" + component.get("v.recordId"));
	},
	navigateToFullOnboarding: function (component, event, helper) {
		//Get FocusTabId
		var workspaceAPI = component.find("workspace");
		var clientFinderTabId;
		var onboardingClientDetailsTabId;
		workspaceAPI.getFocusedTabInfo().then(function (response) {
			onboardingClientDetailsTabId = response.tabId;
		});

		var action = component.get("c.getAccountId");
		action.setParams({ recordId: component.get("v.recordId") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var accountObjresponse = response.getReturnValue();
				console.log("accountObjresponse>>>>>>>>" + accountObjresponse);
				console.log("accountObjresponse Id >>>>>>>>" + accountObjresponse.Id);
				console.log("accountObjresponse Client Type>>>>>>>>" + accountObjresponse.Client_Type__c);
				component.set("v.accountrecordId", accountObjresponse.Id);

				//Navigate to OnboardingClientDetails Components and set parameters
				var evt = $A.get("e.force:navigateToComponent");
				if (
					accountObjresponse.Client_Type__c == "Private Individual" ||
					accountObjresponse.Client_Type__c == "Individual" ||
					accountObjresponse.Client_Type__c == "Sole Trader" ||
					accountObjresponse.Client_Type__c == "Sole Proprietor"
				) {
					evt.setParams({
						componentDef: "c:OnboardingIndividualClientDetails",
						componentAttributes: {
							ProcessName: "LiteToFullOnboarding",
							processType: "LiteToFullOnboarding",
							clientGroupValue: accountObjresponse.Client_Group__c,
							clientTypeValue: accountObjresponse.Client_Type__c,
							accRecordId: component.get("v.accountrecordId"),
							liteOpportunityId: component.get("v.recordId")
						}
					});
				} else {
					evt.setParams({
						componentDef: "c:OnboardingClientDetails",
						componentAttributes: {
							ProcessName: "LiteToFullOnboarding",
							processType: "LiteToFullOnboarding",
							accRecordId: component.get("v.accountrecordId"),
							liteOpportunityId: component.get("v.recordId")
						}
					});
				}

				evt.fire();
			} else {
				var toast = this.getToast("Error", "Something went wrong. Please contact Administrator", "error");
				toast.fire();
			}
		});
		$A.enqueueAction(action);
	}
});
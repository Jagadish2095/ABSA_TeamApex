({
	navigateToEditCmp: function (component, event, helper) {
		component.set("v.opportunityId", component.get("v.recordId"));
		component.find("recordLoader").reloadRecord();

		var workspaceAPI = component.find("workspace");
		var onboardingClientDetailsTabId;
		workspaceAPI.getFocusedTabInfo().then(function (response) {
			onboardingClientDetailsTabId = response.tabId;
		});

		workspaceAPI.closeTab({ tabId: onboardingClientDetailsTabId });

		window.setTimeout(
			$A.getCallback(function () {
				var Entitytype = component.get("v.opportunityRecord.Entity_Type__c");
				var executionLayerRequest = component.get("v.opportunityRecord.ExecutionLayerRequestID_Text__c");
				var id = component.get("v.opportunityRecord.Id");
				var recId = component.get("v.recordId");

				console.log("executionLayerRequest " + executionLayerRequest);
				if (executionLayerRequest != null && executionLayerRequest != undefined && executionLayerRequest != "") {
					var evt = $A.get("e.force:navigateToComponent");
					evt.setParams({
						componentDef: "c:ABSA_ClientDetailsXDS",
						componentAttributes: {
							recordId: recId,
							EntityType: Entitytype
						}
					});
					evt.fire();
				} else {
					var evt = $A.get("e.force:navigateToComponent");
					var accId = component.get("v.opportunityRecord.AccountId");
					var oppId = component.get("v.opportunityRecord.Id");
					var processName = "EditFormExistingOpportunity";

					var clientType = component.get("v.opportunityRecord.Entity_Type__c");

					console.log("clientType: " + clientType);
					if (accId != null && accId != "" && accId != undefined) {
						//Navigate to OnboardingClientDetails - Business Entities
						if (
							clientType != "INDIVIDUAL" &&
							clientType != "Private Individual" &&
							clientType != "Sole Trader" &&
							clientType != "SOLE PROPRIETOR"
						) {
							console.log("In Business accId : " + accId);
							evt.setParams({
								componentDef: "c:OnboardingClientDetails",
								componentAttributes: {
									accRecordId: accId,
									ProcessName: processName,
									opportunityRecordId: oppId
								}
							});
						}

						//Navigate to OnboardingIndividualClientDetails - Individual and Sole Trader
						else {
							evt.setParams({
								componentDef: "c:OnboardingIndividualClientDetails",
								componentAttributes: {
									accRecordId: accId,
									ProcessName: processName,
									opportunityRecordId: oppId,
									clientTypeValue: clientType,
                                    iClientType: clientType
								}
							});
						}
					}

					evt.fire();

					helper.closeFocusedTab(component);
				}
			}),
			1000
		);
	}
});
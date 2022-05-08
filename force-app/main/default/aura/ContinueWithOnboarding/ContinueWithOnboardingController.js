({
	recordUpdated: function (component, event, helper) {
		if (component.get("v.accountRecord.CIF__c") == null || component.get("v.accountRecord.CIF__c") == "") {
			component.set("v.processType", "New to Bank Onboarding");
		} else {
			component.set("v.processType", "Existing Customer");
		}

		var clientTypeValue = component.get("v.accountRecord.Client_Type__c");
		var clientGroupValue = component.get("v.accountRecord.Client_Group__c");
		console.log("Selected Entity Type:" + clientTypeValue);

		if (
			clientTypeValue == "Deceased Estate" ||
			clientTypeValue == "Individual - Minor" ||
			clientTypeValue == "Individual" ||
			clientTypeValue == "Private Individual" ||
			clientTypeValue == "Sole Trader"
		) {
			// Sole Proprieter change to Sole Trader
			//Navigate to OnboardingIndividualClientDetails Bigfom
			var indv = component.get("c.navigateToOnbOardingIndvDetails");
			$A.enqueueAction(indv);
		} else {
			//Navigate to OnboardingClientDetails Bigfom
			//this.navigateToOnbOardingIndvDetails(component);
			var nonIndv = component.get("c.navigateToOnbOardingClientDetails");
			$A.enqueueAction(nonIndv);
		}
	},

	navigateToOnbOardingIndvDetails: function (component, evt, helper) {
		//Get FocusTabId
		var workspaceAPI = component.find("workspace");
		var clientFinderTabId;
		var onboardingClientDetailsTabId;
		var showNoTaxReason =
			component.get("v.accountRecord.Reason_For_Not_Providing_SA_Tax_Number__c") != null &&
			component.get("v.accountRecord.Reason_For_Not_Providing_SA_Tax_Number__c") != undefined
				? true
				: false;
		var registerdChecked = showNoTaxReason == true ? false : true;
		var nameOFFsp = component.get("v.accountRecord.Name_of_FSP__c");
		var fspNumber = component.get("v.accountRecord.FSP_Number__c");
		var certifiedCopy = component.get("v.accountRecord.Certified_Copy_of_the_Licence_Received__c");
		var showFsp;
		console.log("showFsp " + showFsp + "nameOFFsp " + nameOFFsp + "nameOFFsp" + nameOFFsp + "fspNumber " + fspNumber + "certifiedCopy " + certifiedCopy);

		if (nameOFFsp != null || fspNumber != null || certifiedCopy != null) {
			showFsp = true;
		} else {
			showFsp = false;
		}
		console.log("showFsp " + showFsp + "nameOFFsp " + nameOFFsp + "nameOFFsp" + nameOFFsp + "fspNumber " + fspNumber + "certifiedCopy " + certifiedCopy);
		var showCondition = certifiedCopy != null && certifiedCopy == "Yes" ? true : false;
		var showNamedC = component.get("v.accountRecord.Conditions_and_Restrictions__c");
		var showNamedCondition = showNamedCondition != null && showNamedCondition == "Yes" ? true : false;

		workspaceAPI.getFocusedTabInfo().then(function (response) {
			clientFinderTabId = response.tabId;
		});

		//Navigate to OnboardingIndividualClientDetails Components and set parameters
		var evt = $A.get("e.force:navigateToComponent");

		evt.setParams({
			componentDef: "c:OnboardingIndividualClientDetails",
			componentAttributes: {
				accRecordId: component.get("v.recordId"),
				accountRecord: component.get("v.accountRecord"),
				ProcessName: component.get("v.accountRecord.Process_Name__c"),
				clientGroupValue: component.get("v.accountRecord.Client_Group__c"),
				clientTypeValue: component.get("v.accountRecord.Client_Type__c"),
				placeofResValue: component.get("v.accountRecord.Place_of_Residence__c"),
				processType: component.get("v.processType"),
				sicCategoryValue: component.get("v.accountRecord.Standard_Industry_SIC_Category__c"),
				highIndustryValue: component.get("v.accountRecord.The_Client_is_involved_in_High_Risk_Indu__c"),
				showRegulatoryQ2SubSection2: component.get("v.accountRecord.Q2a_Client_affected_by_Regulation_3_1_F__c"),
				showRegulatoryQ2SubSection: component.get("v.accountRecord.Is_the_Client_a_Non_resident__c"),
				showRegulatoryQ1SubSection2: component.get("v.accountRecord.Q1a_Client_affected_by_Regulation_3_1_F__c"),
				showRegulatoryQ1SubSection: component.get("v.accountRecord.Is_the_Client_a_Temporary_Resident__c"),
				showSave: true,
				showConsent: false,
				showNoTaxReason: showNoTaxReason,
				showFsp: showFsp,
				showCondition: showCondition,
				showNamedCondition: showNamedCondition,
				registerdChecked: registerdChecked
			}
		});

		evt.fire();

		//Closing old tab
		workspaceAPI.closeTab({
			tabId: clientFinderTabId
		});
	},

	navigateToOnbOardingClientDetails: function (component, evt, helper) {
		//Get FocusTabId
		var workspaceAPI = component.find("workspace");
		var clientFinderTabId;
		var onboardingClientDetailsTabId;
		var showNoTaxReason =
			component.get("v.accountRecord.Reason_For_Not_Providing_SA_Tax_Number__c") != null &&
			component.get("v.accountRecord.Reason_For_Not_Providing_SA_Tax_Number__c") != undefined
				? true
				: false;
		var registerdChecked = showNoTaxReason == true ? false : true;
		var nameOFFsp = component.get("v.accountRecord.Name_of_FSP__c");
		var fspNumber = component.get("v.accountRecord.FSP_Number__c");
		var certifiedCopy = component.get("v.accountRecord.Certified_Copy_of_the_Licence_Received__c");
		var showFsp;
		console.log("showFsp " + showFsp + "nameOFFsp " + nameOFFsp + "nameOFFsp" + nameOFFsp + "fspNumber " + fspNumber + "certifiedCopy " + certifiedCopy);

		if (nameOFFsp != null || fspNumber != null || certifiedCopy != null) {
			showFsp = true;
		} else {
			showFsp = false;
		}
		console.log("showFsp " + showFsp + "nameOFFsp " + nameOFFsp + "nameOFFsp" + nameOFFsp + "fspNumber " + fspNumber + "certifiedCopy " + certifiedCopy);
		var showCondition = certifiedCopy != null && certifiedCopy == "Yes" ? true : false;
		var showNamedC = component.get("v.accountRecord.Conditions_and_Restrictions__c");
		var showNamedCondition = showNamedCondition != null && showNamedCondition == "Yes" ? true : false;
		workspaceAPI.getFocusedTabInfo().then(function (response) {
			clientFinderTabId = response.tabId;
		});
		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef: "c:OnboardingClientDetails",
			componentAttributes: {
				accRecordId: component.get("v.recordId"),
				accountRecord: component.get("v.accountRecord"),
				clientType: component.get("v.accountRecord.Client_Type__c"),
				clientType2: component.get("v.accountRecord.Client_Type__c"),
				clientGroup: component.get("v.accountRecord.Client_Group__c"),
				placeOfResidence: component.get("v.accountRecord.Place_of_Residence__c"),
				ProcessName: component.get("v.accountRecord.Process_Name__c"),
				processType: component.get("v.processType"),
				sicCategoryValue: component.get("v.accountRecord.Standard_Industry_SIC_Category__c"),
				highIndustryValue: component.get("v.accountRecord.The_Client_is_involved_in_High_Risk_Indu__c"),
				showRegulatoryQ2SubSection2: component.get("v.accountRecord.Q2a_Client_affected_by_Regulation_3_1_F__c"),
				showRegulatoryQ2SubSection: component.get("v.accountRecord.Q2_Are_75_or_more_of_the_capital__c"),
				showRegulatoryQ1SubSection2: component.get("v.accountRecord.Q1a_Client_affected_by_Regulation_3_1_F__c"),
				showRegulatoryQ1SubSection: component.get("v.accountRecord.Q1_Entity_registered_outside_RSA__c"),
				showRegulatoryQ3SubSection: component.get("v.accountRecord.Q3_Are_75_or_more_of_the_voting_rights__c"),
				showRegulatoryQ3SubSection2: component.get("v.accountRecord.Q3a_Client_affected_by_Regulation_3_1_F__c"),
				showRegulatoryQ4SubSection2: component.get("v.accountRecord.Q4a_Client_affected_by_Regulation_3_1_F__c"),
				showRegulatoryQ4SubSection: component.get("v.accountRecord.Q4_Are_there_any_temporary_non_resident__c"),
				showConsentSection: false,
				showSave: true,
				showNoTaxReason: showNoTaxReason,
				showFsp: showFsp,
				showCondition: showCondition,
				showNamedCondition: showNamedCondition,
				registerdChecked: registerdChecked
			}
		});

		evt.fire();

		//Closing old tab
		workspaceAPI.closeTab({
			tabId: clientFinderTabId
		});
	}
});
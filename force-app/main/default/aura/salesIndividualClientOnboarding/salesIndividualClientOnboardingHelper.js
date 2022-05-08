({
	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to load record templates on init event
	 * @param component
	 * @param event
	 */
	loadTemplatesHelper: function (component, event) {
		//Prepare Opportunity template
		var jobDetails = component.get("v.jobDetails");
		component.find("newOpportunityRecordCreator").getNewRecord(
			"Opportunity",
			jobDetails.Sales_Process_Type__r.opportunityRecordTypeId,
			false,
			$A.getCallback(function () {
				var rec = component.get("v.newOpportunity");
				var error = component.get("v.newOpportunityError");
				if (error || rec === null) {
					var message = "Error initializing record template: " + error;
					component.set("v.errorMessage", message);
					return;
				}
			})
		);

		//Prepare Res Address template
		component.find("residentialAddRecordData").getNewRecord(
			"Address__c",
			null,
			false,
			$A.getCallback(function () {
				var rec = component.get("v.resAddressRecord");
				var error = component.get("v.recordError");
				if (error || rec === null) {
					var message = "Error initializing record template: " + error;
					component.set("v.errorMessage", message);
					return;
				}
			})
		);

		//Prepare Pos Address template
		component.find("postalAddRecordData").getNewRecord(
			"Address__c",
			null,
			false,
			$A.getCallback(function () {
				var rec = component.get("v.posAddressRecord");
				var error = component.get("v.recordError");
				if (error || rec === null) {
					var message = "Error initializing record template: " + error;
					component.set("v.errorMessage", message);
					return;
				}
			})
		);

		//Prepare Employment Address template
		component.find("employerAddRecordData").getNewRecord(
			"Address__c",
			null,
			false,
			$A.getCallback(function () {
				var rec = component.get("v.empAddressRecord");
				var error = component.get("v.recordError");
				if (error || rec === null) {
					var message = "Error initializing record template: " + error;
					component.set("v.errorMessage", message);
					return;
				}
			})
		);
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to set default values on init event
	 * @param component
	 * @param event
	 */
	setDefaultValuesHelper: function (component, event) {
		component.set("v.steps", [
			{ label: "Personal Details", value: "personalDetails" },
			{ label: "Contact Information", value: "contactInformation" },
			{ label: "Employment Details", value: "employmentDetails" }
		]);

		component.set("v.postalOptions", [
			{ label: "Yes", value: "Yes" },
			{ label: "No", value: "No" }
		]);

		var accountFieldsFields = [
			"Titles__pc",
			"PersonTitle",
			"Gender__pc",
			"Initials__pc",
			"FirstName",
			"LastName",
			"PersonBirthdate",
			"PersonBirthdate",
			"ID_Type__c",
			"Date_Issued__pc",
			"Marital_Status__pc",
			"Marital_Contract_Type__pc",
			"Country_of_Birth__pc",
			"Nationality__pc",
			"Home_Language__pc",
			"PersonEmail",
			"personMobilePhone",
			"personOtherPhone",
			"Communication_Language__pc",
			"Preferred_Communication_Method__pc",
			"Statement_Preference__pc",
			"Source_of_Income__c",
			"Occupation_Status__pc",
			"Income_Source__pc",
			"Occupation__pc",
			"Occupation_Level__pc",
			"Occupation_Category__pc",
			"Employer_Sector__pc",
			"Employer_Name__pc",
			"Employer_Phone__c",
			"Is_customer_registered_for_income_tax__c",
			"Is_customer_registered_for_foreign_tax__c",
			"Income_Tax_Number__pc",
			"Client_Type__c",
			"Client_Group__c",
			"Country_of_Origin__pc",
			"BillingCountry",
			"ShippingCountry",
			"Place_of_Residence__c",
			"Passport_Number__pc",
			"CountryPassport__pc",
			"Country_Passport_Issued__pc",
			"Passport_Date_of_Issue__pc",
			"Passport_Expiry_Date__c",
			"Registration_Number__c",
		];
		component.set("v.accountFieldsFields", accountFieldsFields);

		//Close Prevoius Tab
		var workspaceAPI = component.find("workspace");
		var fromTabId = component.get("v.fromTabId");
		if (fromTabId) {
			workspaceAPI.closeTab({ tabId: fromTabId });
		}

		//Set the new Tab Label
		workspaceAPI.getFocusedTabInfo().then(function (response) {
			var focusedTabId = response.tabId;
			workspaceAPI.setTabLabel({
				tabId: focusedTabId,
				label: "Big Form"
			});

			workspaceAPI.setTabIcon({
				tabId: focusedTabId,
				icon: "utility:case",
				iconAlt: "Big Form"
			});
		});
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to validate screens
	 * @param component
	 * @param event
	 */
	validateScreensHelper: function (component, event) {
		var screensMap = component.get("v.screensMap");
		var currentStep = component.get("v.currentStep");
		var buttonList = screensMap[currentStep].buttons;
		for (var i = 0; i < buttonList.length; i++) {
			var currentButton = document.getElementById(buttonList[i]);
			console.log("currentButton** " + buttonList[i]);
			if (currentButton) {
				currentButton.click();
			}
		}
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to navigate to next screen
	 * @param component
	 * @param event
	 */
	nextScreenHelper: function (component, event, helper, nextScreen) {
		var buttonLabel = component.find("NEXT").get("v.label");

		if (buttonLabel == "Validate and Save") {
			helper.handleSaveAccount(component, event, helper);
		} else {
			component.set("v.currentStep", nextScreen);
			component.set("v.formTotal", 0);
		}
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to perform update/save on account object
	 * @param component
	 * @param event
	 */
	handleSaveAccount: function (component, event, helper) {
		component.set("v.showSpinner", true);
		//component.set("v.acc.Client_Type__c", "Individual");
		component.set("v.acc.Client_Group__c", "Individual");
		component.set("v.acc.Country_of_Origin__pc", component.get("v.acc.Country_of_Birth__pc"));
		component.set("v.acc.BillingCountry", "South Africa");
		component.set("v.acc.ShippingCountry", "South Africa");
		component.find("accountRecordData").saveRecord(
			$A.getCallback(function (saveResult) {
				if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
					helper.saveResAddress(component, event, helper);
				} else if (saveResult.state === "INCOMPLETE") {
					var message = "User is offline, device doesn't support drafts.";
					helper.getToast("Error", message, "warning");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				} else if (saveResult.state === "ERROR") {
					var message = "Problem saving record, error: " + JSON.stringify(saveResult.error);
					helper.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				} else {
					var message = "Unknown problem, state: " + saveResult.state + ", error: " + JSON.stringify(saveResult.error);
					helper.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				}
			})
		);
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to create Residential Address record
	 * @param component
	 * @param event
	 */
	saveResAddress: function (component, event, helper) {
		component.set("v.resAdd.Account__c", component.get("v.accountId"));
		component.set("v.resAdd.Client_Entity_Type__c", "Individual");
		component.set("v.resAdd.Address_Type__c", "Physical Address");

		component.find("residentialAddRecordData").saveRecord(
			$A.getCallback(function (saveResult) {
				if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
					helper.savePosAddress(component, event, helper);
					console.log("Residential Address Saved successfully: " + component.get("v.resAdd.Id"));
				} else if (saveResult.state === "INCOMPLETE") {
					var message = "User is offline, device doesn't support drafts.";
					helper.getToast("Warning", message, "warning");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				} else if (saveResult.state === "ERROR") {
					var message = "Problem saving record, error: " + JSON.stringify(saveResult.error);
					helper.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				} else {
					var message = "Unknown problem, state: " + saveResult.state + ", error: " + JSON.stringify(saveResult.error);
					helper.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				}
			})
		);
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to create Postal Address record
	 * @param component
	 * @param event
	 */
	savePosAddress: function (component, event, helper) {
		component.set("v.posAdd.Account__c", component.get("v.accountId"));
		component.set("v.posAdd.Client_Entity_Type__c", "Individual");
		component.set("v.posAdd.Address_Type__c", "Postal");

		if (component.get("v.postalSame") == "Yes") {
			component.set("v.posAdd.Shipping_Street__c", component.get("v.resAdd.Shipping_Street__c"));
			component.set("v.posAdd.Shipping_Street_2__c", component.get("v.resAdd.Shipping_Street_2__c"));
			component.set("v.posAdd.Shipping_Suburb__c", component.get("v.resAdd.Shipping_Suburb__c"));
			component.set("v.posAdd.Shipping_State_Province__c", component.get("v.resAdd.Shipping_State_Province__c"));
			component.set("v.posAdd.Shipping_Zip_Postal_Code__c", component.get("v.resAdd.Shipping_Zip_Postal_Code__c"));
		}

		component.find("postalAddRecordData").saveRecord(
			$A.getCallback(function (saveResult) {
				if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
					if (component.get("v.employed")) {
						helper.saveEmployerAddress(component, event, helper);
					} else {
						helper.handleSaveOpportunity(component, event, helper);
					}
				} else if (saveResult.state === "INCOMPLETE") {
					var message = "User is offline, device doesn't support drafts.";
					helper.getToast("Warning", message, "warning");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				} else if (saveResult.state === "ERROR") {
					var message = "Problem saving record, error: " + JSON.stringify(saveResult.error);
					helper.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				} else {
					var message = "Unknown problem, state: " + saveResult.state + ", error: " + JSON.stringify(saveResult.error);
					helper.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				}
			})
		);
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to Employer Postal Address record
	 * @param component
	 * @param event
	 */
	saveEmployerAddress: function (component, event, helper) {
		component.set("v.empAdd.Account__c", component.get("v.accountId"));
		component.set("v.empAdd.Address_Type__c", "Employers");
		component.set("v.empAdd.Client_Entity_Type__c", "Individual");

		component.find("employerAddRecordData").saveRecord(
			$A.getCallback(function (saveResult) {
				if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
					helper.handleSaveOpportunity(component, event, helper);
				} else if (saveResult.state === "INCOMPLETE") {
					var message = "User is offline, device doesn't support drafts.";
					helper.getToast("Warning", message, "warning");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				} else if (saveResult.state === "ERROR") {
					console.log("Problem saving record, error: " + JSON.stringify(saveResult.error));
					var message = "Problem saving record, error: " + JSON.stringify(saveResult.error);
					helper.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				} else {
					var message = "Unknown problem, state: " + saveResult.state + ", error: " + JSON.stringify(saveResult.error);
					helper.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
					component.set("v.showSpinner", false);
					return;
				}
			})
		);
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to Create an opportunity record
	 * @param component
	 * @param event
	 * @param helper
	 */
	handleSaveOpportunity: function (component, event, helper) {
		var today = new Date();
		var jobDetails = component.get("v.jobDetails");
		today.setDate(today.getDate() + 7);
		component.set("v.simpleNewOpportunity.AccountId", component.get("v.accountId"));
		component.set("v.simpleNewOpportunity.Name", "Sales Onboarding");
		component.set("v.simpleNewOpportunity.Process_Type__c", jobDetails.Sales_Process_Type__r.Name);
		component.set("v.simpleNewOpportunity.StageName", "Confirm Client Eligibility");
		component.set("v.simpleNewOpportunity.CloseDate", $A.localizationService.formatDate(today, "YYYY-MM-DD"));

		component.find("newOpportunityRecordCreator").saveRecord(function (saveResult) {
			if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
				var message = "The Opportunity was saved.";
				helper.getToast("Saved", message, "success");
				var oppId = component.get("v.simpleNewOpportunity.Id");
				helper.closeFocusedTabAndOpenNewTab(component, event, oppId);
				component.set("v.showSpinner", false);
			} else if (saveResult.state === "INCOMPLETE") {
				var message = "User is offline, device doesn't support drafts.";
				helper.getToast("Warning", message, "warning");
				component.set("v.errorMessage", message);
				component.set("v.showSpinner", false);
				return;
			} else if (saveResult.state === "ERROR") {
				var message = "Problem saving record, error: " + JSON.stringify(saveResult.error);
				helper.getToast("Error", message, "error");
				component.set("v.errorMessage", message);
				component.set("v.showSpinner", false);
				return;
			} else {
				var message = "Unknown problem, state: " + saveResult.state + ", error: " + JSON.stringify(saveResult.error);
				helper.getToast("Error", message, "error");
				component.set("v.errorMessage", message);
				component.set("v.showSpinner", false);
				return;
			}
		});
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function close the current tab and navigate to record view
	 * @param component
	 * @param event
	 * @param recordId
	 */
	closeFocusedTabAndOpenNewTab: function (component, event, recordId) {
		var workspaceAPI = component.find("workspace");
		console.log("In closeFocusedTabAndOpenNewTab");
		workspaceAPI
			.getFocusedTabInfo()
			.then(function (response) {
				var focusedTabId = response.tabId;

				console.log(focusedTabId);

				//Opening New Tab
				workspaceAPI
					.openTab({
						url: "#/sObject/" + recordId + "/view"
					})
					.then(function (response) {
						workspaceAPI.focusTab({ tabId: response });
					})
					.catch(function (error) {
						console.log(error);
					});

				//Closing old tab
				workspaceAPI.closeTab({ tabId: focusedTabId });
			})
			.catch(function (error) {
				console.log(error);
			});
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to show Toast message
	 * @param title
	 * @param msg
	 * @param type
	 */
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
});
/****************@ Author: Chandra********************************
 ****************@ Date: 2019-11-22*******************************
 ****************@ Work Id: W-003308******************************
 ****************@ Description: Method to handle component event**/

/*Updated the method to render different components based on the selected job on 15/01/2020 - Thabo Senkomane - */
({
	handleComponentEvent: function (component, event, helper) {
		var selectedJob = event.getParam("selectedJob");
		var evt = $A.get("e.force:navigateToComponent");
		if (selectedJob.ObjectRef == "Service_Group_Type__c") {
			var serType = selectedJob.Service_Type__r;

			console.log("serType.Name " + serType.Name);
			//console.log('label '+$A.get("$Label.c.CAF_New_To_Product"));
			//console.log('label2 '+$A.get("$Label.c.CAF_New_To_Bank"));

			if (serType.Name === "Complex Credit") {
				// alert('in alert');
				evt.setParams({
					componentDef: "c:CreditProductOnboarding",
					componentAttributes: {
						jobname: selectedJob,
						ProcessName: "complexcredit",
						showCreateBusinessProspectOnboarding: false,
						showCreateIndividualProspectOnboarding: false
					}
				});
			} else if (serType.Name === $A.get("$Label.c.Onboard_New_Client")) {
				console.log("In Navigate to Onboarding");
				evt.setParams({
					componentDef: "c:OnboardingNTBClient",
					componentAttributes: {
						isLimitReached: true,
						showCreateBusinessProspectOnboarding: true,
						showCreateIndividualProspectOnboarding: true,
						isprocessOnboarding: true,
						jobname: selectedJob
					}
				});
			} /* 20200312: Prashant Jain and Tinashe Shoko: start handling Merchant Onboarding */ else if (
				serType.Name === $A.get("$Label.c.Merchant_Onboarding")
			) {
				evt.setParams({
					componentDef: "c:MerchantOnboarding",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			} /* 20200312: Prashant Jain and Tinashe Shoko: end handling Merchant Onboarding */
			//TdB - Credit Product
			else if (serType.Name === $A.get("$Label.c.New_Credit_Product")) {
				evt.setParams({
					componentDef: "c:CreditProductOnboarding",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			} //Added by Almas Aleem - Credit Product Covid-19
			else if (serType.Name === $A.get("$Label.c.Credit_Maintenance")) {
				evt.setParams({
					componentDef: "c:CreditProductOnboarding",
					componentAttributes: {
						jobname: selectedJob,
						ProcessName: "NewCreditProduct(Covid-19)"
					}
				});
			} //TdB - Lite Onboarding
			else if (serType.Name === $A.get("$Label.c.Onboard_New_Financial_Product")) {
				evt.setParams({
					componentDef: "c:FinancialProductOnboarding",
					componentAttributes: {
						isLimitReached: true,
						showCreateBusinessProspectOnboarding: true,
						showCreateIndividualProspectOnboarding: true,
						isprocessOnboarding: true,
						jobname: selectedJob
					}
				});
			}

			//TdB - Remediate Existing Customer
			else if (serType.Name === $A.get("$Label.c.Remediate_Existing_Customer")) {
				evt.setParams({
					componentDef: "c:RemediateExistingCustomer",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			}
			//Manoj-11172020 - W-007367 - Onboard New Product for Existing Customer
			//Adding an OR Condition to Include the Account Number Portability service Job. This service Job will be Built by the Onboarding team
			else if (serType.Name === $A.get("$Label.c.Onboard_New_Product") || serType.Name == 'Account Number Portability') {
				evt.setParams({
					componentDef: "c:NewProductOnboarding",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			} /* 20200312: Prashant Jain and Tinashe Shoko: end handling Merchant Onboarding */
			// TBD -- Customer Search Consent -- Added by Srinivas (Need to create Custom label after Confirmation)
			else if (serType.Name === "Customer Search Consent") {
				evt.setParams({
					componentDef: "c:CustomerSearchConsent",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			} //TdB - Credit Product
			//stokvel
			else if (serType.Name === $A.get("$Label.c.Stokvel_Onboarding")) {
				evt.setParams({
					componentDef: "c:StokvelOnboarding",
					componentAttributes: {
						isLimitReached: true,
						showCreateStokvelProspectOnboarding: true,
						isprocessOnboarding: true,
						jobname: selectedJob
					}
				});
			} else if (serType.Name === $A.get("$Label.c.New_Credit_Product")) {
				evt.setParams({
					componentDef: "c:CreditProductOnboarding",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			}

			//TdB - Onboard Surety
			else if (serType.Name === $A.get("$Label.c.Onboard_a_Surety")) {
				evt.setParams({
					componentDef: "c:SuretyOnboarding",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			} else if (serType.Name === $A.get("$Label.c.On_Board_New_Product")) {
				evt.setParams({
					componentDef: "c:ClientFinder",
					componentAttributes: {
						isLimitReached: true,
						showNewProductOnboarding: true,
						showBranchCreateIndividualProspectOnboarding: true,
						showCreateBusinessProspect: false,
						jobname: selectedJob
					}
				});
			} else if (serType.Name === $A.get("$Label.c.Linking_accounts_into_a_Package")) {
				evt.setParams({
					componentDef: "c:ClientFinder",
					componentAttributes: {
						isLimitReached: true,
						// showNewProductOnboarding : true,
						showLinkingaccountsintoaPackage: true,
						//showCreateBusinessProspect : true,
						jobname: selectedJob
					}
				});
			} else if (serType.Name.toUpperCase() === $A.get("$Label.c.Delinking_accounts_from_a_Package").toUpperCase()) {
				evt.setParams({
					componentDef: "c:ClientFinder",
					componentAttributes: {
						isLimitReached: true,
						showDelinkingAccountsFromPackage: true,
						jobname: selectedJob
					}
				});
			} else if (serType.Name === $A.get("$Label.c.Lead_Creation")) {
				evt.setParams({
					componentDef: "c:LeadOverride",
					componentAttributes: {
						isLimitReached: true,
						jobname: selectedJob
					}
				});
			} else if (serType.Case_Record_Type__c === $A.get("$Label.c.ATM") || serType.Case_Record_Type__c === $A.get("$Label.c.Complaint")) {
				evt.setParams({
					componentDef: "c:CaseOverride",
					componentAttributes: {
						isLimitReached: true,

						jobname: selectedJob
					}
				});
			} else if (serType.Name === $A.get("$Label.c.SPM_Onboarding")) {
				/* 24082020Haritha and Diksha: start handling SPM Onboarding */
				evt.setParams({
					componentDef: "c:SPMOnboarding",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			} else if (serType.Name === $A.get("$Label.c.CPF_Onboarding")) {
				/* Added by Diksha: start handling CPF Onboarding 11/19/2020 */
				evt.setParams({
					componentDef: "c:CPFOnboarding",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			}
			//Masechaba Maseli CAF Onboarding
			else if (serType.Name === $A.get("$Label.c.CAF_New_To_Bank")) {
				console.log("In NTB If@@@");
				evt.setParams({
					componentDef: "c:CAFNewToBank",
					componentAttributes: {
						isLimitReached: true,
						showCreateBusinessProspectOnboarding: true,
						showCreateIndividualProspectOnboarding: true,
						isprocessOnboarding: true,
						jobname: selectedJob
					}
				});
			} else if (serType.Name === $A.get("$Label.c.CAF_New_To_Product")) {
				console.log("In If@@@");
				evt.setParams({
					componentDef: "c:CAFNewToProduct",
					componentAttributes: {
						jobname: selectedJob
					}
				});
			} else if (helper.isServicesSwitcherLabel(serType.Name)) {
				evt.setParams({
					componentDef: "c:ClientFinder",
					componentAttributes: {
						jobname: selectedJob,
						showServicesSwitcher: true,
						serviceLabel: serType.Name,
						isLimitReached: true
					}
				});
			} else {
				console.log("In else@@@");
				evt.setParams({
					componentDef: "c:ClientFinder",
					componentAttributes: {
						isLimitReached: true,
						showNewCaseCreation: true,
						showCreateIndividualProspect: true,
						showCreateBusinessProspect: true,
						jobname: selectedJob
					}
				});
			}
			evt.fire();

			//Set the new Tab Label
			var workspaceAPI = component.find("workspace");
			workspaceAPI.getFocusedTabInfo().then(function (response) {
				var focusedTabId = response.tabId;
				workspaceAPI.setTabLabel({
					tabId: focusedTabId,
					label: serType.Name
				});
			});
		} else {
			evt.setParams({
				componentDef: "c:ClientFinder",
				componentAttributes: {
					isLimitReached: true,
					showCreateIndividualProspect: true,
					jobname: selectedJob,
					ProcessName: "Sales"
				}
			});
			evt.fire();
		}
	},

	/****************@ Author: Chandra*******************************
	 ****************@ Date: 2019-11-22*******************************
	 ****************@ Work Id: W-003308******************************
	 ****************@ Description: Method to handle init event******/
	doInit: function (component, event, helper) {
		var action = component.get("c.fetchUser");
		var placeHolder;
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				placeHolder = "Hello " + storeResponse.FirstName + ", " + $A.get("$Label.c.What_do_you_want_to_do_today");
				component.set("v.placeHolder", placeHolder);
			}
		});
		$A.enqueueAction(action);
	}
	
});
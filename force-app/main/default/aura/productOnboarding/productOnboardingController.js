({
	doInit: function (component, event, helper) {
		console.log("Initial Is Closed1 " + component.get("v.opportunityRecord.IsClosed"));
		console.log("Initial Is Closed2 " + component.get("v.opportunityRecord2.IsClosed"));
		console.log("recordId " + component.get("v.recordId"));
		helper.hideAccordinsForVoice(component, event, helper); //Added by Diksha for voice 02-09-2021
		helper.fetchRelatedParty(component);
		helper.showSelectedProduct(component, event, helper);
		//Show pricing schemes of Selected Product : W-004843 : Anka Ganta : 2020-07-14
		helper.showPricingSchemes(component, event, helper);
		//helper.getExecutionLayerRequestID(component, event, helper);
		helper.fetchQuestionnaireRecordlist(component, event, helper);
		var selectedScheme = component.get("v.selectedScheme");
		var oppproduct = component.get("v.SelectedProduct");
		component.set("v.acctname", oppproduct);
		if (oppproduct != null && oppproduct != "") {
			var recordId = component.get("v.recordId");
			var action = component.get("c.getApplicationProducts");
			action.setParams({ oppId: recordId });
			action.setCallback(this, function (data) {
				component.set("v.productList", data.getReturnValue()[0]);

				var showacct = data.getReturnValue()[0];
				var ExecutionLayerRequestID__c = showacct.Opportunity.ExecutionLayerRequestID__c;

				if (ExecutionLayerRequestID__c == "" || ExecutionLayerRequestID__c == null) {
					component.set("v.showROA", "Yes");
				}

				if (showacct != undefined && showacct != null && showacct != "") {
					var policyNo = showacct.Policy_Number__c;
					var oppStageName = showacct.Opportunity.StageName;
				}

				if ((oppStageName == "Completed" || oppStageName == "Closed") && $A.util.isUndefinedOrNull(policyNo)) {
					component.set("v.isHide", false);
				}
				if ((oppStageName == "Completed" || oppStageName == "Closed") && policyNo > 0) {
					component.set("v.isHide", true);
				}
				if (showacct != undefined && showacct != null && showacct != "") {
					if (showacct.Policy_Number__c != null && showacct.Policy_Number__c != "") {
						helper.selectOpportunity(component, event, helper);
						component.set("v.policynumber", showacct.Policy_Number__c);
					}
				}

				//hide cheque section if product family is savings
				if (showacct != undefined && showacct != null && showacct != "") {
					var productFamily = showacct.Product_Family__c;
				}

				if (productFamily == "Cheque") {
					component.set("v.productFamily", "Cheque");
					component.set("v.showSpecialistInfo", "No");
					component.set("v.showSavingsAccountGen", "No");
					component.set("v.showDebitCardCheckbox", false);
				}
				//Added by Rajesh for Product Details Expansion
				var activeSections = ["chequeInterestDates", "AnalysisDetails", "chequeAccGen", "ChequeChargeDetails", "chequeStatementDetails"];
				component.set("v.activeSectionsAnalysis", activeSections);
			});
			$A.enqueueAction(action);

			// Call helper for Product Usage
			helper.loadProductData(component, event, helper);
			//Call helper for Logged in User Details
			helper.getUserDetails(component, event, helper);
			//Added by diksha for W-5029
			var purposeOfAcc;
            if(component.find("purposeOfAcc") == undefined){
            purposeOfAcc=null;
              }else{
            purposeOfAcc = component.find("purposeOfAcc").get("v.value");
             }
			if (purposeOfAcc == "CURRENT / CHEQUE / SAVINGS - PRIMARY BUSINESS ACCOUNT") {
				component.find("purposeOfAcctText").set("v.value", "THIS ACCOUNT IS GOING TO BE USED FOR THE DAY TO DAY RUNNING OF THE CLIENTS BUSINESS.");
			}
		}
         //15225 : this functin is added
			//Get get Account Record By OppId
			var getAccountByOppId = component.get("c.getAccountByOppId");
			getAccountByOppId.setParams({
				oppId: component.get("v.recordId")
			});

			getAccountByOppId.setCallback(this, function (response) {
				let title = "";
				let type = "";
				let message = "";
				var err = 0;

				var responseMsg = response.getReturnValue();
				var objAcc = JSON.parse(responseMsg);
				//15225
				if (objAcc.AccId == "null") {
					err++;
					message += "\nAccount Id is null";
				}
				
				if (objAcc.Active_Email__c == "null") {
					err++;
					message += "\nEnter Account Active Email";
				} else {
					component.set("v.ActiveEmail", objAcc.Active_Email__c);
				}
				if (objAcc.FirstName == "null") {
					err++;
					message += "\nEnter Account Name";
				} else {                      
                   	component.set("v.Name", objAcc.FirstName);
                     console.log('in doInit'+component.get("v.Name"));
				}
				if (objAcc.LastName == "null") {
					err++;
					message += "\nEnter Account Surname";
				} else {
					component.set("v.Surname", objAcc.LastName);
				}
				if (objAcc.PreferredLanguage == "null") {
					err++;
					message += "\nEnter Account Language";
				} else {
					component.set("v.PreferredLanguage", objAcc.PreferredLanguage);
				}
                
                if (objAcc.PreferredContact == "null") {
					err++;
					message += "Enter Preferred Contact";
				} else {
					component.set("v.PreferredContact", objAcc.PreferredContact);
                   
				}

				console.log("objAcc Id: " + objAcc.AccId);

			});

			$A.enqueueAction(getAccountByOppId);
        
		//Get application Record
		var getApplicationAction = component.get("c.getApplicationRecord");

		getApplicationAction.setParams({
			opportunityId: component.get("v.recordId")
		});

		// Add callback behavior for when response is received
		getApplicationAction.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {
				//Set application record returned
				component.set("v.application", response.getReturnValue());
				/*
                //Product Price list
                var action = component.get("c.getApplicationProducts");
                action.setCallback(this, function(response) {
                    if(response.getState() == "SUCCESS"){
                        component.set("v.oppLineItems",response.getReturnValue());
                    }
                });
                $A.enqueueAction(action);
			*/

				//Changes Start for W-004995 by Chandra dated 12/06/2020
				if (component.get("v.application.Re_Direct_Fees__c") == true) {
					component.set("v.reDirectFeesChecked", component.get("v.application.Re_Direct_Fees__c"));
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					for (var i = 0; i < errors.length; i++) {
						for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
						}
						if (errors[i].fieldErrors) {
							for (var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for (var j = 0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
								}
							}
						}
						if (errors[i].message) {
							message += (message.length > 0 ? "\n" : "") + errors[i].message;
						}
					}
				} else {
					message += (message.length > 0 ? "\n" : "") + "Unknown error";
				}

				var toast = helper.getToast("Error", message, "error");
				toast.fire();
				helper.hideSpinner(component);
			} else {
				var errors = response.getError();
				var toast = helper.getToast("Error", message, "error");
				toast.fire();
				helper.hideSpinner(component);
			}
		});
		// Send action off to be executed
		console.log("End Is Closed1 " + component.get("v.opportunityRecord.IsClosed"));
		console.log("End Is Closed2 " + component.get("v.opportunityRecord2.IsClosed"));
		$A.enqueueAction(getApplicationAction);
	},

	getAppData: function (component, event, helper) {
		if (component.get("v.roaLoaded") != true) {
			helper.loadProductData(component, event, helper);
		}
	},

	getParty: function (component, event, helper) {
		helper.selectPrincipal(component, event, helper);
	},
	addMoreShareHandler: function (component, event, helper) {
		var inputs = component.get("v.fileShares");
		var numberOfRelatedParty = component.get("v.relatedParties").length;
		var id = inputs.length + 1;

		console.log("Count Party " + component.get("v.relatedParties").length + " input id " + id);
		//if(numberOfRelatedParty < id){
		var obj = { id: id, auraId: "relatedParty" + id };
		//}
		inputs.push(obj);
		component.set("v.fileShares", inputs);
	},
	removeShareHandler: function (component, event, helper) {
		event.preventDefault();
		var selectedItem = event.currentTarget;
		var idtoremove = selectedItem.dataset.idtoremove;
		var inputs = component.get("v.fileShares");
		for (var i = 0; i < inputs.length; i++) {
			var obj = inputs[i];
			if (obj.id == idtoremove) {
				inputs.splice(i, 1);
				break;
			}
		}
		component.set("v.fileShares", inputs);
	},
	isUnderSupervision: function (component, event, helper) {
		var underSupervision = component.find("underSuperVisionGroup").get("v.value");
		//component.find("underSuper").set("v.value",underSupervision);
		component.set("v.isUnderSupervisionBol", underSupervision);
		//if(underSupervision == 'Y'){
		component.set("v.underSupervision", underSupervision);
		//component.set("v.isUnderSupervision", true);
		//}
	},

	isAdviceGiven: function (component, event, helper) {
		var adviseGiven = component.find("adviceGivenGroup").get("v.value");
		component.set("v.isAdviseGivenBol", adviseGiven);
		//component.find("advice").set("v.value", adviseGiven);
		//if(adviseGiven == 'Y'){
		component.set("v.adviseGiven", adviseGiven);
		//component.set("v.isAdviceGiven", true);
		//}
		//else{
		//component.set("v.adviseGiven", 'N');
		//component.set("v.isAdviceGiven", true);
		//}
	},

	issourceFundsGiven: function (component, event, helper) {
		var sourceFundsGiven = component.get("v.sourceFundsGiven");
		if (sourceFundsGiven == "Y") {
			var stringfield = "Yes";
			component.set("v.sourceFundsGiven", "Y");
			component.set("v.issourceFundsGiven", true);
		} else {
			var stringfield = "No";
			component.set("v.sourceFundsGiven", "N");
			component.set("v.issourceFundsGiven", true);
		}
	},

	replacingProductFunc: function (component, event, helper) {
		var isReplacingProduct = component.find("productReplacementGroup").get("v.value");
		component.find("productReplacement").set("v.value", isReplacingProduct);
		if (isReplacingProduct == "Y") {
			component.set("v.isReplacingProductBol", "Y");
			component.set("v.isDuplicateStatement", true);
		} else {
			component.set("v.isReplacingProductBol", "N");
			component.set("v.isDuplicateStatement", false);
		}
	},

	onDuplicateStatement: function (component, event, helper) {
		var selectedOption = component.get("v.selectedOption");

		if (selectedOption == "Y") {
			component.set("v.optionFilter", "Y");
			component.set("v.isDuplicateStatement", true);
		}
	},
	handleSectionToggle: function (cmp, event) {
		var openSections = event.getParam("openSections");
		if (openSections.length === 0) {
			cmp.set("v.activeSectionsMessage", "All sections are closed");
		} else {
			cmp.set("v.activeSectionsMessage", "Open sections: " + openSections.join(", "));
		}
	},
	showNewProductTermBtn: function (component, event, helper) {
		var iPriceNegotiationField = component.find("iPriceNegotiation");
		var iPriceNegotiationValue = iPriceNegotiationField.get("v.value");

		//Set attribute to display button
		component.set("v.showProductTermsBtn", iPriceNegotiationValue);
	},

	showNewNotifyMe: function (component, event, helper) {
		var iNotifyMeField = component.find("iNotifyMe");
		var iNotifyMeValue = iNotifyMeField.get("v.value");

		//Set attribute to display button
		component.set("v.showNotifyMe", iNotifyMeValue);

		if (iNotifyMeValue) {
			component.find("iInternetBanking").set("v.value", false);
			component.set("v.showInternetBanking", false);

			component.find("ieStatement").set("v.value", false);
			component.set("v.showeStatementPanel", false);
		}
	},

	showNewInternetBanking: function (component, event, helper) {
		var iInternetBankingField = component.find("iInternetBanking");
		var iInternetBankingValue = iInternetBankingField.get("v.value");

		//Set attribute to display button
		component.set("v.showInternetBanking", iInternetBankingValue);

		if (iInternetBankingValue) {
			component.find("iNotifyMe").set("v.value", false);
			component.set("v.showNotifyMe", false);

			component.find("ieStatement").set("v.value", false);
			component.set("v.showeStatementPanel", false);
		}
	},

	showEstatement: function (component, event, helper) {
		var ieStatementField = component.find("ieStatement");
		var ieStatementValue = ieStatementField.get("v.value");

		//Set attribute to display button
		component.set("v.showeStatementPanel", ieStatementValue);

		if (ieStatementValue) {
			component.find("iNotifyMe").set("v.value", false);
			component.set("v.showNotifyMe", false);

			component.find("iInternetBanking").set("v.value", false);
			component.set("v.showInternetBanking", false);
		}
	},
	showEmpCarePlan : function(component, event, helper) {
        var empCarePlanField = component.find("empCarePlan");
        var empCarePlanValue =  empCarePlanField.get("v.value");        
        console.log(empCarePlanValue);
        
        //Set attribute to display button
        component.set("v.showEmployeeCarePanel", empCarePlanValue);    
        console.log("Employee Care Plan checked! "+ empCarePlanValue);
          //call Helper Method  to update the product interest field of Application ;
          helper.handleShowEmpcarePlan(component, event, helper);
    },
	showNewDebitCard: function (component, event, helper) {
		var debitCardField = component.find("debitCard");
		var debitCardValue = debitCardField.get("v.value");
		console.log("Debit Card checked! " + debitCardValue);

		//Set attribute to display button
		component.set("v.showDebitCard", debitCardValue);

		if (debitCardValue == true) {
			var debitCardOrdering = component.find("cardOrdering");
			debitCardOrdering.getOpportunityId(component.get("v.recordId"));

			component.find("iNotifyMe").set("v.value", false);
			component.set("v.showNotifyMe", false);

			component.find("iInternetBanking").set("v.value", false);
			component.set("v.showInternetBanking", false);
		}
	},
	//Added by Masechaba Maseli for W-005065
	showTermAndConditionsBtn: function (component, event, helper) {
		var iTermsAndConditionsField = component.find("iTermsAndConditions");
		var iTermsAndConditionsValue = iTermsAndConditionsField.get("v.value");

		//Set attribute to display button
		component.set("v.showTermsAndConditionsBtn", iTermsAndConditionsValue);
	},

	showCompletefulfilmentBtn: function (component, event, helper) {
		//W-008562
		//var isClosedOpportunity = component.get("v.opportunityRecord2.IsClosed");
		/*if(isClosedOpportunity){
            helper.closedOpportunityValidation(component, event, helper);
        }else{*/
		var completefulfilmentField = component.find("completefulfimentid");
		var completefulfilmentValue = completefulfilmentField.get("v.value");
		var purposeOfAcc = component.find("purposeOfAcc").get("v.value");

		var accActTracker = component.get("v.application.Account_Activity_Calculator__c");

		var isThereAnyTPFTP;
        var processType =component.get('v.processType'); // Added by Diksha for Voice 02/09/2021

		/*Updated by Litha INC2314189*/
		if (component.get("v.productFamily") != "Cheque") {
			isThereAnyTPFTP = component.find("isThereAnyTPFTP").get("v.value");
		}

		/*Updated by MD INC1614413 */
		var deliveryMethod, sourceOfFunds, accrualDayOfMonth, capitilisationDayOfWeek, capitilisationDayOfMonth, chargeCapDate, accrualDayOfWeek;
		if (component.get("v.productFamily") == "Cheque") {
			var application = component.get("v.application");
			console.log("application******** " + JSON.stringify(application));
			deliveryMethod = application.Delivery_Method__c; //component.find("deliveryMethod").get("v.value");
			sourceOfFunds = application.Source_of_Funds_Savings__c; //component.find("sourceOfFunds").get("v.value");
			//W-13221 : Anka Chagnes : hide charge details
			/*
            accrualDayOfMonth= application.Accrual_Day_of_Month__c;//component.find("accrualDayOfMonth").get("v.value");
            capitilisationDayOfWeek= application.Capitilisation_Day_of_Week__c;//component.find("capitilisationDayOfWeek").get("v.value");
            capitilisationDayOfMonth= application.Capitilisation_Day_of_Month__c;//component.find("capitilisationDayOfMonth").get("v.value");
            chargeCapDate = application.Charge_Capitalization_Date__c;//component.find("chargeCapDate").get("v.value");
            accrualDayOfWeek= application.Accrual_Day_of_Week__c;//component.find("accrualDayOfWeek").get("v.value");
            */
		}

		/*Updated by MD INC1614413 */
		if (
			component.get("v.productFamily") == "Cheque" &&
			purposeOfAcc != null &&
			accActTracker != null &&
			deliveryMethod != null &&
			sourceOfFunds != null
			/* W- 13221 :&&
			accrualDayOfMonth != null &&
			capitilisationDayOfWeek != null &&
			capitilisationDayOfMonth != null &&
			accrualDayOfWeek != null &&
			chargeCapDate != null*/
		) {
			//Set attribute to display button
			component.set("v.showCompletefulfilmentBtn", completefulfilmentValue);

			/*Updated by MD INC1614413 */
		} else if (
			component.get("v.productFamily") != "Cheque" &&
			purposeOfAcc != null &&
			accActTracker != null &&
			isThereAnyTPFTP != null &&
			isThereAnyTPFTP != undefined
		) {
			//Set attribute to display button
			component.set("v.showCompletefulfilmentBtn", completefulfilmentValue);
		}else if(processType == 'Voice Sales Product Onboarding'){
			component.set("v.showCompletefulfilmentBtn", completefulfilmentValue);

		} else {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				type: "error",
				title: "Error!",
				message: "Please fill all the Mandatory fields before completing fullfillment."
			});
			toastEvent.fire();
		}
		//}
	},

	sendWelcomePckg: function (component, event, helper) {
		helper.sendwelcmepckg(component, event, helper);
	},
	openNewProductTerms: function (component, event, helper) {
		//Show Modal for new Product Term Request
		component.set("v.showProductTermsModal", true);
	},

	//Close Product Term Request
	closeNewProductTermsModal: function (component, event, helper) {
		component.set("v.showProductTermsModal", false);
	},

	submitProductTermsRequest: function (component, event, helper) {
		var opportunityUpdateAction = component.get("c.updateOpportunityAndApplication");

		opportunityUpdateAction.setParams({
			OpportunityId: component.get("v.recordId"),
			applicationRecord: component.get("v.application")
		});

		// Add callback behavior for when response is received
		opportunityUpdateAction.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				component.set("v.showProductTermsBtn", false);
				component.set("v.showProductTermsModal", false);
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					for (var i = 0; i < errors.length; i++) {
						for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
						}
						if (errors[i].fieldErrors) {
							for (var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for (var j = 0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
								}
							}
						}
						if (errors[i].message) {
							message += (message.length > 0 ? "\n" : "") + errors[i].message;
						}
					}
				} else {
					message += (message.length > 0 ? "\n" : "") + "Unknown error";
				}

				var toast = helper.getToast("Error", message, "error");

				toast.fire();

				helper.hideSpinner(component);
			} else {
				var errors = response.getError();

				var toast = helper.getToast("Error", message, "error");

				toast.fire();

				helper.hideSpinner(component);
			}
		});

		// Send action off to be executed
		$A.enqueueAction(opportunityUpdateAction);
	},

	acceptProductTerms: function (component, event, helper) {
		var oppproduct = component.get("v.SelectedProduct");
		var action = component.get("c.getApplicationProducts");
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function (data) {
			component.set("v.productList", data.getReturnValue());

			var showacct = data.getReturnValue();
			if (showacct != undefined && showacct != null && showacct != "") {
				console.log("showacct deatils : " + JSON.stringify(showacct));
				var productFamily = showacct[0].Product_Family__c;
				console.log("product family>>>---" + productFamily);
			}

			//var chargedatenum = component.find("chargeCapDate").get("v.value");

			if (productFamily === "Cheque") {
				console.log("INSIDE IF product family>>>---" + productFamily);
				helper.updateApplication(component, event, helper);
			} else if (productFamily === "SAVINGS" || productFamily === "Savings") {
				console.log("IN SAVING");
				helper.getsavingsaccdetails(component, event, helper);
				helper.updateSavings(component, event, helper);
			}

			helper.updateROAInformation(component, event, helper);
			helper.saveAppRecord(component, event, helper);
			//   helper.openSignatureModal(component, event, helper);
		});
		$A.enqueueAction(action);
	},

	updateAndSaveApplication: function (component, event, helper) {
		//helper.updateNotifyMe(component, event,helper);
		//var isNotifyMe = ;
		// W-008562
		/*var isClosedOpportunity = component.get("v.opportunityRecord2.IsClosed");
		if (isClosedOpportunity) {
			helper.closedOpportunityValidation(component, event, helper);
		} else {*/
		if (component.get("v.showNotifyMe")) {
			console.log("showNotifyMe");
			helper.updateNotifyMe(component, event, helper);
		}

		if (component.get("v.showInternetBanking")) {
			helper.updateInternetBanking(component, event, helper);
			console.log("showInternetBanking");
		}
		//}
	},

	updateAndSaveEstatement: function (component, event, helper) {
		//W-008562
		/*var isClosedOpportunity = component.get("v.opportunityRecord2.IsClosed");
        if(isClosedOpportunity){
			helper.closedOpportunityValidation(component, event, helper);
        }else{*/
		var err = 0;
		var msg = "";
		component.set("v.hideSpinner", false);

		//
		var oppId = component.get("v.recordId");
		var deliveryMethodVal = component.find("deliveryMethodId").get("v.value");
		var statementFreqVal = component.find("statementFrequencyId").get("v.value");
		var statemDayOfMonthVal = component.find("statementDayOfMonthId").get("v.value");
		var accountStreamVal = component.find("accountStreamId").get("v.value");
		var duplicateStatemsVal = component.find("duplicateStatementsId").get("v.value") == "Y" ? true : false;
		var deliveryInstructVal = "";
		var numberOfDaysLength = statemDayOfMonthVal.length;

		if (oppId == "") {
			err++;
			msg += "Empty oppId\n";
		}
		if (deliveryMethodVal == "") {
			err++;
			msg += "Select delivery method\n";
		}
		if (statementFreqVal == "") {
			err++;
			msg += "Select Statement frequently\n";
		}
		if (accountStreamVal == "") {
			err++;
			msg += "Select Account Stream\n";
		}
		if (numberOfDaysLength != null && numberOfDaysLength != undefined) {
			if (numberOfDaysLength > 3) {
				err++;
				msg += "Enter less than 4 charactors e.g 03,21\n";
			}
		}
		console.log("Length is :" + numberOfDaysLength);

		if (duplicateStatemsVal) {
			deliveryInstructVal = component.find("deliveryInstructionId").get("v.value");
			if (deliveryInstructVal == "") {
				err++;
				msg += "Enter delivery Instruction\n";
			}
		}

		if (err == 0) {
			component.set("v.showSpinner", true);
			var action = component.get("c.addEstatementDetails");

			var params = {
				oppId: oppId,
				deliveryMethodVal: deliveryMethodVal,
				statementFrequencyVal: statementFreqVal,
				statementDayOfMonthVal: statemDayOfMonthVal,
				accountStreamVal: accountStreamVal,
				duplicateStatementsVal: duplicateStatemsVal,
				deliveryInstructionVal: deliveryInstructVal
			};

			action.setParams({ jsonString: JSON.stringify(params) });

			action.setCallback(this, function (response) {
				component.set("v.showSpinner", false);
				let title = "";
				let type = "";
				let message = "";

				var responseMsg = response.getReturnValue();
				var errVal = responseMsg.match(/\d+/g);

				console.log("err responseMsg " + responseMsg);

				if (errVal == 0) {
					const value = response.getReturnValue();
					title = "Success";
					type = "success";
					message = "Successfully added";

					component.find("deliveryMethodId").set("v.value", "");
					component.find("statementFrequencyId").set("v.value", "");
					component.find("statementDayOfMonthId").set("v.value", "");
					component.find("accountStreamId").set("v.value", "O");
					if (duplicateStatemsVal) component.find("deliveryInstructionId").set("v.value", "");
				} else {
					title = "Error";
					type = "error";

					const errors = response.getError();
					const error = responseMsg;
					message = responseMsg;
				}

				const toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: title,
					type: type,
					message: message
				});
				toastEvent.fire();

				component.set("v.hideSpinner", true);
			});

			$A.enqueueAction(action);
		} else {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Error",
				type: "error",
				message: msg
			});
			toastEvent.fire();
		}
		// }
	},

	//Show Modal for Account Activity Calculator
	openAccountActivity: function (component, event, helper) {
		component.set("v.showAccCalculator", true);
		// prepopulate industry on Nature of business based on selection on big form
		//component.find("industryforNOB").set("v.value",component.find("industryBackgroud").get("v.value"));
		//component.find("sicCategoryforNOB").set("v.value",component.find("iSicCategory").get("v.value"));
	},
	//Close Account Activity Model
	closeAccActivty: function (component, event, helper) {
		component.set("v.showAccCalculator", false);
	},
	/*
     updateApplication : function(component, event, helper) {
      
        var applicationid  = component.get("v.productRecordId");
        var action = component.get("c.updateApplicationDetails");
        
         action.setParams({ 
							"requireChequeCard" : component.find("requireChequeCard").get("v.value"),
							"requireDepositBook" : component.find("requireDepositBook").get("v.value"),
							"deliveryMethod" : component.find("deliveryMethod").get("v.value"),
							"statementFrequency" : component.find("statementFrequency").get("v.value"),
							"statementDayOfMonth" :component.find("statementDayOfMonth").get("v.value"),
							"accountStream" : component.find("accountStream").get("v.value"),
							"deliveryInstruction" : component.find("deliveryInstruction").get("v.value"),
							"accrualDayOfMonth" : component.find("accrualDayOfMonth").get("v.value"),
							"capitilisationDayOfWeek" : component.find("capitilisationDayOfWeek").get("v.value"),
							"capitilisationDayOfMonth" : component.find("capitilisationDayOfMonth").get("v.value"),
							"accrualDayOfWeek" : component.find("accrualDayOfWeek").get("v.value"),
             
                            "value13" : strTobeSaved,
                            "value14" : applicationid});  
        
         action.setCallback(this,function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
               //  console.log('Application details '+response.getReturnValue());
                 var applicationDetails = response.getReturnValue();
             }
             else if (state === "INCOMPLETE") {
                 //cmp.set('v.showSpinner', true);
             }
                 else if (state === "ERROR") {
                     var errors = response.getError();
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                         //    console.log("Error message: " +errors[0].message);
                         }
                     }else{
                      //   console.log("Unknown error");
                     }
                 }
             
         });
          $A.enqueueAction(action);
     },*/
	////////////////// Product Usage /////////////////
	handleSuccess: function (cmp, event, helper) {
		cmp.set("v.showSpinner", false);
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			type: "success",
			message: "The record has been Saved successfully."
		});
		toastEvent.fire();
	},
	//// Product Usage End ///////////////////////////

	handleSuccessPCR: function (cmp, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			type: "success",
			title: "Success!",
			message: "Official mandate is saved."
		});
		toastEvent.fire();
		var payload = event.getParams();
		console.log(payload.response.id);
		var isFromSaveAndNew = cmp.get("v.isFromSaveAndNew");
		if (isFromSaveAndNew) {
			cmp.set("v.mandateOfficial", "");
			cmp.find("inTermResDated").set("v.value", null);
			cmp.find("legalEntity").set("v.value", "");
		} else {
			location.reload();
		}
	},
	handleOnLoad: function (cmp, event, helper) {},
	handleAccountChange: function (cmp, event, helper) {
		var accountDetail = cmp.get("v.selectedLookUpRecord");
		console.log("selectedLookUpRecord " + JSON.stringify(accountDetail) + "==" + accountDetail.Id + "==" + typeof accountDetail.Id);
		if (accountDetail != null && accountDetail != undefined && accountDetail != "") {
			helper.getAccountDetails(cmp, event, accountDetail.Id);
		}
	},
	/*handleSaveProductContactRelatiosnhip: function(cmp, event, helper) {
        event.preventDefault();
        var productList = cmp.get("v.productList");
        console.log('productList '+JSON.stringify(productList));
        if(productList != null && productList != undefined && productList != ''){
            var mandateOfficial = cmp.get("v.mandateOfficial");
            if(mandateOfficial == 'NEW OFFICIALS'){
                var firstName = cmp.find("firstNameExAcc").get("v.value");
                var LastName = cmp.find("LastNameExAcc").get("v.value");
                var idNumber = cmp.find("idNumberExAcc").get("v.value");
                if(firstName != null && firstName != undefined && firstName !='' &&
                   LastName != null && LastName != undefined && LastName !='' &&
                   idNumber != null && idNumber != undefined && idNumber !=''){
                    var formToSave = cmp.find("productContactRelationship");
                    formToSave.submit();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Please fill all required fields."
                    });
                    toastEvent.fire();
                }
            }else{
                var formToSave = cmp.find("productContactRelationship");
                formToSave.submit();
            }
            cmp.set("v.isFromSaveAndNew",false);
            
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "Please add the product."
            });
            toastEvent.fire();
        }
        
    },*/
	handleClickClient: function (cmp, event, helper) {
		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef: "c:AccountWizardComponent",
			componentAttributes: {}
		});
		evt.fire();
	},
	/*handleSaveAndNewProductContactRelatiosnhip: function(cmp, event, helper) {
        event.preventDefault();
        var productList = cmp.get("v.productList");
        console.log('productList '+JSON.stringify(productList));
        if(productList != null && productList != undefined && productList != ''){
        cmp.set("v.isFromSaveAndNew",true);
            //var formToSave = cmp.find("productContactRelationship");
            //formToSave.submit();
            var mandateOfficial = cmp.get("v.mandateOfficial");
            if(mandateOfficial == 'NEW OFFICIALS'){
                var firstName = cmp.find("firstNameExAcc").get("v.value");
                var LastName = cmp.find("LastNameExAcc").get("v.value");
                var idNumber = cmp.find("idNumberExAcc").get("v.value");
                if(firstName != null && firstName != undefined && firstName !='' &&
                   LastName != null && LastName != undefined && LastName !='' &&
                   idNumber != null && idNumber != undefined && idNumber !=''){
                    var formToSave = cmp.find("productContactRelationship");
                    formToSave.submit();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Please fill all required fields."
                    });
                    toastEvent.fire();
                }
            }else{
                var formToSave = cmp.find("productContactRelationship");
                formToSave.submit();
            }
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "Please add the product."
            });
            toastEvent.fire();
        }
        
    },*/

	//Saurabh Adding Handler for applicationEvent
	handleApplicationEvent: function (component, event, helper) {
		//var sourceComponent = event.getParam("sourceComponent");
		var opportunityProductId = event.getParam("opportunityProductId");
		console.log("within the application event handler");
		// Condition to not handle self raised event
		if (opportunityProductId != null && opportunityProductId != "") {
			//calling Init on App Event
			var a = component.get("c.doInit");
			$A.enqueueAction(a);
		}
	},
	duplicateStatOption: function (component, event, helper) {
		var selectedRadioOption = component.find("duplicateStatementsId");
		var isDuplicateStatementVal = selectedRadioOption.get("v.value");

		if (isDuplicateStatementVal === "Y") {
			component.set("v.showTextIfYes", true);
		} else {
			component.set("v.showTextIfYes", false);
		}
	},
	//Changes Start for W-004995 by Chandra dated 12/06/2020
	handleRedirectFeesChange: function (component, event, helper) {
		var redirectFees = component.find("redirectFees");
		var redirectFeesValue = redirectFees.get("v.value");
		component.set("v.reDirectFeesChecked", redirectFeesValue);
		if (redirectFeesValue == true) {
			component.find("redirectFees").set("v.value", true);
		}
	},
	// changes for W-005030 : Gopi On 16/6/2020
	generateAccActivty: function (component, event, helper) {
		var var1 = component.get("v.application.Expected_number_of_credits_per_month__c");
		var var2 = component.get("v.application.Rand_value_of_credits_per_month__c");
		var var3 = component.get("v.application.Credits_received_via__c");
		var var4 = component.get("v.application.Where_will_the_credits_be_coming_from__c");
		var var5 = component.get("v.application.Number_of_staff_members__c");
		var var6 = component.get("v.application.Payment_date_of_staff__c");
		var var7 = component.get("v.application.Number_of_debits_per_month__c");
		var var8 = component.get("v.application.Number_of_supplier_payments_per_month__c");
		var var9 = component.get("v.application.Where_are_the_suppliers_located__c");
		var var10 = component.get("v.application.Rand_value_of_debits_per_month__c");
		var var11 = component.get("v.application.Reason_for_debit_orders__c");

		var actCalculator = "";
		var isProductAvail = component.get("v.isProductAvail");
		if (isProductAvail) {
			actCalculator =
				"IT IS EXPECTED THAT THERE WILL BE " +
				var1 +
				" number of CREDITS INTO THE ACCOUNT EACH MONTH to the value of " +
				var2 +
				". THE CREDITS WILL BE RECEIVED VIA " +
				var3 +
				" AND WILL COME FROM " +
				var4 +
				".";
		} else {
			actCalculator =
				"IT IS EXPECTED THAT THERE WILL BE CREDITS INTO THE ACCOUNT EACH MONTH.THE CREDITS WILL BE RECEIVED VIA " +
				var3 +
				" AND WILL COME FROM " +
				var4 +
				". IN TERMS OF DEBITS, THERE WILL BE FOR THE FOLLOWING REASONS " +
				var11 +
				". PAYMENTS OUT OF THE ACCOUNT TO SUPPLIERS / SERVICE PROVIDERS IN " +
				var9 +
				".";
		}
		component.find("accActTracker").set("v.value", actCalculator);
		component.set("v.showAccCalculator", false);
	},

	//Added by diksha for W-5029
	showPurposeOfAcctText: function (component, event, helper) {
		var purposeOfAcc = component.find("purposeOfAcc").get("v.value");
		console.log(purposeOfAcc);
		if (purposeOfAcc == "CURRENT / CHEQUE / SAVINGS - INDIVIDUAL ACCOUNT") {
			component.find("purposeOfAcctText").set("v.value", "THIS ACCOUNT IS GOING TO BE USED FOR THE DAY TO DAY RUNNING OF THE INDIVIDUAL AFFAIRS");
		} else if (purposeOfAcc == "CURRENT / CHEQUE / SAVINGS - PRIMARY BUSINESS ACCOUNT") {
			component.find("purposeOfAcctText").set("v.value", "THIS ACCOUNT IS GOING TO BE USED FOR THE DAY TO DAY RUNNING OF THE CLIENTS BUSINESS.");
		} else if (purposeOfAcc == "CURRENT / CHEQUE / SAVINGS - SECONDARY BUSINESS ACCOUNT") {
			component.find("purposeOfAcctText").set("v.value", "CURRENT / CHEQUE / SAVINGS - SECONDARY BUSINESS A");
		} else if (purposeOfAcc == "INVESTMENT") {
			component
				.find("purposeOfAcctText")
				.set("v.value", "THIS ACCOUNT IS GOING TO BE USED TO HOUSE SURPLICE FUNDS THE CLIENT MIGHT HAVE FROM TIME TO TIME.");
		} else if (purposeOfAcc == "VANILLA LENDING - CARD, CAF ETC") {
			component.find("purposeOfAcctText").set("v.value", "APPARENT FROM ACCOUNT TYPE AS PER THE METHODOLOGY PAGES 294 TO 296");
		}
		//added by Manish for W-007828
		else if (purposeOfAcc == "OTHER") {
			component.find("purposeOfAcctText").set("v.value", "");
		}
	},

	//TdB - W-005328 : Add additional fields for Deposit Book Required
	onchangeDepositBookRequired: function (component, event, helper) {
		if (event.getSource().get("v.value") == true) {
			component.set("v.showDepositBookFields", true);
		} else {
			component.set("v.showDepositBookFields", false);
		}
	},

	// Lesibe - W-005411 2020-11-27: Add more cheque sub producdts :
	onchangePriceScheme: function (component, event, helper) {
		helper.productPriceScheme(component, event, helper);
	},

	showTransferFields: function (component, event, helper) {
		var transferVal = component.find("isThereAnyTPFTP").get("v.value");
		console.log("transferVal :" + transferVal);
		if (transferVal == "Yes") {
			component.set("v.transferShowFields", true);
		} else {
			component.set("v.transferShowFields", false);
		}
	},
	handleROAChange: function (component, event, helper) {
		if (
			component.find("currentSituation").get("v.value") != undefined &&
			component.find("currentSituation").get("v.value") != "" &&
			component.find("financialProdExp").get("v.value") != undefined &&
			component.find("financialProdExp").get("v.value") != "" &&
			component.find("needsOrObjectives").get("v.value") != undefined &&
			component.find("needsOrObjectives").get("v.value") != ""
		) {
			component.set("v.showSubSectionB", false);
		} else {
			component.set("v.showSubSectionB", true);
		}

		if (component.find("partiallyOrFullyReplace").get("v.value") == "Yes" || component.find("haveInvestementorInvestedComponent").get("v.value") == "Yes") {
			component.set("v.showYesNoNASeciton", true);
		} else {
			component.set("v.showYesNoNASeciton", false);
		}

		if (component.find("partiallyOrFullyReplace").get("v.value") == "Yes") {
			component.set("v.showSectionD", true);
		} else {
			component.set("v.showSectionD", false);
		}

		if (component.get("v.replacementProduct") == "Yes") {
			component.set("v.showSectionDTable", true);
		} else {
			component.set("v.showSectionDTable", false);
		}
	},
	handleSaveEdition: function (component, event, helper) {
		var sectionCTabledata = component.get("v.sectionCTabledata");
		var draftValues = event.getParam("draftValues");
		sectionCTabledata.forEach((data) => {
			draftValues.forEach((draft) => {
				if (data.id == draft.id) {
					if (draft.achiveFfinancialObjectives != undefined) {
						data.achiveFfinancialObjectives = draft.achiveFfinancialObjectives;
					}
					if (draft.reommendedNotRecommended != undefined) {
						data.reommendedNotRecommended = draft.reommendedNotRecommended;
					}
					if (draft.reason != undefined) {
						data.reason = draft.reason;
					}
				}
			});
		});
		component.set("v.sectionCTabledata", sectionCTabledata);
		component.set("v.draftValues", []);
	},
	handleSectionDSave: function (component, event, helper) {
		var sectionDTabledata = component.get("v.sectionDTabledata");
		var sectionDdraftValues = event.getParam("draftValues");
		sectionDTabledata.forEach((data) => {
			sectionDdraftValues.forEach((draft) => {
				if (data.id == draft.id) {
					if (draft.existingProduct != undefined) {
						data.existingProduct = draft.existingProduct;
					}
					if (draft.newlyProposedPorduct) {
						data.newlyProposedPorduct = draft.newlyProposedPorduct;
					}
				}
			});
		});
		component.set("v.sectionDTabledata", sectionDTabledata);
		component.set("v.sectionDdraftValues", []);
	},
    
	saveROAF: function (component, event, helper) {
		event.preventDefault(); // to avoid standard lds submission event
		var confirmationOFRecCompletion =
			component.get("v.confirmationOFRecCompletion") != null ? JSON.stringify(component.get("v.confirmationOFRecCompletion")) : "";
		var sectionCTabledata = JSON.stringify(component.get("v.sectionCTabledata"));
		var sectionDTabledata = JSON.stringify(component.get("v.sectionDTabledata"));
		var generalNotes = component.get("v.generalNotes");
		var fields = event.getParam("fields");
		fields["Confirmation_of_Record_Completion__c"] = confirmationOFRecCompletion;
		fields["ROA_SectionC_Table_Value__c"] = sectionCTabledata;
		fields["ROA_SectionD_Table_Value__c"] = sectionDTabledata;
		fields["General_Notes__c"] = generalNotes;
		fields["Advice_Given__c"] = component.find("adviceGivenGroup").get("v.value");
		fields["Client_Under_Supervision__c"] = component.find("underSuperVisionGroup").get("v.value");
		component.find("roaForm4").submit(fields);
		helper.saveROA(component, event, helper);
	},
	addBanker: function (component, event, helper) {
		var confirmationOFRecCompletion = component.get("v.confirmationOFRecCompletion") == null ? [] : component.get("v.confirmationOFRecCompletion");
		confirmationOFRecCompletion.push({
			banker: "",
			sectionsCompleted: "",
			additionalComments: ""
		});
		component.set("v.confirmationOFRecCompletion", confirmationOFRecCompletion);
	},
	removeRow: function (component, event, helper) {
		var confirmationOFRecCompletion = component.get("v.confirmationOFRecCompletion");
		var selectedItem = event.currentTarget;
		var index = selectedItem.dataset.record;
		confirmationOFRecCompletion.splice(index, 1);
		component.set("v.confirmationOFRecCompletion", confirmationOFRecCompletion);
	},
	cardDelivery: function (component, event, helper) {
		var debitCardField = component.find("debitCard");
		var debitCardValue = debitCardField.get("v.value");

		//Set attribute to display button
		component.set("v.showDebitCard", debitCardValue);

		if (debitCardValue == true) {
		
			// Find the component whose aura:id is "flowData"
			var flow = component.find("cardOrdering");
			// In that component, start your flow. Reference the flow's API Name.
			flow.startFlow("Sales_Card_Delivery");

			component.find("iNotifyMe").set("v.value", false);
			component.set("v.showNotifyMe", false);

			component.find("iInternetBanking").set("v.value", false);
			component.set("v.showInternetBanking", false);
		}
	},
	//Added by chandra dated 26/07/2021
	handleRecordUpdated: function(component, event, helper) {
		var eventParams = event.getParams();
		if(eventParams.changeType === "LOADED") {
			component.set("v.processType",component.get("v.opportunityRecord2.Process_Type__c"));
		} else if(eventParams.changeType === "CHANGED") {
			// record is changed
		} else if(eventParams.changeType === "REMOVED") {
			// record is deleted
		} else if(eventParams.changeType === "ERROR") {
			// there’s an error while loading, saving, or deleting the record
		}
	},
});
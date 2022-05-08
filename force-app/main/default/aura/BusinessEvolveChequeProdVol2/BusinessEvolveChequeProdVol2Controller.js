({
	doInit: function (component, event, helper) {
		component.set("v.showSpinner", true);
		helper.showSelectedProduct(component, event, helper);
		helper.getAppId(component, event, helper);
		var oppproduct = component.get("v.SelectedProduct");
		console.log("oppproduct1" + oppproduct);
		if (oppproduct != null && oppproduct != "") {
			helper.fetchRelatedParty(component);
			//Show pricing schemes of Selected Product : W-004843 : Anka Ganta : 2020-07-14
			helper.showPricingSchemes(component, event, helper);
			var selectedScheme = component.get("v.selectedScheme");
			helper.fetchQuestionnaireRecordlist(component, event, helper);

			component.set("v.acctname", oppproduct.Name);
			var action = component.get("c.getApplicationProductsV2");
			action.setParams({ oppId: component.get("v.recordId"), oppLineId: oppproduct.Id });

			action.setCallback(this, function (data) {
				component.set("v.productList", data.getReturnValue());

				var showacct = data.getReturnValue()[0];
				var ExecutionLayerRequestID__c = showacct.Opportunity.ExecutionLayerRequestID__c;

				if (ExecutionLayerRequestID__c == "" || ExecutionLayerRequestID__c == "null") {
					component.set("v.showROA", "Yes");
				}

				// added for opp lin items -products
				var selectedproduct = component.get("v.SelectedProduct");
				console.log("  ##########  DO init selectedproduct --" + JSON.stringify(selectedproduct));

				if (selectedproduct.Product_Family__c == "Cheque") {
					console.log("  ##########  Inside cheque ");

					var policyNo = selectedproduct.Policy_Number__c;
					console.log("  ##########  policyNo " + policyNo);

					if (policyNo != 0 || policyNo == null || policyNo == undefined) {
						component.set("v.isHide", false);
					}
					if (!$A.util.isUndefinedOrNull(policyNo)) {
						component.set("v.isHide", true);
					}

					// if(policyNo!= null ||policyNo!='' || policyNo!= 'undefined' ||  !$A.util.isUndefinedOrNull(policyNo)  ){
					if (!$A.util.isUndefinedOrNull(selectedproduct.Policy_Number__c)) {
						console.log(" ######################### Inside Policy Not null");
						helper.selectOpportunity(component, event, helper);
						component.set("v.policynumber", selectedproduct.Policy_Number__c);
					}
				} else if (selectedproduct.Product_Family__c == "Savings") {
					console.log("  ##########  Inside Savings ");

					var policyNo = selectedproduct.Policy_Number__c;
					console.log("  ##########  policyNo " + policyNo);

					if (policyNo != 0 || policyNo == null || policyNo == undefined) {
						component.set("v.isHide", false);
					}
					if (!$A.util.isUndefinedOrNull(policyNo)) {
						component.set("v.isHide", true);
					}

					// if(policyNo!= null ||policyNo!='' || policyNo!= 'undefined' ||  !$A.util.isUndefinedOrNull(policyNo)  ){
					if (!$A.util.isUndefinedOrNull(selectedproduct.Policy_Number__c)) {
						console.log(" ######################### Inside Policy Not null");
						helper.selectOpportunity(component, event, helper);
						component.set("v.policynumber", selectedproduct.Policy_Number__c);
					}
				}
				/*var policynoNull;
                for(var i=0; i < showacct.length; i++){
                    var policyNo = showacct[i].Policy_Number__c;
                     console.log(" policyNo -- "+'i' + JSON.stringify(policyNo));
                     var oppStageName = showacct[i].Opportunity.StageName;
                    
                }
            	
                 if($A.util.isUndefinedOrNull(showacct.Policy_Number__c)){  //temp removed
                   console.log('selected product ' + component.get("v.SelectedProduct"));   
                    console.log('########## POLICY NUMBER  Null ########');
                }
                
                var policyNo = showacct.Policy_Number__c;
                console.log(" policyNo -- " + JSON.stringify(policyNo));
                var oppStageName = showacct.Opportunity.StageName;
               
                if((oppStageName == 'Completed' || oppStageName == 'Closed') && (policyNo != 0 || policyNo == null || policyNo == undefined))  
                {
                    component.set('v.isHide', false); 
                }
                if((oppStageName == 'Completed'  || oppStageName == 'Closed') &&  !$A.util.isUndefinedOrNull(policyNo)  )
                {
                    component.set('v.isHide', true); 
                }
                
                if(showacct.Policy_Number__c!=null || showacct.Policy_Number__c!='' || showacct.Policy_Number__c!= undefined ){
                    console.log(' ######################### Inside Policy Not null');
                    helper.selectOpportunity(component, event, helper);
                    component.set('v.policynumber',showacct.Policy_Number__c);
                    
                } 
                */
				//hide cheque section if product family is savings
				var productFamily = selectedproduct.Product_Family__c;

				console.log("##########   DO init - productFamily" + productFamily);

				if (productFamily == "Cheque") {
					component.set("v.productFamily", "Cheque");
					component.set("v.showSpecialistInfo", "No");
					component.set("v.showSavingsAccountGen", "No");
					component.set("v.showCNA", "Yes");
					component.set("v.showROA", "Yes");
					component.set("v.NoNewDebitCard", false);
				}
			});
			$A.enqueueAction(action);

			// Call helper for Product Usage
			helper.loadProductData(component, event, helper);
			//Call helper for Logged in User Details
			helper.getUserDetails(component, event, helper);
			//Added by diksha for W-5029
			var purposeOfAcc = component.find("purposeOfAcc").get("v.value");
			console.log(purposeOfAcc);
			if (purposeOfAcc == "CURRENT / CHEQUE / SAVINGS - PRIMARY BUSINESS ACCOUNT") {
				component.find("purposeOfAcctText").set("v.value", "THIS ACCOUNT IS GOING TO BE USED FOR THE DAY TO DAY RUNNING OF THE CLIENTS BUSINESS.");
			}
            //15225 : added this function
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
				
			});

			$A.enqueueAction(getAccountByOppId);

			//Get application Record
			var getApplicationAction = component.get("c.getApplicationRecord"); // 14960 -Anka new changes
			//var getApplicationAction = component.get("c.getApplicationProductRecord");

			getApplicationAction.setParams({
				opportunityId: component.get("v.recordId")
			});

			// Add callback behavior for when response is received
			getApplicationAction.setCallback(this, function (response) {
				component.set("v.showSpinner", false);
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
			$A.enqueueAction(getApplicationAction);
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
		var underSupervision = component.get("v.underSupervision");
		if (underSupervision == "Y") {
			component.set("v.underSupervision", "Y");
			//component.set("v.isUnderSupervision", true);
		}
	},
	isAdviceGiven: function (component, event, helper) {
		var adviseGiven = component.get("v.adviseGiven");
		if (adviseGiven == "Y") {
			component.set("v.adviseGiven", "Y");
			component.set("v.isAdviceGiven", true);
		} else {
			component.set("v.adviseGiven", "N");
			component.set("v.isAdviceGiven", true);
		}
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
	replacingProduct: function (component, event, helper) {
		var isReplacingProduct = component.get("v.isReplacingProduct");

		if (isReplacingProduct == "Y") {
			component.set("v.isReplacingProduct", "Y");
			component.set("v.isDuplicateStatement", true);
		} else {
			component.set("v.isReplacingProduct", "N");
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
		var isClosedOpportunity = component.get("v.opportunityRecord.IsClosed");
		if (isClosedOpportunity) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				type: "error",
				title: "Error!",
				message: "You are not allowed to update application record as it is associated with closed opportunity"
			});
			toastEvent.fire();
		} else {
			var iPriceNegotiationField = component.find("iPriceNegotiation");
			var iPriceNegotiationValue = iPriceNegotiationField.get("v.value");

			//Set attribute to display button
			component.set("v.showProductTermsBtn", iPriceNegotiationValue);
		}
	},

	showNewNotifyMe: function (component, event, helper) {
		var iNotifyMeField = component.find("iNotifyMe");
		var iNotifyMeValue = iNotifyMeField.get("v.value");

		//Set attribute to display button
		component.set("v.showNotifyMe", iNotifyMeValue);
		var componentFamily = component.get("v.componentFamily");

		if (iNotifyMeValue) {
			component.find("ieStatement").set("v.value", false);
			component.set("v.showeStatementPanel", false);

			if (componentFamily == "Cheque") {
				component.find("debitCard").set("v.value", false);
				component.set("v.showDebitCard", false);
			}
		}
	},

	showNewInternetBanking: function (component, event, helper) {
		var iInternetBankingField = component.find("iInternetBanking");
		var iInternetBankingValue = iInternetBankingField.get("v.value");

		//Set attribute to display button
		component.set("v.showInternetBanking", iInternetBankingValue);
	},

	showEstatement: function (component, event, helper) {
		var ieStatementField = component.find("ieStatement");
		var ieStatementValue = ieStatementField.get("v.value");

		//Set attribute to display button
		component.set("v.showeStatementPanel", ieStatementValue);
		var componentFamily = component.get("v.componentFamily");

		if (ieStatementValue) {
			component.find("iNotifyMe").set("v.value", false);
			component.set("v.showNotifyMe", false);

			if (componentFamily == "Cheque") {
				component.find("debitCard").set("v.value", false);
				component.set("v.showDebitCard", false);
			}
		}
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
		var isClosedOpportunity = component.get("v.opportunityRecord.IsClosed");
		if (isClosedOpportunity) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				type: "error",
				title: "Error!",
				message: "You are not allowed to update application record as it is associated with closed opportunity"
			});
			toastEvent.fire();
		} else {
			var iTermsAndConditionsField = component.find("iTermsAndConditions");
			var iTermsAndConditionsValue = iTermsAndConditionsField.get("v.value");
			var caseId = component.get("v.opportunityRecord.Case__c");
			var qaApprovalStatus = component.get("v.opportunityRecord.QA_Complex_Approval_Status__c");
			var complexApproval = component.get("v.opportunityRecord.Complex_Application__c");
			console.log("caseId " + caseId);
			console.log("qaApprovalStatus " + qaApprovalStatus);

			//  if(caseId!=null && qaApprovalStatus!='Approved'){
			//     var toastEvent = $A.get("e.force:showToast");
			//    toastEvent.setParams({
			//      "type": "error",
			//       "title": "Error!",
			//       "message": "Please ensure that this application has received QA approval before accepting terms."
			//   });
			//    toastEvent.fire();

			//  }
			//Added by Masechaba Maseli for W-005222
			//  else if(complexApproval==true && qaApprovalStatus!='Approved'){
			//     var toastEvent = $A.get("e.force:showToast");
			//     toastEvent.setParams({
			//         "type": "error",
			//        "title": "Error!",
			//        "message": "This is a complex application, please submit it for approval before accepting terms."
			//    });
			//   toastEvent.fire();

			// }
			//  else{

			//Set attribute to display button
			component.set("v.showTermsAndConditionsBtn", iTermsAndConditionsValue);

			//  }
		}
	},

	showCompletefulfilmentBtn: function (component, event, helper) {
		var isClosedOpportunity = component.get("v.opportunityRecord.IsClosed");
		if (isClosedOpportunity) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				type: "error",
				title: "Error!",
				message: "You are not allowed to update application record as it is associated with closed opportunity"
			});
			toastEvent.fire();
		} else {
			// var productList = component.get("v.productList");
			//var productFamily = productList.Product_Family__c;
			var oppproduct = component.get("v.SelectedProduct");
			var productFamily = oppproduct.Product_Family__c;
			console.log("productFamily" + JSON.stringify(productFamily));
			var completefulfilmentField = component.find("completefulfimentid");
			var completefulfilmentValue = completefulfilmentField.get("v.value");

			var purposeOfAcc = component.find("purposeOfAcc").get("v.value");
			// var accActTracker= component.get("v.application.Account_Activity_Calculator__c");
			var accActTracker = component.find("accActTracker").get("v.value");

			/*var deliveryMethod= component.find("deliveryMethod").get("v.value");
        var sourceOfFunds = component.find("sourceOfFunds").get("v.value");
		var accrualDayOfMonth= component.find("accrualDayOfMonth").get("v.value");
		var capitilisationDayOfWeek= component.find("capitilisationDayOfWeek").get("v.value");
		var capitilisationDayOfMonth= component.find("capitilisationDayOfMonth").get("v.value");
		var accrualDayOfWeek= component.find("accrualDayOfWeek").get("v.value");*/

			if (productFamily == "Cheque") {
				if (purposeOfAcc != null && accActTracker != null) {
					//Set attribute to display button
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
			} else if (productFamily === "SAVINGS" || productFamily === "Savings") {
				{
					// FOr SAVING - Liquidity Plus
					console.log("Inside SAVINGS showCompletefulfilmentBtn");
					if (purposeOfAcc != null && accActTracker != null) {
						component.set("v.isHide", false);
						//Set attribute to display button
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
				}
			}
		}
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
		// component.find("accForm").submit();
		console.log(" +++++++++ -=-=-= Selected product oppProduct" + JSON.stringify(oppproduct));
		/* var action = component.get("c.getApplicationProductsV2");  
        action.setParams({
            oppId: component.get("v.recordId"),
            oppLineId : oppproduct.Id
        });
        action.setCallback(this, function(data){
            component.set("v.productList",data.getReturnValue());
            
            var showacct= data.getReturnValue();
            console.log("acceptProductTerms productList ---: " + JSON.stringify(showacct));
            
            
            
            */
		var productFamily = oppproduct.Product_Family__c;

		console.log("+++++ product family ---" + productFamily);
		//var chargedatenum = component.find("chargeCapDate").get("v.value");

		if (productFamily === "Cheque") {
			console.log("INSIDE IF product family>>>---" + productFamily);
			helper.updateApplication(component, event, helper);
			helper.updateOpportunityLineItem(component, event, helper);
			//addded new to cheque only by Himanshu
			//helper.updateROAInformation(component, event, helper);
		} else if (productFamily === "SAVINGS" || productFamily === "Savings") {
			console.log("INSIDE IF product family>>>---" + productFamily);
			helper.getsavingsaccdetails(component, event, helper);
			//helper.updateSavings(component, event, helper);//W-14960 : Anka new changes
		} else {
		}
		//Need to check for saving and cheque
		helper.updateROAInfo(component, event, helper);
		helper.saveAppRecord(component, event, helper);
		//   helper.openSignatureModal(component, event, helper);

		//});
		//  $A.enqueueAction(action);
	},
	updateAndSaveApplication: function (component, event, helper) {
		//helper.updateNotifyMe(component, event,helper);
		//var isNotifyMe = ;
		// W-008562
		/*var isClosedOpportunity = component.get("v.opportunityRecord.IsClosed");
        if(isClosedOpportunity){
            helper.closedOpportunityValidation(component,event, helper);
        }else{*/
		if (component.get("v.showNotifyMe")) {
			console.log("showNotifyMe");
			helper.updateNotifyMe(component, event, helper);
		}

		if (component.get("v.showInternetBanking")) {
			helper.updateInternetBanking(component, event, helper);
			console.log("showInternetBanking");
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
	// changes for W-005030 : Gopi On 16/6/2020 : w-14960 Anka new changes
	generateAccActivty: function (component, event, helper) {
		var var1 = component.get("v.applicationProduct.Expected_number_of_credits_per_month__c");
		var var2 = component.get("v.applicationProduct.Rand_value_of_credits_per_month__c");
		var var3 = component.get("v.applicationProduct.Credits_received_via__c");
		var var4 = component.get("v.applicationProduct.Where_will_the_credits_be_coming_from__c");
		var var5 = component.get("v.applicationProduct.Number_of_staff_members__c");
		var var6 = component.get("v.applicationProduct.Payment_date_of_staff__c");
		var var7 = component.get("v.applicationProduct.Number_of_debits_per_month__c");
		var var8 = component.get("v.applicationProduct.Number_of_supplier_payments_per_month__c");
		var var9 = component.get("v.applicationProduct.Where_are_the_suppliers_located__c");
		var var10 = component.get("v.applicationProduct.Rand_value_of_debits_per_month__c");
		var var11 = component.get("v.applicationProduct.Reason_for_debit_orders__c");
		var actCalculator =
			"IT IS EXPECTED THAT THERE WILL BE CREDITS INTO THE ACCOUNT EACH MONTH.THE CREDITS WILL BE RECEIVED VIA " +
			var3 +
			" AND WILL COME FROM " +
			var4 +
			". IN TERMS OF DEBITS, THERE WILL BE FOR THE FOLLOWING REASONS " +
			var11 +
			". PAYMENTS OUT OF THE ACCOUNT TO SUPPLIERS / SERVICE PROVIDERS IN " +
			var9 +
			".";
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
			component.find("purposeOfAcctText").set("v.value", "");
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

	/* W-005411 - Anka Ganta-2020-08-11: Based on subProduct, populated price schemes
    and send priceSchemeCode to cheque service*/
	onchangePriceScheme: function (component, event, helper) {
		var selScheme = component.get("v.selectedScheme");
		component.set("v.selectedScheme", selScheme);
		console.log("selectedScheme+++" + selScheme);
	},

	updateAndSaveEstatement: function (component, event, helper) {
		//W-008562
		/*var isClosedOpportunity = component.get("v.opportunityRecord.IsClosed");
        if(isClosedOpportunity){
            helper.closedOpportunityValidation(component,event, helper);
          }else{*/
		var err = 0;
		var msg = "";
		component.set("v.hideSpinner", false);

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
		if (numberOfDaysLength > 3) {
			err++;
			msg += "Enter less than 4 charactors e.g 03,21\n";
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
	onPicklistChange: function (component, event, helper) {
		component.set("v.showeSaveBtnCaseManagement", "true");
	},

	onSuccess: function (component, event, helper) {
		// W-008562
		/*var isClosedOpportunity = component.get("v.opportunityRecord.IsClosed");
        if(isClosedOpportunity){
           helper.closedOpportunityValidation(component,event, helper);
        }else{*/
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			type: "success",
			message: "The record has been updated successfully."
		});
		toastEvent.fire();
		component.set("v.showeSaveBtnCaseManagement", false);
		// }
	},
	getAppData: function (component, event, helper) {
		if (component.get("v.roaLoaded") != true) {
			helper.loadProductData(component, event, helper);
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
					if (draft.newlyProposedPorduct != undefined) {
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
	}
});
/****************@ Author: Chandra********************************
 ****************@ Date: 22/11/2019********************************
 ****************@ Description: Method to get user detail*********/
({
	saveRiskInfoValidation: function (component, event, helper) {
		this.showSpinner(component);
		var recordtypename = component.get("v.opportunityRecord.RecordType.Name");
		console.log("recordtypename" + recordtypename);
		if (recordtypename == "SPM Onboarding") {
			this.saveRiskInfoforSPM(component, event, helper);
		} else if (recordtypename == "CAF Application") {
			console.log("In If");
			this.saveRiskInfoCAF(component, event, helper);
		} else {
			console.log("In else");
			var action = component.get("c.getOpportunityProduct");
			action.setParams({
				oppId: component.get("v.recordId")
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var response = response.getReturnValue();
					if (response != "undefined") {
						component.set("v.product", response);
						this.saveRiskInfo(component, event, helper);
					} else {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							type: "error",
							title: "",
							message: "Please select product to proceed Risk Profiling"
						});
						toastEvent.fire();
					}
				}
			});
			// enqueue the Action
			$A.enqueueAction(action);
		}
		this.hideSpinner(component);
	},

	/****************@ Author: Anka Ganta********************************
	 ****************@ Date: 20/01/2020********************************
	 ****************@ Description: Account and RelatedPartyDetails*********/
	getAccountDetails: function (component) {
		var oppId = component.get("v.recordId");
		var action = component.get("c.getAccountData");
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				//this.showSpinner(component);
				component.set("v.account", response.getReturnValue());
				component.set("v.accountRecord", response.getReturnValue());
				component.set("v.selectedIdType", component.get("v.account.ID_Type__pc"));
				component.set("v.selectedClientType", component.get("v.account.Client_Type__c"));
				component.set("v.selectedNationality", component.get("v.account.Nationality__pc"));
				component.set("v.selectedCountryResidence", component.get("v.account.Country_of_Residence__pc"));
				component.set("v.selectedCountryBirth", component.get("v.account.Country_of_Birth__pc"));
				component.set("v.selectedCountryRegistration", component.get("v.account.Country_of_Registration__c"));
				component.set("v.accountRecordType", component.get("v.account.RecordType.Name"));
				component.set("v.accRecordId", component.get("v.account.Id"));

				if (component.get("v.accountRecordType") == "Business Client" || component.get("v.accountRecordType") == "Business Prospect") {
					component.set("v.accountName", component.get("v.account.Name"));
				} else {
					component.set("v.accountName", component.get("v.account.FirstName") + " " + component.get("v.account.LastName"));
				}

				console.log("accountName in helper.Account: " + component.get("v.accountName"));

				//Call to get Opportunity details
				//Get logged in User details
				var getOpportunityAction = component.get("c.getOpportunityData");

				getOpportunityAction.setParams({
					oppId: component.get("v.recordId")
				});

				// Add callback behavior for when response is received
				getOpportunityAction.setCallback(this, function (response) {
					var message;

					var state = response.getState();

					if (component.isValid() && state === "SUCCESS") {
						var oppDetails = response.getReturnValue();

						//Set Opportunit Casa Fields
						if (oppDetails != null) {
							console.log("oppDetails : " + oppDetails.CASA_Status__c);
							console.log("oppDetails : " + oppDetails.CASA_Reference_Number__c);
							console.log("oppDetails : " + oppDetails.CASA_Screening_Date__c);
							console.log("oppDetails : " + oppDetails.CASA_Screening_Status_Value__c);
							console.log("oppDetails : " + oppDetails.Risk_Rating_Date__c);
							console.log("oppDetails : " + oppDetails.Risk_Rating__c);
							//console.log('oppDetails : ' + oppDetails.Case__c);
							console.log("accountName : " + component.get("v.accountName"));
							component.set("v.opportunityRecord", oppDetails);

							//Show Casa results if any
							if (
								oppDetails.CASA_Reference_Number__c != null &&
								oppDetails.CASA_Reference_Number__c != 0 &&
								oppDetails.CASA_Reference_Number__c != ""
							) {
								component.set("v.showFinishedScreen", true);
								component.set("v.activeCasaSections", "casaScreeningResults");
								console.log("activeCasaSections : " + component.get("v.activeCasaSections"));
							}

							//Show Risk fields if any
							if (oppDetails.Risk_Rating__c != null) {
								//Set Risk Data from Opportunity
								var dataTable = [];
								var riskRatingValues = {
									accName: component.get("v.accountName"),
									riskRating: oppDetails.Risk_Rating__c,
									screeningDate: $A.localizationService.formatDate(oppDetails.Risk_Rating_Date__c, "yyyy-MM-dd")
								};

								dataTable.push(riskRatingValues);
								component.set("v.docList", dataTable);

								//Show Risk result Table
								component.set("v.activeRiskSections", "RiskRatingResults");
								console.log("activeRiskSections : " + component.get("v.activeRiskSections"));
								var cmpTarget = component.find("resultsDiv");
								$A.util.removeClass(cmpTarget, "slds-hide");

								component.set("v.showGenerateCIFButton", true);
							}

							//Get Participant details
							var action2 = component.get("c.getPartcicpantAccountData");
							action2.setParams({
								oppId: component.get("v.recordId")
							});

							action2.setCallback(this, function (response) {
								var state = response.getState();
								if (state == "SUCCESS") {
									console.log(" participantAccountList " + JSON.stringify(response.getReturnValue()));
									component.set("v.participantAccountList", response.getReturnValue());
								} else {
									console.log("Failed with state: " + state);
								}
							});
							$A.enqueueAction(action2);
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

						var toast = this.getToast("Error", message, "error");

						toast.fire();

						this.hideSpinner(component);
					}
				});

				// Send action off to be executed
				$A.enqueueAction(getOpportunityAction);
			} else {
				console.log("Failed with state: " + state);
				// this.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Anka Ganta********************************
	 ****************@ Date: 27/02/2020********************************
	 ****************@ Description: Method to call Risk Profiling Service****/
	saveRiskInfo: function (component, event, helper) {
		this.showSpinner(component);

		if (component.get("v.accountRecordType") == "Business Client" || component.get("v.accountRecordType") == "Business Prospect") {
			component.set("v.accountName", component.get("v.accountRecord.Name"));
		} else {
			component.set("v.accountName", component.get("v.accountRecord.FirstName") + " " + component.get("v.accountRecord.LastName"));
		}

		//var product= component.find("customerImports").get("v.value")
		var action = component.get("c.saveRikInfo");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
				var accName = component.get("v.accountName");
				var casaRisk = response.getReturnValue();
				console.log("value at 283" + casaRisk);

				var resp = JSON.parse(response.getReturnValue());
				var resultObject = resp.WQriskProfileClientV7Response;

				if (resultObject != null && resultObject.msgNo == "200") {
					component.set("v.respObject", resultObject);
					component.set("v.showRiskResults", true);
					component.set("v.activeRiskSections", "RiskRatingResults");
					component.set("v.showGenerateCIFButton", true);

					var resList = [];
					resList.push(resultObject);

					resList.forEach(function (element) {
						element.accName = accName;
						element.screeningDate = today;
					});

					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type: "success",
						title: "Risk Rating Complete",
						message: "Risk Profiling Completed Succesfully!"
					});
					toastEvent.fire();

					component.set("v.docList", resList);
					var cmpTarget = component.find("resultsDiv");
					$A.util.removeClass(cmpTarget, "slds-hide");
				} else {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type: "error",
						title: "Risk Rating Error",
						message: resultObject.msg
					});
					toastEvent.fire();

					component.set("v.showGenerateCIFButton", false);
					component.set("v.showRiskResults", false);
					var cmpTarget = component.find("resultsDiv");
					$A.util.addClass(cmpTarget, "slds-hide");
				}
			} else if (state === "ERROR") {
				var message;
				var errors = response.getError();

				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "",
					message: errors[0].message
				});
				toastEvent.fire();
			} else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "",
					message: "UnKnown error occured Please contact Administrator"
				});
				toastEvent.fire();
			}
			$A.get("e.force:refreshView").fire();
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},
	/****************@ Author: Haritha Police********************************
	 ****************@ Date: 15/09/2020********************************
	 ****************@ Description: Method to call Risk Profiling Service for SPM****/
	saveRiskInfoforSPM: function (component, event, helper) {
		this.showSpinner(component);

		if (component.get("v.accountRecordType") == "Business Client" || component.get("v.accountRecordType") == "Business Prospect") {
			component.set("v.accountName", component.get("v.accountRecord.Name"));
		} else {
			component.set("v.accountName", component.get("v.accountRecord.FirstName") + " " + component.get("v.accountRecord.LastName"));
		}

		//var product= component.find("customerImports").get("v.value")
		var action = component.get("c.saveRikInfoforSPM");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				$A.get("e.force:refreshView").fire();
				var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
				var accName = component.get("v.accountName");
				var casaRisk = response.getReturnValue();
				console.log("value at 283" + casaRisk);

				var resp = JSON.parse(response.getReturnValue());
				var resultObject = resp.WQriskProfileClientV7Response;

				if (resultObject != null && resultObject.msgNo == "200") {
					component.set("v.respObject", resultObject);
					component.set("v.showRiskResults", true);
					component.set("v.activeRiskSections", "RiskRatingResults");

					var resList = [];
					resList.push(resultObject);

					resList.forEach(function (element) {
						element.accName = accName;
						element.screeningDate = today;
					});

					component.set("v.docList", resList);
					var cmpTarget = component.find("resultsDiv");
					$A.util.removeClass(cmpTarget, "slds-hide");
				} else {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type: "error",
						title: "Risk Rating Error",
						message: resultObject.msg
					});
					toastEvent.fire();

					component.set("v.showRiskResults", false);
					var cmpTarget = component.find("resultsDiv");
					$A.util.addClass(cmpTarget, "slds-hide");
				}
			} else if (state === "ERROR") {
				var message;
				var errors = response.getError();

				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "",
					message: errors[0].message
				});
				toastEvent.fire();
			} else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "",
					message: "UnKnown error occured Please contact Administrator"
				});
				toastEvent.fire();
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	// function automatic called by aura:waiting event
	showSpinner: function (component, event, helper) {
		// remove slds-hide class from mySpinner
		var spinner = component.find("mySpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	// function automatic called by aura:doneWaiting event
	hideSpinner: function (component, event, helper) {
		// add slds-hide class from mySpinner
		var spinner = component.find("mySpinner");
		$A.util.addClass(spinner, "slds-hide");
	},
	// W-006880 -Anka Ganta - 2020-10-26
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},
	//Start changes for W-004683 By Himani

	getEntitytype: function (component, event, helper) {
		var action = component.get("c.getentitytype");
		action.setParams({
			opportunityId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responsevalue1 = response.getReturnValue();
				component.set("v.entitytype", responsevalue1);
				var entitytype = component.get("v.entitytype");
				console.log("entitytype" + entitytype);
				for (var i in entitytype) {
					console.log("entityvalue" + entitytype[i].Entity_Type__c);
					component.set("v.entitytypestring", entitytype[i].Entity_Type__c);
				}

				this.DocumentUpload(component);
			} else {
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	DocumentUpload: function (component, event, helper) {
		var action = component.get("c.getDocs");
		action.setParams({
			opportunityId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responsevalue1 = response.getReturnValue();
				component.set("v.documentsUploaded", responsevalue1);
				this.getMandatoryDocs(component);
				this.getRelMandatoryDocs(component);
			} else {
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	getMandatoryDocs: function (component) {
		var Entitytype = component.get("v.entitytypestring");
		var OppId = component.get("v.recordId");
		console.log("Entitytype" + Entitytype);
		var action = component.get("c.getAllMandatoryDocuments");
		action.setParams({
			Entitytype: Entitytype
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responsevalue = response.getReturnValue();
				console.log("responsevalue" + responsevalue);
				component.set("v.Mandatorydocuments", responsevalue);

				//var dataAudit=component.get("v.dataAudit");
				//console.log("dataAudit"+dataAudit);
				var Mandatorydocuments = component.get("v.Mandatorydocuments");
				var documentsUploaded = component.get("v.documentsUploaded");

				console.log("v.Mandatorydocuments" + Mandatorydocuments);
				console.log("v.documentsUploaded" + documentsUploaded);
				var DocFlag;
				var checkFlag;
				var nonMandFlag = "F";
				for (var i in Mandatorydocuments) {
					DocFlag = "F";
					for (var j in documentsUploaded) {
						console.log("Mandatorydocuments[i].ECM_Type__c" + Mandatorydocuments[i].ECM_Type__c);
						console.log("documentsUploaded[j]" + documentsUploaded[j]);
						if (documentsUploaded[j] === Mandatorydocuments[i].ECM_Type__c) {
							DocFlag = "T";
						}
					}
					if (DocFlag === "F") {
						console.log("bb");
						nonMandFlag = "T";
						//    this.setOpportunityVal(component, event, true);
					}
				}

				if (nonMandFlag === "T") {
					console.log("no mand docs available");
					this.setOpportunityVal(component, event, true);
				} else {
					console.log("mand docs available");
					this.setOpportunityVal(component, event, false);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	getRelMandatoryDocs: function (component) {
		var Entitytype = component.get("v.entitytypestring");
		var OppId = component.get("v.recordId");
		var documentsUploaded = component.get("v.documentsUploaded");
		console.log("documentsUploaded" + documentsUploaded);
		console.log("Entitytype" + Entitytype);
		console.log("OppId" + OppId);

		var action = component.get("c.getAllRelatedMandatoryDocuments");
		action.setParams({
			Entitytype: Entitytype,
			OppId: OppId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responsevalue = response.getReturnValue();
				console.log("responsevalue" + responsevalue);

				component.set("v.relatedPartyManDocs", responsevalue);

				console.log("relaPartyManDocs+++" + component.get("v.relatedPartyManDocs"));
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				}
			}
		});
		$A.enqueueAction(action);
	},

	setOpportunityVal: function (component, event, checkFlag) {
		console.log("checkFlag++" + checkFlag);
		var recordId = component.get("v.recordId");
		var action = component.get("c.updateOpportunity");
		action.setParams({
			recordId: recordId,
			docFlag: checkFlag
		});
		action.setCallback(this, function (data) {
			var response = data.getReturnValue();
		});
		$A.enqueueAction(action);
	},

	//End changes for W-004683 By Himani
	// W-005715 : Anka Ganta : 2020-08-18
	// if Related party status is not 'Approved' Stop user to do Risk Profiling and make relPartyInvalidStatusFlag is true
	CheckRelatedPartyCasaStatus: function (component, event, helper) {
		var oppId = component.get("v.recordId");
		var action = component.get("c.CheckRelatedPartyCasaStatus");
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			//var response = data.getReturnValue();
			console.log("relPartyInvalidStatusFlag 1++" + component.get("v.relPartyInvalidStatusFlag"));
			//debugger;
			component.set("v.relPartyInvalidStatusFlag", response.getReturnValue());
			console.log("relPartyInvalidStatusFlag 2++" + component.get("v.relPartyInvalidStatusFlag"));
		});
		$A.enqueueAction(action);
	},
	/****************@ Author: Masechaba Maseli********************************
	 ****************@ Date: 26/01/2021********************************
	 ****************@ Description: Method to call Risk Profiling Service for CAF****/
	saveRiskInfoCAF: function (component, event, helper) {
		this.showSpinner(component);

		if (component.get("v.accountRecordType") == "Business Client" || component.get("v.accountRecordType") == "Business Prospect") {
			component.set("v.accountName", component.get("v.accountRecord.Name"));
		} else {
			component.set("v.accountName", component.get("v.accountRecord.FirstName") + " " + component.get("v.accountRecord.LastName"));
		}

		//var product= component.find("customerImports").get("v.value")
		var action = component.get("c.saveCAFRikInfo");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
				var accName = component.get("v.accountName");
				var casaRisk = response.getReturnValue();
				console.log("value at 283" + casaRisk);

				var resp = JSON.parse(response.getReturnValue());
				var resultObject = resp.WQriskProfileClientV7Response;

				if (resultObject != null && resultObject.msgNo == "200") {
					component.set("v.respObject", resultObject);
					component.set("v.showRiskResults", true);
					component.set("v.activeRiskSections", "RiskRatingResults");
					component.set("v.showGenerateCIFButton", true);

					var resList = [];
					resList.push(resultObject);

					resList.forEach(function (element) {
						element.accName = accName;
						element.screeningDate = today;
					});

					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type: "success",
						title: "Risk Rating Complete",
						message: "Risk Profiling Completed Succesfully!"
					});
					toastEvent.fire();

					component.set("v.docList", resList);
					var cmpTarget = component.find("resultsDiv");
					$A.util.removeClass(cmpTarget, "slds-hide");
				} else {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type: "error",
						title: "Risk Rating Error",
						message: resultObject.msg
					});
					toastEvent.fire();

					component.set("v.showGenerateCIFButton", false);
					component.set("v.showRiskResults", false);
					var cmpTarget = component.find("resultsDiv");
					$A.util.addClass(cmpTarget, "slds-hide");
				}
			} else if (state === "ERROR") {
				var message;
				var errors = response.getError();

				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "",
					message: errors[0].message
				});
				toastEvent.fire();
			} else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "",
					message: "UnKnown error occured Please contact Administrator"
				});
				toastEvent.fire();
			}
			$A.get("e.force:refreshView").fire();
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},
	// To Route the case to EDD if the banker checks the Checkbox W-013710 by Mohammed
    createEDDCase : function(component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.createEDDCaseReason");		
        action.setParams({
            "oppId": component.get("v.recordId"),
            "Subject": component.get("v.reasonForEDD")
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {		
                var response = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "",
                    "message": "The Case is Routed to EDD"
                });
                toastEvent.fire();
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "",
                    "message": "Failed to Route the Case to EDD Please contact Administrator"
                });
                toastEvent.fire();
            }
            
            $A.get('e.force:refreshView').fire();
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    //W-013710 End
});
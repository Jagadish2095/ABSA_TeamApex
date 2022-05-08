({
	getQnA: function (component) {
		this.showSpinner(component);
		var action = component.get("c.getQuesAndAnsList"); //get all question and answers
		action.setParams({
			accountId: component.get("v.accountId") // accountId to get SA Identity number
		});

		// Add callback behavior for when response is received
		action.setCallback(this, function (response) {
			var state = response.getState();
            console.log(`getQnA State: ${state}`);
			if (component.isValid() && state === "SUCCESS") {
				var responseBean1 = JSON.parse(response.getReturnValue());

                console.log(`errors : ${JSON.stringify(responseBean1.errorList)}`);


				if (responseBean1.message != null && responseBean1.message != "") {
					//check error message  from service
					component.set("v.xdsDecision", false);
					component.set("v.isShowError", true);
					component.set("v.xdsMessage", responseBean1.message);
                } else if (responseBean1.errorList && responseBean1.errorList.length > 0) {
					component.set("v.xdsDecision", false);
					component.set("v.isShowError", true);
					component.set("v.xdsMessage", responseBean1.errorList[0].field);
				} else if (responseBean1.StatusCode == 500) {
					// error in service calling/or service is not up
					component.set("v.xdsDecision", false);
					component.set("v.isShowError", true);
					component.set("v.xdsMessage", responseBean1.Message);
                    component.set("v.showDHA", true);//Added by chandra dated 21/01/2022
                    component.set("v.showPDF", true);//Added by chandra dated 21/01/2022
                    component.set("v.showDHAQNA", true);//Added by chandra dated 21/01/2022
				} else if (responseBean1.isUserBlocked == true) {
					// is user is blocked
					component.set("v.xdsDecision", false);
					component.set("v.isShowError", true);
					component.set("v.xdsMessage", "something went wrong user is blocked.");
				} else {

					//component.set("v.xdsDecision",true);
					component.set("v.isShowError", false);
                    console.log("showVerifyButton : false");

					// Display in modal or not responseBeanForModal. W-015254. Hloni Matsoso 28/01/2022
					var recordId = component.get("v.recordId");
					if(recordId == null || recordId == undefined)
					{
						component.set("v.displayQuestionsInAModal", false);
						component.set("v.responseBean", responseBean1);
						//component.set("v.displayQuestionsInAModal", null);


					}else{
						component.set("v.displayQuestionsInAModal", true);
						component.set("v.responseBeanForModal", responseBean1);
						component.set("v.responseBean", null);
					}
					if (responseBean1.authenticationDocument.questions != null) {
						component.set("v.showVerifyButton", false);
						component.set("v.isQuestionsShow", true);
					}else{
                        console.log("showVerifyButton : TRUE: Qs blank");
                    }

				
				}
			}else{
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }

                console.log(`getQnA errors: ${JSON.stringify(errors)}`);
                component.set("v.isShowError", true);
                component.set("v.xdsMessage", `Something went wrong: ${JSON.stringify(errors)}`);
            }
	
			this.hideSpinner(component);
            console.log(`DONE`);

		});
		$A.enqueueAction(action);
	},

	setAnswers: function (component, event, helper) {
		var requestBeanForVerification = component.get("v.requestBeanForVerification");
		var isSendAnswer;
		var questNoAnswered;
        var recordId = component.get("v.recordId");


		if (requestBeanForVerification != null) {
			// validations to check if all questions are answered
			for (var i = 0; i < requestBeanForVerification.authenticationDocument.questions.questionDocument.length; i++) {
				var quest = requestBeanForVerification.authenticationDocument.questions.questionDocument[i];
				var flag;
				for (var j = 0; j < quest.answers.answerDocument.length; j++) {
					var ans = quest.answers.answerDocument[j];
					if (ans.isEnteredAnswerYN) {
						flag = ans.isEnteredAnswerYN;
						break;
					} else {
						flag = ans.isEnteredAnswerYN;
					}
				}
				if (flag) {
					isSendAnswer = true;

					continue;
				} else {
					isSendAnswer = false;
					questNoAnswered = JSON.stringify(quest.question);
					break;
				}
			}
			if (!isSendAnswer) {
				this.fireToast("Error", "Please select answer for Question: " + questNoAnswered, "error");
			} else {
				this.showSpinner(component);
				requestBeanForVerification.processAction = "Authenticate"; // add authenticate
				delete requestBeanForVerification.StatusCode; // delete extra param from payload
				delete requestBeanForVerification.StatusMessage;
				delete requestBeanForVerification.Message;
				delete requestBeanForVerification.enquiryid;
				delete requestBeanForVerification.enquiryresultid;

				var action = component.get("c.verifyClient");
				action.setParams({
					requestBeanForVerificationString: JSON.stringify(requestBeanForVerification) // send answer to xds system back
				});
				// Add callback behavior for when response is received
				action.setCallback(this, function (response) {
					var state = response.getState();

					if (component.isValid() && state === "SUCCESS") {
						var result = JSON.parse(response.getReturnValue());
						if (result.authenticated) {
							// xds decision

							component.set("v.xdsDecision", true);
							component.set("v.isShowError", false);
							component.set("v.showAuthenticated", true);
							component.set("v.showVerifyButton", true);
							component.set("v.xdsMessage", "User authenticated! Please click Next button continue.");
                    		component.set("v.showDHA", true);//Added by chandra dated 21/01/2022
                    		component.set("v.showPDF", true);//Added by chandra dated 21/01/2022
                    		component.set("v.showDHAQNA", false);//Added by chandra dated 21/01/2022

							//Code added by chandra to set cache object dated 30/03/2021
							helper.setSessionCache(component, event, helper);
						} else {
							component.set("v.invalidAttemptsCount", 1);
							component.set("v.xdsDecision", false);
							component.set("v.isShowError", true);
							component.set("v.showVerifyButton", true);

							component.set("v.xdsMessage", "Reloading questions. Error: " + result.message);
                            console.error(`Submit Error: ${JSON.stringify(result.message)}`);
		                    this.showSpinner(component);
                            helper.getQnA(component);
						}

						// Raise XDS Result event. Handled by ClientDnvIndicator. W-015254. 27-01-2022. Hloni Matsoso.
						helper.raiseXdsResultEvent(recordId, result.authenticated);
					}
					this.hideSpinner(component);
					component.set("v.isSubmittingAnswers", false);

				});
				component.set("v.isSubmittingAnswers", true);
				$A.enqueueAction(action);

			}
		} else {
			this.fireToast("Error", "Please select answer for Questions", "error");
		}
	},

	getAccountNameHelper: function (component, event, helper) {
		this.showSpinner(component);
		var action = component.get("c.getAccountName");
		action.setParams({
			accountId: component.get("v.accountId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.accountName", response.getReturnValue());
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	getAccountProductsHelper: function (component, event, helper) {
		this.showSpinner(component);
		var getAccountProducts = component.get("c.getAccountProducts");
		getAccountProducts.setParams({
			accountId: component.get("v.accountId")
		});
		getAccountProducts.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();

				// if storeResponse size is equal 0 ,display No Result Found... message on screen.
				if (storeResponse.length == 0) {
					this.fireToast("Error", "No Result Found...Please try again !!!", "error");
				} else {
					storeResponse.sort();
					component.set("v.listOfSearchRecords", storeResponse);
				}
				// set searchResult list with return value from server.
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(getAccountProducts);
	},

	getGeneralPAHelper: function (component, event, helper) {
		this.showSpinner(component);
		var getGeneralPA = component.get("c.getGeneralPA");
		getGeneralPA.setParams({
			accountnumber: component.get("v.selectedAccountNumber")
		});
		getGeneralPA.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				if (result.statusCode == 200) {
					if (result.CIgetGeneralPowerOfAttorneyV4Response.nbsmsgo3.msgEntry[0].msgErrInd == "E") {
						this.fireToast(
							"Error",
							"General Power of Attorney : " + result.CIgetGeneralPowerOfAttorneyV4Response.nbsmsgo3.msgEntry[0].msgTxt,
							"error"
						);
					} else {
						var responsefinaltable = result.CIgetGeneralPowerOfAttorneyV4Response.cip081do.outputTable;
						responsefinaltable.PAType = "General Power of Attorney";
						responsefinaltable.customer = component.get("v.accountName");
						component.set("v.generalPAList", responsefinaltable);
						var data = component.get("v.data");
						data.push(responsefinaltable);
						component.set("v.data", data);
					}
				} else {
					this.fireToast("Error", "General Power of Attorney : " + result.StatusMessage, "error");
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(getGeneralPA);
	},

	getSpecialPAHelper: function (component, event, helper) {
		this.showSpinner(component);
		var getSpecialPA = component.get("c.getSpecialPA");
		getSpecialPA.setParams({
			accountnumber: component.get("v.selectedAccountNumber")
		});
		getSpecialPA.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				if (result.statusCode == 200) {
					if (result.CIgetSpecialPowerOfAttorneyV4Response.nbsmsgo3.msgEntry.msgErrInd == "E") {
						this.fireToast(
							"Error",
							"Special Power of Attorney : " + result.CIgetSpecialPowerOfAttorneyV4Response.nbsmsgo3.msgEntry.msgTxt,
							"error"
						);
					} else {
						var responsefinaltable = result.CIgetSpecialPowerOfAttorneyV4Response.cip080do.outputTable;
						responsefinaltable.PAType = "Special Power of Attorney";
						responsefinaltable.customer = component.get("v.accountName");
						component.set("v.specialPAList", responsefinaltable);
						var data = component.get("v.data");
						data.push(responsefinaltable);
						component.set("v.data", data);
					}
				} else {
					this.fireToast("Error", "Special Power of Attorney : " + result.StatusMessage, "error");
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(getSpecialPA);
	},

	getQuestionsHelper: function (component, event, helper) {
		component.set("v.isQuestionsShow", false);
		this.showSpinner(component);
		var getQuestions = component.get("c.getQuestions");
		getQuestions.setParams({
			accountNumber: component.get("v.selectedRows")[0].idNbr,
			surname: component.get("v.selectedRows")[0].surname
			//accountNumber : "5702270227081", surname : "SWART"
		});
		getQuestions.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				if (result.StatusCode == 200) {
					if (result.errorMessage != "" && result.errorMessage != undefined) {
						component.set("v.xdsDecision", false);
						this.fireToast("Error", result.errorMessage, "error");
					} else {
						component.set("v.questionResponse", result);
						component.set("v.isQuestionsShow", true);
						console.log("isQuestionsShow: " + component.get("isQuestionsShow"));
						//component.set("v.xdsDecision",true);
					}
				} else {
					component.set("v.xdsDecision", false);
					this.fireToast("Error", result.StatusMessage, "error");
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(getQuestions);
	},

	submitAnswersHelper: function (component, event, helper) {
		var requestBeanForVerification = component.get("v.questionResponse");
		var isSendAnswer;
		var questNoAnswered;

		if (requestBeanForVerification != null) {
			// validations to check if all questions are answered
			for (var i = 0; i < requestBeanForVerification.questions.questionDocument.length; i++) {
				var quest = requestBeanForVerification.questions.questionDocument[i];
				var flag;
				for (var j = 0; j < quest.answers.answerDocument.length; j++) {
					var ans = quest.answers.answerDocument[j];
					if (ans.isEnteredAnswerYN) {
						flag = ans.isEnteredAnswerYN;
						break;
					} else {
						flag = ans.isEnteredAnswerYN;
					}
				}
				if (flag) {
					isSendAnswer = true;

					continue;
				} else {
					isSendAnswer = false;
					questNoAnswered = JSON.stringify(quest.question);
					break;
				}
			}
			if (!isSendAnswer) {
				this.fireToast("Error", "Please select answer for Question: " + questNoAnswered, "error");
			} else {
				this.showSpinner(component);
				requestBeanForVerification.processAction = "Authenticate"; // add authenticate
				delete requestBeanForVerification.StatusCode; // delete extra param from payload
				delete requestBeanForVerification.StatusMessage;
				delete requestBeanForVerification.Message;
				delete requestBeanForVerification.enquiryid;
				delete requestBeanForVerification.enquiryresultid;

				var action = component.get("c.verifyClient");
				action.setParams({
					requestBeanForVerificationString: JSON.stringify(requestBeanForVerification) // send answer to xds system back
				});
				// Add callback behavior for when response is received
				action.setCallback(this, function (response) {
					var state = response.getState();
					if (component.isValid() && state === "SUCCESS") {
						var result = response.getReturnValue();
						if (result.authStatus == "Successful") {
							this.fireToast("Success", "User authenticated! Please click Next button continue.", "success");
							component.set("v.isQuestionsShow", false);
							component.set("v.xdsDecision", true);

							//Code added by chandra to set cache object dated 18/03/2021
							helper.setSessionCache(component, event, helper);
						} else {
							component.set("v.xdsDecision", false);
							this.fireToast("Error", result.message + " : " + result.errorMessage, "error");
						}
					}
					this.hideSpinner(component);
				});
				$A.enqueueAction(action);
			}
		} else {
			this.fireToast("Error", "Please select answer for Questions", "error");
		}
	},

	/****************@ Author: Chandra*********************************************
	 ****************@ Date: 18/03/2021********************************************
	 ****************@ Work Id: W-010280*******************************************
	 ***@ Description: Method Added by chandra to get session Cache***************/
	iDnVPollingHelper: function (component, event, helper) {
		console.log(`iDnVPollingHelper starting...`);
		var action = component.get("c.getSessionCacheValues");
		action.setParams({
			cifCode: component.get("v.cifCode")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var responseVal = response.getReturnValue();
				component.set("v.clientIDnVObject", responseVal);
				if (responseVal != null) {
					if (responseVal.matched && responseVal.verified && responseVal.identified) {
						component.set("v.isAuthenticated", true);
					}
				}
				helper.checkXDSApplicability(component, event, helper);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in iDnVPollingHelper method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in iDnVPollingHelper method. State: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra************************************************
	 ****************@ Date: 18/03/2021***********************************************
	 ****************@ Work Id: W-010280**********************************************
	 ***@ Description: Method Added by chandra to navigate to Next Step***************/
	navigateToNext: function (component, event, helper, authenticationType) {
		component.set("v.xdsDecision", true);
		helper.fireToast("Success", "Client Authenticated - Authentication Type(s): " + authenticationType, "success");
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	/****************@ Author: Chandra************************************************
	 ****************@ Date: 18/03/2021***********************************************
	 ****************@ Work Id: W-010280**********************************************
	 ***@ Description: Method Added by chandra to set Session Cache******************/
	setSessionCache: function (component, event, helper) {
		var action = component.get("c.setSessionCacheValues");
		action.setParams({
			cifCode: component.get("v.cifCode")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.isAuthenticated", true);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in setSessionCache method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in setSessionCache method. State: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra************************************************
	 ****************@ Date: 18/03/2021***********************************************
	 ****************@ Work Id: W-010280**********************************************
	 ***@ Description: Method Added by chandra to Check XDS Applicability******************/
	checkXDSApplicability: function (component, event, helper) {
		let serviceGroup,
			clientIDnVObject,
			isVerified,
			isMatched,
			isIdentified,
			authenticationType,
			isAuthenticated,
			serviceType,
			serviceGroupsXDSNotApplicableString,
			serviceGroupsXDSNotApplicableList,
			lPinServiceTypeString,
			lPinServiceTypeList,
			ePinServiceTypeString,
			ePinServiceTypeList;

		serviceGroup = component.get("v.serviceGroup");
		clientIDnVObject = component.get("v.clientIDnVObject");
		isAuthenticated = component.get("v.isAuthenticated");
		serviceType = component.get("v.serviceType");
		serviceGroupsXDSNotApplicableString = $A.get("$Label.c.Service_Groups_XDS_Not_Applicable");
		serviceGroupsXDSNotApplicableList = serviceGroupsXDSNotApplicableString.split(";");

        console.log(`checkXDSApplicability: serviceGroupsXDSNotApplicableList : ${JSON.stringify(serviceGroupsXDSNotApplicableList)}`);

		if (clientIDnVObject != null) {
			isVerified = clientIDnVObject.verified;
			isMatched = clientIDnVObject.matched;
			isIdentified = clientIDnVObject.identified;
			authenticationType = clientIDnVObject.authenticationType;
		}

		if (!serviceGroupsXDSNotApplicableList.includes(serviceGroup) && isAuthenticated) {
			component.set("v.showXDS", false);
			helper.navigateToNext(component, event, helper, authenticationType);
		} else if (!serviceGroupsXDSNotApplicableList.includes(serviceGroup) && !isAuthenticated) {
			component.set("v.showXDS", true);
		} else if (serviceGroupsXDSNotApplicableList.includes(serviceGroup)) {
			component.set("v.showXDS", false);
			if (!isIdentified) {
				component.set("v.errorMessage", "The client could not be identified. Cannot proceed with the job.");
			} else if (!isVerified) {
				component.set("v.errorMessage", "The client could not be verified. Cannot proceed with the job.");
			} else if (!isMatched) {
				component.set("v.errorMessage", "Client CIF mismatched. Cannot proceed with the job.");
			} else if (isAuthenticated) {
				var serviceTypeList = [];
				authenticationType.forEach(function (dataItem) {
					if (dataItem == "L_PIN") {
						lPinServiceTypeString = $A.get("$Label.c.Service_Types_Allowed_For_L_PIN");
						lPinServiceTypeList = lPinServiceTypeString.split(";");
						serviceTypeList.push(...lPinServiceTypeList);
					} else if (dataItem == "E_PIN") {
						ePinServiceTypeString = $A.get("$Label.c.Service_Types_Allowed_For_E_PIN");
						ePinServiceTypeList = ePinServiceTypeString.split(";");
						serviceTypeList.push(...ePinServiceTypeList);
					}
				});
				if (!serviceTypeList.includes(serviceType)) {
					component.set("v.errorMessage", "You are not allowed to perform this job for this authentication type.");
				} else {
					helper.navigateToNext(component, event, helper, authenticationType);
				}
			}
		}
	},

	//Show lightning spinner
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	//Hide lightning spinner
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},

	//Lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});

		toastEvent.fire();
	},

	raiseXdsResultEvent: function (recordId, result) {
        var XDSResult = $A.get("e.c:XDSResultEvent");

		if(recordId == null || recordId == undefined){
			// If not placed on Account record
		}else{
			// Only when placed on Account record, for credit card onboarding
			if(XDSResult == null){
				console.warn('WHY IS XDSResult event NULL ???');
			}else{
				XDSResult.setParams({ "isAuthenticated" : result
									, "recordId" : recordId });
				XDSResult.fire();
				console.log('XDS Results raised: ' + result);
			}
		}
    }
});
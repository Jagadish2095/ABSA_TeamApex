({
	StovelcasaScreening: function (component, event, helper) {
		helper.showSpinner(component);
	
		var AccountID = component.get("v.accountRecId");
		console.log("AccountID: " + AccountID);
		// var action = component.get("c.stokvelPrimaryCASAScreening");
		var action = component.get("c.callScreening");

		action.setParams({
			accountID: AccountID
		});
		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			helper.hideSpinner(component);

			var screenRespObj = JSON.parse(response.getReturnValue());
			console.log("CASA Response: " + JSON.stringify(screenRespObj));
			if (state == "SUCCESS") {
				if (screenRespObj != null && screenRespObj.statusCode == 200) {
					if (screenRespObj.msgNo == "0" && screenRespObj.refNo != null && screenRespObj.refNo != "0") {
						helper.showSpinner(component);
						var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");

						//Update Account
						component.find("iCASAScreenStatus").set("v.value", screenRespObj.casaStatus);
						component.find("iCASAScreenDate").set("v.value", today);
						component.find("iCASARefNumber").set("v.value", screenRespObj.refNo);
						component.find("iValidUpdateBypass").set("v.value",true);
						console.log("val7 " + component.find("iValidUpdateBypass").get("v.value"));
						component.find("recordStokEditForm").submit();
						console.log("val8 " + component.find("iValidUpdateBypass").get("v.value"));
					} else {
						//Error
						console.log("Error on MsgNo or refNo: " + JSON.stringify(screenRespObj));
						component.set("v.errorMessage", "StovelcasaScreening Error, Response: " + JSON.stringify(screenRespObj));
						helper.fireToast("Error", "An error occurred during CASA Screening. ", "error");
					}
				} else {
					//Error
					console.log("StovelcasaScreening Error, Response: " + JSON.stringify(screenRespObj));
					component.set("v.errorMessage", "StovelcasaScreening Error, Response: " + JSON.stringify(screenRespObj));
					helper.fireToast("Error", "An error occurred during CASA Screening. ", "error");
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
						component.set("v.errorMessage", "stokvelcasaScreening Apex error: " + JSON.stringify(errors));
				helper.fireToast("Error", "stokvelcasaScreening Apex error: " + JSON.stringify(errors), "error");
			} else {
				component.set("v.errorMessage", "stokvelcasaScreening Unexpected error occurred, state returned: " + state);
				helper.fireToast("Error", "stokvelcasaScreening Unexpected error occurred, state returned: " + state, "error");
			}
		});
		$A.enqueueAction(action);
	},

    saveContactInfo: function (component, event, helper) 
    {
        return new Promise(function (resolve, reject) {
            const globalId = component.getGlobalId();
            helper.showSpinner(component);       
            component.find("iValidUpdateBypass").set("v.value", true);
            document.getElementById(globalId + "_contact_submit").click();
            helper.hideSpinner(component);
            resolve("success");
        });
     },
    
	//Get Account Record Type
	getRecordTypeId: function (component) {
		var action = component.get("c.getRecordTypeId");
		console.debug("recordtypeid 1 " + action);
		action.setParams({
			developerName: "IndustriesBusiness",
			sobjectName: "Account"
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var recordTypeId = response.getReturnValue();
				component.set("v.recordTypeId", recordTypeId);
			} else if (state === "ERROR") {
				var errors = response.getError();
				console.log("getRecordTypeId Error: " + JSON.stringify(errors));
				component.set("v.errorMessage", "getRecordTypeId Error: " + JSON.stringify(errors));
			} else {
				console.log("getRecordTypeId Unexpected error occurred, state returned: " + state);
				component.set("v.errorMessage", "getRecordTypeId Unexpected error occurred, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	ScreenRelatedParties: function (component, helper) {
		return new Promise(function (resolve, reject) {
			debugger;
			helper.showSpinner(component);
			var accountRecId = "0015r00000AhPkxAAF";
			var casaref = "121230299";
			//        alert(' accid ' + component.get("v.accountRecId"));
			//  console.log("ScreenRelatedParties helper now with promise casa: " + component.get("v.casareferencenumber"));
			var action = component.get("c.screenstokvelRelatedParties");
			action.setParams({
				accountId: accountRecId,
				casaRefNumber: casaref
			});
			debugger;
			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var resp = response.getReturnValue();
				var screenRespObj = response.getReturnValue();

				console.log("response ScreenRelatedParties: " + screenRespObj);
				if (state == "SUCCESS" && screenRespObj == "SUCCESS") {
					helper.showSpinner(component);
					debugger;

					console.log("response ScreenRelatedParties: " + screenRespObj);
					helper.hideSpinner(component);
					resolve("success");
				} else if (screenRespObj === "ERROR") {
					var errors = response.getError();
					helper.fireToast("Error", "An error occurred on ScreenRelatedParties. ", "error");
					console.log("ScreenRelatedParties Apex error: " + errors);
					reject("error while trying to screen related parties " + errors);
				} else {
					console.log("ScreenRelatedParties Unexpected error occurred, state returned: " + state);
					helper.fireToast("Error", "An error occurred on ScreenRelatedParties. ", "error");
					reject("screen related parties error ");
				}
			});
			$A.enqueueAction(action);
		});
	},

	/*   
   StovelRiskProfiling: function (component, helper) {
        helper.showSpinner(component);
        var  accountRecId = '0015r00000AhPkxAAF';
      //  var  productCode = component.get("v.productCode");
        var  productCode = "DPL0950100";
      alert('productCode ' + productCode);
      debugger;
      var action = component.get("c.attempEntityRiskProfiling");       
        action.setParams({
                "accountId" : accountRecId,
                "productCode" : productCode
        });
        // set a callBack
        action.setCallback(this, function(response) {
            var state = response.getState();
            //helper.hideSpinner(component);
    debugger;
            var screenRespObj = JSON.parse(response.getReturnValue());
        //   alert('screenRespObj' + screenRespObj.body.CIB003O.CIcreateClientV22Response.outputClientKey);
            if(state == "SUCCESS"){
                if(screenRespObj != null && screenRespObj.statusCode == 200){
                  console.log("StovelRiskProfiling: SUCCESS " + screenRespObj.riskRating);             
                    if(screenRespObj.msgNo == '200' && screenRespObj.riskRating != null && screenRespObj.riskRating != '')
                    {    
                       helper.hideSpinner(component); //hide the spinner
                       helper.fireToast('Success', 'The entity  has been successfully RISK PROFILED.', 'success');
                       console.log("handleSuccess  Riskprofiled succesfully");
                    }
                }else{
                    helper.hideSpinner(component); //hide the spinner
                       helper.fireToast('Error', 'The entity  was an error while trying to  RISK PROFILE the entity.', 'error');
                       console.log("The entity  was an error while trying to  RISK PROFILE the entity" + screenRespObj);

                  }
            }else if(state === "ERROR"){
                var errors = response.getError();
                console.log("stokvel risk profiling1 Apex error: " + errors);
               
                helper.hideSpinner(component); //hide the spinner
                helper.fireToast('Error', 'The entity  was an error while trying to  RISK PROFILE the entity.', errors);
                console.log("The entity  was an error while trying to  RISK PROFILE the entity" + errors);

            }else{
                console.log("stokvel risk profiling Unexpected error occurred, state returned: " + state);
                helper.hideSpinner(component); //hide the spinner
                helper.fireToast('Error', 'stokvel risk profiling Unexpected error occurred, state returned.', 'state');
                console.log("The entity  was an error while trying to  RISK PROFILE the entity" + state);
            }
        });
        $A.enqueueAction(action);
    },
   */

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
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
	fetchTranslationValues: function (component, listName, systemName, valueType, direction, objName, objField) {
		var action = component.get("c.getTranslationValues");
		var objObject = { sobjectType: objName }
		action.setParams({
			systemName: systemName,
			valueType: valueType,
			direction: direction,

			objObject: objObject,

			objField: objField
		});

		action.setCallback(this, function (response) {
			var mapValues = response.getReturnValue();

			var listValues = [];
 
			for (var itemValue in mapValues) {
				if (/*mapValues[itemValue] == "valid" &&*/ itemValue != "Post" && itemValue != "Mail" ) {
					listValues.push(itemValue);
				} else {
					// Add function to log/mail system admin with missing values
				}
			}

			listValues.sort();

			component.set(listName, listValues);

		});

		$A.enqueueAction(action);
	},

	validateEntityInformation : function(component) {
		let numberError = this.validateNumberOfEmployees(component);
		if (numberError) {
			return numberError;
		}
		let languageError = this.validatelanguage(component);
		if (languageError) {
			return languageError;
		}
		let communicationMethodError =  this.validatelanguage(component);
		if (communicationMethodError) {
			return communicationMethodError;
		}

		let cellPhoneError =  this.validateCellPhone(component);
		if (cellPhoneError) {
			return cellPhoneError;
		}

		let emailError =  this.validateEmail(component);
		return emailError;
	},

	validateNumberOfEmployees : function (component) {
		const numberOfEmployeesError = "Forecast of Members is required"
		const numberOfEmployeesComponent = component.find("iNumberOfEmployees");
		const numberOfEmployees = numberOfEmployeesComponent.get("v.value");

		if (numberOfEmployees == null || !numberOfEmployees)  {
			numberOfEmployeesComponent.reportValidity();
			return numberOfEmployeesError;
		}
	},


	validateCellPhone : function(component) {
		const cellphoneIsEmptyError = "Cellphone Number is required";
		const cellphoneInvalidError = "Cellphone number can not be invalid";
		const cellPhoneComponent = component.find("iPersonOtherPhone");
		const cellPhoneNumber = cellPhoneComponent.get("v.value");
		let errorMessage = cellPhoneNumber == null || !cellPhoneNumber ? cellphoneIsEmptyError : (
			!this.validateByRegionPhone(cellPhoneNumber) ? cellphoneInvalidError : null);

		if (errorMessage) {
			cellPhoneComponent.reportValidity();
		}
		return errorMessage
	},
	validatelanguage : function (component) {
		const languageError = "Communication Language is required"
		const languageComponent = component.find("CommunicationLanguage");
		const languageEmployees = languageComponent.get("v.value");

		if (languageEmployees == "" || !languageEmployees)  {
			languageComponent.checkValidity();
			return languageError;
		}
	},
	validateCommunicationMethod : function (component) {
		const methodComponent = component.find("PreferredCommunicationMethod");
		const methodName = methodComponent.get("v.value");
		const communicationMethodError = "Preferred communication Channel is required";
		const smsMethodErrorEnding = " if Preferred method of communication is SMS";
		const emailMethodErrorEnding = " if Preferred method of communication is Email";

		if (methodName === "" || !methodName) {
			methodComponent.checkValidity();
			return communicationMethodError;
		}

		if (methodName === "Phone") {
			return this.validateAlternatePhone(component);
		}

		if (methodName === "SMS") {
			let cellphoneError = this.validateCellPhone(component);
			return  cellphoneError ? cellphoneError + smsMethodErrorEnding : null;
		}

		if (methodName === "Email") {
			let emailError = this.validateEmail(component);
			return  emailError ? emailError + emailMethodErrorEnding : null;
		}
	},

	validateAlternatePhone : function(component) {
		const phoneMethodError = "Alternate Phone is required if Preferred method of communication is phone";
		const phoneIncorrectError = "Invalid Alternate Phone";
		const phoneComponent = component.find("iAlternatePhone");
		const phoneNumber = phoneComponent.get("v.value");
		let errorMessage = phoneNumber == null || !phoneNumber ? phoneMethodError : (
			phoneNumber.length < 10 ? phoneIncorrectError : null);
		if (errorMessage) {
			phoneComponent.reportValidity();
		}
		return errorMessage;
	},

	validateByRegionPhone : function(phone) {
		const phoneRegularTest = new RegExp("^\\(?([0-0]{1})\\)?([6-8]{1})[-. ]?([0-9]{8})$");
		return phoneRegularTest.test(phone);
	},

	validateEmail : function(component) {
		const emailMethodError = "Email is required";
		const emailComponent = component.find("iPersonEmail");
		const email = emailComponent.get("v.value");

		if (email == null || !email) {
			emailComponent.reportValidity();
			return emailMethodError;
		}

		return null;
	},
	communicationLanguageOptions: [
        'Afrikaans','English'
    ],
	fetchLanguageOptions: function(component) {
        component.set('v.communicationLanguageOptions', this.communicationLanguageOptions);
    },
});
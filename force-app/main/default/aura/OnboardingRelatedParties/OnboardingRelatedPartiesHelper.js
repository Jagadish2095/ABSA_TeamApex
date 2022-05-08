({
	helperMethod: function () {},

	fetchData: function (component) {
		var accId;
		if (component.get("v.recordId") == undefined) {
			accId = component.get("v.accRecId"); //when the component is on the NTB form
		} else {
			accId = component.get("v.recordId"); //when the component is on the Account form
		}
		var action = component.get("c.getRelatedParties");

		action.setParams({
			accountId: accId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var data = response.getReturnValue();
				component.set("v.data", data);
			} else {
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	refreshData: function (component) {
		this.fetchData(component);
	},

	validateRecords: function (component) {
		var accId = component.get("v.accRecId");
		var action = component.get("c.validateRelatedParties");

		action.setParams({
			accountId: accId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var error = response.getReturnValue();
				if (error != "") {
					alert(error);
				}
			} else {
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	removeRelationship: function (component, event) {
		component.set("v.showSpinner", true);
		var action = component.get("c.removeRelatedParty");
		action.setParams({
			accnConRelId: component.get("v.rowId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success!",
					message: "Relationship was successfully removed.",
					type: "success"
				});
				toastEvent.fire();
				this.fetchData(component);
			} else {
				console.log("Failed with state: " + state);
			}
		});
		component.set("v.showSpinner", false);
		$A.enqueueAction(action);
	},
	fetchPersonAccInfo: function (cmp, event, conId) {
		var action = cmp.get("c.fetchPersonAccDetails");
		action.setParams({
			personAccId: conId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var retVal = response.getReturnValue();
				console.log("retVal " + JSON.stringify(retVal));
				cmp.set("v.personAccount", retVal);
				var valArray = [];

				if (retVal.Country_of_Citizenship__c != null && retVal.Country_of_Citizenship__c != undefined && retVal.Country_of_Citizenship__c != "") {
					valArray = retVal.Country_of_Citizenship__c.split(";");
				}
				cmp.set("v.countryOfCitizenShip", valArray);

				if (retVal.Is_the_Client_a_Temporary_Resident__c == true) {
					cmp.set("v.showTempResidentSection", true);
				} else {
					cmp.set("v.showTempResidentSection", false);
				}

				var operatingRole = retVal.Operating_Roles__c;
				if (operatingRole != undefined && operatingRole.includes("Mandate & Indemnity User")) {
					cmp.set("v.isMandatIndemnityUser", true);
				} else {
					cmp.set("v.isMandatIndemnityUser", false);
				}
				//TdB - To Call Address Components
				var objCompB = cmp.find("addressComp");
				if (objCompB != undefined) {
					objCompB.getAccountId(cmp.get("v.personAccount.Id"));
					objCompB.getAccountClientType(cmp.get("v.personAccount.Client_Type__c"));
				}
			} else {
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},
	updateAccRecord: function (cmp, event, personAccount) {
		personAccount.Is_the_Client_a_Temporary_Resident__c = cmp.get("v.showTempResidentSection");
		var action = cmp.get("c.updatePersonAccDetails");
		action.setParams({
			personAcc: personAccount
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				cmp.set("v.isError2", true);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "success",
					title: "Success!",
					message: "The record has been updated successfully."
				});
				toastEvent.fire();
				this.refreshData(cmp);
				cmp.set("v.showModalRecordEdit", false);

				//Added by chandra against W-004945
				var cmpEvent = cmp.getEvent("hideRelatedPartiesEvent");
				cmpEvent.setParams({
					showRelatedParties: false
				});
				cmpEvent.fire();
			} else {
				cmp.set("v.isError", false);
				cmp.set("v.isError2", false);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "Error!",
					message: "Given details is incorrect, Please try again."
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	//Newly added by Rajesh for delete functionality
	deleteRelationship: function (component, event) {
		component.set("v.showSpinner", true);

		var action = component.get("c.deleteRelatedParty");
		action.setParams({
			accnConRelId: component.get("v.rowId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var retVal = response.getReturnValue();
			if (state === "SUCCESS") {
				console.log("retVal " + retVal);
				if (retVal != "" && retVal != undefined && retVal != null) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Error!",
						message: " This record is related to other record cannot delete ",
						type: "error"
					});
					toastEvent.fire();
				} else {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Success!",
						message: "Related party was successfully deleted.",
						type: "success"
					});
					toastEvent.fire();
					this.fetchData(component);
				}
			} else {
				console.log("Failed with state: " + state);
			}
		});
		component.set("v.showSpinner", false);
		$A.enqueueAction(action);
	},
	fetchAddressList2: function (component, event, rowId) {
		var action = component.get("c.fetchAddressList");
		action.setParams({
			accnConRelId: rowId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var retVal = response.getReturnValue();
			console.log("retVal " + JSON.stringify(retVal));
			if (state === "SUCCESS") {
				component.set("v.addressData", retVal);
			} else {
				console.log("Failed with state: " + state);
			}
		});
		component.set("v.showSpinner", false);
		$A.enqueueAction(action);
	},
	fetchAddressList2: function (component, event, rowId) {
		var action = component.get("c.fetchAddressList");
		action.setParams({
			accnConRelId: rowId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var retVal = response.getReturnValue();
			console.log("retVal " + JSON.stringify(retVal));
			if (state === "SUCCESS") {
				component.set("v.addressData", retVal);
			} else {
				console.log("Failed with state: " + state);
			}
		});
		component.set("v.showSpinner", false);
		$A.enqueueAction(action);
	},
	fetchPickListVal: function (component, fieldName, elementId) {
		var action = component.get("c.getselectOptions");
		action.setParams({
			objObject: component.get("v.accountContactRelation"),
			fld: fieldName
		});
		var opts = [];
		action.setCallback(this, function (response) {
			if (response.getState() == "SUCCESS") {
				var allValues = response.getReturnValue();
				for (var i = 0; i < allValues.length; i++) {
					opts.push({
						class: "optionClass",
						label: allValues[i],
						value: allValues[i]
					});
				}
				if (elementId == "Designation__c") {
					component.set("v.designationOptions", allValues);
				}
			}
		});
		$A.enqueueAction(action);
	},
	fetchCountryValues: function (component, fieldName, elementId) {
		var action = component.get("c.getPickListValues");
		var opts = [];
		action.setCallback(this, function (response) {
			if (response.getState() == "SUCCESS") {
				var allValues = response.getReturnValue();
				console.log("allValues " + JSON.stringify(allValues));
				component.set("v.countryValuesArray_NEW", allValues);
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra****************************************
	 ****************@ Date: 16/07/2020****************************************
	 ****************@ Work Id: W-004945***************************************
	 ***@ Description: Method Added by chandra to calculate controlling perct*/

	calculateControllingPercentage: function (component, event, helper) {
		var roles = component.find("roles").get("v.value"); //Added by chandra against 4746,5410
		roles = roles.join(";"); //Added by chandra against 4746,5410
		var primaryEntityId = component.get("v.primaryEntityId");

		console.log("primaryEntityId-->" + primaryEntityId);
		console.log("perc-->" + component.get("v.ChangedSharePercentage"));
		console.log("roles-->" + roles);

		var action = component.get("c.calculateControllingPercentage");
		action.setParams({
			accConRelId: component.get("v.recordIdAccountContactEdited"),
			sharePercentage: component.get("v.ChangedSharePercentage"),
			roles: roles,
			primaryEntityId: primaryEntityId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var retVal = response.getReturnValue();
			if (state === "SUCCESS") {
				console.log("Record updated successfully");
			} else {
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra****************************************
	 ****************@ Date: 16/07/2020****************************************
	 ****************@ Work Id: W-004945***************************************
	 ***@ Description: Method Added by chandra to updateAccConRelationship****/

	updateAccConRelationship: function (component, event, helper) {
		var roles = component.find("roles").get("v.value");
		var sharedPercentage;
		var newRoles = roles.join(";");

		//Added by Diksha For W-6596
		var taxNumber, taxResidency;

		if (component.find("taxNumber") == undefined) {
			taxNumber = null;
		} else {
			taxNumber = component.find("taxNumber").get("v.value");
		}
		if (component.find("taxResidency") == undefined) {
			taxResidency = null;
		} else {
			taxResidency = component.find("taxResidency").get("v.value");
		}

		if (component.find("sharePercentage") == undefined) {
			sharedPercentage = 0;
		} else {
			sharedPercentage = component.find("sharePercentage").get("v.value");
		}

		var action = component.get("c.updateAccConRelationship");
		action.setParams({
			accConRelId: component.get("v.recordIdAccountContactEdited"),
			sharePercentage: sharedPercentage,
			roles: newRoles,
			taxNumber: taxNumber,
			taxResidency: taxResidency
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var retVal = response.getReturnValue();
			console.log("state: " + state);
			console.log("retVal: " + retVal);
			if (state === "SUCCESS") {
				console.log("Record updated successfully");
			} else if (state === "ERROR") {
				console.log("Failed with state: " + state);
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

	//TdB - Set Individual Prospect Record Type Id
	getIndividualProspectRecordType: function (component) {
		var action = component.get("c.getClientRecordTypeByName");
		//Set the Object parameters and Field Set name
		action.setParams({
			recordTypeName: "Individual_Prospect"
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				component.set("v.individualProspectRecordTypeId", response.getReturnValue());
			} else if (state === "ERROR") {
				var message = "";
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

				// show error notification
				var toastEvent = this.getToast("Error!", message, "Error");
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra****************************************
	 ****************@ Date: 16/07/2020****************************************
	 ****************@ Work Id: W-004945***************************************
	 ***@ Description: Method Added by chandra to set Roles for Trusts & CC****/

	fetchRolesOptionVal: function (component, fieldName) {
		//alert(component.get("v.accountClientType"));
		var processType = component.get("v.processTyperp");
		var action = component.get("c.getselectOptions");
		action.setParams({
			objObject: component.get("v.accountContactRelation"),
			fld: fieldName
		});
		action.setCallback(this, function (response) {
			//  alert(response.getState());
			if (response.getState() == "SUCCESS") {
				//Condition Added by chandra for Trusts and Close Corporation against 4746, 5410
				var allValues;
				var opts = [];
				var filteredValue = [];
				var selectedValues = component.get("v.selectedRole");

				if (processType != "Surety Onboarding") {
					if (component.get("v.accountClientType") == "Trusts" || component.get("v.PrimaryClientType") == "Trusts") {
						let trustRoleString = $A.get("$Label.c.Roles_For_Trust");
						let trustRoleList = trustRoleString.split(";");
						allValues = trustRoleList;
					} else if (component.get("v.accountClientType") == "Close Corporation" || component.get("v.PrimaryClientType") == "Close Corporation") {
						let ccRoleString = $A.get("$Label.c.Roles_For_CC");
						let ccRoleList = ccRoleString.split(";");
						allValues = ccRoleList;
					} else if (component.get("v.accountClientType") == "Private Company" || component.get("v.PrimaryClientType") == "Private Company") {
						let pcRoleString = $A.get("$Label.c.Roles_For_PC");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "Co-operative" || component.get("v.PrimaryClientType") == "Co-operative") {
						let cooperativesRoleString = $A.get("$Label.c.Roles_for_Co_operatives");
						let cooperativesRoleList = cooperativesRoleString.split(";");
						allValues = cooperativesRoleList;
					} else if (component.get("v.accountClientType") == "Foreign Company" || component.get("v.PrimaryClientType") == "Foreign Company") {
						let foreignCompaniesRoleString = $A.get("$Label.c.Roles_For_Foreign_Companies");
						let foreignCompaniesRoleList = foreignCompaniesRoleString.split(";");
						allValues = foreignCompaniesRoleList;
					} else if (
						component.get("v.accountClientType") == "Foreign Listed Company" ||
						component.get("v.PrimaryClientType") == "Foreign Listed Company"
					) {
						let foreignListedCompaniesRoleString = $A.get("$Label.c.Roles_For_Foreign_Companies");
						let foreignListedCompaniesRoleList = foreignListedCompaniesRoleString.split(";");
						allValues = foreignListedCompaniesRoleList;
					} else if (component.get("v.accountClientType") == "Foreign Trust" || component.get("v.PrimaryClientType") == "Foreign Trust") {
						let foreignTrustRoleString = $A.get("$Label.c.Roles_For_Foreign_Trust");
						let foreignTrustRoleList = foreignTrustRoleString.split(";");
						allValues = foreignTrustRoleList;
					} else if (
						component.get("v.accountClientType") == "Public Listed Company" ||
						component.get("v.PrimaryClientType") == "Public Listed Company"
					) {
						let publicListedCompanyRoleString = $A.get("$Label.c.Roles_For_Public_Listed_Company");
						let publicListedCompanyRoleList = publicListedCompanyRoleString.split(";");
						allValues = publicListedCompanyRoleList;
					} else if (
						component.get("v.accountClientType") == "Clubs/Societies/Associations/Other Informal Bodies" ||
						component.get("v.PrimaryClientType") == "Clubs/Societies/Associations/Other Informal Bodies"
					) {
						let pcRoleString = $A.get("$Label.c.Roles_for_Clubs_Societies_Associations_Other_Informal_Bodies");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (
						component.get("v.accountClientType") == "Incorporated Company" ||
						component.get("v.PrimaryClientType") == "Incorporated Company"
					) {
						let pcRoleString = $A.get("$Label.c.Roles_for_Incorporated_Companies");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (
						component.get("v.accountClientType") == "Non Profit Companies" ||
						component.get("v.PrimaryClientType") == "Non Profit Companies"
					) {
						let pcRoleString = $A.get("$Label.c.Roles_for_Not_for_Profit_Companies");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (
						component.get("v.accountClientType") == "Non Profit Organizations (NGO)" ||
						component.get("v.PrimaryClientType") == "Non Profit Organizations (NGO)"
					) {
						let pcRoleString = $A.get("$Label.c.Roles_for_Not_for_Profit_Organizations");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "PARTNERSHIP" || component.get("v.PrimaryClientType") == "PARTNERSHIP") {
						let pcRoleString = $A.get("$Label.c.Roles_for_Partnership");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (
						component.get("v.accountClientType") == "Organs of State and Institutions of Higher Learning" ||
						component.get("v.PrimaryClientType") == "Organs of State and Institutions of Higher Learning"
					) {
						let pcRoleString = $A.get("$Label.c.Roles_for_Institutions_of_Higher_Learning");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "Funds" || component.get("v.PrimaryClientType") == "Funds") {
						let fundsRoleString = $A.get("$Label.c.Roles_for_Funds");
						let fundsRoleList = fundsRoleString.split(";");
						allValues = fundsRoleList;
					} else if (
						component.get("v.accountClientType") == "Central Bank or Regulator" ||
						component.get("v.PrimaryClientType") == "Central Bank or Regulator"
					) {
						let centralBankRoleString = $A.get("$Label.c.Roles_for_Central_Bank");
						let centralBankRoleList = centralBankRoleString.split(";");
						allValues = centralBankRoleList;
					} else if (component.get("v.accountClientType") == "Joint &amp; Several" || component.get("v.PrimaryClientType") == "Joint &amp; Several") {
						let pcRoleString = $A.get("$Label.c.Roles_for_Joint_and_Several");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "Deceased Estate" || component.get("v.PrimaryClientType") == "Deceased Estate") {
						let pcRoleString = $A.get("$Label.c.Roles_for_Deceased_Estate");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "Schools" || component.get("v.PrimaryClientType") == "Schools") {
						let ccRoleString = $A.get("$Label.c.Roles_for_Schools");
						let ccRoleList = ccRoleString.split(";");
						allValues = ccRoleList;
					} else if (
						component.get("v.accountClientType") == "Regulated Credit Entities and Financial Institutions" ||
						component.get("v.PrimaryClientType") == "Regulated Credit Entities and Financial Institutions"
					) {
						let pcRoleString = $A.get("$Label.c.Roles_for_Regulated_Credit_Entities_and_Financial_Institutions");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "Stokvel" || component.get("v.PrimaryClientType") == "Stokvel") {
						let pcRoleString = $A.get("$Label.c.	Roles_for_Stokvel");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "Churches" || component.get("v.PrimaryClientType") == "Churches") {
						let pcRoleString = $A.get("$Label.c.Roles_for_Churches");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "Body Corporates" || component.get("v.PrimaryClientType") == "Body Corporates") {
						let pcRoleString = $A.get("$Label.c.Roles_for_Body_Corporates");
						let pcRoleList = pcRoleString.split(";");
						allValues = pcRoleList;
					} else if (component.get("v.accountClientType") == "Sole Trader" || component.get("v.PrimaryClientType") == "Sole Trader") {
						let ccRoleString = $A.get("$Label.c.Roles_for_Sole_Trader");
						let ccRoleList = ccRoleString.split(";");
						allValues = ccRoleList;
					} else {
						allValues = response.getReturnValue();
					}

					//TdB - Surety Onboardig
				} else {
					let pcRoleString = $A.get("$Label.c.Roles_for_Surety_Onboarding");
					let pcRoleList = pcRoleString.split(";");
					allValues = pcRoleList;
				}
				console.log("allValues: " + JSON.stringify(allValues));
				for (var i = 0; i < allValues.length; i++) {
					opts.push({
						class: "optionClass",
						label: allValues[i],
						value: allValues[i]
					});
				}
				console.log("optsRoles: " + JSON.stringify(opts));
				component.set("v.roleOptions", opts);
			}
		});
		$A.enqueueAction(action);
	},

	fetchRolesSelectedVal: function (component, recordIdAccountContactEdited) {
		console.log("recordIdAccountContactEdited-->" + recordIdAccountContactEdited);
		var action = component.get("c.getselectectedRoleVal");

		action.setParams({
			accConId: recordIdAccountContactEdited
		});
		action.setCallback(this, function (response) {
			if (response.getState() == "SUCCESS") {
				var selectedValues;
				let result = response.getReturnValue();
				let returnedRoles = result.Roles;

				if (returnedRoles != undefined) {
					selectedValues = returnedRoles.split(";");
					component.set("v.selectedRole", selectedValues);
				}
				console.log("result" + JSON.stringify(result));
				component.set("v.ChkUBOField", result.UBO__c);

				if (
					selectedValues.includes("Operators on primary accounts ( Internet Main Users, Signatories, Card Users)") ||
					selectedValues.includes("Operators on primary accounts (Internet Main Users,Signatories,Card users)")
				) {
					component.set("v.isOperatingRole", true);
				} else {
					component.set("v.isOperatingRole", false);
				}
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Sandeep Golla****************************************
	 ****************@ Date:28/12/2020****************************************
	 ****************@ Work Id: W-007847***************************************
	 ***@ Description: Helper function to Generate Hanis Certificate****/
	getHanisCertificate: function (component, event, rowRecord) {
		component.set("v.showSpinner", true);
		var idNumber = rowRecord.IDNumber;

		var actionHanisService = component.get("c.callHanisServiceForRelatedParties");
		actionHanisService.setParams({
			idNumber: idNumber
		});
		actionHanisService.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());
				if (respObj.statusCode == 200) {
					console.log("HANIS SERVICE SUCCESS ; " + respObj);
					var hanisResponse = respObj;
					var accountId;
					var relatedPartyName = rowRecord.FirstName + rowRecord.LastName;
					if (component.get("v.recordId") == undefined) {
						accountId = component.get("v.accRecId"); //when the component is on the NTB form
					} else {
						accountId = component.get("v.recordId"); //when the component is on the Account form
					}
					var action = component.get("c.GenerateHanisCertificate");
					action.setParams({
						hanisData: JSON.stringify(hanisResponse),
						accRecordId: accountId,
						name: relatedPartyName
					});
					action.setCallback(this, function (response) {
						var state = response.getState();
						var message = "";
						if (component.isValid() && state === "SUCCESS") {
							component.set("v.showSpinner", false);
							var toast = this.getToast("Success!", "Hanis Certificate Generated Succesfully", "Success");
							toast.fire();
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
							component.set("v.showSpinner", false);
						} else {
							var errors = response.getError();
							var toast = this.getToast("Error", message, "error");
							toast.fire();
							component.set("v.showSpinner", false);
						}
					});
					$A.enqueueAction(action);
				} else if (respObj.statusCode == 404) {
					console.log("HANIS SERVICE ERROR OCCURRED");
					var message = respObj.message;
					var toastEvent = this.getToast("Hanis Service Error!", message, "error");
					toastEvent.fire();
					component.set("v.showSpinner", false);
				} else {
					console.log("HANIS SERVICE ERROR OCCURRED");
					var message = "We cannot complete the request now, please try again if error persist contact administrator.";
					var toastEvent = this.getToast("Hanis Service Error!", message, "error");
					toastEvent.fire();
					component.set("v.showSpinner", false);
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
				component.set("v.showSpinner", false);
			} else {
				var errors = response.getError();
				var toast = this.getToast("Error", message, "error");
				toast.fire();
				component.set("v.showSpinner", false);
			}
		});
		$A.enqueueAction(actionHanisService);
	},

	/****************@ Author: Sandeep Golla****************************************
	 ****************@ Date:28/12/2020****************************************
	 ****************@ Work Id: W-007849***************************************
	 ***@ Description: Helper function to Generate CPB Certificate****/
	getCPBCertificate: function (component, event, rowRecord) {
		component.set("v.showSpinner", true);
		var idNumber = rowRecord.IDNumber;
		var lastName = rowRecord.LastName;

		var actionCPBservice = component.get("c.callCPBServiceForRelatedParties");
		actionCPBservice.setParams({
			idNumber: idNumber,
			lastName: lastName
		});
		actionCPBservice.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";
			if (component.isValid() && state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());
				var searchInfo = respObj.SearchInformation;
				console.log("searchInfo---" + searchInfo);
				if (respObj.statusCode == 200 && searchInfo) {
					console.log("CPB SERVICE SUCCESS : " + JSON.stringify(respObj));
					component.set("v.showSpinner", false);
					var cpbResponse = respObj;
					var accountId;
					var relatedPartyName = rowRecord.FirstName + rowRecord.LastName;
					if (component.get("v.recordId") == undefined) {
						accountId = component.get("v.accRecId"); //when the component is on the NTB form
					} else {
						accountId = component.get("v.recordId"); //when the component is on the Account form
					}
					var action = component.get("c.GenerateCPBCertificate");
					action.setParams({
						cpbData: JSON.stringify(cpbResponse),
						accRecordId: accountId,
						name: relatedPartyName
					});
					action.setCallback(this, function (response) {
						var state = response.getState();
						var message = "";
						if (component.isValid() && state === "SUCCESS") {
							component.set("v.showSpinner", false);
							var toast = this.getToast("Success!", "CPB Certificate Generated Succesfully", "Success");
							toast.fire();
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
							component.set("v.showSpinner", false);
						} else {
							var errors = response.getError();
							var toast = this.getToast("Error", message, "error");
							toast.fire();
							component.set("v.showSpinner", false);
						}
					});
					$A.enqueueAction(action);
				} else if (respObj.statusCode == 200 && !searchInfo) {
					console.log("NO CPB SERVICE FOR THIS CUSTOMER");
					var toastEvent = this.getToast("NO CPB Service!", "NO CPB SERVICE FOR THIS CUSTOMER", "info");
					toastEvent.fire();
					component.set("v.showSpinner", false);
				} else if (respObj.statusCode == 404) {
					console.log("CPB SERVICE ERROR OCCURRED");
					var message = respObj.message;
					var toastEvent = this.getToast("CPB Service Error!", message, "error");
					toastEvent.fire();
					component.set("v.showSpinner", false);
				} else {
					console.log("CPB SERVICE ERROR OCCURRED");
					var message = "We cannot complete the request now, please try again if error persist contact administrator.";
					var toastEvent = this.getToast("CPB Service Error!", message, "error");
					toastEvent.fire();
					component.set("v.showSpinner", false);
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
				component.set("v.showSpinner", false);
			} else {
				var errors = response.getError();
				var toast = this.getToast("Error", message, "error");
				toast.fire();
				component.set("v.showSpinner", false);
			}
		});
		$A.enqueueAction(actionCPBservice);
	},
	//Helper Method to show toasts
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		return toastEvent;
	},
	//Anka - Set Client Type
	getPrimaryClientType: function (component, acrId) {
		var action = component.get("c.getClientTypeByaccContRelId");
		//Set the Object parameters and Field Set name
		action.setParams({
			accContRelId: acrId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				component.set("v.PrimaryClientType", response.getReturnValue());
			} else if (state === "ERROR") {
				var message = "";
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

				// show error notification
				var toastEvent = this.getToast("Error!", message, "Error");
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	// W-008562
	getOpportunityStage: function (component, event, helper, accId) {
		var action = component.get("c.OpportunityStage");
		action.setParams({
			accountId: accId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var retVal = response.getReturnValue();
				console.log("Success " + state);
				component.set("v.OppStage", retVal);
			} else {
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},
	// W-8562 - Closed opportunity validation
	closedOpportunityValidation: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			type: "error",
			title: "Error!",
			message: "You are not allowed to update application record as it is associated with closed opportunity"
		});
		toastEvent.fire();
	},

	updateAccAccRelationship: function (component, event, helper, recordId, sharePercentage, roles) {
		var action = component.get("c.updateAccountAccountRelationship");
		action.setParams({
			accAccRelId: recordId,
			sharePercentage: sharePercentage,
			roles: roles
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var retVal = response.getReturnValue();
			if (state === "SUCCESS") {
				component.set("v.showSpinner", false);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success!",
					message: "Record updated successfully.",
					type: "success"
				});
				toastEvent.fire();
				component.set("v.showModalRecordEdit", false);
			} else {
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	//Function to Call Experian Service
	callExperianService: function (component, event, rowRecord) {
		var idNumber = rowRecord.IDNumber;
		component.set("v.showSpinner", true);

		var action = component.get("c.callExperianHandler");
		action.setParams({ registrationNumber: idNumber });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());
				if (respObj.statusCode == 200 && respObj.message == null) {
					component.set("v.experianResponse", respObj);
					console.log("=========>" + JSON.stringify(respObj.companyDownload.results.kreditSearchFile.companyDetails));

					var CompanyDetailsObj = respObj.companyDownload.results.kreditSearchFile.companyDetails;
					console.log("respObj rec " + JSON.stringify(respObj));
					if (component.isValid() && state === "SUCCESS") {
						this.saveExperianCertificate(component, event, rowRecord);
					}
					if (CompanyDetailsObj != undefined && CompanyDetailsObj != "" && CompanyDetailsObj != null) {
						if ($A.get("$Label.c.Entity_Type_Status_To_Proceed").includes(CompanyDetailsObj.status)) {
						} else {
							var toast = this.getToast("Error!", "Unsuccessfully" + CompanyDetailsObj.status, "Error");
							toast.fire();
						}
					}
				} else if (respObj.statusCode == 200 && respObj.message == "Company registration number not valid") {
					var toastEvent = helper.getToast("Error", respObj.message, "error");
					toastEvent.fire();
				} else if (respObj.statusCode > 399 || respObj.statusCode < 500) {
					console.log("EXPERIAN SERVICE ERROR OCCURRED");
					var message = respObj.message;
					var toastEvent = helper.getToast("Error", message, "error");
					toastEvent.fire();
				} else {
					console.log("EXPERIAN SERVICE ERROR OCCURRED");
					var message = "We cannot complete the request now, please try again if error persist contact administrator.";
					var toastEvent = helper.getToast("Error", message, "error");
					toastEvent.fire();
				}
				component.set("v.showSpinner", false);
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
				component.set("v.showSpinner", false);
			} else {
				var errors = response.getError();
				var toast = helper.getToast("Error", message, "error");
				toast.fire();
				component.set("v.showSpinner", false);
			}
		});
		$A.enqueueAction(action);
	},

	//Function to save document to ECM
	saveExperianCertificate: function (component, event, rowRecord) {
		var experianObj = component.get("v.experianResponse");
		var action = component.get("c.generateExperianCertificate");
		var accountId = component.get("v.accRecordId");
		var accountId = component.get("v.recordId");

		action.setParams({
			experianData2: JSON.stringify(experianObj),
			accRecordId: rowRecord.ContactAccountId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";
			if (state == "SUCCESS") {
				console.log("==BUSS==accRecord====>" + JSON.stringify(response.getReturnValue()));
				var accountRec = response.getReturnValue();
				var toast = this.getToast("Success!", "Exprian Certificate Generated Succesfully", "Success");
				toast.fire();
			}
		});
		$A.enqueueAction(action);
	}
});
({
	myAction: function (component, event, helper) {},
	doInit: function (component, event, helper) {
		//TdB - Set Individual Prospect Record Type Id
		helper.getIndividualProspectRecordType(component, event);

		helper.fetchCountryValues(component, event, helper);
		helper.fetchPickListVal(component, "Designation__c", "Designation__c");
		var actions = [
			{ label: "Edit", name: "edit_relationship" },
			{ label: "Remove Relationship", name: "remove_relationship" },
			{ label: "Delete", name: "delete_relationship" }
		];

		component.set("v.columns", [
			{ label: "Full Name", fieldName: "FullName", type: "text" },
			{ label: "Client Type", fieldName: "ClientType", type: "text" },
			{ label: "ID Number/Registration Number", fieldName: "IDNumber", type: "text" },
			{ label: "Share Percentage", fieldName: "SharePercentage", type: "text" },
			{ label: "Roles", fieldName: "Roles", type: "text" },
			{ type: "action", typeAttributes: { rowActions: actions } }
		]);

		helper.fetchData(component);
		if (component.get("v.isFromUBOListView")) {
			helper.fetchRolesOptionVal(component, "Roles");
		}
		helper.fetchRolesOptionVal(component, "Roles");
		var editedRecordId = component.get("v.recordIdAccountContactEdited");

		if (editedRecordId != null && editedRecordId != undefined && editedRecordId != "") {
			helper.fetchRolesSelectedVal(component, editedRecordId);
		}
		// W-008562

		var accId;
		if (component.get("v.recordId") == undefined) {
			accId = component.get("v.accRecId"); //when the component is on the NTB form
		} else {
			accId = component.get("v.recordId"); //when the component is on the Account form
		}
		console.log("account41-" + accId);
		debugger;
		if (accId != undefined && accId != null) {
			helper.getOpportunityStage(component, event, helper, accId);
		}
	},

	doAction: function (component, event, helper) {
		var parentValue = event.getParam("arguments");

		if (parentValue) {
			console.log("@@@@parentValue.accId" + parentValue.accId + "parentValue.processTypeparam" + parentValue.processTypeparam);
			var accountRecId = parentValue.accId; //params
		}

		console.log("@@@@accountRecId--->" + accountRecId);
		//alert('ACCOUNT ID in OnboardingRelatedParties:'+accountRecId);
		component.set("v.accRecId", accountRecId);
		component.set("v.primaryEntityId", accountRecId);
		console.log("@@@@accountRecId2--->" + component.get("v.accRecId"));
		component.set("v.processTyperp", parentValue.processTypeparam); //Manoj-6067-Lite Onboarding Manual Capture

		var actions2 = [
			{ label: "Edit", name: "edit_relationship" },
			{ label: "Remove Relationship", name: "remove_relationship" },
			{ label: "Delete", name: "delete_relationship" },
			{ label: "Generate Hanis", name: "hanis_certificate" },
			{ label: "Generate CPB", name: "cpb_certificate" },
			{ label: "Generate Experian", name: "exprian_certificate" }
		];

		component.set("v.columns", [
			{ label: "Full Name", fieldName: "FullName", type: "text" },
			{ label: "Client Type", fieldName: "ClientType", type: "text" },
			{ label: "ID Number/Registration Number", fieldName: "IDNumber", type: "text" },
			{ label: "Share Percentage", fieldName: "SharePercentage", type: "text" },
			{ label: "Roles", fieldName: "Roles", type: "text" },
			{ type: "action", typeAttributes: { rowActions: actions2 } }
		]);

		helper.fetchData(component);
	},

	showClientFinderModal: function (component, event, helper) {
		component.set("v.showModal", true);
	},

	closeClientFinderModal: function (component, event, helper) {
		//W-008562
		var stage = component.get("v.OppStage");
		if (stage == "Closed") {
			helper.closedOpportunityValidation(component, event, helper);
		} else {
			component.set("v.showModal", false);

			//Added by chandra against W-004945
			var cmpEvent = component.getEvent("hideRelatedPartiesEvent");
			cmpEvent.setParams({ showOnboardingRelatedParty: false });
			cmpEvent.fire();
		}
	},

	refreshRecords: function (component, event, helper) {
		helper.refreshData(component);
	},

	validateRecords: function (component, event, helper) {},

	handleRowAction: function (component, event, helper) {
		var action = event.getParam("action");
		var row = event.getParam("row");
		switch (action.name) {
			case "edit_relationship":
				//var row = event.getParam('row');
				/*var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": row.Id
                });
                editRecordEvent.fire();*/

				if (row.isIndividual == "true") {
					helper.getPrimaryClientType(component, row.Id); //Added by Anka
					helper.fetchRolesSelectedVal(component, row.Id); //Added by chandra against 4746,5410
					helper.fetchRolesOptionVal(component, "Roles"); //Added by chandra against 4746,5410
					component.set("v.showModalRecordEdit", true);
					component.set("v.showAccConRelationshipEdit", true);

					component.set("v.recordIdAccountContactEdited", row.Id);
					component.set("v.showModalRecordEdit", true);
					var actions2 = [{ label: "Edit Address", name: "edit_address" }];

					component.set("v.addressColumns", [
						{ label: "Address Type", fieldName: "Address_Type__c", type: "text" },
						{ label: "Address Name", fieldName: "Address1__c", type: "text" },
						{ label: "Suburb", fieldName: "Address2__c", type: "text" },
						{ label: "City", fieldName: "Address3__c", type: "text" },
						{ label: "Postal Code", fieldName: "Address5__c", type: "text" },
						{ type: "action", typeAttributes: { rowActions: actions2 } }
					]);
					helper.fetchAddressList2(component, event, row.Id);
				} else {
					component.set("v.showAccConRelationshipEdit", false);
					component.set("v.selectedRecordObjectApiName", "FinServ__AccountAccountRelation__c");
					component.set("v.recordIdAccountAccountEdited", row.Id);
					component.set("v.showModalRecordEdit", true);
				}
				break;
			case "remove_relationship":
				var row = event.getParam("row");
				component.set("v.rowId", row.Id);
				component.set("v.showRemoveRelationshipConfirmation", true);
				break;
			case "delete_relationship":
				var row = event.getParam("row");
				component.set("v.rowId", row.Id);
				component.set("v.showDeleteRelationshipConfirmation", true);
				break;
			//Added by Sandeep Golla against WorkItem W-007847
			case "hanis_certificate":
				var row = event.getParam("row");
				helper.getHanisCertificate(component, event, row);
				break;
			case "cpb_certificate":
				var row = event.getParam("row");
				helper.getCPBCertificate(component, event, row);
				break;

			case "exprian_certificate":
				var row = event.getParam("row");
				helper.callExperianService(component, event, row);
				break;
		}
	},

	confirmRemoveAction: function (component, event, helper) {
		component.set("v.showRemoveRelationshipConfirmation", false);
		helper.removeRelationship(component, event);
	},

	cancelRemoveAction: function (component, event, helper) {
		component.set("v.showRemoveRelationshipConfirmation", false);
	},
	handleSuccessAccConReln: function (cmp, event, helper) {
		helper.refreshData(cmp);
		cmp.set("v.showModalRecordEdit", false);
	},
	handleCancelAccConReln: function (cmp, event, helper) {
		cmp.set("v.showModalRecordEdit", false);

		//Added by chandra against W-004945
		var cmpEvent = cmp.getEvent("hideRelatedPartiesEvent");
		cmpEvent.setParams({ showRelatedParties: false });
		cmpEvent.fire();
	},
	handleLoadAccConRelnRecord: function (cmp, event, helper) {
		var processType = cmp.get("v.processTyperp");

		if (processType != "Surety Onboarding") {
			var share = cmp.find("sharePercentage").get("v.value");
			if (share >= 10) {
				cmp.find("uboFld").set("v.value", "Yes");
			} else {
				cmp.find("uboFld").set("v.value", "No");
			}
		}

		var accId = cmp.find("accountId").get("v.value");
		var conId = cmp.find("contactId").get("v.value");
		var isError = cmp.get("v.isError2");
		var selectedOptionValue = cmp.get("v.selectedRole"); //Added by chandra dated 22/07/2020
		cmp.set("v.selectedRole", selectedOptionValue);
		if (isError) {
			helper.fetchPersonAccInfo(cmp, event, conId);
			cmp.set("v.accIdForAccContactEdit", accId);
		}

		if (processType != "Surety Onboarding") {
			//Added by chandra dated 22/07/2020
			if (
				selectedOptionValue.includes("Shareholder/Controller") ||
				selectedOptionValue.includes("Members/Controllers") ||
				selectedOptionValue.includes("Partner/Controller") ||
				selectedOptionValue.includes("Named Beneficiaries") ||
				selectedOptionValue.includes("Trustees")
			) {
				// cmp.find("sharePercentage").set("v.value", "");
				cmp.find("sharePercentage").set("v.disabled", false);
			}
		}
	},
	handleUpdateAccConRelationship: function (cmp, event, helper) {
		event.preventDefault();
		/*
     var isResidentialAddAvailable = false;
        var addressData = cmp.get("v.addressData");
        for(var i in addressData){
            if(addressData[i].Address_Type__c == 'Residential'){
                isResidentialAddAvailable = true;
            }
        }
        
        if(!isResidentialAddAvailable){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please enter residential address.",
                "type":"error"
            });
            toastEvent.fire();  
            return;
        } */
		var processType = cmp.get("v.processTyperp");
		var personAccRecord = cmp.get("v.personAccount");
		var validationFlag = false;
		var clientType = cmp.get("v.accountClientType");

		if (processType != "Surety Onboarding") {
			var sharePercentage = cmp.find("sharePercentage").get("v.value");
			var clientIdType = cmp.find("clientIdType").get("v.value");
			var processTypeLite = cmp.get("v.processTyperp");
			if (processTypeLite != "Lite Onboarding") {
				//Manoj-6073-Lite Onboarding Manual Capture Individual
				if (
					personAccRecord.PersonBirthdate != null &&
					personAccRecord.PersonBirthdate != "" &&
					personAccRecord.Country_of_Citizenship__c != null &&
					personAccRecord.Country_of_Citizenship__c != "" &&
					personAccRecord.Country_of_Citizenship__c != undefined &&
					personAccRecord.Gender__pc != null &&
					personAccRecord.Gender__pc != "" &&
					personAccRecord.Country_of_Birth__pc != null &&
					personAccRecord.Country_of_Birth__pc != "" &&
					personAccRecord.Country_of_Birth__pc != undefined &&
					((personAccRecord.PersonEmail != null && personAccRecord.PersonEmail != "" && personAccRecord.PersonEmail != undefined) ||
						(personAccRecord.Phone != null && personAccRecord.Phone != "" && personAccRecord.Phone != undefined))
				) {
					validationFlag = true;
				} else {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Error!",
						message: "Please fill all required fields.",
						type: "error"
					});
					toastEvent.fire();
				}
			}

			if (processTypeLite == "Lite Onboarding") {
				//Manoj-6073-Lite Onboarding Manual Capture Individual
				validationFlag = true;
			}

			if (processTypeLite != "Lite Onboarding") {
				//Manoj-6073-Lite Onboarding Manual Capture Individual
				//Newly added by Rajesh to validate First and Last Name length to 30
				var selectedOptionValue = cmp.find("roles").get("v.value");

				if (selectedOptionValue.includes("Operators on primary accounts ( Internet Main Users, Signatories, Card Users)")) {
					var iCountryDateIssued = cmp.find("iCountryDateIssued").get("v.value");
					console.log("iCountryDateIssued " + iCountryDateIssued);
					if (iCountryDateIssued == null || iCountryDateIssued == "" || iCountryDateIssued == undefined) {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title: "Error!",
							message: "Please enter Date issued when Operator is selected.",
							type: "error"
						});

						toastEvent.fire();
						return;
					}
				}

				//TdB - Validate Operating Role
				var isOperatingRoleVal = cmp.get("v.isOperatingRole");
				if (
					isOperatingRoleVal == true &&
					(!personAccRecord.Operating_Roles__c ||
						personAccRecord.Occupation_Status__pc == null ||
						personAccRecord.Occupation_Status__pc == undefined ||
						personAccRecord.Occupation_Status__pc == "")
				) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Error!",
						message: "Please complete Occupation and Operating Role",
						type: "error"
					});
					toastEvent.fire();
					return;
				}

				//TdB - Validate Tem Resident Fields
				var isShowTempResidentSection = cmp.get("v.showTempResidentSection");
				if (
					isShowTempResidentSection == true &&
					(!personAccRecord.Country_of_Permanent_Residency__c ||
						!personAccRecord.Purpose_of_Visit__c ||
						!personAccRecord.Date_of_Arrival_in_South_Africa__c ||
						!personAccRecord.Period_of_Visit__c)
				) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Error!",
						message: "Please complete all fields required for Temporary Resident",
						type: "error"
					});
					toastEvent.fire();
					return;
				}
				//TdB - Occupation validation
				var occupationStatusValue = personAccRecord.Occupation_Status__pc;
				if (
					occupationStatusValue == "Full Time Employed" ||
					occupationStatusValue == "Part Time Employed" ||
					occupationStatusValue == "Self Employed Professional" ||
					occupationStatusValue == "Self Employed-Non-Professional" ||
					occupationStatusValue == "Temporary Employed"
				) {
					if (
						!personAccRecord.Occupation__pc ||
						!personAccRecord.Occupation_Category__pc ||
						!personAccRecord.Employer_Name__pc ||
						!personAccRecord.Employer_Sector__pc
					) {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title: "Error!",
							message: "Please complete Occupation Section.",
							type: "error"
						});
						toastEvent.fire();
						return null;
					}
				}
			}

			if (sharePercentage <= 100) {
				if (validationFlag && clientIdType != null && clientIdType != undefined && clientIdType != "" && clientIdType != "Trusts") {
					//Added by chandra to validate share Percentage is not blank when "Shareholder/Controller" role is selected
					var selectedOptionValue = cmp.find("roles").get("v.value");

					if (
						(selectedOptionValue.includes("Shareholder/Controller") ||
							selectedOptionValue.includes("Members/Controllers") ||
							selectedOptionValue.includes("Partner/Controller")) &&
						(cmp.find("sharePercentage").get("v.value") == "" || cmp.find("sharePercentage").get("v.value") == "0")
					) {
						var toastEvent = $A.get("e.force:showToast");

						toastEvent.setParams({
							title: "Error!",
							message: "Share Percentage is required to fill when role Shareholder/Controller or Members/Controllers is selected.",
							type: "error"
						});

						toastEvent.fire();
					} else {
						//Added by  chandra against W-004945 to calculate controlling percentage on share percentage change
						if (cmp.get("v.ChangedSharePercentage") != "" && cmp.get("v.ChangedSharePercentage") != undefined) {
							helper.calculateControllingPercentage(cmp, event, helper);
						} else {
							if (cmp.find("sharePercentage").get("v.value") == "") {
								cmp.find("sharePercentage").set("v.value", "0");
							}

							helper.updateAccConRelationship(cmp, event, helper);
						}
						var account = cmp.get("v.personAccount");
						helper.updateAccRecord(cmp, event, account);
						cmp.find("accConRelnForm").submit();

						cmp.set("v.ChangedSharePercentage", "");
					}
				}
			} else {
				if (
					clientType != "Trusts" &&
					clientType != "Clubs/Societies/Associations/Other Informal Bodies" &&
					clientType != "Central Bank or Regulator" &&
					clientType != "Non Profit Companies" &&
					clientType != "Non Profit Organizations (NGO)"
				) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Error!",
						message: "Share percantage should not exceed 100%",
						type: "error"
					});
					toastEvent.fire();
				}
			}
			var ChkUBOField = cmp.get("v.ChkUBOField");
			var taxNumber, taxResidency;

			if (cmp.find("taxNumber") == undefined) {
				taxNumber = null;
			} else {
				taxNumber = cmp.find("taxNumber").get("v.value");
			}
			if (cmp.find("taxResidency") == undefined) {
				taxResidency = null;
			} else {
				taxResidency = cmp.find("taxResidency").get("v.value");
			}

			if (ChkUBOField == "Yes" && taxNumber == null && taxResidency == null) {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: "Please Enter Tax Number & Tax Residency Fields",
					type: "error"
				});
				//toastEvent.fire();
				//return;
			}

			var account = cmp.get("v.personAccount");
			helper.updateAccRecord(cmp, event, account);
			cmp.find("accConRelnForm").submit();
		}
		//TdB - Surety validation
		else {
			if (
				personAccRecord.LastName != null &&
				personAccRecord.LastName != "" &&
				personAccRecord.LastName != undefined &&
				((personAccRecord.PersonEmail != null && personAccRecord.PersonEmail != "" && personAccRecord.PersonEmail != undefined) ||
					(personAccRecord.Phone != null && personAccRecord.Phone != "" && personAccRecord.Phone != undefined))
			) {
				console.log("In validation if - " + personAccRecord);
				validationFlag = true;
			} else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: "Please fill all required fields.",
					type: "error"
				});
				toastEvent.fire();
			}

			if (selectedOptionValue == undefined || selectedOptionValue == null || selectedOptionValue == "") {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: "Please select a Role",
					type: "error"
				});

				toastEvent.fire();
				return;
			}

			helper.updateAccConRelationship(cmp, event, helper);

			var account = cmp.get("v.personAccount");
			helper.updateAccRecord(cmp, event, account);
			cmp.find("accConRelnForm").submit();
		}
	},
	//Newly added by Rajesh for delete functionality
	confirmDeleteAction: function (component, event, helper) {
		component.set("v.showDeleteRelationshipConfirmation", false);
		helper.deleteRelationship(component, event);
	},
	//Newly added by Rajesh for delete functionality
	cancelDeleteAction: function (component, event, helper) {
		component.set("v.showDeleteRelationshipConfirmation", false);
	},
	//W: 004009 added by Saurabh for fatca functionality
	assignCheckboxValue: function (component, event, helper) {
		var processType = cmp.get("v.processTyperp");

		if (processType != "Surety Onboarding") {
			var nonFinaceCheck = component.find("isNonFinacialEntityCheck").get("v.value");
			var isTaxedOutsideSA = component.find("isTaxResidentOutsideSA").get("v.value");
			if (nonFinaceCheck) {
				component.find("isNonFinanceEntity").set("v.value", nonFinaceCheck);
			}
			if (isTaxedOutsideSA) {
				component.find("isTaxedOutsideSA").set("v.value", nonFinaceCheck);
			}
		}
	},
	//W: 004009 added by Saurabh for fatca functionality
	handleSectionToggle: function (component, event, helper) {
		var processType = component.get("v.processTyperp");

		if (processType != "Surety Onboarding") {
			//check for sharing percentage when you toggle the fatca section
			var shareValue = component.find("sharePercentage").get("v.value");
			if (shareValue >= 10) {
				component.set("v.showFatcaSection", true);
			}
		}
	},

	handleAddressRowAction: function (component, event, helper) {
		component.set("v.isRefreshPage", true);
		var action = event.getParam("action");

		if (action.name == "edit_address") {
			var row = event.getParam("row");
			var editRecordEvent = $A.get("e.force:editRecord");
			editRecordEvent.setParams({
				recordId: row.Id
			});
			editRecordEvent.fire();
		}
	},
	refreshAll: function (component, event, helper) {
		var isError = component.get("v.isError");
		var isFromEdit = component.get("v.isRefreshPage");

		if (isFromEdit == undefined) {
			isFromEdit = false;
		}

		if (isFromEdit && isError) {
			component.set("v.isRefreshPage", false);
			var rowId = component.get("v.recordIdAccountContactEdited");
			var ChkUBOField = component.get("v.ChkUBOField");

			helper.fetchAddressList2(component, event, rowId);
		}

		component.set("v.isError", true);
	},
	handleAddAddress: function (component, event, helper) {
		component.set("v.showAddressForm", true);
	},
	handleCancel: function (component, event, helper) {
		component.set("v.showAddressForm", false);
	},
	handleSubmitAddress: function (cmp, event, helper) {
		var personAcc = cmp.get("v.personAccount");
		console.log("personAcc " + JSON.stringify(personAcc));
		event.preventDefault(); // stop the form from submitting
		const fields = event.getParam("fields");

		if (personAcc != null && personAcc != undefined) {
			fields.Account__c = personAcc.Id; // modify a field
		}

		cmp.find("myRecordForm").submit(fields);
	},
	handleSuccessAddCreate: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			message: "Address created successfully..!",
			type: "success"
		});
		toastEvent.fire();
		component.set("v.showAddressForm", false);
		helper.fetchAddressList2(component, event, component.get("v.recordIdAccountContactEdited"));
	},
	handleChangeCountryOfCitzn: function (component, event, helper) {
		var slectedVal = component.get("v.countryOfCitizenShip");

		var personAccount = component.get("v.personAccount");
		personAccount.Country_of_Citizenship__c = slectedVal.join(";");
		component.set("v.personAccount", personAccount);
	},
	handleSharePercentChange: function (component, event, helper) {
		var share = event.getSource().get("v.value");
		component.set("v.ChangedSharePercentage", share); //Added by Chandra 07152020 against 4945
		//commented by chandra since ubo decide on the basis of controlling percentage
		/*if(share >= 10){
            component.find("uboFld").set("v.value",'Yes');
        }else{
            component.find("uboFld").set("v.value",'No');
        }*/
	},

	/****************@ Author: Chandra****************************************
	 ****************@ Date: 06/07/2020****************************************
	 ****************@ Work Id: W-004939***************************************
	 ***@ Description: Method Added by chandra to handle Roles selection*******/
	handleChange: function (component, event, helper) {
		var processType = component.get("v.processTyperp");

		if (processType != "Surety Onboarding") {
			var selectedOptionValue = event.getParam("value");
			if (
				selectedOptionValue.includes("Shareholder/Controller") ||
				selectedOptionValue.includes("Members/Controllers") ||
				selectedOptionValue.includes("Partner/Controller") ||
				selectedOptionValue.includes("Named Beneficiaries") ||
				selectedOptionValue.includes("Trustees")
			) {
				component.find("sharePercentage").set("v.disabled", false);
			} else {
				component.find("sharePercentage").set("v.value", "");
				component.find("sharePercentage").set("v.disabled", true);
			}

			//TdB - Set Participant Indicator
			if (selectedOptionValue.includes("Participant")) {
				component.set("v.isParticipant", true);
				component.set("v.newIndivProspect.Client_Group__c", "Individual");
			} else {
				component.set("v.isParticipant", false);
			}

			//TdB - Set Occupation section to show based on Role
			if (
				selectedOptionValue.includes("Operators on primary accounts ( Internet Main Users, Signatories, Card Users)") ||
				selectedOptionValue.includes("Operators on primary accounts (Internet Main Users,Signatories,Card users)")
			) {
				component.set("v.isOperatingRole", true);
			} else {
				component.set("v.isOperatingRole", false);
			}
		}
	},

	/** TdB - Set additional Occupation fields **/
	setOccupationFields: function (component, event, helper) {
		var occupationStatusValue = component.find("iOccupationStatus").get("v.value");

		if (
			occupationStatusValue == "Full Time Employed" ||
			occupationStatusValue == "Part Time Employed" ||
			occupationStatusValue == "Self Employed Professional" ||
			occupationStatusValue == "Self Employed-Non-Professional" ||
			occupationStatusValue == "Temporary Employed"
		) {
			component.set("v.isEmployed", true);
		} else {
			component.set("v.isEmployed", false);
		}
	},

	/****************@ Author: Chandra****************************************
	 ****************@ Date: 25/08/2020****************************************
	 ****************@ Work Id: W-004746***************************************
	 ***@ Description: Method Added by chandra to set Client Type*************/
	setClientType: function (component, event, helper) {
		var methodParam = event.getParam("arguments");
		var clientTypeChangedVal;

		if (methodParam) {
			clientTypeChangedVal = methodParam.clientTypeVal; //params

			console.log("setClientType OnboardingRelatedParties : " + clientTypeChangedVal);

			component.set("v.accountClientType", clientTypeChangedVal);
		}
	},

	closeCasaReferenceScreen: function (component, event, helper) {
		component.set("v.showCASAReferenceEntry", false);
	},

	openCasaReferenceScreen: function (component, event, helper) {
		console.log("Acc Id : " + component.get("v.accRecordId"));
		component.set("v.showCASAReferenceEntry", true);
	},

	loadRelatedParties: function (component, evt, helper) {
		var accId = component.get("v.accRecId");
		var casaReference = component.find("casaReferenceNumber").get("v.value");
		console.log("casaReference---->" + casaReference);
		console.log("accId---->" + accId);

		var action = component.get("c.getRelatedPartyListByPrimaryRefNo");
		action.setParams({
			accRecId: accId,
			CasaRefNumber: casaReference
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var returnValue = response.getReturnValue();
			console.log("state---->" + state);
			component.set("v.showCASAReferenceEntry", false);
		});
		$A.enqueueAction(action);
		component.set("v.showCASAReferenceEntry", false);
	},

	//TdB: display Reason for not providing SA TAX Number
	showReasonForTaxNA: function (component, event, helper) {
		var reasonForTaxNA = component.find("reasonForTaxNA");
		if (event.getSource().get("v.checked") == false) {
			component.set("v.showNoTaxReason", true);
		} else {
			component.set("v.showNoTaxReason", false);
		}
	},

	//TdB: display Country For Foreign Tax
	showCountryForeignTax: function (component, event, helper) {
		var countryForeignTax = component.find("registeredForeignTax");
		if (event.getSource().get("v.checked") == true) {
			component.set("v.showCountryForeignTax", true);
		} else {
			component.set("v.showCountryForeignTax", false);
		}
	},

	//TdB : display FAIS details
	handleCheckboxChange: function (component, event, helper) {
		if (event.getSource().get("v.value") == true) {
			component.set("v.showFsp", true);
		} else {
			component.set("v.showFsp", false);
		}
	},

	//TdB : Update Account Account Relationship
	updateAccAccRecord: function (component, event, helper) {
		event.preventDefault(); // stop the form from submitting
		component.set("v.showSpinner", true);
		const fields = event.getParam("fields");
		var recordId = component.get("v.recordIdAccountAccountEdited");
		var sharePercentage = fields.Shareholding_Percentage__c;
		var roles = fields.Roles__c;
		helper.updateAccAccRelationship(component, event, helper, recordId, sharePercentage, roles);
	},

	handleChangeOperatingRole: function (component, event, helper) {
		var selectedOperatingRole = component.get("v.personAccount.Operating_Roles__c");

		if (selectedOperatingRole != undefined && selectedOperatingRole.includes("Mandate & Indemnity User")) {
			component.set("v.isMandatIndemnityUser", true);
		} else {
			component.set("v.isMandatIndemnityUser", false);
		}
	},

	handleTempResidentSection: function (component, event, helper) {
		if (event.getSource().get("v.checked") == true) {
			component.set("v.showTempResidentSection", true);
		} else {
			component.set("v.showTempResidentSection", false);
		}
	}
});
({
	getLoggedInUserDetailsHelper: function (component, event, helper) {
		component.set("v.isSpinner", true);
		component.set("v.errorMessage", null);
		var action = component.get("c.getLoggedInUserDetails");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				component.set("v.userRecord", resp);
				helper.getBeneficiaryListMapHelper(component, event, helper);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in getLoggedInUserDetailsHelper method. Error: " + JSON.stringify(errors));
				component.set("v.isSpinner", false);
			} else {
				component.set("v.errorMessage", "Unknown error in getLoggedInUserDetailsHelper method. State: " + state);
				component.set("v.isSpinner", false);
			}
		});
		$A.enqueueAction(action);
	},

	getCombiAccountListHelper: function (component, event, helper) {
		var action = component.get("c.getAccountDetails");
		var clientAccountId = component.get("v.recordId");
		action.setParams({
			clientAccountId: clientAccountId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				if (responseValue.startsWith("Error: ")) {
					// error
					component.set("v.errorMessage", responseValue);
				} else {
					// success
					var accList = [];
					var respObj = JSON.parse(responseValue);

					for (var key in respObj) {
						if (respObj[key].productType == "CO") {
							accList.push(respObj[key].oaccntnbr);
						}
						component.set("v.combiAccList", accList);
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error CIGetAccountLinkedToClientCodeController.getAccountDetails: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},

	addBeneficiary: function (component) {
		var accountId = component.get("v.recordId");
		var selectedAccount = component.get("v.selectedCombiValue");
		var sourceAccType = component.get("v.accountNumberType");
		var beneficiaryName = component.get("v.beneficiaryName");
		var accountNumber = component.get("v.targetAccount");
		var sourceRef = component.get("v.sourceRef");
		var targetRef = component.get("v.targetRef");
		var accountType = component.find("iselectAccType").get("v.value");
		var branchCodeId = component.get("v.selectedBranchCodeId");
		var loggedInUser = component.get("v.userRecord");
		var srcAccNumber = component.get("v.accountNumber");

		if (beneficiaryName && branchCodeId && accountType && accountNumber && sourceRef && targetRef) {
			component.set("v.isRequiredFieldsMissing", false);
		} else {
			component.set("v.isRequiredFieldsMissing", true);
			return;
		}

		var action = component.get("c.addBeneficiaryRecord");

		action.setParams({
			selectedAccount: selectedAccount,
			sourceAccType: sourceAccType,
			beneficiaryName: beneficiaryName,
			accountType: accountType,
			branchCodeId: branchCodeId,
			accountNumber: accountNumber,
			sourceRef: sourceRef,
			targetRef: targetRef,
			userRecord: loggedInUser
		});

		// Add callback behavior for when response is received
		action.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					var toast = this.getToast("Error!", "Unable to add beneficiary, Please try again later", "Error");
					toast.fire();
					component.set("v.errorMessage", responseData);
				} else {
					var toast = this.getToast("Success!", "Beneficiary successfully added", "Success");
					toast.fire();

					/*  var ivrBeneficiaryCheckbox = component.get("v.ivrBeneficiaryCheckbox");
                    console.log('responseData***', responseData);
                    console.log('ivrBeneficiaryCheckbox***', ivrBeneficiaryCheckbox);
                    console.log('ivrCode***', component.get("v.ivrCode"));
                    console.log('tieb***', component.get("v.tieb"));

                    if(ivrBeneficiaryCheckbox){
                        var updateAction = component.get("c.updateIVRBeneficiary");
                        updateAction.setParams({
                            accId: accountId,
                            instrNo: responseData.instrNo,
                            beneficiaryName: beneficiaryName,
                            srcAccNumber: srcAccNumber,
                            srcAccType: sourceAccType,
                            trgAccType: accountType,
                            trgAccNumber: accountNumber,
                            trgBranchCodeId: branchCodeId,
                            srcRef: sourceRef,
                            trgRef: targetRef,
                            ivrCustNo: component.get("v.ivrCode"),
                            tieb: component.get("v.tieb")
                        });
                    } */

					// Refresh table after update
					var a = component.get("c.handleLoad");
					$A.enqueueAction(a);
				}

				component.set("v.isEditBeneficiaryOpen", false);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error BeneficiaryMaintenance.addBeneficiaryRecord: " + JSON.stringify(errors[0].messages));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			component.set("v.isSpinner", false);
		});

		// Send action off to be executed
		$A.enqueueAction(action);
	},

	handleClickUpdate: function (component, helper, instrNo) {
		component.set("v.instrNo", instrNo);
		component.set("v.isEditBeneficiaryOpen", true);
		console.log("instrNo : " + instrNo);
		console.log(component.get("v.branchCode"));
		console.log(component.get("v.selectedBankName"));

		//Get beneficiary from Map
		var allBeneficiaries = component.get("v.mapValues");
		var selectedBeneficiary;

		console.log(component.get("v.selectedBankId"));
		console.log(component.get("v.selectedBranchCodeId"));

		for (var key in allBeneficiaries) {
			if (component.get("v.mapValues")[key].key == instrNo) {
				selectedBeneficiary = component.get("v.mapValues")[key].value;
				if (selectedBeneficiary[0] && selectedBeneficiary[0] > 0) {
					component.set("v.ivrBeneficiaryCheckbox", true);
					component.find("ivrBeneficiary").set("v.disabled", true);
				} else {
					component.set("v.ivrBeneficiaryCheckbox", false);
					component.find("ivrBeneficiary").set("v.disabled", false);
				}
				component.set("v.ivrCode", selectedBeneficiary[0]);
				component.set("v.beneficiaryName", selectedBeneficiary[1]);
				component.set("v.bankName", selectedBeneficiary[2]);
				component.set("v.targetAccount", selectedBeneficiary[3]);
				component.set("v.sourceRef", selectedBeneficiary[4]);
				component.set("v.targetRef", selectedBeneficiary[5]);
				component.set("v.tieb", component.get("v.tiebMap")[key].value);
				break;
			}
		}

		//Get Bank and Branch Record based on Branch Code terurned from service
		var getBenListAction = component.get("c.getBankIdByName");
		var bankNameVal = component.get("v.bankName");

		getBenListAction.setParams({
			bankName: bankNameVal
		});

		getBenListAction.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();

				if (state === "SUCCESS") {
					var result = response.getReturnValue();

					if (result != null) {
						//Set Bank Name and Branch
						component.set("v.selectedBankId", result.Bank__c);
						component.set("v.selectedBranchCodeId", result.Id);
						component.set("v.selectedBranchCodeName", result.Name);
					} else {
						//Set Bank Name and Branch
						component.set("v.selectedBankId", null);
						component.set("v.selectedBranchCodeId", null);
						component.set("v.selectedBranchCodeName", null);
					}

					// Refresh table after update
					var a = component.get("c.handleLoad");
					$A.enqueueAction(a);

					component.set("v.isSpinner", false);
				} else if (state === "ERROR") {
					var toast = helper.getToast("Error", "There was an error retrieving the list of beneficiaries for this Account", "error");

					component.set("v.isSpinner", false);

					toast.fire();
				}
			})
		);

		$A.enqueueAction(getBenListAction);
	},

	handleClickRemove: function (component, helper, instrNo) {
		component.set("v.instrNo", instrNo);
		component.set("v.isRemoveBeneficiaryOpen", true);
	},

	getBeneficiaryListMapHelper: function (component, event, helper) {
        component.set("v.isSpinner", true);
		var action = component.get("c.getEBSBeneficiaries");
		action.setParams({
			cifKey: component.find("cifKeyField").get("v.value"),
			sourceAccount: component.get("v.accountNumber")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var arrayMapKeys = [];
				var tiebMap = [];
				var maxIVRCode = 0;

				if (result["Exception"] != null) {
					component.set("v.errorMessage", result["Exception"].join(", "));
				} else {
					for (var key in result) {
						if (key == "instructionTable") {
							component.set("v.instructionTableList", result[key]); //DBOOYSEN 14/04/2021. W-008297
						} else {
							let resultString = String(result[key]);
							let resultArray = resultString.split(",");
							if (Number(resultArray[0]) != "" && Number(resultArray[0]) > maxIVRCode) {
								maxIVRCode = Number(resultArray[0]);
							}

						tiebMap.push({ key: key, value: resultArray[6] });
						resultArray.splice(6, 1);
						arrayMapKeys.push({ key: key, value: resultArray });
						}
					}
					component.set("v.maxIVRCode", maxIVRCode);
					component.set("v.mapValues", arrayMapKeys);
					component.set("v.tiebMap", tiebMap);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in getBeneficiaryListMapHelper method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in getBeneficiaryListMapHelper method. State: " + state);
			}
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},

	//function called to generate and retrieve the the Beneficiary List document
	sendBeneficiaryListHelper: function (component, event, helper) {
		component.set("v.isModalSpinner", true);

		var action = component.get("c.getBeneficiaryData");
		action.setParams({
			beneficiaryListString: JSON.stringify(component.get("v.instructionTableList")),
			documentTemplateName: "IVR Beneficiary List",
			accountId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var dataSet = response.getReturnValue();
			console.log("sendBeneficiaryListHelper resp: " + dataSet);
			var state = response.getState();
			if (state === "SUCCESS") {
				if (!$A.util.isEmpty(dataSet) && !dataSet.startsWith("Error:")) {
					//Send email functionality
					component.set("v.isFormReadOnly", true);
					helper.sendEmailHelper(
						component,
						event,
						helper,
						dataSet,
						component.get("v.clientEmailAddress"),
						"Beneficiary List",
						"IVR_Beneficiary_List"
					);
				} else {
					component.set("v.errorMessage", "Apex Error BeneficiaryMaintenance.getBeneficiaryData: " + dataSet);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error BeneficiaryMaintenance.getBeneficiaryData: " + JSON.stringify(errors));
			} else {
				var toast = helper.getToast("Error", "Unexpected error occurred, BeneficiaryMaintenance.getBeneficiaryData state returned: " + state, "error");
				toast.fire();
			}
			component.set("v.isModalSpinner", false);
		});
		$A.enqueueAction(action);
	},

	//function that send an email from apex
	sendEmailHelper: function (component, event, helper, attachment, emailTo, documentName, emailTemplate) {
		component.set("v.isModalSpinner", true);

		var action = component.get("c.sendBeneficiaryList");
		action.setParams({
			caseId: component.get("v.caseRecordIdFromFlow"),
			emailAddress: emailTo,
			emailTemplateName: emailTemplate,
			pdfData: attachment,
			docName: documentName
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp.startsWith("Error:")) {
					component.set("v.isFormReadOnly", false);
					component.set("v.errorMessageModal", resp);
					var toast = helper.getToast("Error!", resp, "error");
					toast.fire();
				} else {
					//Success
					var toast = helper.getToast("Success!", resp, "success");
					toast.fire();
					helper.closeSendBeneficiaryListModalHelper(component, event, helper);
					//Close Case on success of email sent
					component.find("caseStatusFieldModal").set("v.value", "Closed");
					component.find("caseEditFormModal").submit();
				}
			} else if (state === "ERROR") {
				component.set("v.isFormReadOnly", false);
				var errors = response.getError();
				component.set("v.errorMessageModal", "Apex error BeneficiaryMaintenance: " + JSON.stringify(errors));
			} else {
				component.set("v.isFormReadOnly", false);
				var toast = helper.getToast("Error", "Unexpected error occurred, BeneficiaryMaintenance state returned: " + state, "error");
				toast.fire();
			}
			component.set("v.isModalSpinner", false);
		});
		$A.enqueueAction(action);
	},

	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		return toastEvent;
	},

	//Open Modal (sendBeneficiaryPaymentHistoryModal)
	openSendBeneficiaryListModalHelper: function (component, event, helper) {
		component.set("v.openSendBeneficiaryListModal", true);
	},

	//Close Modal (sendBeneficiaryPaymentHistoryModal)
	closeSendBeneficiaryListModalHelper: function (component, event, helper) {
		component.set("v.openSendBeneficiaryListModal", false);
	}
});
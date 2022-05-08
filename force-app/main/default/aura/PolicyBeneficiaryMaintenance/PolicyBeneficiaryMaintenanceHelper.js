({
	/****************@ Author: Chandra***************************************
	 ****************@ Date: 15/10/2020**************************************
	 ****************@ Work Id: W-006912*************************************
	 ***@ Description: Method Added by chandra to get Beneficiary List*******/

	getBeneficiaryDetailList: function (component, event, helper) {
		var action = component.get("c.getBeneficiaryDetails");
		action.setParams({
			policyNumber: component.get("v.policyNumberFromFlow"),
			roleTypes: ["Beneficiary"]
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var rolePlayersDetails = [];
				var beneficiaryData = [];
				var data = [];

				if (
					result != null &&
					result.LAlistPolicyDetailsbyPolicyNumberV7Response != null &&
					result.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o != null &&
					result.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails != null
				) {
					rolePlayersDetails = result.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails;
					component.set("v.serviceResponse", result.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o);
				}

				rolePlayersDetails.forEach(function (item) {
					beneficiaryData.push(item);
					data.push({
						firstName: item.firstName,
						surname: item.surname,
						relationshipCode: item.relationshipCode,
						percentSplit: item.percentSplit,
						lifeClientCode: item.lifeClientCode,
						idType: item.idType,
						idNumber: item.idNumber,
						emailAddress: item.emailAddress,
						dateOfBirth: item.dateOfBirth,
						titleCode: item.titleCode,
						addressLine1: item.addressLine1,
						addressLine2: item.addressLine2,
						suburb: item.suburb,
						city: item.city,
						postalCode: item.postalCode,
						contactTelephoneNumber: item.contactTelephoneNumber
					});
				});
				component.set("v.data", data);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in getBeneficiaryDetailList method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in getBeneficiaryDetailList method. State: " + state);
			}
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 15/10/2020**************************************
	 ****************@ Work Id: W-006912*************************************
	 ***@ Description: Method Added by chandra to save edit percentage********/
	saveEditPercentage: function (component, event, helper) {
		component.set("v.showMaintainBeneficiaryPercentMsg", false);
		component.set("v.showSubmitBeneficiary", true);
		var datatable = component.find("policyBeneficiaryData");
		datatable.set("v.suppressBottomBar", true);
	},

	/****************@ Author: Chandra****************************************
	 ****************@ Date: 08/07/2020****************************************
	 ****************@ Work Id: W-006901,007778********************************
	 ***@ Description: Method Added by chandra to show edit modal for update**/

	showEditModal: function (component, row) {
		var selectedProductType = component.get("v.selectedProductTypeFromFlow"); // Added by chandra dated 15/02/2021
		if (selectedProductType != "LX") {
			$A.createComponent(
				"c:AddUpdatePolicyBeneficiaryDetails",
				{
					firstName: row.firstName,
					surName: row.surname,
					relationshipCode: row.relationshipCode,
					idType: row.idType,
					idNumber: row.idNumber,
					emailAddress: row.emailAddress,
					contactTelephoneNumber: row.contactTelephoneNumber,
					lifeClientCode: row.lifeClientCode,
					percentSplit: row.percentSplit,
					dateOfBirth: row.dateOfBirth,
					titleCode: row.titleCode,
					addressLine1: row.addressLine1,
					addressLine2: row.addressLine2,
					suburb: row.suburb,
					city: row.city,
					postalCode: row.postalCode,
					actionType: "Edit"
				},
				function (content, status) {
					if (status === "SUCCESS") {
						component.find("overlayLib").showCustomModal({
							header: "Edit Beneficiary Details",
							body: content,
							showCloseButton: true,
							cssClass: "mymodal",
							closeCallback: function () {}
						});
					}
				}
			);
		} else {
			// Added by chandra dated 15/02/2021
			$A.createComponent(
				"c:AddUpdatePolicyBeneficiaryDetails",
				{
					firstName: row.firstName,
					surName: row.surname,
					relationshipCode: row.relationshipCode,
					idType: row.idType,
					idNumber: row.idNumber,
					emailAddress: row.emailAddress,
					contactTelephoneNumber: row.contactTelephoneNumber,
					lifeClientCode: row.lifeClientCode,
					percentSplit: row.percentSplit,
					dateOfBirth: row.dateOfBirth,
					titleCode: row.titleCode,
					addressLine1: row.addressLine1,
					addressLine2: row.addressLine2,
					suburb: row.suburb,
					city: row.city,
					postalCode: row.postalCode,
					contactTypeID: row.contactTypeID,
					clientGID: row.clientGID,
					selectedProductType: selectedProductType,
					actionType: "Edit"
				},
				function (content, status) {
					if (status === "SUCCESS") {
						component.find("overlayLib").showCustomModal({
							header: "Edit Beneficiary Details",
							body: content,
							showCloseButton: true,
							cssClass: "mymodal",
							closeCallback: function () {}
						});
					}
				}
			);
		}
	},

	/****************@ Author: Chandra***********************************************
	 ****************@ Date: 08/07/2020***********************************************
	 ****************@ Work Id: W-006280,007783***************************************
	 ***@ Description: Method Added by chandra to show add modal to add beneficiary**/

	showAddModal: function (component) {
		var selectedProductType = component.get("v.selectedProductTypeFromFlow"); // Added by chandra dated 14/02/2021
		if (selectedProductType != "LX") {
			$A.createComponent("c:AddUpdatePolicyBeneficiaryDetails", { actionType: "Add" }, function (content, status) {
				if (status === "SUCCESS") {
					component.find("overlayLib").showCustomModal({
						header: "Add Beneficiary",
						body: content,
						showCloseButton: true,
						cssClass: "mymodal",
						closeCallback: function () {}
					});
				}
			});
		} else {
			// Added by chandra dated 14/02/2021
			$A.createComponent(
				"c:AddUpdatePolicyBeneficiaryDetails",
				{ actionType: "Add", selectedProductType: selectedProductType },
				function (content, status) {
					if (status === "SUCCESS") {
						component.find("overlayLib").showCustomModal({
							header: "Add Beneficiary",
							body: content,
							showCloseButton: true,
							cssClass: "mymodal",
							closeCallback: function () {}
						});
					}
				}
			);
		}
	},

	/****************@ Author: Prashant******************************
	 ****************@ Date: 24/10/2020******************************
	 ****************@ Work Id: W-006280*****************************
	 ***@ Description: Method Added to convert list to map**********/

	convertListToMapWithStringKey: function (listToConvert, key) {
		var result = listToConvert.reduce(function (map, obj) {
			map[obj[key]] = obj;
			return map;
		}, {});
		return result;
	},

	/****************@ Author: Prashant****************************************************
	 ****************@ Date: 24/10/2020****************************************************
	 ****************@ Work Id: W-006280,006906,006901,006929*****************************
	 ***@ Description: Method Added to call LAUpdateBeneficiaryDetailsV2 service**********/

	callLAUpdateBeneficiaryDetailsV2: function (component, event, helper, requestBean) {
		var action = component.get("c.LAUpdateBeneficiaryDetailsV2");
		action.setParams({
			jsonString: JSON.stringify(requestBean)
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp && resp.LAupdateBeneficiaryDetailsV2Response && resp.LAupdateBeneficiaryDetailsV2Response.la950p9o) {
					if (!resp.LAupdateBeneficiaryDetailsV2Response.la950p9o.responseNumber) {
						component.set("v.pendingAction", null);
						component.set("v.pendingRow", null);
						helper.fireToastEvent("Success!", "Beneficiary details submitted successfully!!", "success");
						component.find("addBeneficiary").set("v.disabled", false);
						var columns = component.get("v.columns");
						columns[4].typeAttributes.disabled = false;
						columns[5].typeAttributes.disabled = false;
						component.set("v.columns", columns);
					} else {
						component.set("v.showRefreshButton", true);
						helper.fireToastEvent(
							"Error!",
							"Error during submitting Beneficiary details. Error: " + resp.LAupdateBeneficiaryDetailsV2Response.la950p9o.responseDescription,
							"error"
						);
					}
				} else {
					component.set("v.showRefreshButton", true);
					component.set(
						"v.errorMessage",
						"Unexpected response received from callLAUpdateBeneficiaryDetailsV2 service. Response: " + JSON.stringify(resp)
					);
				}
			} else if (state === "ERROR") {
				component.set("v.showRefreshButton", true);
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in callLAUpdateBeneficiaryDetailsV2 method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in callLAUpdateBeneficiaryDetailsV2 method. State: " + state);
			}
			component.set("v.showSubmitBeneficiary", false);
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 15/10/2020**************************************
	 ****************@ Work Id: W-006912*************************************
	 ***@ Description: Method Added by chandra for Lightning toastie********/

	fireToastEvent: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	/****************@ Author: Chandra***************************************************
	 ****************@ Date: 10/02/2021**************************************************
	 ****************@ Work Id: W-007776*************************************************
	 ***@ Description: Method Added by chandra to get Beneficiary List for Exergy*******/

	getBeneficiaryDetailListForExergy: function (component, event, helper) {
		var action = component.get("c.getBeneficiaryDetailsForExergy");
		action.setParams({
			policyNumber: component.get("v.policyNumberFromFlow")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var reducedV3DC2ClientRoles = [];
				var beneficiaryData = [];
				var data = [];

				if (
					result != null &&
					result.Policy_LoadByRefNoResponse != null &&
					result.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult != null &&
					result.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts != null &&
					result.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract != null &&
					result.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.ClientRoles != null &&
					result.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.ClientRoles.V3_DC2ClientRole != null
				) {
					reducedV3DC2ClientRoles = result.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.ClientRoles.V3_DC2ClientRole;
					component.set("v.serviceResponse", result.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult);
				}

				var serviceResponse = component.get("v.serviceResponse");

				reducedV3DC2ClientRoles.forEach(function (item) {
					beneficiaryData.push(item);
					var idType,
						idNumber,
						emailAddress,
						dateOfBirth,
						titleCode,
						addressLine1,
						addressLine2,
						suburb,
						city,
						postalCode,
						contactTelephoneNumber,
						clientGID,
						contactTypeID,
						initials;
					var updatedTelephoneDateTime, updatedAddressDateTime;

					if (serviceResponse != undefined && serviceResponse.Clients != undefined && serviceResponse.Clients.V3_DC2Client != undefined) {
						var clientAddresses = serviceResponse.Clients.V3_DC2Client;
					}
					clientGID = item.ClientGID;
					clientAddresses.forEach(function (itemclientAddresses) {
						if (
							itemclientAddresses != undefined &&
							itemclientAddresses.Addresses != undefined &&
							itemclientAddresses.Addresses.V3_DC2Address != undefined
						) {
							var addresses = itemclientAddresses.Addresses.V3_DC2Address;
							var latestAddress = helper.getLatestItem(component, addresses, clientGID);

							if (latestAddress != undefined) {
								addressLine1 = latestAddress.AddressLine1;
								addressLine2 = latestAddress.AddressLine2;
								city = latestAddress.Town;
								suburb = latestAddress.Suburb;
								postalCode = latestAddress.Zip_PostalCode;
								emailAddress = latestAddress.Address;
							}

							dateOfBirth = itemclientAddresses.DateOfBirth;
							titleCode = itemclientAddresses.TitleID;
							initials = itemclientAddresses.Initials;
							if (itemclientAddresses.Identifiers != undefined && itemclientAddresses.Identifiers.DC2Identifier != undefined) {
								var identifiers = itemclientAddresses.Identifiers.DC2Identifier;
								identifiers.forEach(function (identifier) {
									if (identifier.ClientGID == clientGID && identifier.IdentifierTypeID == "SA Identity Document") {
										idNumber = identifier.Description;
										idType = identifier.IdentifierTypeID;
									}
								});
							}

							if (itemclientAddresses.Telephones != undefined && itemclientAddresses.Telephones.DC2Telephone != undefined) {
								var telephones = itemclientAddresses.Telephones.DC2Telephone;
								var latestTelephoneDetail = helper.getLatestItem(component, telephones, clientGID);

								if (latestTelephoneDetail != undefined) {
									contactTelephoneNumber = latestTelephoneDetail.TelLocal;
									contactTypeID = latestTelephoneDetail.CommunicationTypeTelephoneID;
								}
							}
						}
					});
					data.push({
						firstName: item.BeneficiaryDetail.Name,
						surname: item.BeneficiaryDetail.Surname,
						relationshipCode: item.ReleationShipID,
						percentSplit: item.BeneficiaryDetail.Percentage,
						idType: idType != "undefined" ? idType : "",
						idNumber: idNumber != "undefined" ? idNumber : "",
						emailAddress: emailAddress != "undefined" ? emailAddress : "",
						dateOfBirth: dateOfBirth != "undefined" ? dateOfBirth : "",
						titleCode: titleCode != "undefined" ? titleCode : "",
						addressLine1: addressLine1 != "undefined" ? addressLine1 : "",
						addressLine2: addressLine2 != "undefined" ? addressLine2 : "",
						suburb: suburb != "undefined" ? suburb : "",
						city: city != "undefined" ? city : "",
						postalCode: postalCode != "undefined" ? postalCode : "",
						contactTelephoneNumber: contactTelephoneNumber != "undefined" ? contactTelephoneNumber : "",
						initials: initials != "undefined" ? initials : "",
						contactTypeID: contactTypeID != "undefined" ? contactTypeID : "",
						clientGID: clientGID != "undefined" ? clientGID : ""
					});
				});
				component.set("v.data", data);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in getBeneficiaryDetailsForExrergy method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in getBeneficiaryDetailsForExrergy method. State: " + state);
			}
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra****************************************************
	 ****************@ Date: 11/02/2021***************************************************
	 ****************@ Work Id: W-007772,007778,007777,007783*****************************
	 ***@ Description: Method Added to call contractCaptureBeneficiary service***********/

	callContractCaptureBeneficiary: function (component, event, helper, requestBean) {
		var action = component.get("c.contractCaptureBeneficiary");
		action.setParams({
			jsonString: JSON.stringify(requestBean)
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp && resp.Contract_Capture_BeneficaryResponse) {
					if (resp.Contract_Capture_BeneficaryResponse.Contract_Capture_BeneficaryResult == "1") {
						component.set("v.pendingAction", null);
						component.set("v.pendingRow", null);
						helper.fireToastEvent("Success!", "Beneficiary details submitted successfully!!", "success");
						component.find("addBeneficiary").set("v.disabled", false);
						var columns = component.get("v.columns");
						columns[4].typeAttributes.disabled = false;
						columns[5].typeAttributes.disabled = false;
						component.set("v.columns", columns);
					} else if (
						resp.Contract_Capture_BeneficaryResponse.Contract_Capture_BeneficaryResult == "0" &&
						resp.Contract_Capture_BeneficaryResponse.V3_DC2_LoggedMsg.Message != null
					) {
						component.set("v.showRefreshButton", true);
						helper.fireToastEvent(
							"Error!",
							"Error during submitting Beneficiary details. Error Messages: " + resp.Contract_Capture_BeneficaryResponse.V3_DC2_LoggedMsg.Message,
							"error"
						);
					} else if (
						resp.Contract_Capture_BeneficaryResponse.Contract_Capture_BeneficaryResult == "0" &&
						resp.Contract_Capture_BeneficaryResponse.V3_DC2_LoggedMsg.Message == null
					) {
						component.set("v.showRefreshButton", true);
						helper.fireToastEvent("Error!", "Error during submitting Beneficiary details. Please contact System Admin.", "error");
					}
				} else {
					component.set("v.showRefreshButton", true);
					component.set(
						"v.errorMessage",
						"Unexpected response received from callContractCaptureBeneficiary service. Response: " + JSON.stringify(resp)
					);
				}
			} else if (state === "ERROR") {
				component.set("v.showRefreshButton", true);
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in callContractCaptureBeneficiary method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in callContractCaptureBeneficiary method. State: " + state);
			}
			component.set("v.showSubmitBeneficiary", false);
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra*********************************************
	 ****************@ Date: 11/02/2021********************************************
	 ****************@ Work Id: W-007772,007778,007777,007783**********************
	 ***@ Description: Method Added to get SessionId******************************/

	getSessionId: function (component, event, helper, requestBean) {
		var action = component.get("c.getSessionGID");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				component.set("v.exergySessionId", resp);
			} else if (state === "ERROR") {
				component.set("v.showRefreshButton", true);
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in getSessionGID method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in getSessionGID method. State: " + state);
			}
			component.set("v.showSubmitBeneficiary", false);
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra*************************************
	 ****************@ Date: 11/02/2021************************************
	 ****************@ Work Id: W-007772,007778,007777,007783**************
	 ***@ Description: Method Added to get SessionId**********************/

	getLatestItem: function (component, recordList, clientGID) {
		let latestItem;
		let latestDateTime;
		recordList.forEach(function (item) {
			if (item.ClientGID == clientGID) {
				if (latestDateTime == undefined || item.UpdatedDate > latestDateTime) {
					latestItem = item;
					latestDateTime = item.UpdatedDate;
				}
			}
		});
		return latestItem;
	}
});
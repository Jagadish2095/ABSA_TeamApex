({
	// getCustomerHold method to get active imposed Customer holds data

	getCustomerHold: function (component, event, helper) {
		// Show Spinner Loader
		component.set("v.isShowSpinner", "true");
		var action = component.get("c.getClientHoldDetails");
		// Set the parameters
		action.setParams({
			clientCodeP: component.get("v.currentRecordCIF"),
			accNumberP: "0",
			siteCodeP: component.get("v.currentUserSiteCode")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var jsonResult = JSON.parse(result);

				if (
					jsonResult.clntExstOnFica != "Y" &&
					jsonResult.idRequiredHold != "Y" &&
					jsonResult.curatorshipHold != "Y" &&
					jsonResult.deceasedEstateHld != "Y" &&
					jsonResult.deceasedSpouseHld != "Y" &&
					jsonResult.finCrimeHold != "Y" &&
					jsonResult.postalAddrHold != "Y" &&
					jsonResult.employerAddrHold != "Y" &&
					jsonResult.insolvntEstateHld != "Y" &&
					jsonResult.clntAgrmntIssued != "Y"
				) {
					component.set("v.errorMessage", "No hold imposed!");
				} else {
					if (jsonResult.clntExstOnFica == "Y") {
						component.set("v.ficLock", true);
					}

					if (jsonResult.idRequiredHold == "Y") {
						component.set("v.identificationRequired", true);
					}

					if (jsonResult.curatorshipHold == "Y") {
						component.set("v.curatorship", true);
					}

					if (jsonResult.deceasedEstateHld == "Y") {
						component.set("v.deceasedEstate", true);
					}

					if (jsonResult.deceasedSpouseHld == "Y") {
						component.set("v.spouseDeceased", true);
					}

					if (jsonResult.finCrimeHold == "Y") {
						component.set("v.financialCrime", true);
					}

					if (jsonResult.postalAddrHold == "Y") {
						component.set("v.newPostalAddressRequired", true);
					}

					if (jsonResult.employerAddrHold == "Y") {
						component.set("v.newEmployerNameAddressRequ", true);
					}

					if (jsonResult.insolvntEstateHld == "Y") {
						component.set("v.insolventEstate", true);
					}

					if (jsonResult.clntAgrmntIssued == "Y") {
						component.set("v.clientAgreementIssued", true);
					}

					if (jsonResult.physicalAddrHold == "Y") {
						component.set("v.newResidentialExecutorPhysicalAddressRequired", true);
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error retrieving customer hold", +JSON.stringify(errors));
			}

			// Hide Spinner Loader
			component.set("v.isShowSpinner", "false");
		});
		$A.enqueueAction(action);
	}
});
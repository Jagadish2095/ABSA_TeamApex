({
	getPolicyData: function (component) {
		var contractTypesLabel = $A.get("$Label.c.Sum_Assured_Contract_Types");
		var contractTypesList = contractTypesLabel.split(";");

		var action = component.get("c.fetchPolicyDetails");
		action.setParams({
			policyNumber: component.get("v.policyNumberFromFlow")
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					component.set("v.errorMessage", responseData);
				} else {
					var policyResults = JSON.parse(responseData);
					if (!policyResults.Clients) {
						component.set("v.errorMessage", "Clients not found for selected policy");
						this.hideSpinner(component);
						return;
					}

					if (!policyResults.Contracts) {
						component.set("v.errorMessage", "Contracts not found for selected policy");
						this.hideSpinner(component);
						return;
					}

					var clientsArray = policyResults.Clients.V3_DC2Client;
					var contractsObj = policyResults.Contracts.V3_DC2Contract;
					var contractTypeId = contractsObj.ContractTypeID;
					var contractTypeDescription = contractsObj.ContractTypeDescription;
					var listOfComponents = contractsObj.Components.V3_DC2Component;
					var contractDueDate = contractsObj.DateNextDue;
					var contractPremium = contractsObj.AdjustedPremium;
					component.set("v.contractDueDate", $A.localizationService.formatDate(contractDueDate, "yyyy/MM/dd"));
					component.set("v.contractPremium", contractPremium);

					var sumAssuredData = [];

					if (!contractTypesList.includes(contractTypeId)) {
						var message = "Contract type: (" + contractTypeId + ") " + contractTypeDescription + ", is currenlty not supported!";
						component.set("v.errorMessage", message);
					}

					listOfComponents.forEach(function (componentItem) {
						var firstName;
						var surname;
						var dateOfBirth;
						var lifeAssuredGID = componentItem.LifeAssuredGID;
						clientsArray.forEach(function (clientItem) {
							if (lifeAssuredGID === clientItem.Activities.GID) {
								firstName = clientItem.Activities.Firstname;
								surname = clientItem.Activities.Surname;
								dateOfBirth = clientItem.Activities.DateOfBirth;
							}
						});

						sumAssuredData.push({
							firstName: firstName ? firstName : "",
							surname: surname ? surname : "",
							dateOfBirth: dateOfBirth ? $A.localizationService.formatDate(dateOfBirth, "yyyy/MM/dd") : "",
							cover: componentItem.Cover ? componentItem.Cover : "",
							benefitType: componentItem.Description ? componentItem.Description : "",
							premium: componentItem.Premium ? componentItem.Premium : "",
							contractGID: componentItem.ContractGID ? componentItem.ContractGID : "",
							lifeAssuredGID: lifeAssuredGID ? lifeAssuredGID : "",
							productID: componentItem.ProductID ? componentItem.ProductID : "",
							movementDate: contractsObj.MovementDate ? contractsObj.MovementDate : "",
							commencementDate: componentItem.CommenceDate ? componentItem.CommenceDate : "",
							benefitTerm: componentItem.BenefitTerm ? componentItem.BenefitTerm : "",
							premiumGrowth: componentItem.PGPerc ? componentItem.PGPerc + "%" : "",
							premiumTerm: componentItem.PremiumTerm ? componentItem.PremiumTerm : "",
							coverGrowth: componentItem.CGPerc ? componentItem.CGPerc + "%" : "",
							premium: componentItem.Premium ? componentItem.Premium : "",
							gID: componentItem.GID
						});
					});
					component.set("v.sumAssuredData", sumAssuredData);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "getPolicyData error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "getPolicyData unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	submitMemberDetails: function (component) {
		this.showSpinner(component);
		var rowData = component.get("v.rowData");
		var newCoverAmount = component.get("v.newCoverAmount");

		//Cover amount must not be blank
		if (!newCoverAmount || Number(newCoverAmount <= 0) || isNaN(Number(newCoverAmount))) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide valid cover amount", "warning");
			return;
		}

		var action = component.get("c.getCalculatedPremiumAmount");
		action.setParams({
			contractGid: rowData.contractGID,
			lifeAssuredGid: rowData.lifeAssuredGID,
			productId: rowData.productID,
			coverAmount: newCoverAmount
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					component.set("v.errorMessage", responseData);
					this.fireToastEvent("Error", responseData, "error", "sticky");
				} else {
					component.set("v.newPremiumAmount", responseData);
					component.set("v.confirmMemberDetails", true);
					component.set("v.ammendDetails", false);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "submitMemberDetails error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "submitMemberDetails unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	confirmMemberDetails: function (component) {
		this.showSpinner(component);
		var rowData = component.get("v.rowData");

		var action = component.get("c.alterSumAssuredAmount");
		action.setParams({
			contractGid: rowData.contractGID,
			lifeAssuredGid: rowData.lifeAssuredGID,
			productId: rowData.productID,
			coverAmount: component.get("v.newCoverAmount")
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					component.set("v.errorMessage", responseData);
					this.fireToastEvent("Error", responseData, "error", "sticky");
				} else {
					this.fireToastEvent("Success!", "The cover amount has been successfully updated", "Success", "sticky");
					component.set("v.confirmMemberDetails", false);
					component.set("v.ammendDetails", false);
					component.set("v.errorMessage", "");
					this.getPolicyData(component);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "confirmMemberDetails error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "confirmMemberDetails unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},

	fireToastEvent: function (title, msg, type, mode) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type,
			mode: mode
		});
		toastEvent.fire();
	}
});
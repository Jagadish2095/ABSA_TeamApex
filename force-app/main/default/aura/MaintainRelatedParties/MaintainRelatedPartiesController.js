({
	doInit: function (component, event, helper) {
		debugger;
		component.set("v.controllerSelected", false);				
        var accountRecId = component.get("v.accountRecId");
		var currentScannedDocuments = component.get("v.currentScannedDocuments");
		var promise = helper.getRelatedPartyData(component, event, helper).then(
			$A.getCallback(function (result) {
				helper.getCasaMainRefnumber(component, helper);
				var relatedPartyAccountID = component.get("v.relatedPartyIDNumber");
				let actions = component.get("v.availableActions");

				var isRelatedParty = true;
				if (isRelatedParty && relatedPartyAccountID != "") {
					var promise = helper.getCasaRefnumberByRecordID(component, helper, isRelatedParty).then(
						// resolve handler
						$A.getCallback(function (result) {
                            let arrlength = component.get("v.numberOfRelatedPatries");
                            let controllerSelected = component.get("v.controllerSelected");
                            if (controllerSelected && arrlength >= 2) {
                                component.set("v.CanNavigate", true);
                            } else {
                                component.set("v.CanNavigate", false);
                            }
							var isAddingRelatedParty = component.get("v.IsAddingRelatedParty");
                            if(isAddingRelatedParty == true)
                            {
                                 component.set("v.isRelatedPartyAdded", true);
                            }
						
						}),
						// reject handler
						$A.getCallback(function (error) {
							console.log("reject handleResponse result :" + error);
							alert("Error");
							//add error code
						})
					);
				}
			}),
			$A.getCallback(function (error) {
				component.find("branchFlowFooter").set("v.heading", "Error executeCompleteTwo");
				component.find("branchFlowFooter").set("v.message", error);
				component.find("branchFlowFooter").set("v.showDialog", true);
			})
		);
		// helper.getRelatedPartyData(component,event,helper);
	},

	addRelatedParty: function (component, event, helper) {
		
		component.set("v.IsAddingRelatedParty", true);
       // component.set("v.isRelatedPartyAdded", true);
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	handleNavigate: function (component, event, helper) {
		var actionClicked = event.getParam("action");
		let navigate = component.get("v.navigateFlow");

		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				{
					let promise = helper.ScreenRelatedParties(component, helper).then(
						$A.getCallback(function (result) {
							component.set("v.IsAddingRelatedParty", false);
							navigate("NEXT");
						}),
						$A.getCallback(function (error) {
							component.set("v.errorMessage", "There was an error while trying to screen Signatory: \n" + error);
						})
					);
				}
				break;
			default:
				navigate(actionClicked);
				break;
		}
	},

	onSelectMandatorySignatoryChange: function (component, event, helper) {
		//Get all records.
		let allIdsList = component.get("v.thirdpartydata");
		let ids = new Array();
		for (let index = 0; index < allIdsList.length; ++index) {
			ids.push(allIdsList[index].accountId);
			console.log(JSON.stringify(allIdsList[index].accountId));
		}

		let target = event.getSource();
		let idToChange = target.get("v.text");
		let isCheckedVal = target.get("v.value");
		let mainAccountId = component.get("v.accountRecId");

		console.log("isCheckedVal;" + isCheckedVal);
		console.log("idToChange;" + idToChange);

		let action = component.get("c.updateMandatorySignatoryAccountFromDatabase");

		action.setParams({
			allIds: ids,
			idToChange: idToChange,
			isCheckedVal: isCheckedVal,
			accountId: mainAccountId
		});

	action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.numberOfSelectedSignatories", JSON.stringify(response.getReturnValue()));

				helper.getRelatedpartiesCount(component);
				helper.validateMandatorySignatory(component);                
                let arrlength = component.get("v.numberOfRelatedPatries");
                let controllerSelected = component.get("v.controllerSelected");
                if (controllerSelected && arrlength >= 2) {
					component.set("v.CanNavigate", true);
                } else {
					component.set("v.CanNavigate", false);
                }
				helper.fireToast("Success", "Related party details was successfully saved.", "success");
                
			} else {
				var errors = response.getError();
				console.log("Error message: " + errors[0].message);
			}
		});

		$A.enqueueAction(action);
	},

	handleSaveEdition: function (cmp, event, helper) {
		var action = cmp.get("c.updateAccount");
		var draftValues1 = event.getParam("draftValues");
		console.log("draftValues1" + JSON.stringify(draftValues1));
		action.setParams({
			accRelationsWrapper1: draftValues1
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var state = response.getState();
				$A.get("e.force:refreshView").fire();
			} else {
				console.log("!warning ths is nan error");
				console.log(response.getError());
			}
		});
		$A.enqueueAction(action);
	},

	onCheckboxChange: function (component, event, helper) {},

	removeThirdparty: function (component, event, helper) {
		let target = event.getSource();
		let idTobeChange = target.get("v.value");
		component.set("v.idToChange", idTobeChange);
		let isCheckedVal = target.get("v.value");
		component.set("v.isRemoveRelatedParty", true);
        component.set("v.isRelatedPartyDeleted", true);
         component.set("v.IsDeletingRelatedParty", true);
	},
	closeConfirmModal: function (component, event, helper) {
		component.set("v.isRemoveRelatedParty", false);
	},
	closeModal: function (component, event, helper) {
		component.set("v.addRelatedParty", false);
	},
	handleRemoveRelatedParty: function (component, event, helper) {
		helper.showSpinner(component);
		component.set("v.isRemoveRelatedParty", false);

		const action = component.get("c.removeRelatedparty");
		action.setParams({
			relatedAccountId: component.get("v.idToChange"),
			mainAccountId: component.get("v.accountRecId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				let tableData = JSON.parse(response.getReturnValue());
				helper.hideSpinner(component);
				component.set("v.numberOfRelatedPatries", tableData.length);
				component.set("v.controllerSelected", false);
				for (let index = 0; index < tableData.length; ++index) {
					if (tableData[index].contactController == true) {
						component.set("v.controllerSelected", tableData[index].contactController);
					}
				}
				component.set("v.thirdpartydata", tableData);
				helper.validateMandatorySignatory(component);
				helper.fireToast("Success", "The related party has been successfully removed.", "success");
			} else if (state === "ERROR") {
				helper.hideSpinner(component);
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

	onSelectRadioboxChange: function (component, event, helper) {
		component.set("v.showSpinner", true);

		//Get all records.
		let allIdsList = component.get("v.thirdpartydata");
		let ids = new Array();
		for (let index = 0; index < allIdsList.length; ++index) {
			ids.push(JSON.stringify(allIdsList[index].accountId));
			console.log(JSON.stringify(allIdsList[index].accountId));
		}

		let target = event.getSource();
		let idToChange = target.get("v.value");
		let mainAccountId = component.get("v.accountRecId");
		let action = component.get("c.updateAccountFromDatabase");
		action.setParams({
			allIds: ids,
			idToChange: idToChange,
			accountId: mainAccountId
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				console.log("isControllerSelected = " + resp);
				component.set("v.controllerSelected", resp);

				helper.getRelatedpartiesCount(component);
				helper.validateMandatorySignatory(component);
                
                let arrlength = component.get("v.numberOfRelatedPatries");
                let controllerSelected = component.get("v.controllerSelected");
                if (controllerSelected && arrlength >= 2) {
                    component.set("v.isRelatedPartyAdded", true);
                    component.set("v.CanNavigate", true);
                } else {
                    component.set("v.CanNavigate", false);
                }
                
				helper.fireToast("Success", "Related party details was successfully saved. ", "success");
                
			} else {
				var errors = response.getError();
				console.log("Error message: " + errors[0].message);
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	}
});
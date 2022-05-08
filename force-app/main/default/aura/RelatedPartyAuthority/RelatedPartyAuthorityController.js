({
	doInit: function (component, event, helper) {
		console.log("doInit");
		component.set("v.controllerSelected", false);

		//Setup the Thirparty List gridview.
		component.set("v.thirdpartycolumns", [
			{ label: "Signatory", fieldName: "contactName", type: "text" },
			{ label: "Id Number", fieldName: "contactIdNumber", type: "text" },
			{ label: "CIF code", fieldName: "accountCIF", type: "text" },
			{ label: "Casa Number", fieldName: "accountCASA", type: "text" },
			{ label: "Mark as controller(chairperson)", fieldName: "contactController", type: "text" },
			{ label: "Mandated officials", checked: true, fieldName: "accountMandatorySignatory", type: "boolean", editable: "true" }
		]);

		helper.getRelatedPartyData(component, event, helper);
	},
	handleNavigate: function (component, event, helper) {
		const fieldIsMandatoryError = "Please fulfill required fields";

        if (!helper.validateRequiredFields(component)) {
            helper.fireToast("Error",fieldIsMandatoryError, "error");
            return;
        }
	
		var actionClicked = event.getParam("action");
		let navigate = component.get("v.navigateFlow");

		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				{
					let promise = helper.createProductContactRelationship(component, helper).then(
						$A.getCallback(function (result) {
							let Ipromise = helper.createAuthLinkForRelatedParties(component, helper).then(
								$A.getCallback(function (result) {
									navigate("NEXT");
								}),
								$A.getCallback(function (error) {
									component.set("v.errorMessage",  JSON.stringify(error));
								})
							);
						}),
						$A.getCallback(function (error) {
							component.set("v.errorMessage", "There was an error while trying to create CI auth Signatory: \n" + error);
						})
					)}
				break;
			default:
				navigate(actionClicked);
				break;
		}
	},


	onSelectMandatorySignatoryChange: function (component, event, helper) {
		//	helper.fireToast("Success", "Related party details was successfully saved.", "success");
		helper.validateMandatorySignatory(component, helper);
	},

});
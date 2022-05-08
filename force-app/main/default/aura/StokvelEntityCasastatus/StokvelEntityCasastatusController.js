({
	doInit: function (component, event, helper) {
		component.set("v.EntityCasastatuscolumns", [
			{ label: "Entity Name", fieldName: "entityName", type: "text" },
			{ label: "CASA reference number", fieldName: "casaRefNumber", type: "text" },
			{ label: "Status", fieldName: "status", type: "text" }
		]);
		component.set("v.RelatedPartiescolumns", [
			//{ label: "", fieldName: "relatedPartyaccountID", type: "text" },
			{ label: "CASA reference number", fieldName: "casaRefNumber", type: "text" },
			{ label: "First Name", fieldName: "relatedPartyName", type: "text" },
			{ label: "Surname", fieldName: "relatedPartySurName", type: "text" },
			{ label: "ID Number", fieldName: "relatedPartyId", type: "text" },
			{ label: "Screening Date", fieldName: "relatedPartyScreeningdate", type: "text" },
			{ label: "Status", fieldName: "status", type: "text" }
		]);

		helper.getStokvelCasastatus(component, event, helper);
		helper.getrelatedPartystatus(component, event, helper);
	},

	NavigateNextProductSelection: function (component, event, helper) {
		var casaScreeningStatus = "";

		if (component.get("v.EntityCasastatus") != undefined && component.get("v.EntityCasastatus")[0] != undefined) {
			casaScreeningStatus = component.get("v.EntityCasastatus")[0].status;
		}
		var navigate = component.get("v.navigateFlow");
		helper.showSpinner(component);
		let promise = helper.checkiftheCIFexist(component, helper).then(
			$A.getCallback(function (result) {
				if (casaScreeningStatus == "CONTINUE" || casaScreeningStatus == "INCOMPLETE-RISKP") {
					helper.hideSpinner(component);
					navigate("NEXT");
				} else {
					helper.hideSpinner(component);
					component.set("v.errorMessage", "Incorrect CASA status, cannot continue.");
				return;
			}
			}),
			$A.getCallback(function (error) {
				let Ipromise = helper.stokvelCIFCreation(component, helper).then(
					$A.getCallback(function (result) {
						if (casaScreeningStatus == "CONTINUE" || casaScreeningStatus == "INCOMPLETE-RISKP") {
							helper.hideSpinner(component);
							navigate("NEXT");
						} else {
							component.set("v.errorMessage", "Incorrect CASA status, cannot continue.");
						return;
					}
					}),
					$A.getCallback(function (error) {
						helper.hideSpinner(component);
						component.set("v.errorMessage", "There was an error while trying to create CIF Error: " + JSON.stringify(error));
					})
				);
			})
		);
	},
	doSelect: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		var accid = selectedRows[0].relatedPartyaccountID;

		component.set("v.recordId", accid);
		component.set("v.accountRecId", accid);
		if (selectedRows[0].status == "PENDING APPROVAL" ||selectedRows[0].status == "DECLINED") {
			component.set("v.isCasaStatusPending",true);
			var navigate = component.get("v.navigateFlow");
			navigate("NEXT");
		}
		// component.set("v.isCasaStatusPending",true);
		//var rowIndex = rows.indexOf(row);
		//console.log('selectedRows is : ' +selectedRows);
	}
});
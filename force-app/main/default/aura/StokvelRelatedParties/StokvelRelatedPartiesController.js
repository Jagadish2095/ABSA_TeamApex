({
	//create Stokvel client
	linkStokvelRelatedParty: function (component, event, helper) {
		var selectedAccount = component.get("v.accountSelected");
		component.set("v.relatedPartyRecordId", selectedAccount.Id);
		component.set("v.recordId", selectedAccount.Id);

		if(selectedAccount.Id == undefined)
		{
			let Ipromise = helper.UpdateRelatedAccount(component, helper, selectedAccount).then(
				$A.getCallback(function (result) {
					
					var navigate = component.get("v.navigateFlow");
					navigate("NEXT");
					resolve("success");
				}),
				$A.getCallback(function (error) {
					component.set("v.errorMessage", "There was an error while trying to link RelatedParty" + JSON.stringify(error));
				})
			); 
		}
		else{
		let Ipromise = helper.UpdateRelatedPartiesGender(component, helper, selectedAccount).then(
			$A.getCallback(function (result) {
				
				var navigate = component.get("v.navigateFlow");
				navigate("NEXT");
				resolve("success");
			}),
			$A.getCallback(function (error) {
				component.set("v.errorMessage", "There was an error while trying to link RelatedParty" + JSON.stringify(error));
			})
		); 
		}
	
		debugger;
	},

	//Toggle open new related parties form (CaptureRelatedParties component)
	openCaptureRelatedParties: function (component, event, helper) {
		component.set("v.createNewRelatedParty", true);
	},

	//Method called from child component (CaptureRelatedParties) to Navigate to the next Flow Screen
	executeNavigateNext: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	}
});
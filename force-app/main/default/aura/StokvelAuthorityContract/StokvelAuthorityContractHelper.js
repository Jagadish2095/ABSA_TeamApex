({
	saveDocumentInfo: function (component, event, helper) {
        return new Promise(function (resolve, reject) {
            helper.showSpinner(component);
            var opportunityId = component.get("v.opportunityId");
            var accountRecId = component.get("v.accountRecId");
            var proofContractData = component.get('v.customerProofAuthorityData');
            var customerContractData = component.get('v.customerContractData');
             var action = component.get("c.insertDocumentInformation");
            
            action.setParams({
                currentScannedDocuments: proofContractData,
                customerContractData : customerContractData,
                accountRecId: accountRecId,
                opportunityId: opportunityId
            });
            // set a callBack
            action.setCallback(this, function (response) {
                var state = response.getState();
                var resp = response.getReturnValue();
                
                if (state === "ERROR") {
                    helper.hideSpinner(component);
                    var errors = response.getError();
                    helper.fireToast("Error", "An error occurred on saveDocumentInfo. ", "error");
                    console.log("saveDocumentInfo Apex error: " + JSON.stringify(errors));
                    reject("error");
                }
                resolve("success");
                helper.hideSpinner(component);
            });
            $A.enqueueAction(action);
        });
	},
    saveOpportunitySatge: function (component, event, helper) {
       // return new Promise(function (resolve, reject) {
            helper.showSpinner(component);
            var opportunityId = component.get("v.opportunityId");            
             var action = component.get("c.updateOpportunityStage");
            
            action.setParams({                
                opportunityId: opportunityId
            });
            // set a callBack
            action.setCallback(this, function (response) {
                var state = response.getState();
                var resp = response.getReturnValue();
                
                if (state === "ERROR") {
                    helper.hideSpinner(component);
                    var errors = response.getError();
                    helper.fireToast("Error", "An error occurred on saveDocumentInfo. ", "error");
                    console.log("saveDocumentInfo Apex error: " + JSON.stringify(errors));
                    //reject("error");
                }
                //resolve("success");
                helper.hideSpinner(component);
            });
            $A.enqueueAction(action);
        //});
	},
    //Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},
    fireToast: function (title, msg, type) {
		let toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
})
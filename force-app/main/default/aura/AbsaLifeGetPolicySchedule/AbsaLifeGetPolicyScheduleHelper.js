({
		getPolicyData: function (component, event, helper) {
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
					var componentsObj = contractsObj.Components.V3_DC2Component;
					var contractNextDueDate = contractsObj.DateNextDue;
                    var totalPremium = contractsObj.AdjustedPremium;
                    
					component.set("v.policyName", contractsObj.ContractTypeDescription);
					component.set("v.policyNumber", policyResults.RefNo);
					component.set("v.status", contractsObj.StatusDescription);
					component.set("v.nextPremiumDate", $A.localizationService.formatDate(contractNextDueDate, "yyyy/MM/dd"));
                    component.set("v.premiumDue", totalPremium);
                    
                    var memberList = [];

                    componentsObj.forEach(function (componentItem) {
                        var firstName;
                        var surname;
                        var lifeAssuredGID = componentItem.LifeAssuredGID;
                        clientsArray.forEach(function (clientItem) {
                            if(lifeAssuredGID === clientItem.Activities.GID){
                                firstName = clientItem.Activities.Firstname;
                                surname = clientItem.Activities.Surname;
                            }
                        });

                        memberList.push({
                            firstName: (firstName)? firstName : "",
                            surname: (surname)? surname : "",
                            cover: (componentItem.Cover)? componentItem.Cover : "",
                            benefitType: (componentItem.Description)? componentItem.Description : "",
                            premium: (componentItem.Premium)? componentItem.Premium : "",
                            commencementDate: (componentItem.CommenceDate)? componentItem.CommenceDate : "",
                            gID: componentItem.GID
                        });
                    });
                    component.set("v.benefitsData", memberList);
                    
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
    
    handlePreviewHelper: function (component, event, helper) {
        
		var action = component.get("c.getPolicyDocument");
        action.setParams({
			policyNumber: component.get("v.policyNumberFromFlow")
		});

		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
            
			if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                if(responseData.statusCode == 200){
                    if (responseData.header.response == "Successful") {
                        component.set("v.pdfData", responseData.body.document);
                        component.set("v.isShowModal", true);
                        component.set("v.isShowPreviewModal", true);
                        
                    }else {
                        component.set("v.errorMessage", JSON.stringify(responseData));
                    }
                }else{
                    component.set("v.errorMessage", responseData.message);
                }
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "getPolicyDocument error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "getPolicyDocument unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},
    
    sendEmailHelper: function (component, event, helper) {
       
        let emailParamsMap = new Map();
		emailParamsMap["clientName"] = component.get("v.clientName");
		emailParamsMap["policyNumber"] = component.get("v.policyNumberFromFlow");
		emailParamsMap["clientEmail"] = component.get("v.clientEmail");
        var action = component.get("c.sendEmail");
        action.setParams({
            sendPolicyParams: emailParamsMap,
            pdfData: component.get("v.pdfData")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            component.set("v.pdfData", null);
            component.set("v.isShowModal", false);
        	component.set("v.isEmailCommunication", false);
            component.set("v.commButtonLabel", " ");
            if (state === "SUCCESS") {
                helper.fireToastEvent("Success!",  "Policy Schedule letter emailed successfully!", "success");
                helper.navigateNext(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in caseCloseHelper method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in caseCloseHelper method. State: " + state);
            }

            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
	
	downloadPolicyScheduleHelper: function (component, event, helper) {
		
        var policyNumber = component.get("v.policyNumberFromFlow");
        var data = component.get("v.pdfData");
				var element = document.createElement("a");
				var docName = "PolicySchedule -" + policyNumber + ".pdf";
				element.setAttribute("href", "data:application/octet-stream;content-disposition:attachment;base64," + data);
				element.setAttribute("download", docName);
				element.click();
        helper.navigateNext(component);
        component.set("v.commButtonLabel", " ");
        helper.hideSpinner(component);
	},

    showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},
    
    navigateNext: function (component) {
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	fireToastEvent: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type,
			mode: 'dismissible'
		});
		toastEvent.fire();
	}
})
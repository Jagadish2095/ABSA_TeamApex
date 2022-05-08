/****************@ Author: Chandra********************************
 ****************@ Date: 22/11/2019*******************************
 ****************@ Description: Method to handle init function***/
({
	doInit: function (component, event, helper) { 
		helper.getParentAccountWrapper(component);
		helper.getAccountDetails(component);
		helper.getBusinessAccountDetails(component);
		//helper.getOpportunityDetails(component);
		//helper.showProduct(component, event, helper);
		helper.getEntitytype(component);
		//var Entitytype = component.get("v.account.Client_Type__c");

		//console.log("entitytype"+Entitytype);
		helper.getTradingAsNameDetails(component);
		//W-005715 : Anka Ganta : 2020-08-18
		helper.CheckRelatedPartyCasaStatus(component);
	},

	/****************@ Author: Chandra********************************
	 ****************@ Date: 22/11/2019********************************
	 ****************@ Description: Method to validate client info****/
	validateClientInfo: function (component, event, helper) {
		var oppId = component.get("v.recordId");
		helper.submitAccountDetails(component, event, helper);
	},

	/****************@ Author: Anka Ganta********************************
	 ****************@ Date: 26/02/2020********************************
	 ****************@ Description: Method to show Submit CASA button****/
	showButton: function (component, event, helper) {
		var submitButton = component.find("submitButton");
		var caseId = component.get("v.opportunityRecord2.Case__c");
		var qaApprovalStatus = component.get("v.opportunityRecord2.QA_Complex_Approval_Status__c");
		var complexApproval = component.get("v.opportunityRecord2.Complex_Application__c");

		if ((caseId != null || complexApproval == true) && (qaApprovalStatus == "Submitted" || qaApprovalStatus == "Accepted By Approver")) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				type: "error",
				title: "Error!",
				message: "You cannot make changes as this opportunity is undergoing QA review."
			});
			toastEvent.fire();
		} else if (event.getSource().get("v.checked")) {
			$A.util.removeClass(submitButton, "slds-hide");

			//	helper.submitAccountDetails(component,event,helper);
		} else {
			$A.util.addClass(submitButton, "slds-hide");
		}
	},

	refreshStatus: function (component, event, helper) {
		var caseId = component.get("v.opportunityRecord2.Case__c");
		var qaApprovalStatus = component.get("v.opportunityRecord2.QA_Complex_Approval_Status__c");
		var complexApproval = component.get("v.opportunityRecord2.Complex_Application__c");
		console.log("caseId " + caseId);
		console.log("qaApprovalStatus " + qaApprovalStatus);

		if ((caseId != null || complexApproval == true) && (qaApprovalStatus == "Submitted" || qaApprovalStatus == "Accepted By Approver")) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				type: "error",
				title: "Error!",
				message: "Please ensure that this application has received QA approval before generating CIF."
			});
			toastEvent.fire();
		} else {
			helper.refreshStatus(component, event, helper);
			helper.getAnalystCommentsHelper(component, event, helper);
		}
	}
});
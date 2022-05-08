/****************@ Author: Chandra********************************
 ****************@ Date: 22/11/2019*******************************
 ****************@ Description: Method to handle init function***/
({
	doInit: function (component, event, helper) {
		//  component.set("v.recordId",component.get("v.flowAccountRecId"));
		component.set("v.columns", [
			{ label: "Name", fieldName: "accName", type: "text" },
			{ label: "Risk Rating", fieldName: "riskRating", type: "text" },
			{ label: "Screening Date", fieldName: "screeningDate", type: "text" }
		]);

		helper.getAccountDetails(component);
		//helper.getOpportunityDetails(component);
		//helper.showProduct(component, event, helper);
		helper.getEntitytype(component);
		//var Entitytype = component.get("v.account.Client_Type__c");
		helper.CheckRelatedPartyCasaStatus(component, event, helper);
	},

	saveRiskInfo: function (component, event, helper) {
		// helper.validateRiskInfo(component, event, helper);
		//helper.saveRiskInfo(component, event, helper);
		helper.saveRiskInfoValidation(component, event, helper);
	},

	/****************@ Author: Anka Ganta********************************
	 ****************@ Date: 27/02/2020********************************
	 ****************@ Description: Method to show Submit Risk Profiling button****/
	showButtonRisk: function (component, event, helper) {
		var submitButtonRisk = component.find("submitButtonRisk");
		var caseId = component.get("v.opportunityRecord2.Case__c");
		var qaApprovalStatus = component.get("v.opportunityRecord2.QA_Complex_Approval_Status__c");
		var complexApproval = component.get("v.opportunityRecord2.Complex_Application__c");
		var recordtypename=component.get("v.opportunityRecord.RecordType.Name");
        var riskStatus = component.get("v.opportunityRecord.Risk_Status__c");
		if ((caseId != null || complexApproval == true) && (qaApprovalStatus == "Submitted" || qaApprovalStatus == "Accepted By Approver")) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				type: "error",
				title: "Error!",
				message: "You cannot make changes as this opportunity is undergoing QA review."
			});
			toastEvent.fire();
		}//Included a condition for Remediation W-013710
        else if(recordtypename == 'Customer Remediation' && riskStatus != 'Valid'){
            if(event.getSource().get("v.checked")){            
                $A.util.removeClass(submitButtonRisk, 'slds-hide');}
			else{
				$A.util.addClass(submitButtonRisk, 'slds-hide');
			   }
        } 
		else if (recordtypename != 'Customer Remediation' && event.getSource().get("v.checked")) {
			$A.util.removeClass(submitButtonRisk, "slds-hide");
			//	helper.submitAccountDetails(component,event,helper);
		} else {
			$A.util.addClass(submitButtonRisk, "slds-hide");
		}

		helper.getRelMandatoryDocs(component);
	},
	// W-006880 : Anka Ganta : 2020-10-26 START
	handleLoad: function (component, event, helper) {
		var opportunityRecordTypeId = component.find("recordTypeId").get("v.value");
		component.set("v.opportunityRecordTypeId", opportunityRecordTypeId);
	},

	handleSubmit: function (component, event, helper) {
		helper.showSpinner(component);
		event.preventDefault(); // Prevent default submit
		var fields = event.getParam("fields");

		component.find("OppDetailsForm").submit(fields); // Submit form
		console.log("handle handleSubmit");
	},

	handleSuccess: function (component, event, helper) {
		helper.hideSpinner(component);
	},

	handleError: function (component, event, helper) {
		helper.hideSpinner(component); //hide the spinner

		var componentName = "OnboardingRiskRating";
		console.log(componentName + ": error JSON: " + JSON.stringify(event.getParams()));
		helper.fireToast("Error!", "There has been an error saving the data.", "error");
	},
	// W-006880 -END

	//For US W-013710
    showEDDReason : function(component, event, helper) {
        component.set("v.isreasonForEDD",!(component.get("v.isreasonForEDD")));
    },
    submitEDD : function(component, event, helper) {
        var reason = component.get("v.reasonForEDD");
        if(reason == null || reason == "" ){
            component.set("v.showError",true);
        }
        else{
            component.set("v.showError",false);
            helper.createEDDCase(component);
        }
        
    },
    // W-013710 END
});
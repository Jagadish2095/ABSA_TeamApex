({
	submit : function(component, event, helper) {
		var opportunity = component.get("v.opportunityRecord");
        if(opportunity.QA_Complex_Approval_Status__c != 'Approved' && opportunity.QA_Complex_Approval_Status__c != 'Submitted' &&  opportunity.QA_Complex_Approval_Status__c != 'Accepted By Approver'){
            this.submitForApproval(component, event, helper, "c.submitForQA")
        }
        else if(opportunity.QA_Complex_Approval_Status__c == 'Approved' && opportunity.Service_Center_Approval_Status__c != 'Submitted' && opportunity.Service_Center_Approval_Status__c != 'Approved' && opportunity.Teller_Approval_Status__c == null){
            this.submitForApproval(component, event, helper, "c.submitToServiceCenterOrTellerAfterQA");
        }
        else if(opportunity.Service_Center_Approval_Status__c == 'Approved' && opportunity.Teller_Approval_Status__c != 'Submitted' && opportunity.Teller_Approval_Status__c != 'Approved'){
            this.submitForApproval(component, event, helper, "c.submitToTellerorQC");
        }
        else if(opportunity.Teller_Approval_Status__c == 'Approved' && opportunity.QC_Approval_Status__c != 'Submitted' && opportunity.QC_Approval_Status__c != 'Approved'){
            this.submitForApproval(component, event, helper, "c.submitToQC");
        }
            else{
                component.set("v.showSpinner", false);
                component.set("v.recordError", "No Approval Process found/ Approval Process is in Progress ");
            }
	},
    
    submitForApproval : function(component, event, helper, methodName){
        var comments = component.get("v.comments");
        var action = component.get(methodName);
        action.setParams({
            "oppId": component.get("v.recordId"),
            "comments" : comments
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.showSpinner", false);
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Approval Request Submitted Succesfully"
                });
                toastEvent.fire();
            }
            else {
                var errors = response.getError();
                if (errors.length > 0) {
                    var message = errors[0].message;
                    component.set("v.recordError", message);
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})
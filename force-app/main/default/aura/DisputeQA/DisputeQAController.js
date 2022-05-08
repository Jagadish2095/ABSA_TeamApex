({
	recordUpdated : function(component, event, helper) {
        component.set("v.showSpinner", false);
    },
    
    handleClick : function(component, event, helper){
        component.set("v.showModal", true);
    },
    
    onSubmit : function(component, event, helper) {
        var opportunity = component.get("v.opportunityRecord");
        if(opportunity.QA_Complex_Approval_Status__c == 'Rejected' && opportunity.ABSA_Region__c != null){
            component.set("v.opportunityRecord.Disputed_QA_Approval_Status__c", "Submitted");
            component.find("record").saveRecord($A.getCallback(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    //alert('success');
                    component.set("v.showSpinner", true);
                    helper.submitForApproval(component, event, helper);
                } 
                else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            }));
        }
        else if(opportunity.ABSA_Region__c == null){
            component.set("v.recordError", "Can't Submit to Dipsute QA. Please fill Absa Region");
        }
        else{
            component.set("v.recordError", "No Approval Process found");
        }
    },
    
    onCancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})
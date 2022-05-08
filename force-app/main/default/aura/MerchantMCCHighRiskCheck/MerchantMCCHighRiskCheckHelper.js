({
	getHighRiskMCC : function(component,event,helper) {
        helper.showSpinner(component);
        var mccSelected = component.find("oppMccCode").get("v.value");
        var triggerApprovalProcess = component.find("oppTriggerApprovalProcess").get("v.value");
        //If there is a value in Trigger_Approval_Process__c then set flag to true so we skip the apex call
        var sendForApproval = $A.util.isEmpty(triggerApprovalProcess) ? false : true;
        //If we don't already need to send for approval and there is a value selected for MCC
        //Then check if selected MCC is of high risk.
        if(!sendForApproval && !$A.util.isEmpty(mccSelected)){
            var action = component.get("c.getHighRiskMCCs");
            action.setCallback(this, function(response) {
                if (response.getState() == "SUCCESS") {
                    var responseValue = response.getReturnValue();
                    if(responseValue != null){
                        for (var i in responseValue) {
                            if (responseValue[i].Type__c === mccSelected) {
                                sendForApproval = true;
                                break;
                            }
                        }
                    }else{
                        //Cannot find mdt records
                        this.fireToast('Error', 'Unable to find High Risk MCC Codes.', 'error');
                    }
                } else if(response.getState() === "ERROR"){
                    var errors = response.getError();
                    component.set("v.errorMessage", "getHighRiskMCC: Apex error: [" + JSON.stringify(errors) + "]. ");
                } else {
                    component.set("v.errorMessage", "getHighRiskMCC: Apex error. ");
                }
            });
            $A.enqueueAction(action);
        }
        if(sendForApproval){
            component.find("oppApprovalStatus").set("v.value", "Pending");
            component.find("oppTriggerApprovalProcess").set("v.value", "MATCH/TransUnion/Experian/MCC Risk Check");
            component.find("oppMCCPassed").set("v.value", false);
            component.set("v.showApprovalStatus", true);
        }else{
            component.find("oppApprovalStatus").set("v.value", null);
            component.find("oppTriggerApprovalProcess").set("v.value", null);
            component.find("oppMCCPassed").set("v.value", true);
        }
        helper.hideSpinner(component);
        component.find('opportunityEditForm').submit();
        component.find("opportunityForm").reloadRecord();
    },

    showSpinner: function(component) {
        component.set("v.isSpinner",true);
    },

    hideSpinner: function(component) {
        component.set("v.isSpinner",false);
    },

    //Fire Lightning toast
    fireToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})
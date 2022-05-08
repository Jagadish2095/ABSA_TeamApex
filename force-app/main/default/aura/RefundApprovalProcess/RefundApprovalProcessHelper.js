({
    checkRefundApprovalStage : function(component) {
        var action = component.get("c.getRefundApprovalStage");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    component.set("v.refundApprovalStage", responseValue.Refund_Approval_Stage__c);
                    //component.set('v.isButtonActive',false);
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                console.log('Callback to getRefundApprovalStage Failed. Error : [' + JSON.stringify(errors) + ']');
                //component.set('v.isButtonActive',true);
            } else {
                console.log('Callback to getRefundApprovalStage Failed.');
                // component.set('v.isButtonActive',true);
            }
        });
        $A.enqueueAction(action);
    },
    
    submitRefundApproval : function(component) {
        var action = component.get("c.submitLevel4ApprovalProcess");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                
                console.log('Callback to submitLevel1ApprovalProcess Success. Response : [' + JSON.stringify(responseValue) + ']');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Success!",
                    "type" : "success",
                    "message" : "Request submitted for Approval Successfully",
                    "mode" : "dismissible"
                    
                });
                toastEvent.fire();
                
                
                if (responseValue != null) {
                    
                    //component.set("v.refundApprovalStage", responseValue.Refund_Approval_Stage__c);
                    //component.set('v.isButtonActive',false);
                }
            } else if(response.getState() == "ERROR"){
                var errors = response.getError();
                //alert('Submit Error');
                console.log('Callback to submitLevel4ApprovalProcess Failed. Error : [' + JSON.stringify(errors) + ']');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Error!",
                    "type" : "error",
                    "message" : 'Refund Approval Request failed to submit. ' +errors[0].message,
                    "mode" : "dismissible"
                });
                toastEvent.fire();
                //component.set('v.isButtonActive',true);
            } else {
                console.log('Callback to submitLevel4ApprovalProcess Failed.');
                // component.set('v.isButtonActive',true);
            }
            
        });
        $A.enqueueAction(action);
    },

})
({
 
init: function (component,evt,helper) {
    console.log('recordId##' + component.get("v.recordId"));
    var userId = $A.get("$SObjectType.CurrentUser.Id");
    console.log('userId##' + userId);
    component.set("v.currentUser", userId);
    helper.refreshData(component, event, helper);
    },
onCheckRejection: function(component, event, helper) {
    var rejectionAck = component.find("rejectionAck").get("v.checked");
    console.log('rejectionAck##' + rejectionAck);
    if (rejectionAck == true) {
        component.set("v.isAcknowledgedRejection", "true");
    } else {
        component.set("v.isAcknowledgedRejection", "false");
    }

},

handleRejection: function(component, event, helper) {
 var approvalName = 'CAF_Sanctioning_Approval_Process';
 var textarea = component.get('v.approvalDecisionComment');
 var comments = component.get('v.approvalDecisionComment');    
 var status = 'Reject';  
 console.log('comments##' + comments);   
 helper.handleApprovalRequest(component, event, helper, approvalName, comments, status);
},

onCheckApproval: function(component, event, helper) {
    var approvalAck = component.find("approvalAck").get("v.checked");
    console.log('approvalAck##' + approvalAck);
    if (approvalAck == true) {
        component.set("v.isAcknowledgedApproval", "true");
    } else {
        component.set("v.isAcknowledgedApproval", "false");
    }

},
    
onCheckApprovalDecision: function(component, event, helper) {
    var decisionSubmitAttest = component.find("decisionSubmitAttest").get("v.checked");
    console.log('decisionSubmitAttest##' + decisionSubmitAttest);
    if (decisionSubmitAttest == true) {
        component.set("v.isCheckedApprovalDecision", "true");
    } else {
        component.set("v.isCheckedApprovalDecision", "false");
    }

},    
    
 setStatusApproved: function(component, event, helper) {
   var allocatedSanctioner =  component.find("qaApprover").get("v.value");
    var currentUser =  component.get("v.currentUser");
      console.log('allocatedSanctioner##' + allocatedSanctioner);
      console.log('currentUser##' + currentUser);
     if(currentUser != allocatedSanctioner){
      var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();      
     }else{component.set("v.approvalStatus", "Approve");
     console.log('approvalStatus##' + component.get("v.approvalStatus"));
          }  
}, 
    
 setStatusDeclined: function(component, event, helper) {
      var allocatedSanctioner =  component.find("qaApprover").get("v.value");
    var currentUser =  component.get("v.currentUser");
      console.log('allocatedSanctioner##' + allocatedSanctioner);
      console.log('currentUser##' + currentUser);
     if(currentUser != allocatedSanctioner){
      var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();      
     }else{
 component.set("v.approvalStatus", "Decline");
  console.log('approvalStatus##' + component.get("v.approvalStatus")); 
     }
}, 
 
  setStatusRejected: function(component, event, helper) {
    var allocatedSanctioner =  component.find("qaApprover").get("v.value");
    var currentUser =  component.get("v.currentUser");
      console.log('allocatedSanctioner##' + allocatedSanctioner);
      console.log('currentUser##' + currentUser);
     if(currentUser != allocatedSanctioner){
      var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();      
     }else{
 component.set("v.approvalStatus", "Reject");
  console.log('approvalStatus##' + component.get("v.approvalStatus")); 
     }
}, 

handleApproval: function(component, event, helper) {
 var approvalName = 'CAF_Sanctioning_Approval_Process';
 var comments = ' ';    
 var status = 'Approve';  
    
 helper.handleApprovalRequest(component, event, helper, approvalName, comments, status);
},
    
setStatusReassign: function(component, event, helper) {
 component.set("v.approvalStatus", "Reassign");
  console.log('approvalStatus##' + component.get("v.approvalStatus"));     
}, 
    
handleApprovalDecision: function(component, event, helper) {
 var approvalName = 'CAF_Sanctioning_Approval_Process';
 var comments = component.get("v.approvalDecisionComment");    
 var status = component.get("v.approvalStatus");  
    
 helper.handleApprovalRequest(component, event, helper, approvalName, comments, status);
},
    
onCommentChange : function(component, event, helper) {
        var approvalDecisionComment = component.find("decisionComments").get("v.value");
        component.set('v.approvalDecisionComment', approvalDecisionComment);
        console.log ('Comment : ' + approvalDecisionComment);
    }, 
    
onCommentChangeRej : function(component, event, helper) {
        var approvalDecisionComment = component.find("rejectionReason").get("v.value");
        component.set('v.approvalDecisionComment', approvalDecisionComment);
        console.log ('Comment : ' + approvalDecisionComment);
    },   

handleApplicationApproval: function(component, event, helper) {
    var approvalDecision = component.find("applicationApprovalGroup").get("v.value");
    console.log('approvalDecision##' + approvalDecision);
    if (approvalDecision == "Approved") {
        component.set("v.openApprovalComments", "true");
        component.set("v.isApplicationRejected", "false");
        component.set("v.isApplicationDeclined", "false");
    } else if (approvalDecision == "Rejected") {
        component.set("v.openApprovalComments", "false");
        component.set("v.isApplicationRejected", "true");
        component.set("v.isApplicationDeclined", "false");
    } else if (approvalDecision == "Declined") {
        component.set("v.openApprovalComments", "false");
        component.set("v.isApplicationRejected", "false");
        component.set("v.isApplicationDeclined", "true");
    } else {
        component.set("v.openApprovalComments", "false");
        component.set("v.isApplicationRejected", "false");
        component.set("v.isApplicationDeclined", "false");
    }
},

onCheckApplicationRejection: function(component, event, helper) {
    var applicationARejectionAck = component.find("applicationARejectionAck").get("v.checked");
    console.log('applicationARejectionAck##' + applicationARejectionAck);
    if (applicationARejectionAck == true) {
        component.set("v.isSubmitRejection", "true");
    } else {
        component.set("v.isSubmitRejection", "false");
    }

},

handleSubmitRejection: function(component, event, helper) {
    //apex code to reject approval 
},


openRejectComments: function(component, event, helper) {
   // var rejectionReasons = component.find("rejectionReasons").get("v.value");
  //  var declineReasons = component.find("declineReasons").get("v.value");
    var rejectionReasons = component.find("rejectionReasons1");
    console.log('rejectionReasons##' + rejectionReasons);
    var declineReasons = component.find("declineReasons1");
    console.log('declineReasons##' + declineReasons);
    if (declineReasons != null || rejectionReasons != null) {
        component.set("v.openRejDeclineComments", "true");
    } else {
        component.set("v.openRejDeclineComments", "false");
    }

},


onCheckApplicationApproval: function(component, event, helper) {
    var applicationApprovalAck = component.find("applicationApprovalAck").get("v.checked");
    console.log('applicationApprovalAck##' + applicationApprovalAck);
    if (applicationApprovalAck == true) {
        component.set("v.isSubmitApproval", "true");
    } else {
        component.set("v.isSubmitApproval", "false");
    }

},

handleSubmitApplicationApproval: function(component, event, helper) {
  
},


openApprovalComments: function(component, event, helper) {
    var rejectionReasons = component.find("rejectionReasons").get("v.value");
    var declineReasons = component.find("declineReasons").get("v.value");
    console.log('rejectionReasons##' + rejectionReasons);
    console.log('declineReasons##' + declineReasons);
    if (declineReasons != null || rejectionReasons != null) {
        component.set("v.openRejDeclineComments", "true");
    } else {
        component.set("v.openRejDeclineComments", "false");
    }

},
})
({
    doInit: function(component, event, helper) {
        var caseId = component.get("v.recordId");
        helper.getQueueMembers(component, event, helper);
        
        
        var defaultApprover;
        var caseStatus;
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                component.set("v.defaultApprover", storeResponse.Name);
                defaultApprover = storeResponse.Name;
            }
        });
        $A.enqueueAction(action);
        
        var userName = $A.get("$SObjectType.CurrentUser.FullName");
        
    },
    
    showBtn : function(component, event, helper) {
        var iTermsAndConditionsField = component.find("iTermsAndConditions");
        var iTermsAndConditionsValue =  iTermsAndConditionsField.get("v.value");
        
        component.set("v.agreeToTerms", iTermsAndConditionsValue);
    },
    decisionChanged : function(component, event, helper) {
        var selectedOption = component.get("v.selectedOption");
        if(selectedOption == 'Accepted'){
            component.set("v.selectedOption", 'Accepted');
        } else {
            component.set("v.selectedOption", 'Requested More Information');
        }
    },
    submitDecision : function (component, event, helper) {
        var selectedOptionVal = component.get("v.selectedOption");
        var caseProduct = component.get("v.caseProduct");
        var caseStatus = component.get("v.caseStatus");
        console.log('caseProduct'+caseProduct);
        if((caseStatus !== 'Load Product' && caseStatus!=='QA Card Instruction' && caseStatus!=='Closed' && caseProduct!='Bank Guarantee') && selectedOptionVal === 'Accepted') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Cannot Accept Decision for Open Status!"
            });
            toastEvent.fire();   
        } else {       
            var comments = component.find('comments');
            var MandateNum; 
            var MandateNumVal;
            if(caseProduct=='Overdraft'){
              MandateNum =  component.find('MandateNum');
              MandateNumVal = MandateNum.get("v.value");
            }
            var commentsVal = comments.get("v.value");
            
            if(commentsVal == undefined) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Please fill in all Required Fields!"
                });
                toastEvent.fire();   
            } else if(caseProduct=='Overdraft' && MandateNumVal == undefined) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Please fill in all Required Fields!"
                });
                toastEvent.fire();   
            }
              else{
                helper.insertDecisionHistory(component, event, helper);  
            }
		}
    }
})
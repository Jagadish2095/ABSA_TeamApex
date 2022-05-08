({  
    doInit: function(component, event, helper) {
        helper.getAllEmails(component);
        helper.checkPolicyExists(component);
        helper.getEmailStatus(component);
    },
 
 	onPicklistEmailChange: function(component, event, helper) {
        
    },
    
    onCompletedCheck: function(component, event) {
        var checkCmp = component.find("completedCheckbox");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true){
            component.find("emailSelect").set("v.disabled", true);
            component.set("v.showAlternativeEmail", true);
        }
        else{
            component.find("emailSelect").set("v.disabled", false);
            component.set("v.showAlternativeEmail", false);
        }
    },
    
    emailDocs: function(component, event, helper) {
        var checkCmp = component.find("completedCheckbox");
        //Alternative Email Selected
        if(checkCmp.get("v.value") == true){
            var motivationArr = [];
            motivationArr.push(component.find('altEmail'));
            var allValid = motivationArr.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                inputCmp.focus();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            var allEmails = component.get("v.emailOptions");
            var alternativeEmail = component.get("v.alternativeEmail");
            var isDuplicate = false;
            for (var i = 0; i < allEmails.length; i++) {
                if(alternativeEmail == allEmails[i].value){
                    isDuplicate = true;
                }
            } 
            if(isDuplicate){
                allValid = false;
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "This email has already been added and cannot be added as an alternative again!",
                    "type":"error"
                });
                toastEvent.fire();
            }
            if (allValid) {
                helper.sendDocsAlternative(component);
            }
        }
        //Else use default
        else{
            var motivationArr = [];
            motivationArr.push(component.find('emailSelect'));
            var allValid = motivationArr.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                inputCmp.focus();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            if (allValid) {
                helper.sendDocsDefault(component);
            }
        }    	
   	},
})
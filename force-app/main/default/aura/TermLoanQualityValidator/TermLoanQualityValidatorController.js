({
    doInit: function(component, event, helper) {
        var oppId = component.get("v.recordId");
      
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                component.set("v.defaultApprover", storeResponse.Name);
            }
        });
        $A.enqueueAction(action);
        
        var userName = $A.get("$SObjectType.CurrentUser.FullName");
        
    },
    showBtn : function(component, event, helper) {
        var decision = component.get("v.selectedOption");
        if(decision=='Accepted'){
            var iAcceptCheckField = component.find("iAcceptCheckA");
            var iAcceptCheckValue =  iAcceptCheckField.get("v.value");
            component.set("v.agreeToTerms", iAcceptCheckValue);
        }else{
            var iAcceptCheckField = component.find("iAcceptCheckR");
            var iAcceptCheckValue =  iAcceptCheckField.get("v.value");
            component.set("v.agreeToTerms", iAcceptCheckValue);
            
        }
    },
    
     decisionChanged : function(component, event, helper) {
        var selectedOption = component.get("v.selectedOption");
        if(selectedOption == 'Accepted'){
            component.set("v.selectedOption", 'Accepted');
        }
        else
        {
            component.set("v.selectedOption", 'Rejected');
        }
    },
     
    submit : function(component, event, helper) {
        helper.submitD(component, event, helper);
    }
})
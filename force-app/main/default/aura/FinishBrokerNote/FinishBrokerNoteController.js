({
    doInit: function(component, event, helper) {
        var evt = $A.get("e.c:BNGenerationNCrossSellEvent");
        evt.setParam("check", true);
        evt.fire();
    },
	onButtonPressed : function(component, event, helper) {
        let isSuccess = false;
		var toastEventSuccess = $A.get("e.force:showToast");
        toastEventSuccess.setParams({
            "title": "Success!",
            "message": "Hi Email is Sent! Please Finish the Process.",
            type: 'success'
        });
        
        var toastEventError = $A.get("e.force:showToast");
        toastEventError.setParams({
            "title": "Error!",
            "message": "Please generate broker note first.",
            type: 'error'
        });
        component.set("v.validateCase",false);
        var caseId=component.get("v.recordId");
        console.log("caseId to be passed: "+caseId);
        var action = component.get("c.SendEmailToCustomer");
        
        action.setParams({"CaseId":caseId});
        
        action.setCallback(this, function(result){
            component.set("v.isLoading", false);
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log(" result.getReturnValue(): "+result.getReturnValue());
                if(result.getReturnValue() == 'Broker note not generated')
                {
                    isSuccess = false;
                    toastEventError.fire();
                }
                else
                {
                      console.log('isSuccess:::'+isSuccess);
                    isSuccess=true;
                    toastEventSuccess.fire();
                    helper.EnableFinishButton(component, event, helper);
                }
            }
            if(state=='ERROR'){
                var errors = result.getError();
                if (errors) {
                    for(let error of errors){
                        let errorMessage = error.message;
                        let errorKey = errorMessage.match(/(\b[A-Z][A-Z]+([_]*[A-Z]+)*)/g).pop();
                        errorMessage = errorMessage.split(errorKey+", ").pop().split(": [").shift();
                        
                        var toastEvent = $A.get('e.force:showToast');
                        toastEvent.setParams({
                            title: 'Error!',
                            message: errorMessage,
                            type: 'error'
                        });
                        toastEvent.fire();  
                    }
                }
            }
        });
        $A.enqueueAction(action); 
        console.log('isSuccess12:::'+isSuccess);
        component.set("v.isLoading", true);
        
	},
    
})
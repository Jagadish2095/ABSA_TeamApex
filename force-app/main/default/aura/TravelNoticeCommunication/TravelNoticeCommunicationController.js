({
    doInit : function(component, event, helper){
        
    },
	closeCase : function(component, event, helper) {
		helper.showSpinner(component);
        var action = component.get('c.sendEmail');

        var caseId = component.get('v.caseRecordId');
        var email = component.find("emailAddress").get("v.value");
        console.log('CaseI ' + caseId);
        console.log('Email ' + email);
        action.setParams({
            "emailAddress" : email,
            "caseRecordId" : caseId
		});
		
        action.setCallback(this, $A.getCallback(function (response) {

			var state = response.getState();
			
            if (state === "SUCCESS") {
                helper.hideSpinner(component);
                
                var result = response.getReturnValue();
               
                if(result === 'success'){
                    var toast = helper.getToast("Success", "Email sent successfully", "success");
                }else{
                    var toast = helper.getToast("Error", result, "error");
                }

                helper.hideSpinner(component);

                toast.fire();

                $A.get('e.force:refreshView').fire();

                
            } else if (state === "ERROR") {
                
				helper.hideSpinner(component);
                
				var toast = helper.getToast("Error", "There was an error when sending an email", "error");
				
				
				
                toast.fire();
                
                $A.get('e.force:refreshView').fire();
            }
        }));

       
            $A.enqueueAction(action);
    }
	
})
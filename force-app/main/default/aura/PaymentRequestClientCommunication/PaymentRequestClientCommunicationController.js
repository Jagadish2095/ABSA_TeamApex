({
	doInit : function(component, event, helper) {
      
        var caserecId = component.get('v.caseRecordId');
        console.log('case rec id--'+component.get('v.caseRecordId'));
        var caseRecTypeId = component.get('v.caseRecordTypeId');
        console.log('case rec type id--'+component.get('v.caseRecordTypeId'));
        var jsonString = component.get('v.selectedStatmentAccountFromFlow');
        component.set('v.caseObjId',component.get('v.caseRecordId'));
        component.set('v.caseRecordTypeId',component.get('v.caseRecordTypeId'));
       
    },
    
    closeCase : function(component, event, helper) {
        console.log('--Send EMAIL--');
        
        var action = component.get("c.sendEmailOnCaseClose"); 
        
        var accountNumber = component.get('v.accNumberToCon');
       
        var emailAddress = component.find("emailAddress").get("v.value");
		var jsonString = component.get('v.selectedStatmentAccountFromFlow');
        
        console.log('case recordId---'+component.get("v.caseRecordId"));
        console.log('emailTemplate---'+component.get("v.emailTemplate"));
        action.setParams({caseRecordId: component.get("v.caseRecordId"),
                          emailAddress: component.find("emailAddress").get("v.value"),
                          emailTemplate :  component.get("v.emailTemplate")
                         });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseMessage = response.getReturnValue();
                if(responseMessage == 'success'){
                component.set("v.hideCloseCase",true);
               
                    $A.get('e.force:refreshView').fire();
                                        
                   
                      helper.getToast("Success", "Case is closed successfully ", "success");
                   
                }else{
                    helper.getToast("Error!", responseMessage, "error");
                   // toastEvent.fire(); 
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);                        
                    helper.getToast("Error!", errors[0].message, "error");
                    }
                }  
            }
         });
         $A.enqueueAction(action);
    }
})
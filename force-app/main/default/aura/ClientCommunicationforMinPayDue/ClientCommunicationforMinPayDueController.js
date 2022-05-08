({
	doInit : function(component, event, helper) {
        
        var accountNumber = component.get('v.accNumberFromFlow');
        var amountDue = component.get('v.amountdueFromFlow');
        component.set('v.accNumberToCon',accountNumber);
        component.set('v.amtDueToCon',amountDue);
        var caserecId = component.get('v.caseRecordId');
        var caseRecTypeId = component.get('v.caseRecordTypeId'); 
        component.set('v.caseObjId',component.get('v.caseRecordId'));
        component.set('v.caseRecordTypeId',component.get('v.caseRecordTypeId'));
    },
    closeCase : function(component, event, helper) {
      //  console.log('--Send EMAIL--');
        
        var action = component.get("c.sendEmailNotifications"); 
        
        var accountNumber = component.get('v.accNumberToCon');
        var amountDue = component.get('v.amtDueToCon');
        var emailAddress = component.find("emailAddress").get("v.value");
        action.setParams({caseRecordId: component.get("v.caseObjId"),
                          emailAddress: component.find("emailAddress").get("v.value"),
                          accNumber: accountNumber, 
                          minAmountDue: amountDue,
                          mobileNumber: component.find("mobile").get("v.value"),
                          commMethod: component.find("commMethod").get("v.value")
                         });
        
        action.setCallback(this, function(response) {	//caseRecord
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.hideCloseCase",true);
                var toastEvent = helper.getToast("Success", "Case is closed successfully.Please click Next to continue. ", "Success");
    			toastEvent.fire();
                 $A.get('e.force:refreshView').fire();
                location.reload();
            } else if(state === "ERROR"){
                
            } else{
                
            }
         });
         $A.enqueueAction(action);
    }
})
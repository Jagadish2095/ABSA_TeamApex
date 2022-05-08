({
	doInit : function(component, event, helper) {
      
        var caserecId = component.get('v.caseRecordId');
        var caseRecTypeId = component.get('v.caseRecordTypeId');
        component.set('v.caseObjId',component.get('v.caseRecordId'));
        component.set('v.caseRecordTypeId',component.get('v.caseRecordTypeId'));
       
    },
    
    closeCase : function(component, event, helper) {
                
        var action = component.get("c.sendEmailOnCaseClose"); 
        var accountNumber = component.get('v.SelectedAccNumberFromFlow');
        
        
        action.setParams({caseRecordId: component.get("v.caseObjId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.hideCloseCase",true);
                var toastEvent = helper.getToast("Success", "Case is closed successfully.Please click Next to continue. ", "Success");
    			toastEvent.fire();
            } else if(state === "ERROR"){
               
            } else{
                
            }
         });
         $A.enqueueAction(action);
    }
})
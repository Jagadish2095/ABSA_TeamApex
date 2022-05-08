({
	doInitHelper: function(component, event, helper) {
        component.set("v.isComponentVisible",true);
      var caseID=component.get("v.recordId");
      var action = component.get("c.getInitValues");
      action.setParams({"caseID" : caseID});
      action.setCallback(this, function(response) {
           var state = response.getState();
           if (component.isValid() && state === "SUCCESS"){
               if(!$A.util.isUndefinedOrNull(response.getReturnValue())){
                   component.set("v.caseObj",response.getReturnValue().caseObject);
                
               var isPhoneNull = response.getReturnValue().isNewAlternateConBlank;
               if(isPhoneNull===true){
                   	component.set("v.isNewContactVisible",false);
               }
               else{	
                   component.set("v.isNewContactVisible",true);
                   }}
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });        
        $A.enqueueAction(action);
   }
})
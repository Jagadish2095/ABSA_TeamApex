({
	handleClick : function(component, event, helper) {
		//component.set("v.isModalOpen", true);
        component.set("v.displaySuccessPanel", false);  
        component.set("v.displayLandingPanel", false);
        component.set("v.twoFAAuthUnSuccessfullPanel", false);
	},  
     closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
      component.set("v.isInitiateDisabled", true);
      component.set("v.twoFAAuthUnSuccessfullPanel", false);
   },  
     twoFactorAuthnSuccess : function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
      component.set("v.isInitiateDisabled", false);
      component.set("v.displaySuccessPanel", true);  
      component.set("v.displayLandingPanel", false);
   },
    reSend2FA: function (component, event, helper, instrNo) {
        
        var action = component.get("c.resend2FA");
        
        action.setParams({
       "caseId": component.get("v.parentCaseId")
        });
    
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //var toastEvent = $A.get("e.force:showToast");
            var toast;
            if (state == "SUCCESS") {               
                var isSuccess = response.getReturnValue(); 
                
                if(isSuccess){
                    component.set("v.isModalOpen", false);  
                    component.set("v.displayLandingPanel", false);
                     toast = helper.getToast("Success", 'ReSend 2FA Authentication has sent successfully', "Success");                    
                }else{
                   
                    toast = helper.getToast("Error!", 'something went wrong', "error");
                }
    
            }else {  
              toast = helper.getToast("Error!", state, "error");
                
            }    
              //$A.get('e.force:refreshView').fire(); 
              toast.fire();
              
        });
        $A.enqueueAction(action);         

	},
    
    
})
({
	cancelOverlay : function(component, event, helper) {
		component.set("v.showOverlay", false);	
        component.set("v.data.wrapUpBtnDisabled", true); 
        component.set("v.data.showSpinner.notes",'slds-hide'); 
	}, 
    wrapUpHandler: function(component, event, helper) {
        component.set("v.showOverlay", false);
        
        component.set("v.data.showSpinner.notes",'slds-hide');  
        
        var checkboxValue = component.get("v.doNotShowPopUp");
        
        if(!checkboxValue){            
            helper.navigateToSharePointHelper(component, event);
            return; 
        } 
        var action = component.get("c.saveUserInfo");   
        action.setParams({
                "popUpDisplay": checkboxValue
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            var errors = response.getError();
            if (component.isValid() && state === "SUCCESS") {
                helper.navigateToSharePointHelper(component, event);
                console.log("User show wrap up checkbox saved successfully");          
            }else if (errors && errors.length > 0){ 
                console.log("User show wrap up checkbox did not save successfully");  
                component.set("v.modalObj", {isOpen: true, header: 'Save user info exception', body: errors[0].message});
            }
        });      
        $A.enqueueAction(action);  
    }
})
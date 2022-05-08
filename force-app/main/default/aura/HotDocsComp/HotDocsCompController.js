({
    doInit : function(component, event, helper) {
        //helper.getCheckExemptedReasons(component);
        helper.doInit(component);
    },
    
    closeModel : function(component, event, helper) {
        component.set("v.isOpen",false);
        
    },
    
    lauchInterview: function(component, event, helper) { 
        helper.lauchInterview(component);
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
    
    //onChange handler for all changeable markup
    onChange: function(component, event, helper) {   
                               
        var checkingRequired = (component.get("v.checkingRequired") === "Yes");     
        component.set("v.showCheckingCompleted", checkingRequired);
        component.set("v.showNoCheckingReasons", !checkingRequired);
		helper.updateApplication(component);        
    },
    
   dispatchDraftedWill: function(component, event, helper) {
   		helper.dispatchDraftedWill(component); 
   }   
})
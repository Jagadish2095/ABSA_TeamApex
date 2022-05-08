({
	reverseDebitOrderHandler : function(component, event, helper) {
        var reason_for_reversal = component.get("v.value");
        var maxCounts = $A.get("$Label.c.DBS_ActionMaxRepeats")
          
        if(!reason_for_reversal){
            component.set("v.errorMsg", "Reason for reversal required");
            component.set("v.requiredStar", true);
            return;            
        } 
        component.set("v.errorMsg", "");
        component.set("v.requiredStar", false);         
     
        component.set("v.maxRepeats", maxCounts);
        component.set("v.showOverlay", false);           
 
        //Disable all buttons
        helper.disAbleActionButtons(component, event, 'true');
 		
        //reverse debit order. 
        helper.debitOrderReversalHelper(component, event);
        
		component.set("v.value", "30");
        component.set("v.requiredStar", false);                    
	}, 
	cancelOverlay : function(component, event, helper) {
		component.set("v.showOverlay", false);
        component.set("v.value", "30");
        component.set("v.requiredStar", false); 
	},     
})
({
    iipHoldHandler: function(component, event, helper) {

        var selectedAction = event.getSource().get("v.name");
        component.set("v.actionTaken", selectedAction);
        
        var maxCounts = $A.get("$Label.c.DBS_ActionMaxRepeats")
        component.set("v.maxRepeats", maxCounts);
        component.set("v.showOverlay", false);

        //Disable all buttons
        helper.disAbleActionButtons(component, event, 'true');	
         
        helper.iipHoldHelper(component, event);
        
    },
	cancelOverlay : function(component, event, helper) {
		component.set("v.showOverlay",false);
	},        
})
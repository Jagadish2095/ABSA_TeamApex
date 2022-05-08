({
	additionalNotesHandler : function(component, event, helper) {

        var inputVariable = component.get("v.extraNotes");
        component.get("v.extraNotes", inputVariable);         
        
        var updateNotesEvent = component.getEvent("addNotes");  
        updateNotesEvent.setParams({"additionalNotes" : inputVariable,"botStatus": 1}).fire();   		
	},
    anchorCursorHandler: function(component, event, helper) {
        setTimeout(function(){
            var input =component.find("additionalNotes");
            input.focus();
        }, 200);
    }
})
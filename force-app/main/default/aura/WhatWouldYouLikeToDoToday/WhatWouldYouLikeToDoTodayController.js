({
	//Function call when the user selects any record from the results list   
    handleComponentEvent : function(component, event, helper) {
       // debugger;
        //Get the selected sObject record from the component event 	 
        var selectedsObjectGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedLookUpRecord" , selectedsObjectGetFromEvent);
        
		console.log(component.get("v.selectedLookUpRecord").Name);
        var objLength = Object.keys(selectedsObjectGetFromEvent).length;
        console.log('objLength>>>'+JSON.stringify(selectedsObjectGetFromEvent));
        if(objLength > 0){
            component.set("v.showOpportunityWizardCAF",true);
        }
        
        
	}
    
})
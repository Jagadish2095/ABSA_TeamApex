({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component, event, helper) {
        var firstDateNextMonth = new Date();
        firstDateNextMonth.setMonth(firstDateNextMonth.getMonth()+1,1);
        component.set("v.commencementDate", firstDateNextMonth.getFullYear() + '-' + (firstDateNextMonth.getMonth()+1) + '-' + firstDateNextMonth.getDate());
    
    	helper.checkOnInitValidity(component);
    },
    
    validateApp: function(component, event, helper) {
        helper.checkIfValid(component);
    },
})
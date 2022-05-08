({
	doInit : function(component, event, helper) {
		helper.getRelatedParties(component);
	},
    getParty : function(component, event, helper) {
        
        helper.selectedPrincipal(component, event, helper);
        
    }
})
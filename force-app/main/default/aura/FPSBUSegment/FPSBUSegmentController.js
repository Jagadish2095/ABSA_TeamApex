({
    doInit : function(component, event, helper) {
        helper.fetchAccounts(component);
       
    },
    Clicked : function(component, event, helper){
        component.set("v.isModalOpen", true);
        
    },
    returnToApp : function(component, event, helper) {        
		component.set("v.isModalOpen", false);
	}
})
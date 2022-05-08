({
	doInit : function(component, event, helper) {
		
	},
    removeAccount: function (component, event, helper) {
         helper.removeAccount(component, event);
        
     },
    onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
})
({
	doInit: function (component, event, helper) {
        
    },
   onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeAccount: function (component, event, helper) {
        helper.removeLeases(component, event);
        },
    
    
    /////////////
    onCheckedRemoveFurtherAccount : function (component, event, helper) {
        debugger;
        var chkBoxCmp = component.find("chkRemoveThisFurtherAccount");
        component.set("v.isActiveRemoveFurtherAccount", chkBoxCmp.get("v.value"));
    },
    
    removeFurtherAccount : function (component, event, helper) {
        helper.removeFurtherCond(component, event);
        },
    
    onCheckedRemoveSpecialAccount : function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisSpecialAccount");
        component.set("v.isActiveRemoveSpecialAccount", chkBoxCmp.get("v.value"));
    },
    
    removeSpecialAccount : function (component, event, helper) {
        helper.removeSpecialCond(component, event);
        },
    
    onCheckedRemoveConversionAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisConversionAccount");
        component.set("v.isActiveConversionAccount", chkBoxCmp.get("v.value"));
    },
    
    removeConversionAccount : function (component, event, helper) {
        helper.removeConversionAcct(component, event);
        },
    
})
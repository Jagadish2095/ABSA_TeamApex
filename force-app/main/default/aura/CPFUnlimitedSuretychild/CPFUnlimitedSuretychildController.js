({
	doInit: function (component, event, helper) {
    },
    /*OnchangetobeReleased : function (component, event, helper) {
         var changeValue = event.getParam("value");
        if(changeValue== 'No'){
            
            component.set("v.showTobeReleasedOptions", 'No');
        }
        else if(changeValue=='Yes'){
            
            component.set("v.showTobeReleasedOptions",'Yes');
            }
    },*/
    /*OnchangeIncludeAdd : function (component, event, helper) {
         var changeValue1 = event.getParam("value");
        if(changeValue1== 'No'){
            component.set("v.showIncAddOptions", 'No');
        }
        else if(changeValue1=='Yes'){
            
            component.set("v.showIncAddOptions",'Yes');
            }
    },*/
	onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeUnlimitedAccount: function (component, event, helper) {
         helper.removeNewUnlimitedGuarantee(component, event);
        
     },
   
})
({
    /****************@ Author: Chandra********************************
 	****************@ Date: 08/07/2020*******************************
 	****************@ Work Id: W-004939******************************
 	***@ Description: Method Added by chandra to handle entity clicks**/
    
    handleClick: function (component, event, helper) {
        var selectedButtonLabel = event.getSource().get("v.label");
        component.set("v.showClientFinder",true);
    }
})
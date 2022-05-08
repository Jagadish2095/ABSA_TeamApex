({
	calculateNCA : function(component, event, helper) {
          helper.updateClientDetails(component, event);
		  helper.caluclateNCAStatus(component);
        
	},
    
     handleUpdateAccount: function (component, event, helper) {
        var account = component.get("v.account");
        var updatedAcc = event.getParam("account");
        component.set("v.account", (updatedAcc != null ? updatedAcc : account));
          },
    doInit : function(component, event, helper) {
		//set options
		
         var options = [
            { label: "Yes", value: "Yes" },
            { label: "No", value: "No" }
        ];

        component.set("v.options", options);
        
        //get application product
        //
        helper.getApplication(component);
	},
    
    onCredRadioChange: function (component, event, helper) {
        var value = event.getParam("value");
       component.set("v.isCredValue", (value == "Yes" ? true : false));
 
    },
    onStateRadioChange: function (component, event, helper) {
        var value = event.getParam("value");
       component.set("v.textStateValue", value );
 
    },
    onJurRadioChange: function (component, event, helper) {
        var value = event.getParam("value");
       component.set("v.textjurValue", value );
 
    },
    onAmenRadioChange: function (component, event, helper) {
        var value = event.getParam("value");
        console.log('vvv',value);
       component.set("v.isAmenValue", (value == "Yes" ? true : false));
 
    },
})
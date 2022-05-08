({
    doInit : function(component, event, helper) {
      helper.showSpinner(component, event, helper);
      helper.getCPBServiceDetails(component, event, helper); 
    },
 })
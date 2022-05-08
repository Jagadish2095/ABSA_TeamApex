({
	doInit : function(component, event, helper) {
        
        component.set("v.baseURL",'https://'+window.location.hostname);
	},
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
    closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   }
})
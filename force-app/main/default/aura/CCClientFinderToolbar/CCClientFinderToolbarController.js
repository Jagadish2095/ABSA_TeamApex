({
   handleClick: function (component, event, helper) {
      var utilityAPI = component.find("UtilityBarEx");
      utilityAPI.setUtilityHighlighted({
         highlighted: true
      });
   },
   openModel: function (component, event, helper) {
      var workspaceAPI = component.find("workspace");
      workspaceAPI.openTab({
          url: '#/sObject/001R0000003HgssIAC/view',
          focus: true
      });
      var utilityAPI = component.find("UtilityBarEx");
      utilityAPI.toggleModalMode({
         enableModalMode: true
     });
     // helper.navigateToPersonalDataConsent(component, event);
    //  component.set("v.isModalOpen", true);
   },
   closeModel: function (component, event, helper) {
      component.set("v.isDisable", true);
      component.set("v.isModalOpen", false);
   },
   submitDetails: function (component, event, helper) {
      component.set("v.isDisable", false);
      component.set("v.isModalOpen", false);
   },
})
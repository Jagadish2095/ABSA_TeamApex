({
  doInit: function (component, event, helper) {
    component.set("v.currentContext", "start");
    component.set("v.isLoading", true);
    //Get environment
    var action = component.get("c.getMoodysEnvironment");
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var returnedData = response.getReturnValue();
        console.log(returnedData);
        component.set("v.envURL", returnedData);
        component.set("v.isLoading", false);
      } else {
        console.log(response.getReturnValue());
        component.set("v.isLoading", false);
      }
    });
    $A.enqueueAction(action);
  },

  selectContext: function (component, event, helper) {
      var selectedContext = event.getParam("name");
      helper.helpContext(component, selectedContext, "https://absa-stg.creditlens.moodysanalytics.com", "38", helper);
  }
});
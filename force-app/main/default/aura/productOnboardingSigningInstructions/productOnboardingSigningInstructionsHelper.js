({
  /*@ Author: Tinashe M Shoko
   **@ Date: 03/04/2020
   **@ Description: Method to fetch the linked Application Product Merchant Id
   ** associated with the Opportunity*/
  fetchOpportunityLineItemId: function (component, event, helper) {
    var recordId = component.get("v.recordId");
    var action = component.get("c.getOpportunityProduct");
    action.setParams({
      oppId: recordId
    });
    action.setCallback(this, function (response) {
      if (response.getState() == "SUCCESS") {
        var responseValue = response.getReturnValue();
        if (responseValue != null) {
          component.set("v.opportunityProductId", responseValue.Id);
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.log(
          "Callback to fetchOpportunityLineItemId Failed. Error : [" +
            JSON.stringify(errors) +
            "]"
        );
      } else {
        console.log("Callback to fetchOpportunityLineItemId Failed.");
      }
    });
    $A.enqueueAction(action);
  },

      //Lightning toastie
      fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
});
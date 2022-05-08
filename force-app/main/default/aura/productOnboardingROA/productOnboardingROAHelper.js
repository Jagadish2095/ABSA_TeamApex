({
    /*@ Author: Tinashe M Shoko
     **@ Date: 03/04/2020
     **@ Description: Method to fetch the linked Application Product Merchant Id
     ** associated with the Opportunity*/
    fetchApplicationId: function (component, event, helper) {
    var recordId = component.get("v.recordId");
      var action = component.get("c.getApplicationRecord");
      action.setParams({
        "opportunityId": recordId
      });
      action.setCallback(this, function (response) {
        if (response.getState() == "SUCCESS") {
          var responseValue = response.getReturnValue();
          if (responseValue != null) {
            component.set("v.applicationId", responseValue.Id);
            component.set("v.underSupervisionValue", responseValue.Client_Under_Supervision__c);
            component.set("v.adviceGivenValue", responseValue.Advice_Given__c);
            component.set("v.productReplacementValue", responseValue.Replacing_an_Existing_Product__c);
          }
        } else if (response.getState() === "ERROR") {
          var errors = response.getError();
          console.log(
            "Callback to fetchApplicationId Failed. Error : [" +
              JSON.stringify(errors) +
              "]"
          );
        } else {
          console.log("Callback to fetchApplicationId Failed.");
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
({
  fetchAccounts: function (component, event, helper) {
    this.showSpinner(component);
    var action = component.get("c.getRelationshipBanker");
    action.setParams({ accountId: component.get("v.recordId") });
    //Set up the callback

    action.setCallback(this, function (actionResult) {
      var state = actionResult.getState();
      var res = actionResult.getReturnValue();
      if (component.isValid() && state === "SUCCESS") {
        if (res[0].Relationship_Banker_Name__r != undefined) {
          var loginDate = res[0].Relationship_Banker_Name__r.LastLoginDate.slice(0, -14);
          this.hideSpinner(component);
          component.set("v.AccountName", res[0].Name);
          component.set("v.BankerName", res[0].Relationship_Banker_Name__r.Name);
          component.set("v.BankerABNumber", res[0].Relationship_Banker_Name__r.AB_Number__c);
          component.set("v.BRID", res[0].Relationship_Banker_Name__r.BRID__c);
          component.set("v.Bankersitecode", res[0].Relationship_Banker_Name__r.SiteCode__c);
          component.set("v.BankerlastloggedIn", loginDate);
          component.set("v.BankerMobileNumber", res[0].Relationship_Banker_Name__r.MobilePhone);
          component.set("v.BankerEmailAddress", res[0].Relationship_Banker_Name__r.Email);
          component.set("v.BankerManager", res[0].Relationship_Banker_Manager__c);
          component.set("v.BankerJobtitle", res[0].Relationship_Banker_Name__r.Title);
          component.set("v.BankerWorknumber", res[0].Relationship_Banker_Name__r.phone);
        } else {
          this.hideSpinner(component);
          this.getToast("Error", " No RelationShip Banker Found", "error");
          component.set("v.errorMessage", "No RelationShip Banker Found ");
        }
      } else if (state === "ERROR") {
        var errors = res.getError();
        this.getToast("Error", " An error Occurred", "error");
        component.set("v.errorMessage", "An error Occurred: FPSBUSegment.getRelationshipBanker: " + JSON.stringify(errors));
      }
    });
    $A.enqueueAction(action);
  },

  hideSpinner: function (component) {
    component.set("v.showSpinner", false);
  },

  showSpinner: function (component) {
    component.set("v.showSpinner", true);
  },
  getToast: function (title, msg, type) {
    var toastEvent = $A.get("e.force:showToast");

    toastEvent.setParams({
      title: title,
      message: msg,
      type: type
    });
    toastEvent.fire();
  }
})
/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 28-10-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-013340
 **/
({
  doInit: function (component, event, helper) {
    helper.getAccountDetails(component, event, helper);
  },

  showEmailScreen: function (component, event, helper) {
    helper.loadPdf(component, event, helper);
  },

  sendEmail: function (component, event, helper) {
    if (component.get("v.mandateEmail")) {
      helper.sendEmail(component, event, helper);
    } else {
      helper.fireToastEvent("Error", "Email is Required", "error");
    }
  },

  showAccountDetails: function (component, event, helper) {
    component.set("v.errorMessage", "");
    component.set("v.stepName", "accountDetails");
  },

  refreshView: function (component, event, helper) {
    $A.get("e.force:refreshView").fire();
  },
  closeCase: function (component, event, helper) {
    component.find("statusField").set("v.value", "Closed");
    component.find("caseCloseEditForm").submit();
    $A.get("e.force:refreshView").fire();
  }
});
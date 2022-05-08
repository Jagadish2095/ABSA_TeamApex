/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 28-10-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-013340 W-016008
 **/
({
  getAccountDetails: function (component, event, helper) {
    helper.showSpinner(component);
    var action = component.get("c.getAccountDetails");
    action.setParams({
      accountNumber: component.get("v.accountNumberFromFlow")
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var responseValue = response.getReturnValue();
        if (responseValue.startsWith("Error: ")) {
          //error
          this.fireToastEvent("Error!", "Please review all errors", "Error");
          component.set("v.errorMessage", responseValue);
        } else {
          var respObj = JSON.parse(responseValue);
          component.set("v.accountDetails", respObj);
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        component.set(
          "v.errorMessage",
          "Apex error AccountEnquiryCntr.getAccountDetails: " +
            JSON.stringify(errors[0].message)
        );
      } else {
        component.set(
          "v.errorMessage",
          "Unexpected error occurred, state returned: " + state
        );
      }
      this.hideSpinner(component);
    });
    $A.enqueueAction(action);
  },

  loadPdf: function (component, event, helper) {
    helper.showSpinner(component);
    var action = component.get("c.getDocumentData");
    action.setParams({
      accountDetails: JSON.stringify(component.get("v.accountDetails")),
      accountId: component.get("v.caseAccountId"),
      caseRecordId: component.get("v.caseRecordId")
    });
    action.setCallback(this, function (response) {
      var returnResponse = response.getReturnValue();
      var state = response.getState();
      if (state === "SUCCESS") {
        if (
          !$A.util.isEmpty(returnResponse) &&
          !returnResponse.startsWith("Error:")
        ) {
          helper.fireToastEvent(
            "Success",
            "Account Document Generated",
            "success"
          );
          //Add send email functionality
          component.set("v.pdfData", returnResponse);
          component.set("v.stepName", "Email Screen");
          component.set("v.errorMessage", "");
        } else {
          component.set(
            "v.errorMessage",
            "Apex Error AccountEnquiryCntr.getDocumentData: " + returnResponse
          );
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        component.set(
          "v.errorMessage",
          "Apex error AccountEnquiryCntr.getDocumentData: " +
            JSON.stringify(errors)
        );
      } else {
        component.set(
          "v.errorMessage",
          "Unexpected error, AccountEnquiryCntr.getDocumentData : " + state
        );
      }

      this.hideSpinner(component);
    });
    $A.enqueueAction(action);
  },

  sendEmail: function (component, event, helper) {
    helper.showSpinner(component);
    var action = component.get("c.sendEmailAttachment");
    action.setParams({
      accountDetails: JSON.stringify(component.get("v.accountDetails")),
      pdfData: component.get("v.pdfData"),
      email: component.get("v.mandateEmail"),
      caseId: component.get("v.caseRecordId"),
      accountId: component.get("v.caseAccountId")
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var result = response.getReturnValue();

        if (result.startsWith("Email sent Successfully")) {
          this.fireToastEvent("Success", "Email sent successfully", "success");

          component.find("statusField").set("v.value", "Closed");
          component.find("caseCloseEditForm").submit();
          $A.get("e.force:refreshView").fire();
        } else {
          this.fireToastEvent("Error", result, "error");
        }

        $A.get("e.force:refreshView").fire();
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            this.fireToastEvent("Error", errors[0].message, "error");
          }
        }
      }

      this.hideSpinner(component);
    });
    $A.enqueueAction(action);
  },

  showSpinner: function (component) {
    component.set("v.showSpinner", true);
  },

  hideSpinner: function (component) {
    component.set("v.showSpinner", false);
  },

  fireToastEvent: function (title, msg, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: title,
      message: msg,
      type: type
    });
    toastEvent.fire();
  }
});
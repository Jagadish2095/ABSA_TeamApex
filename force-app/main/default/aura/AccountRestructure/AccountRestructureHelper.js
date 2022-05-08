/**
 * @description       :
 * @author            : Humbelani Denge
 * @last modified on  : 02-09-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-005674
 **/
({
  //Get Contract details based on user selected account
  getContractDetailsHelper: function (component, event, helper) {
    var action = component.get("c.getContractDetailsfromServer");
    action.setParams({ iAccount: component.get("v.accountNumberFromFlow") });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var responseValue = response.getReturnValue();
        if (responseValue.startsWith("Error: ")) {
          //error
          component.set("v.accountInArrears", true); // dont allow restructure if theres error
          this.fireToastEvent("Error!", "Please review all errors", "Error");
          component.set("v.errorMessage", responseValue);
        } else {
          var respObj = JSON.parse(responseValue);
          component.set(
            "v.contractNumber",
            respObj[0].E_CONTR_DETAILS.CONTRACT
          );
          component.set(
            "v.outstandingAmount",
            +respObj[0].E_CONTR_DETAILS.OUTSTANDING_CAPITAL
          );
          component.set("v.installment", respObj[0].E_CONTR_DETAILS.ANNUITY);
          component.set(
            "v.nextInstallmentDate",
            respObj[0].E_CONTR_DETAILS.INSTALMENT_DATE
          );
          component.set("v.term", respObj[0].E_CONTR_DETAILS.TERM);
          component.set("v.arBalance", respObj[0].E_CONTR_DETAILS.AR_BALANCE);
          component.set(
            "v.amountFinanced",
            +respObj[0].E_CONTR_DETAILS.AMOUNT_FINANCED
          );
          component.set("v.residual", respObj[0].E_CONTR_DETAILS.RESIDUAL);
          component.set(
            "v.remainingTerm",
            respObj[0].E_CONTR_DETAILS.REMAINING_TERM
          );
          component.set(
            "v.interestRate",
            +respObj[0].E_CONTR_DETAILS.RATE + "%"
          );
          component.set(
            "v.corporateCode",
            respObj[0].E_CONTR_DETAILS.CORP_CODE
          );

          component.set("v.stepName", "contractDetails");
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        component.set(
          "v.errorMessage",
          "Apex error AccountRestructure.getContractDetails: " +
            JSON.stringify(errors)
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

  getPrevalidationInfo: function (component, event, helper) {
    var action = component.get("c.getPrevalidationInfo");
    action.setParams({
      accountNumber: component.get("v.accountNumberFromFlow")
    });

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var responseValue = response.getReturnValue();
        if (responseValue.startsWith("Error:")) {
          //error
          this.fireToastEvent("Error!", "Please review all errors", "Error");
          component.set("v.errorMessage", responseValue);
        } else {
          component.set("v.errorMessage", null);
          var respObj = JSON.parse(responseValue);
          component.set("v.preValidationResults", respObj);
          this.hideSpinner(component);
          var preValid = false;
          for (let i = 0, len = respObj.length; i < len; i++) {
            if (respObj[i].allowed === "Y") {
              preValid = true;
            }
          }
          if (preValid === true) {
            component.set("v.isPreValidationButtonDisabled", false);
          }
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        component.set(
          "v.errorMessage",
          "Apex error AccountPreValidationRequest.accountPreValidationRequest: " +
            JSON.stringify(errors)
        );
      } else {
        component.set(
          "v.errorMessage",
          "Unexpected error occurred, state returned: " + state
        );
      }
    });
    $A.enqueueAction(action);
  },

  loadTermOptions: function (component, event, helper) {
    component.set("v.stepName", "contractDetails");
    var action = component.get("c.loadTermOptionsfromServer");

    action.setParams({
      accountNumber: component.get("v.accountNumberFromFlow"),
      advanceAmount: component.get("v.advanceAmount")
    });

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var responseValue = response.getReturnValue();
        if (responseValue.startsWith("Error:")) {
          //error
          this.fireToastEvent("Error!", "Please review all errors", "Error");
          component.set("v.errorMessage", responseValue);
        } else {
          component.set("v.errorMessage", null);
          var respObj = JSON.parse(responseValue);
          if (respObj.length == 1 && !respObj[0].newCalculatedInstalmentsNo) {
            component.set("v.errorMessage", respObj[0].restructureType);
          } else {
            component.set("v.stepName", "termOptions");
            component.set("v.termOptions", respObj);
          }
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        component.set(
          "v.errorMessage",
          "Apex error AccountRestructure.getContractDetails: " +
            JSON.stringify(errors)
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

  showAdjustment: function (component, event, helper) {
    var restructionOption = component.get("v.selectedOption");
    var termOptions = component.get("v.termOptions");
    for (let i = 0; i < termOptions.length; i++) {
      if (termOptions[i].restructureType === restructionOption) {
        component.set("v.newTerm", termOptions[i].newTerm);
        component.set("v.newInstallment", termOptions[i].newInstalment);
        component.set("v.newResidual", termOptions[i].newResidual);
        component.set(
          "v.newCalculatedInstallmentsNo",
          termOptions[i].newCalculatedInstalmentsNo
        );
        component.set(
          "v.newContractEndDate",
          termOptions[i].newContractEndDate
        );
        component.set("v.stepName", "termOptionsoptionSelected");
      }
    }
  },

  confirmOption: function (component, event, helper) {
    component.set("v.isModalOpen", true);

    component.set("v.modalerrorMessage", "");
    component.set("v.noSelected", false);

    if (component.get("v.isEmailEditable")) {
      component
        .find("clientEmailAddress")
        .set("v.value", component.get("v.caseRecord.Client_Email_Address__c"));
    }
    if (component.get("v.mandateEmail") != "") {
      component
        .find("clientEmailAddress")
        .set("v.value", component.get("v.mandateEmail"));
    }
  },

  confirmAdjustmentHelper: function (component, event, helper) {
    var action = component.get("c.confirmAdjustment");

    action.setParams({
      accountNumber: component.get("v.accountNumberFromFlow"),
      advanceAmount: component.get("v.advanceAmount"),
      restructureOption: component.get("v.selectedOption"),
      email: component.find("clientEmailAddress").get("v.value"), //to be updated
      consent: "Y",
      newInstallment: component.get("v.newInstallment"),
      newCalculatedInstallmentsNo: component.get(
        "v.newCalculatedInstallmentsNo"
      ),
      newTerm: component.get("v.newTerm"),
      newContractEndDate: component.get("v.newContractEndDate"),
      newResidualAmount: component.get("v.newResidual")
    });

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var responseValue = response.getReturnValue();
        if (responseValue.startsWith("Error:")) {
          //error
          this.hideModalSpinner(component);
          this.fireToastEvent("Error!", "Please review all errors", "Error");
          component.set("v.errorMessage", responseValue);
        } else {
          component.set("v.errorMessage", null);
          var respObj = JSON.parse(responseValue);
          component.set("v.stepName", "termOptions");
          this.fireToastEvent(
            "Success!",
            "Request created Successfully",
            "Success"
          );

          helper.sendEmail(component, event, helper);
        }
      } else if (state === "ERROR") {
        this.hideModalSpinner(component);
        var errors = response.getError();
        component.set(
          "v.errorMessage",
          "Apex error AccountRestructure.getContractDetails: " +
            JSON.stringify(errors)
        );
      } else {
        component.set(
          "v.errorMessage",
          "Unexpected error occurred, state returned: " + state
        );
        this.hideModalSpinner(component);
      }
    });
    $A.enqueueAction(action);
  },

  sendEmail: function (component, event, helper) {
    var action = component.get("c.sendEmail");

    var caseId = component.get("v.caseRecordId");
    var email = component.find("clientEmailAddress").get("v.value");
    var selectedOption = component.get("v.selectedOption");
    var corporateCode = component.get("v.corporateCode");
    action.setParams({
      emailAddress: email,
      caseId: caseId,
      selectedOption: selectedOption,
      corporateCode: corporateCode
    });
    action.setCallback(
      this,
      $A.getCallback(function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var result = response.getReturnValue();

          if (result.startsWith("Email sent Successfully")) {
            var toast = this.fireToastEvent(
              "Success",
              "Email sent successfully",
              "success"
            );

            component.find("statusField").set("v.value", "Closed");
            component.find("caseCloseEditForm").submit();
          } else {
            var toast = this.fireToastEvent("Error", result, "error");
          }

          $A.get("e.force:refreshView").fire();
        } else if (state === "ERROR") {
          this.hideModalSpinner(component);
          var errors = response.getError();
          if (errors) {
            if (errors[0] && errors[0].message) {
              var toast = this.fireToastEvent(
                "Error",
                errors[0].message,
                "error"
              );
            }
          }
        }
      })
    );
    $A.enqueueAction(action);
  },

  showSpinner: function (component) {
    component.set("v.showSpinner", true);
  },

  hideSpinner: function (component) {
    component.set("v.showSpinner", false);
  },

  showModalSpinner: function (component) {
    component.set("v.showModalSpinner", true);
  },

  hideModalSpinner: function (component) {
    component.set("v.showModalSpinner", false);
  },

  fireToastEvent: function (title, msg, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: title,
      message: msg,
      type: type
    });
    toastEvent.fire();
  },

  saveReasonandCloseCase: function (component, event, helper) {
    var description = component.find("descriptionField").get("v.value");
    if (description) {
      description += "Reason : " + component.get("v.reasonLoanAdjustment");
    } else {
      description = "Reason : " + component.get("v.reasonLoanAdjustment");
    }

    component.find("descriptionField").set("v.value", description);
    component.find("statusField").set("v.value", "Closed");
    component.find("caseCloseEditForm").submit();
    helper.hideModalSpinner(component);
    $A.get("e.force:refreshView").fire();
  }
});
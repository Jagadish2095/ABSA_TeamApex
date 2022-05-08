/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 14-09-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-005674
 **/
({
  doInit: function (component, event, helper) {
    helper.showSpinner(component);
    helper.getPrevalidationInfo(component, event, helper);
  },

  handlePreviousPreValidation: function (component, event, helper) {
    component.set("v.stepName", "preValidation");
  },

  previousOptions: function (component, event, helper) {
    component.set("v.stepName", "termOptions");
  },

  confirmOption: function (component, event, helper) {
    helper.confirmOption(component, event, helper);
  },

  updateAdvanceAmount: function (component, event, helper) {
    helper.showAdjustment(component, event, helper);
  },

  confirmAdjustmentController: function (component, event, helper) {
    helper.showModalSpinner(component);
    helper.confirmAdjustmentHelper(component, event, helper);
  },

  handlePrevalidation: function (component, event, helper) {
    helper.showSpinner(component);
    helper.getContractDetailsHelper(component, event, helper);
  },

  getCalculatorOptions: function (component, event, helper) {
    if (
      !component.get("v.advanceAmount") ||
      component.get("v.advanceAmount") === 0
    ) {
      component.set("v.errorMessage", " Capitalization Amount is required");
    } else if (
      component.get("v.advanceAmount") > Math.abs(component.get("v.arBalance"))
    ) {
      component.set(
        "v.errorMessage",
        " Capitalization amount cannot be greater than the AR balance"
      );
    } else {
      component.set("v.errorMessage", null);
      helper.showSpinner(component);
      helper.loadTermOptions(component, event, helper);
    }
  },

  onRadioSelection: function (component, event, helper) {
    component.set("v.selectedOption", event.getSource().get("v.value"));
  },

  showAdjustment: function (component, event, helper) {
    helper.showAdjustment(component, event, helper);
  },

  closeModal: function (component, event, helper) {
    component.set("v.isModalOpen", false);
    component.set("v.reasonLoanAdjustment", "");
  },

  stopAdjustment: function (component, event, helper) {
    if (!component.get("v.reasonLoanAdjustment")) {
      component.set("v.noSelected", true);
      component.set("v.modalerrorMessage", "Reason is required!");
    } else {
      component.set("v.isModalOpen", false);
      component.set("v.modalerrorMessage", "");
      helper.showModalSpinner(component);
      helper.saveReasonandCloseCase(component, event, helper);
    }
  },

  handleError: function (component, event, helper) {
    component.set(
      "v.modalerrorMessage",
      "Error : " + JSON.stringify(event.getParams())
    );
  },
  refreshView: function (component, event, helper) {
    helper.hideModalSpinner(component, event, helper);
    $A.get("e.force:refreshView").fire();
  }
});
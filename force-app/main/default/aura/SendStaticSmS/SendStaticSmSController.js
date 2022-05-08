/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 25-10-2021
 * @last modified by  : Mradul Maheshwari
 **/
({
  doInit: function (component, event, helper) {
    helper.getStaticResource(component, event, helper);

    helper.getAccountCategory(component, event, helper);
  },

  handleMainPickListChange: function (component, event, helper) {
    var selectedOptionValue = event.getParam("value");
    if (selectedOptionValue != "Forbearance") {
      helper.clearDependantPickList(component);
      component.set("v.smsPreview", selectedOptionValue);
    }
    if (selectedOptionValue == "Forbearance") {
      helper.handleForbearance(component);
    }
    if (
      selectedOptionValue.includes("<collector_info>") ||
      selectedOptionValue.includes("<contact number>")
    ) {
      helper.showSpinner(component, event, helper);

      helper.mapPreLegalSmsValues(component, selectedOptionValue, helper);
    }
  },

  handleForbearancePickListChange: function (component, event) {
    var selectedOptionValue = event.getParam("value");
    var accountCategory = component.get("v.accountCategory");
    if (
      (selectedOptionValue === "POI" && accountCategory === "AVF") ||
      accountCategory === "AVAF"
    ) {
      component.set("v.smsPreview", component.get("v.pickListMap")["irAvaf"]);
    } else if (
      (selectedOptionValue === "POI" && accountCategory === "FSA") ||
      accountCategory === "FORD"
    ) {
      component.set("v.smsPreview", component.get("v.pickListMap")["irford"]);
    } else if (
      selectedOptionValue === "PROOFV" &&
      (accountCategory === "FSA" || accountCategory === "FORD")
    ) {
      component.set(
        "v.smsPreview",
        component.get("v.pickListMap")["PROOFVFORD"]
      );
    } else if (
      selectedOptionValue === "PROOFV" &&
      (accountCategory === "AVAF" || accountCategory === "AVF")
    ) {
      component.set(
        "v.smsPreview",
        component.get("v.pickListMap")["PROOFVAVAF"]
      );
    } else {
      component.set("v.smsPreview", selectedOptionValue);
    }
  },

  sendStaticSms: function (component, event, helper) {
    if (component.get("v.smsPreview")) {
      helper.handleSendSms(component, event, helper);
    } else {
      component.set("v.errorMessage", "Sms cannot be empty");
    }
    if (!component.get("v.clientAccountRecord.PersonMobilePhone")) {
      component.set(
        "v.errorMessage",
        "Client person mobile phone cannot be empty"
      );
    }
  }
});
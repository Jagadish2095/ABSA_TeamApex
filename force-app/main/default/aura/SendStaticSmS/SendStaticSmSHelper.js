/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 25-10-2021
 * @last modified by  : Mradul Maheshwari
 **/
({
  mapPreLegalSmsValues: function (component, selectedOptionValue, helper) {
    selectedOptionValue = selectedOptionValue.replace(
      "<collector_info>",
      component.get("v.record.Name")
    );
    selectedOptionValue = selectedOptionValue.replace(
      "<contact number>",
      component.get("v.record.Phone")
    );
    if (
      !$A.util.isUndefinedOrNull(
        component.get("v.clientAccountRecord.PersonTitle")
      )
    ) {
      selectedOptionValue = selectedOptionValue.replace(
        "<Title, surname>",
        component.get("v.clientAccountRecord.PersonTitle") +
          ", " +
          component.get("v.clientAccountRecord.Name")
      );
    } else if (
      !$A.util.isUndefinedOrNull(
        component.get("v.clientAccountRecord.Titles__pc")
      )
    ) {
      selectedOptionValue = selectedOptionValue.replace(
        "<Title, surname>",
        component.get("v.clientAccountRecord.Titles__pc") +
          ", " +
          component.get("v.clientAccountRecord.Name")
      );
    } else {
      selectedOptionValue = selectedOptionValue.replace(
        "<Title, surname>",
        "" + ", " + component.get("v.clientAccountRecord.Name")
      );
    }
    component.set("v.smsPreview", selectedOptionValue);

    helper.hideSpinner(component, event, helper);
  },

  handleSendSms: function (component, event, helper) {
    this.showSpinner(component);
    var action = component.get("c.sendSms");
    action.setParams({
      caseRecordId: component.get("v.caseRecordId"),
      phone: component.get("v.clientAccountRecord.PersonMobilePhone"),
      msg: component.get("v.smsPreview"),
      integrationService: $A.get("$Label.c.smsIntegrationService")
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var responseVal = response.getReturnValue();
        if (responseVal.startsWith("Error: ")) {
          component.set("v.errorMessage", responseVal);
          helper.toastEventHelper("Error", "Failed to send sms", "Error");
        } else {
          helper.toastEventHelper(
            "Success",
            "Sms sent successfully",
            "Success"
          );
        }
        $A.get("e.force:refreshView").fire();
      } else if (state === "ERROR") {
        var errors = response.getError();
        component.set(
          "v.errorMessage",
          "handleSendSms Error: " + JSON.stringify(errors)
        );
      } else {
        component.set("v.errorMessage", "Error State: " + state);
      }
      helper.hideSpinner(component);
    });
    $A.enqueueAction(action);
  },

  getAccountCategory: function (component, event, helper) {
    this.showSpinner(component, event, helper);
    var action = component.get("c.getAccountCategory");
    action.setParams({ accountNumber: component.get("v.selectedAccNo") });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var responseCategory = response.getReturnValue();

        if (responseCategory) {
          if (responseCategory.startsWith("Error:")) {
            component.set("v.errorMessage", responseCategory);
            component.find("submitButton").set("v.disabled", true);
          } else {
            component.set("v.accountCategory", responseCategory);
          }
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        helper.toastEventHelper("Error!", "error", JSON.stringify(errors));
      }
      this.hideSpinner(component, event, helper);
    });
    $A.enqueueAction(action);
  },

  clearDependantPickList: function (component) {
    component.find("forbearanceSms").set("v.value", null);
    component.set("v.isPicklistDisabled", true);
    if (component.get("v.smsPreview")) {
      component.set("v.smsPreview", null);
    }
  },

  handleForbearance: function (component) {
    component.set("v.isPicklistDisabled", false);
    component.set("v.smsPreview", null);
  },

  initializePicklistOptions: function (component, event, helper) {
    var pickListMap = JSON.parse(component.get("v.pickListMap"));
    var mainPickListOptions = [];
    var forbearancePickListOptions = [];
    var mainPLOmmisionList = [
      "Proof of insurance and letter for Vehicle finance account",
      "Request to Restructure",
      "irford",
      "irAvaf",
      "Proof of insurance",
      "Acknowledgment of Terms and Conditions(Long-term plan)",
      "Acknowledgment of Terms and Conditions(Short-term plan)",
      "Request Declined",
      "PROOFVAVAF",
      "PROOFVFORD"
    ];

    for (var key in pickListMap) {
      if (!mainPLOmmisionList.includes(key)) {
        mainPickListOptions.push({ label: key, value: pickListMap[key] });
      } else if (
        mainPLOmmisionList.includes(key) &&
        key != "irford" &&
        key != "irAvaf" &&
        key != "PROOFVAVAF" &&
        key != "PROOFVFORD"
      ) {
        forbearancePickListOptions.push({
          label: key,
          value: pickListMap[key]
        });
      }
    }
    component.set("v.mainPickListOptions", mainPickListOptions);
    component.set("v.forbearancePickListOptions", forbearancePickListOptions);
    component.set("v.pickListMap", pickListMap);
  },

  getStaticResource: function (component, event, helper) {
    const url = new URL(window.location.href);
    const resourceRelPath = $A.get("$Resource.Avaf_StaticSms_PicklistValues");
    const resourceUrl = `${url.origin}${resourceRelPath}`;
    window
      .fetch(resourceUrl)
      .then(
        $A.getCallback((response) => {
          if (!response.ok) {
            component.set(
              "v.errorMessage",
              "Error retrieving pick list options, please contact your administrator."
            );
            component.find("submitButton").set("v.disabled", true);
          }
          response.json().then(
            $A.getCallback((data) => {
              component.set("v.pickListMap", JSON.stringify(data));
              this.initializePicklistOptions(component, event, helper);
            })
          );
        })
      )
      .catch(
        $A.getCallback((error) => {
          console.error("Fetch Error :-S", error);
        })
      );
  },

  showSpinner: function (component) {
    component.set("v.showSpinner", true);
  },

  hideSpinner: function (component) {
    component.set("v.showSpinner", false);
  },

  toastEventHelper: function (title, message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: title,
      type: type,
      message: message
    });
    toastEvent.fire();
  }
});
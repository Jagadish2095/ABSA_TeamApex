({
  fetchCaseDetails: function (component, event, helper) {
    component.set("v.showBodySpinner", true);
    var action = component.get("c.getCaseDetailWrapper");
    action.setParams({ caseObjId: component.get("v.recordId") });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        let result = JSON.parse(response.getReturnValue());
        component.set("v.caseRec", result.caseRec);
        component.set("v.options", this.getMapvalues(result.yesNoPicklistValues));
        component.set("v.timeFrameOptions", this.getMapvalues(result.timeFramePicklistValues));
        component.set("v.workItemOptions", this.getMapvalues(result.workItemPicklistValues));
        component.set("v.reasonOptions", this.getMapvalues(result.reasonPicklistValues));
        component.set("v.caseObj", result.caseObject);
        component.set("v.caseDocuments", result.caseDocuments);
        component.set("v.showBodySpinner", false);
        var isclosed = result.caseObject.status == "Closed" ? true : false;
        component.set("v.isClosedFinalised", isclosed);
        console.log("checkStatusOne: " + isclosed);
        //manage correct icon to show on child case
        if (isclosed) {
          if (result.caseObject.result == true) {
            component.set("v.isApproveSelected", true);
            component.set("v.isRejectSelected", false);
            component.set("v.isNewDecision", false);
          } else if (result.caseObject.result == false) {
            component.set("v.isApproveSelected", false);
            component.set("v.isRejectSelected", true);
            component.set("v.isNewDecision", false);
          }
        }
        this.caseStepOnInit(component, result.caseObject.status, result.caseObject.isParent);
        this.checkCaseDetails(component, event, helper);
      } else {
        let errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            this.showToast("Error", errors[0].message, "error");
            component.set("v.showBodySpinner", false);
          }
        } else {
          this.showToast("Error", "Unknown Error", "error");
          component.set("v.showBodySpinner", false);
        }
      }
    });
    $A.enqueueAction(action);
  },

  saveParentCaseDetails: function (component, caseItem) {
    component.set("v.showBodySpinner", true);
    var action = component.get("c.saveCaseObject");
    action.setParams({
      caseObj: JSON.stringify(caseItem)
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        $A.get("e.force:refreshView").fire();
        this.showToast("Success", "Information Captured.", "success");
        component.set("v.showBodySpinner", false);
      } else {
        let errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            this.showToast("Error", errors[0].message, "error");
            component.set("v.showBodySpinner", false);
          }
        } else {
          this.showToast("Error", "Unknown Error", "error");
          component.set("v.showBodySpinner", false);
        }
      }
    });
    $A.enqueueAction(action);
  },

  createChildCaseForQueue: function (component, caseItem) {
    component.set("v.showBodySpinner", true);
    var action = component.get("c.createChildCase");
    action.setParams({ caseObj: JSON.stringify(caseItem) });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        $A.get("e.force:refreshView").fire();
        this.showToast("Success", "Financial Spreading Request Submitted.", "success");
        component.set("v.showBodySpinner", false);
      } else {
        let errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log(errors);
            this.showToast("Error", errors[0].message, "error");
            component.set("v.showBodySpinner", false);
          }
        } else {
          this.showToast("Error", "Unknown Error", "error");
          component.set("v.showBodySpinner", false);
        }
      }
    });
    $A.enqueueAction(action);
  },

  checkCaseDetails: function (component, event, helper) {
    if (
      component.get("v.caseObj.spreadingPriority") != null &&
      component.get("v.caseObj.consolidatedSpread") != null &&
      component.get("v.caseObj.financials") != null &&
      component.get("v.caseObj.managementAccounts") != null &&
      component.get("v.caseObj.groupLoans") != null &&
      component.get("v.caseObj.projections") != null &&
      component.get("v.caseObj.timeFrame") != null
    ) {
      component.set("v.isDisableNext", false);
    }
  },

  //Show correct tab based on status
  caseStepOnInit: function (component, caseStatus, isParent) {
    var stepParentMap = new Map();
    stepParentMap.set("Complete Details", 1);
    stepParentMap.set("Upload Documents", 2);
    stepParentMap.set("Submit Request", 3);

    var stepChildMap = new Map();
    stepChildMap.set("Request Context", 1);
    stepChildMap.set("Review Documentation", 2);
    stepChildMap.set("Fulfil Request", 3);
    stepChildMap.set("Closed", 3);

    var currentStep;
    console.log('isParent: '+isParent);
    console.log("status: " + caseStatus);
    if (isParent) {
      currentStep = stepParentMap.get(caseStatus);
    } else {
      currentStep = stepChildMap.get(caseStatus);
    }
    console.log("currentStepItem: " + currentStep);

    if (currentStep) {
      component.set("v.currentStep", currentStep);
      component.set("v.selectedStep", "Step" + currentStep);
    } else {
      component.set("v.selectedStep", "Step1");
    }
  },

  //Manage tabs when button is not used
  manageStepCount: function (component) {
    var selectedStep = component.get("v.selectedStep").replace("Step", "");
    var stepNumber = parseInt(selectedStep);
    component.set("v.currentStep", stepNumber);
  },

  //Method to ensure terms at end of process are accepted
  helpTermsCheck: function (component) {
    var answer = component.get("v.termsAccepted");
    var newAnswer = answer == true ? false : true;
    //component.set("v.termsAccepted",newAnswer);
  },

  getMapvalues: function (picklistOptions) {
    let options = [];
    for (var key in picklistOptions) {
      options.push({ label: key, value: picklistOptions[key] });
    }
    return options.reverse();
  },

  setPageNumber: function (component, event, helper) {
    let currentStep = component.get("v.currentStep");
    currentStep = parseInt(currentStep) + 1;
    if (currentStep > 3) {
      currentStep = 3;
      this.showToast("Success", "Financial Spreading request submitted", "success");
    }
    component.set("v.currentStep", currentStep);
    let seletedStep = "Step" + currentStep;
    component.set("v.selectedStep", seletedStep);
    this.manageButtons(component, event, helper);
  },

  manageButtons: function (component, event, helper) {
    let currentStep = component.get("v.currentStep");
    console.log("currentStep::", currentStep);
    let isDisablePrevious = currentStep > 1;
    component.set("v.isDisablePrevious", !isDisablePrevious);
    let nextButtonLabel = "Next";
    if (currentStep == 3) {
      nextButtonLabel = "Submit";
    }
    component.set("v.nextButtonLabel", nextButtonLabel);
  },

  manageButtonsInDetailPage: function (component, event, helper) {
    let currentStep = component.get("v.currentStep");
    let isDisablePrevious = currentStep > 1;
    component.set("v.isDisablePrevious", !isDisablePrevious);
    let isDisableNext = currentStep >= 4;
    component.set("v.isDisableNext", isDisableNext);
  },

  //Toast helper method
  showToast: function (title, message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      type: type,
      title: title,
      message: message
    });
    toastEvent.fire();
  }
});
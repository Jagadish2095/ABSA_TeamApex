({
  doInit: function (component, event, helper) {
    helper.fetchCaseDetails(component, event, helper);
    var obj = component.get("v.caseRecord");
    console.log(obj);
  },
  handleNext: function (component, event, helper) {
    var currentStep = component.get("v.currentStep");
    if (currentStep === 1) {
      var caseItem = component.get("v.caseObj");
      caseItem.status = "Complete Details";
      if (!caseItem.sicCode || caseItem.sicCode.trim() === "") {
        helper.showToast("Error", "Capture Client SIC Code", "error");
        return;
      } else if (caseItem.timeFrame === "4 hours" && !caseItem.comments) {
        helper.showToast("Error", "Comment field is mandatory", "error");
        return;
      } else {
        helper.saveParentCaseDetails(component, caseItem);
      }
    } else if (currentStep === 2) {
      var caseItem = component.get("v.caseObj");
      caseItem.status = "Upload Documents";
      helper.saveParentCaseDetails(component, caseItem);
    } else if (currentStep === 3) {
      var caseItem = component.get("v.caseObj");
      caseItem.status = "Submit Request";
      caseItem.submitted = true;
      helper.createChildCaseForQueue(component, caseItem);
    }

    currentStep = parseInt(currentStep) + 1;
    component.set("v.currentStep", currentStep);
    console.log("currentStep ->" + currentStep);
    let seletedStep = "Step" + currentStep;
    component.set("v.selectedStep", seletedStep);
    helper.manageButtons(component, event, helper);
  },
  handlePrevious: function (component, event, helper) {
    let currentStep = component.get("v.currentStep");
    currentStep = parseInt(currentStep) - 1;
    component.set("v.currentStep", currentStep);
    console.log("currentStep ->" + currentStep);
    let seletedStep = "Step" + currentStep;
    component.set("v.selectedStep", seletedStep);
    helper.manageButtons(component, event, helper);
  },
  handleNextInDetailPage: function (component, event, helper) {
    let currentStep = component.get("v.currentStep");
    currentStep = parseInt(currentStep) + 1;
    component.set("v.currentStep", currentStep);
    let seletedStep = "Step" + currentStep;
    component.set("v.selectedStep", seletedStep);
    helper.manageButtonsInDetailPage(component, event, helper);
  },
  handlePreviosInDetailPage: function (component, event, helper) {
    let currentStep = component.get("v.currentStep");
    currentStep = parseInt(currentStep) - 1;
    component.set("v.currentStep", currentStep);
    let seletedStep = "Step" + currentStep;
    component.set("v.selectedStep", seletedStep);
    helper.manageButtonsInDetailPage(component, event, helper);
  },
  onChange: function (component, event, helper) {
    helper.checkCaseDetails(component, event, helper);
  },
  handleUploadFinished: function (component, event, helper) {
    var uploadedFiles = event.getParam("files");
    console.log("uploadedFiles", uploadedFiles);
    let existingFiles = component.get("v.fileNames");
    console.log("existingFiles", existingFiles);
    // Get the file name
    uploadedFiles.forEach((file) => existingFiles.push(file.name));
    console.log("existingFiles2", existingFiles);
    component.set("v.fileNames", existingFiles);
    console.log("existingFiles3", component.get("v.fileNames"));
    helper.showToast("Success", "Document uploaded successfully", "success");
    /* var uploadedFiles = event.getParam("files");
        let fileName = '';
        // Get the file name
        uploadedFiles.forEach(file => fileName += file.name+'/n');
        component.set("v.fileName",fileName);
        helper.showToast('Success', 'Document uploaded successfully', 'success'); */
  },
  disableTabNavigation: function (component, event, helper) {
    component.set("v.selectedStep", "Step1");
  },
  handleHeaderChecbox: function (component, event, helper) {
    let isAllDocumentsSelected = component.get("v.isAllDocumentsSelected");
    let caseDocuments = component.get("v.caseDocuments");
    for (let i = 0; i < caseDocuments.length; i++) {
      caseDocuments[i].isChecked = isAllDocumentsSelected;
    }

    component.set("v.caseDocuments", caseDocuments);
  },
  approvedSelected: function (component, event, helper) {
      var closedState = component.get("v.isClosedFinalised");
      if (!closedState) {
        component.set("v.isNewDecision", false);
        component.set("v.isApproveSelected", true);
        component.set("v.isRejectSelected", false);
        component.set("v.isDisablePrevious", true);
        component.set("v.isDisableNext", true);
        //helper.saveCaseDetailsTwo(component, event, helper);
      }
  },
  rejectSelected: function (component, event, helper) {
      var closedState = component.get("v.isClosedFinalised");
      if (!closedState) {
        component.set("v.isNewDecision", false);
        component.set("v.isApproveSelected", false);
        component.set("v.isRejectSelected", true);
        component.set("v.isDisablePrevious", true);
        component.set("v.isDisableNext", true);
        //helper.saveCaseDetailsTwo(component, event, helper);
      }
  },

  finaliseChild: function (component, event, helper) {
    component.set("v.showBodySpinner", true);
    var caseObj = component.get("v.caseObj");
    var finalDecision = component.get("v.isApproveSelected");
    caseObj.result = finalDecision == true ? true : false;
    var action = component.get("c.finaliseChildCase");
    action.setParams({ caseObj: JSON.stringify(caseObj) });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        $A.get("e.force:refreshView").fire();
        let currentStep = component.get("v.currentStep");
        currentStep = parseInt(currentStep) + 1;
        component.set("v.currentStep", currentStep);
        let seletedStep = "Step" + currentStep;
        component.set("v.selectedStep", seletedStep);
        helper.showToast("Success", "Financial Spreading Case Submitted", "success");
        component.set("v.showBodySpinner", false);
      } else {
        helper.showToast("Error", "error found", "error");
        component.set("v.showBodySpinner", false);
      }
    });
    $A.enqueueAction(action);
  },

  viewDoc: function (component, event, helper) {
    var selectedIndex = event.getSource().get("v.name");
    var fileObjectId = component.get("v.caseDocuments")[selectedIndex].documentId;
    var openPreview = $A.get("e.lightning:openFiles");
    openPreview.fire({
      recordIds: [fileObjectId]
    });
  },

  termsCheck: function (component, event, helper) {
    helper.helpTermsCheck(component);
  },

  tabSelected: function (component, event, helper) {
    helper.manageStepCount(component);
  }
});
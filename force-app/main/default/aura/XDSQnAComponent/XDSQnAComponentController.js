({
    doInit: function (component, event, helper) {
        component.set("v.columns", [
            { label: "Power of Attorney type", fieldName: "PAType", type: "text" },
            { label: "Name", fieldName: "name", type: "text" },
            { label: "Id Type", fieldName: "idType", type: "text" },
            { label: "Id Number", fieldName: "idNbr", type: "text" },
            { label: "Signature", fieldName: "signature", type: "text" },
            { label: "Customer", fieldName: "customer", type: "text" },
            { label: "May Collect Cheque", fieldName: "consentCollChqsInd", type: "text" }
        ]);
    },
    
    initComp: function (component, event, helper) {
        //Get Questions and Answer From XDS
        helper.getQnA(component);
    },
    
    onChangePOWTabSelection: function (component, event, helper) {
        component.set("v.byPassXDS", false);
        
        if (event.getParam("id") === "POAverification") {
            component.set("v.data", []);
            helper.getAccountProductsHelper(component, event, helper);
        }
    },
    
    onAccountSelect: function (component, event, helper) {
        component.set("v.data", []);
        component.find("PASelect").set("v.value", "all");
        if (component.get("v.selectedAccountNumber") != "") {
            helper.getGeneralPAHelper(component, event, helper);
            helper.getSpecialPAHelper(component, event, helper);
        } else {
            component.set("v.specialPAList", null);
            component.set("v.generalPAList", null);
        }
    },
    
    handleChange: function (component, event, helper) {
        helper.showSpinner(component);
        var question = event.getSource().get("v.name");
        var selectedValue = event.getSource().get("v.value");
        
        if (selectedValue == "-Please Select-") {
            helper.fireToast("Error", "Please select proper answer", "error");
        }
        var requestBeanForVerification1 = component.get("v.requestBeanForVerification");
        if (!requestBeanForVerification1) {
            requestBeanForVerification1 = component.get("v.responseBean");
        }
        requestBeanForVerification1.questions.questionDocument.forEach(function (quest) {
            if (quest.question == question) {
                quest.answers.answerDocument.forEach(function (ans) {
                    if (ans.answer == selectedValue && ans.isEnteredAnswerYN == false) {
                        ans.isEnteredAnswerYN = true;
                    } else {
                        ans.isEnteredAnswerYN = false;
                    }
                });
            }
        });
        
        component.set("v.requestBeanForVerification", requestBeanForVerification1);
        helper.hideSpinner(component);
    },
    
    sendAnswers: function (component, event, helper) {
        helper.setAnswers(component, event, helper);
    },
    
    handleXDSBypass: function (component, event, helper) {
        var xdsBypassChecked = component.get("v.byPassXDS");
        
        var action = component.get("c.logXDSBypass");
        
        action.setParams({
            caseRecId: component.get("v.caseId"),
            bypassChecked: xdsBypassChecked
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                
                if (xdsBypassChecked == true) {
                    component.set("v.byPassXDSBy", result.xdsBypassBy);
                    component.set("v.byPassXDSDate", result.xdsBypassDate);
                    component.set("v.showVerifyButton", false);
                    component.set("v.xdsDecision", true);
                    component.set("v.isShowError", false);
                    component.set("v.xdsMessage", "User authenticated! Please click Next button continue.");
                } else {
                    component.set("v.byPassXDSBy", null);
                    component.set("v.byPassXDSDate", null);
                    component.set("v.showVerifyButton", true);
                    component.set("v.xdsDecision", false);
                }
            }
        });
        
        $A.enqueueAction(action);
        
        component.set("v.disableHandleNext", false);//Added by chandra dated 26/05/2021 against W-012460
        
    },
    
    handleXDSMandateBypass: function (component, event) {
        var xdsBypassMandateChecked = component.get("v.byPassXDSMandate");
        if (xdsBypassMandateChecked) {
            component.set("v.xdsDecision", true);
            component.set("v.disableHandleNext", false);//Added by chandra dated 26/05/2021 against W-012460

        }
    },
    
    resetTableData: function (component, event) {
        var selectedValue = event.getSource().get("v.value");
        var data = [];
        if (selectedValue == "all") {
            if (component.get("v.generalPAList") != null) data.push(component.get("v.generalPAList"));
            if (component.get("v.specialPAList") != null) data.push(component.get("v.specialPAList"));
        } else if (selectedValue == "general") {
            if (component.get("v.generalPAList") != null) data.push(component.get("v.generalPAList"));
        } else if (selectedValue == "special") {
            if (component.get("v.specialPAList") != null) data.push(component.get("v.specialPAList"));
        }
        component.set("v.data", data);
    },
    
    getSelectedName: function (component, event) {
        var selectedRows = event.getParam("selectedRows");
        component.set("v.selectedRows", selectedRows);
    },
    
    verifySelected: function (component, event, helper) {
        helper.getQuestionsHelper(component, event, helper);
    },
    
    setSelectedAnswer: function (component, event, helper) {
        helper.showSpinner(component);
        var ChangeQuestion = event.getSource().get("v.name");
        var selectedValue = event.getSource().get("v.value");
        
        if (selectedValue == "-Please Select-") {
            helper.fireToast("Error", "Please select proper answer", "error");
        }
        var questionResponse = component.get("v.questionResponse");
        questionResponse.questions.questionDocument.forEach(function (question) {
            if (question.question == ChangeQuestion) {
                question.answers.answerDocument.forEach(function (ans) {
                    if (ans.answer == selectedValue && ans.isEnteredAnswerYN == false) {
                        ans.isEnteredAnswerYN = true;
                    } else {
                        ans.isEnteredAnswerYN = false;
                    }
                });
            }
        });
        
        component.set("v.questionResponse", questionResponse);
        helper.hideSpinner(component);
    },
    
    submitAnswers: function (component, event, helper) {
        helper.submitAnswersHelper(component, event, helper);
    },
    
    /****************@ Author: Chandra*********************************************
	 ****************@ Date: 18/03/2021********************************************
	 ****************@ Work Id: W-010280*******************************************
	 ***@ Description: Method Added by chandra to perform XDS Check on Record Load***/
    onCaseLoad: function (component, event, helper) {
        component.set("v.accountId", component.find("caseAccountId").get("v.value"));
        component.set("v.cifCode", component.find("caseCifNumber").get("v.value"));
        component.set("v.serviceGroup", component.find("sdServiceGroup").get("v.value"));
        component.set("v.serviceType", component.find("sdServiceType").get("v.value"));
        helper.getAccountNameHelper(component, event, helper);
        helper.iDnVPollingHelper(component, event, helper);
    },
    
    /****************@ Author: Chandra*********************************************
	 ****************@ Date: 18/03/2021********************************************
	 ****************@ Work Id: W-010280*******************************************
	 ***@ Description: Method Added by chandra to perform XDS Check on Case Load error***/
    onCaseError: function (component, event, helper) {
        var errorMessage = event.getParam("message");
        component.set("v.errorMessage", "Failed to load Case Record with Id: " + component.get("v.caseId") + " Error: " + errorMessage);
    },
    
    /****************@ Author: Chandra*********************************************
	 ****************@ Date: 18/03/2021********************************************
	 ****************@ Work Id: W-010280*******************************************
	 ***@ Description: Method Added by chandra to perform XDS Check on Account Load***/
    handleRecordUpdated: function (component, event, helper) {
        var eventParams = event.getParams();
        if (eventParams.changeType === "LOADED") {
            component.set("v.accountId", component.get("v.accountRecord.Id"));
            component.set("v.cifCode", component.get("v.accountRecord.CIF__c"));
            helper.getAccountNameHelper(component, event, helper);
            helper.iDnVPollingHelper(component, event, helper);
        } else if (eventParams.changeType === "CHANGED") {
            // record is changed
        } else if (eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if (eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
            component.set("v.errorMessage", component.get("v.recordLoadError"));
        }
    }
});
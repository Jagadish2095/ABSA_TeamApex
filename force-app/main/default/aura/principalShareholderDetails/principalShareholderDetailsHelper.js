({
    fetchData: function (component) {
        var oppId;
        if (component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId"); //when the component is on the NTB form
        } else {
            oppId = component.get("v.recordId") //when the component is on the Account form
        }

        var isCasaScreening = component.get("v.caseScreeningSuccess");
        var action = component.get("c.getRelatedParties");
        action.setParams({
            "oppId": oppId,
            "submitForCasa": isCasaScreening
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.data", data.PrincipalData);
                component.set("v.isPrincipalInfoCorrect", data.PrincipalInfoStatus);
                this.setDefaultPrincipalSelection(component);

            }
            else {
                this.showError(response, "getRelatedParties");
            }
        });
        $A.enqueueAction(action);
    },

    fectSelectPrincipal: function (component, event, helper) {
        var acrID = event.currentTarget.dataset.id;
        var action = component.get("c.getSelectedParties");

        action.setParams({
            "acrId": acrID
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();

                if (data.isNonSAResident == "true") {
                    data.isNonSAResident = true;
                }
                else {
                    data.isNonSAResident = false;
                }

                if (data.isTemporaryResident == "true") {
                    data.isTemporaryResident = true;
                }
                else {
                    data.isTemporaryResident = false;
                }
                component.set("v.selectedPrincipal", data);
            }
            else {
                this.showError(response, "getSelectedParties");
            }
        });
        $A.enqueueAction(action);
    },

    updateInformation: function (component, event, helper) {
        var action = component.get("c.updateInformation");

        action.setParams({
            "acrId": component.get("v.selectedPrincipal.Id"),
            "highestQualification": component.get("v.selectedPrincipal.HighestQualification"),
            "residentailAddress": component.get("v.selectedPrincipal.ResidentialAddress"),
            "numberOfYearInIndustry": component.get("v.selectedPrincipal.NumberOfYearInTheSpecificIndustry"),
            "monthsActivelyInvolvedInTheBusiness": component.get("v.selectedPrincipal.MonthsActivelyInvolvedInTheBusiness"),
            "monthsSinceShareholding": component.get("v.selectedPrincipal.MonthsSinceShareholding"),
            "dateShareholdingAcquired": component.get("v.selectedPrincipal.DateShareholdingAcquired"),
            "isNonSAResident": component.get("v.selectedPrincipal.isNonSAResident"),
            "isTemporaryResident": component.get("v.selectedPrincipal.isTemporaryResident")
        });

        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                if (response.getReturnValue() === "Principal Details Updated Successfully!" || response.getReturnValue() == "Inserted the application record") {
                    var toastEvent = this.getToast("Success!", response.getReturnValue(), "success");
                    toastEvent.fire();

                    component.set("v.showSelectedPrincipal", false);
                }
            }

            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);

    },

    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    getApplication: function (component) {
        var opportunityId = component.get("v.recordId");

        var action = component.get("c.getApplication");
        action.setParams({
            "opportunityId": opportunityId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                //var q = responseValue.Highest_Qualification__c;
            }
        });
        $A.enqueueAction(action);
    },

    //
    keepFocusedTabAndOpenNewTab: function (component, caseId) {
        var workspaceAPI = component.find("workspace");

        workspaceAPI.getFocusedTabInfo()
            .then(function (response) {
                var focusedTabId = response.tabId;

                //Opening New Tab
                workspaceAPI
                    .openTab({
                        url: "#/sObject/" + caseId + "/view"
                    })
                    .then(function (response) {
                        workspaceAPI.focusTab({ tabId: response });
                    })
                    .catch(function (error) {
                        console.log(error);
                    });

                //Closing old tab
                //workspaceAPI.closeTab({ tabId: focusedTabId });
            }).catch(function (error) {
                console.log(error);
            });
    },

    setDefaultPrincipalSelection: function (component) {
        var princDetails = component.get("v.data");
        var selectedRows = component.get("v.selectedRows");
        var selectedMain = component.get("v.mainShareholderId");

        if (princDetails != null) {
            component.set("v.isPrincipalInfoRequired", (princDetails.length > 0 ? true : false));

            for (var i = 0; i < princDetails.length; i++) {
                var prinDet = princDetails[i];
                if (prinDet.ChkSelected == true && !selectedRows.includes(prinDet.Id)) {
                    selectedRows.push(prinDet.Id);
                }
                //keep selected principals selected even after refresh
                if (prinDet.ChkSelected == false && selectedRows.includes(prinDet.Id)) {
                    prinDet.ChkSelected = true;
                }
                if (prinDet.RadSelected == true) {
                    component.set("v.mainShareholderId", prinDet.Id);
                }
                if (selectedMain != null && prinDet.Id == selectedMain) {
                    prinDet.RadSelected = true;
                }
            }
            component.set("v.maxNumberSelected", (princDetails.length <= 4 ? princDetails.length : 4));
            this.eventHandler(component);
        }
    },

    eventHandler: function (component) {
        var updateEvent = $A.get("e.c:clientDetailsSectionCreditEvent");
        updateEvent.setParams({
            "maxNumberSelected": component.get("v.maxNumberSelected"),
            "selectedPrincipal": component.get("v.selectedRows"),
            "selectedMainPrincipal": component.get("v.mainShareholderId"),
            "isPrincipalInfoCorrect": component.get("v.isPrincipalInfoCorrect"),
            "isPrincipalInfoRequired": component.get("v.isPrincipalInfoRequired"),
            "principalsDetails": component.get("v.data")
        });
        updateEvent.fire();
    },

    //Lightning toastie
    getToast: function (title, msg, type) {

        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type": type
        });

        return toastEvent;
    },

    showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }

        // show error notification
        var toastEvent = this.getToast("Error: PrincipalShareholderDetails " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})
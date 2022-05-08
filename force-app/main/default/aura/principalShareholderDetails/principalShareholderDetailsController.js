({
    doInit: function (component, event, helper) {
        component.set("v.columns", [
            {
                label: "Principal/Shareholder Name", fieldName: "FullName", type: "url",
                typeAttributes: { label: { fieldName: "FullName" }, taget: "_princilDetails" }
            },
            { label: "Main", fieldName: "isMain", type: "text" },
            { label: "CIF", fieldName: "CIF", type: "text" },
            { label: "ID Number", fieldName: "IDNumber", type: "text" },
            { label: "Controlling Interest %", fieldName: "SharePercentage", type: "percentage" },
            { label: "CASA Reference", fieldName: "CASAReferenceNumber", type: "text" },
            { label: "CASA Result", fieldName: "CASAScreeningStatus", type: "text" }
        ]);

        //helper.getApplication(component);
        helper.fetchData(component);
    },

    onRadioChange: function (component, event, helper) {
        var selected = event.getSource().get("v.text");
        var selectedRows = component.get("v.selectedRows");

        var index = selectedRows.indexOf(selected);

        if (index > -1) {
            component.set("v.mainShareholderId", selected);
            helper.eventHandler(component);
        }
        else {
            event.getSource().set("v.value", false);
            component.set("v.mainShareholderId", selected);
            helper.setDefaultPrincipalSelection(component);
            var toastEvent = helper.getToast("Info!", "Please make sure you choose selected PRINCIPAL/SHAREHOLDER as main!", "Info");
            toastEvent.fire();
        }
    },

    onCheckedPrincipal: function (component, event, helper) {
        var selecteP = event.getSource().get("v.name");
        var checked = event.getSource().get("v.checked");
        var selectedRows = component.get("v.selectedRows");

        if (checked) {
            if (selectedRows.length < 4) {
                selectedRows.push(selecteP);
            }
            else {
                event.getSource().set("v.checked", false);
                var toastEvent = helper.getToast("Info!", "Only up to 4 selected PRINCIPAL/SHAREHOLDER allowed!", "Info");
                toastEvent.fire();
            }
        }
        else {
            var index = selectedRows.indexOf(selecteP);
            selectedRows.splice(index, 1);
        }
        helper.eventHandler(component);
    },

    updateInfoOnCustomerHub: function (component, event, helper) {
        var selectedRow = component.get("v.mainShareholderId");
        helper.keepFocusedTabAndOpenNewTab(component, selectedRow);
    },

    showPrincipal: function (component, event, helper) {
        component.set("v.selectedPrincipal");
        component.set("v.showSelectedPrincipal", true);
        helper.fectSelectPrincipal(component, event, helper);
    },

    saveAndClose: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var toastEvent;

        if (component.get("v.selectedPrincipal.HighestQualification") != undefined) {

            if (component.get("v.selectedPrincipal.NumberOfYearInTheSpecificIndustry") != undefined) {

                if (component.get("v.selectedPrincipal.MonthsActivelyInvolvedInTheBusiness") != undefined) {

                    if (component.get("v.selectedPrincipal.DateShareholdingAcquired") != undefined) {
                        helper.updateInformation(component, event, helper);
                        component.set("v.savedInfo", Math.random());
                    }
                    else {
                        component.set("v.showSpinner", false);
                        toastEvent = helper.getToast("Error!", "Date Shareholding Acquired field is no captured!", "error");
                    }
                }
                else {
                    component.set("v.showSpinner", false);
                    toastEvent = helper.getToast("Error!", "Months Actively Involved In TheBusiness field is no captured!", "error");
                }
            }
            else {
                component.set("v.showSpinner", false);
                toastEvent = helper.getToast("Error!", "Number Of Year In The Specific Industry field is no captured!", "error");
            }
        }
        else {
            component.set("v.showSpinner", false);
            toastEvent = helper.getToast("Error!", "Highest Qualification field is no captured!", "error");
        }
        if (toastEvent) {
            toastEvent.fire();
        }
    },

    showSubmitCASAScreeningBtn: function (component, event, helper) {
        var iSubmitCASAScreeningsValue = event.getSource().get("v.value");

        if (iSubmitCASAScreeningsValue != null) {

            //Set attribute to display button
            component.set("v.showSubmitCASAScreeningBtn", iSubmitCASAScreeningsValue);
            component.set("v.isPrincipalInfoCorrect", iSubmitCASAScreeningsValue);
            helper.eventHandler(component);
        }
    },

    //Close Product Term Request
    closeSelectedPrincpalBox: function (component, event, helper) {
        component.set("v.showSelectedPrincipal", false);
    },

    submitForCasaScreening: function (component, event, helper) {

        helper.showSpinner(component);

        var oppId;
        if (component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId"); //when the component is on the NTB form
        } else {
            oppId = component.get("v.recordId") //when the component is on the Account form
        }

        var action = component.get("c.principalCasaScreening");

        action.setParams({
            "oppId": oppId
        });

        // set a callBack
        action.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");

            if (state == "SUCCESS") {
                var response = response.getReturnValue();

                if (response.toUpperCase() == "SUCCESS") {
                    component.set("v.caseScreeningSuccess", true);

                    var a = component.get("c.doInit");
                    $A.enqueueAction(a);

                    toastEvent = helper.getToast("Success", "CASA Screening has been Successfully Completed", "Success");

                } else {
                    toastEvent = helper.getToast("Error", response, "Error");

                }

            } else {
                toastEvent = helper.getToast("Error", state, "Error");
            }

            toastEvent.fire();
            helper.hideSpinner(component);
        });

        // enqueue the Action
        $A.enqueueAction(action);
    }
})
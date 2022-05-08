({

    fireToastEvent: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },

    showSpinner: function(component) {
        component.set("v.showSpinner", true);
    },

    hideSpinner: function(component) {
        component.set("v.showSpinner", false);
    },

    changeOwnerOfCase: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var action = component.get("c.redirectCase");
        action.setParams({
            caseId: component.get("v.caseIdFromFlow")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
                window.location.reload(true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log(errors[0].message);
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error in Routing case");
                }
            }
        });
        $A.enqueueAction(action);

    },

    createEvent: function(component, event, helper) {
        component.set("v.showSpinner", true);
        let action;
        if(component.get("v.awaitingCase")){
             action = component.get("c.createReminder");
        }else{
        action = component.get("c.pauseCaseAndCreateReminder");
        }
        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            dateFromCalendar: component.get("v.getDateFromCalendar"),
            caseOutcome: component.find('picklistCaseOutcome').get("v.value")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
                this.fireToastEvent("Success!", "Reminder was created", "Success");
                $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log(errors[0].message);
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error in Routing case");
                }
            }
        });
        $A.enqueueAction(action);

    },
    sendSMSAndCreateReminder: function(component, event, helper) {
        component.set("v.showSpinner", true);
       let action;
              if(component.get("v.awaitingCase")){
                   action = component.get("c.createReminder");
              }else{
              action = component.get("c.pauseCaseAndCreateReminder");
              }
        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            dateFromCalendar: component.get("v.getDateFromCalendar"),
            caseOutcome:''
        });
;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false)
                this.fireToastEvent("Success!", "Reminder was created", "Success");
              this.handleSendSmsWithoutCaseId(component, event, helper);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log(errors[0].message);
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error in Routing case");
                }
            }
        });
        $A.enqueueAction(action);

    },

    getSupportingDocuments: function(component, event) {
        component.set("v.proofOfId", null)
        component.set("v.showSpinner", true);
        let cifnumber = component.find("cifField").get("v.value")
        var documentTypes = ['Ent_ProofOfId', 'Ent_ProofOfIncome', 'Ent_ProofOfAddress', 'Ent_ProofOfApplication'];
        let here = this;
        let key = 'Ent_ProofOfId';
        let value = cifnumber;
        let action = component.get("c.getECMDocuments");
        let valueForApplication = component.get("v.selectedAccountNumberToFlow");
        if (documentTypes.length != 0) {
            let intervalId = window.setInterval(
                $A.getCallback(function() {
                    action.setParams({
                        caseId: component.get("v.caseIdFromFlow"),
                        docType: key,
                        cifAccountNumber: value,
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.valueFromECM", response.getReturnValue()[0])
                            var contentVersionDocument = component.get("v.valueFromECM");
                            if (contentVersionDocument) {
                                if (contentVersionDocument.Id) {
                                    if (documentTypes.find(item => contentVersionDocument.Title.includes(item))) {
                                        documentTypes = documentTypes.filter(item => !contentVersionDocument.Title.includes(item));
                                        if (contentVersionDocument.Title.includes('Ent_ProofOfId')) {
                                            key = 'Ent_ProofOfIncome';
                                            contentVersionDocument.Title = 'Proof of Id'
                                            component.set("v.proofOfId", contentVersionDocument.Id);
                                        }
                                        if (contentVersionDocument.Title.includes('Ent_ProofOfIncome')) {
                                            key = 'Ent_ProofOfAddress';
                                            let documents = component.get("v.contents");
                                            contentVersionDocument.Title = 'Proof of Income';
                                            documents.push(contentVersionDocument);
                                            component.set("v.contents", documents);
                                        }
                                        if (contentVersionDocument.Title.includes('Ent_ProofOfAddress')) {
                                            key = 'Ent_ProofOfApplication';
                                            value = valueForApplication;
                                            contentVersionDocument.Title = 'Proof of Address';
                                            let documents = component.get("v.contents");
                                            documents.push(contentVersionDocument);
                                            component.set("v.contents", documents);

                                        }
                                        if (contentVersionDocument.Title.includes('Ent_ProofOfApplication')) {
                                            let documents = component.get("v.contents");
                                            contentVersionDocument.Title = 'Proof of Application';
                                            documents.push(contentVersionDocument);
                                            component.set("v.contents", documents);
                                            component.set("v.showSpinner", false);

                                        }
                                        if (documentTypes.length === 0) {
                                            component.set("v.itWasRetreved", true);
                                            component.set("v.showSpinner", false);
                                            window.clearInterval(intervalId);
                                        }
                                    }

                                }
                            }
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {

                                if (errors[0].message) {

                                    if (errors[0].message.includes('An operation on a socket could')) {
                                        here.fireToastEvent("Error!", errors[0].message, "Error");
                                    }
                                    if (errors[0].message.includes('Ent_ProofOfId')) {
                                        if (documentTypes.find(item => 'Ent_ProofOfId')) {
                                            key = 'Ent_ProofOfIncome';
                                            documentTypes = documentTypes.filter(item => item != 'Ent_ProofOfId')
                                            here.fireToastEvent("Error!", errors[0].message, "Error");

                                        }
                                    }
                                    if (errors[0].message.includes('Ent_ProofOfIncome')) {
                                        if (documentTypes.find(item => 'Ent_ProofOfIncome')) {
                                            key = 'Ent_ProofOfAddress';
                                            documentTypes = documentTypes.filter(item => item != 'Ent_ProofOfIncome')
                                            here.fireToastEvent("Error!", errors[0].message, "Error");
                                        }
                                    }
                                    if (errors[0].message.includes('Ent_ProofOfAddress')) {
                                        if (documentTypes.find(item => 'Ent_ProofOfAddress')) {
                                            key = 'Ent_ProofOfApplication';
                                            documentTypes = documentTypes.filter(item => item != 'Ent_ProofOfAddress')
                                            here.fireToastEvent("Error!", errors[0].message, "Error");
                                        }

                                    }
                                    if (errors[0].message.includes('Ent_ProofOfApplication')) {
                                        if (documentTypes.find(item => 'Ent_ProofOfAddress')) {
                                            documentTypes = documentTypes.filter(item => item != 'Ent_ProofOfApplication')
                                            here.fireToastEvent("Error!", errors[0].message, "Error");
                                        }
                                    }
                                    if (documentTypes.length === 0) {
                                        component.set("v.itWasRetreved", true);
                                        component.set("v.showSpinner", false);
                                        window.clearInterval(intervalId);
                                    }
                                }
                            }

                        }

                    });

                    $A.enqueueAction(action);
                }), 5000
            );
        }
    },

    handleSendSms: function(component, event, helper) {
        component.get("v.showSpinner", true);
        var action = component.get("c.sendSms");

        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            phoneNumber: component.find("clientNumber").get("v.value")

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.get("v.showSpinner", false);
                var responseVal = response.getReturnValue();
                if (responseVal.startsWith("Error: ")) {
                    component.set("v.errorMessage", responseVal);
                    this.fireToastEvent("Error!", "SMS failed", "Error");;
                } else {
                    this.fireToastEvent("Success!", "SMS was sent", "Success");
                }
                $A.get("e.force:refreshView").fire();
            } else if (state === "ERROR") {
                component.get("v.showSpinner", false);
                var errors = response.getError();
                component.set(
                    "v.errorMessage",
                    "handleSendSms Error: " + JSON.stringify(errors)
                );
            } else {
                component.set("v.errorMessage", "Error State: " + state);
            }

        });
        $A.enqueueAction(action);
    },
    handleSendSmsWithoutCaseId: function(component, event, helper) {
        component.get("v.showSpinner", true);
        var action = component.get("c.sendSms");
        action.setParams({
            caseId: null,
            phoneNumber: component.find("clientNumber").get("v.value")

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.get("v.showSpinner", false);
                var responseVal = response.getReturnValue();
                if (responseVal.startsWith("Error: ")) {
                    component.set("v.errorMessage", responseVal);
                    this.fireToastEvent("Error!", "SMS failed", "Error");;
                } else {
                    this.fireToastEvent("Success!", "SMS was sent", "Success");
                }
                $A.get("e.force:refreshView").fire();
            } else if (state === "ERROR") {
                component.get("v.showSpinner", false);
                var errors = response.getError();
                component.set(
                    "v.errorMessage",
                    "handleSendSms Error: " + JSON.stringify(errors)
                );
            } else {
                component.set("v.errorMessage", "Error State: " + state);
            }

        });
        $A.enqueueAction(action);
    },
});
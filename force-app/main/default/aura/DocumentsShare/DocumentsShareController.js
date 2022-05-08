({


    doInit: function(component, event, helper) {
        var actions = [
            { label: 'Email', name: 'email' },
            { label: 'Download', name: 'download' },
            { label: 'E-Sign', name: 'sign' },
            { label: 'Delete', name: 'delete' }
        ];

        var actions2 = [
            { label: 'Update Signatory Details', iconName: 'utility:edit', name: 'update_details' }
        ];

        component.set('v.columns', [
            { label: 'Document Name', fieldName: 'Name', type: 'text', sortable: true, wrapText: true},
            { label: 'Document Type', fieldName: 'Type__c', type: 'text', sortable: true,  wrapText: true},
            { label: 'Document Status', fieldName: 'Document_Status__c', type: 'text', sortable: true},
            { label: 'ECM Reference Number', fieldName: 'Reference__c', type: 'text', sortable: true, wrapText: true}, // Tinashe W-005663 - display the ECM Reference number for users to see
            { label: 'User', fieldName: 'Owner.Name', type: 'text', sortable: true},
            { label: 'Date Created', fieldName: 'CreatedDate', type: 'date', sortable: true,
             typeAttributes: {day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true} },
            { type: 'action', typeAttributes: { rowActions: actions} }
        ]);

        component.set('v.columns1', [
            { label: 'Request No.', fieldName: 'linkName', type: 'url', typeAttributes: { label: { fieldName: 'Name' }} },
            { label: 'Document Name', fieldName: 'Document_Name__c', type: 'text' },
            { label: 'User', fieldName: 'Created_By_Name__c', type: 'text' },
            { label: 'Status', fieldName: 'Status__c', type: 'text' },
            { label: 'Date Submitted', fieldName: 'CreatedDate', type: 'date', typeAttributes: {day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true} }
        ]);

        component.set('v.columns2', [
            { label: 'Document Name', fieldName: 'Document_Name', type: 'text' },
            { label: 'Document Type', fieldName: 'Document_Type', type: 'text' },
            { label: 'Title', fieldName: 'Title', type: 'text' },
            { label: 'Last Name', fieldName: 'Last_Name', type: 'text' },
            { label: 'Mobile', fieldName: 'Mobile_Phone', type: 'text' },
            { label: 'Email', fieldName: 'Email', type: 'text' },
            { label: 'Order', fieldName: 'Order', type: 'number' },
            { label: 'Method', fieldName: 'Method', type: 'text' },
            { label: 'Role', fieldName: 'Role', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions2 } }
        ]);

        helper.fetchData(component);
        helper.fetchUserName(component);
        helper.fetchOwnerName(component);
        helper.fetchImpressionRequest(component);
        helper.fetchAllClientEmails(component);
        //helper.checkCasaValidity(component);
        //helper.checkStage(component);
    },

    confirmAction: function(component, event, helper) {
        component.set("v.showAdviserConfirmation", false);
        let lines = [];
        lines = component.find('linesTable').getSelectedRows();
        if (component.get("v.onScreenSharing")) {
            for (var i = 0; i < lines.length; i++) {
                helper.download(component, lines[i].Id, lines[i].Name);
            }
            for (var i = 0; i < lines.length; i++) {
                helper.onScreenSharing(component, lines[i].Id);
            }
            component.set("v.onScreenSharing", false);
        } else if (component.get("v.electronicSharing")) {
            var ids = new Array();
            for (var i = 0; i < lines.length; i++) {
                ids.push(lines[i].Id);
            }
            var idListJSON = JSON.stringify(ids);
            helper.emailSharing(component, component.get("v.selectedClientEmail"), idListJSON);
            component.set("v.electronicSharing", false);
        }

        helper.refresh(component);
    },

    cancelAction: function(component, event, helper) {
        component.set("v.showAdviserConfirmation", false);
        component.set("v.showAssistantConfirmation", false);
        component.set("v.showNoAccess", false);
        component.set("v.onScreenSharing", false);
        component.set("v.electronicSharing", false);
    },

    updateSelectedText: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRowsCount', selectedRows.length);
    },


    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'sign':
                let lines = [];
                lines = component.find('linesTable').getSelectedRows();
                if (lines.length === 0) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "To E-Sign document(s) please make a selection.",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else {
                    var row = event.getParam('row');
                    component.set("v.documentId", row.Id);
                    helper.checkIfDocumentRestricted(component, event, helper, 'sign', '');
                }
                break;
            case 'email':
                let lines2 = [];
                lines2 = component.find('linesTable').getSelectedRows();
                var checkCmp = component.find("completedCheckboxEmailSharing");
                component.set("v.isCompleted", checkCmp.get("v.value"));
                if (lines2.length === 0) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "To email document(s) please make a selection.",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else if (lines2.length > 10) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "To email document(s) please select maximum of 10 documents.",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else if (checkCmp.get("v.value") == true) {
                    if(component.get("v.alternativeEmailSharing") == '') {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams ({
                            "title": "Error!",
                            "message": "Use Alternative Email for Document Sharing? checkbox is selected, please capture Alternative Email.",
                            "type": "error"
                        });
                        toastEvent.fire();
                    } else {
                        component.set("v.selectedClientEmail", component.get("v.alternativeEmailSharing"));
                        //component.set("v.showAdviserConfirmation", true);
                        component.set("v.electronicSharing", true);

                        var oppId = component.get("v.recordId");
                        var action = component.get("c.getUserRole");
                        action.setParams({
                            "oppId": oppId
                        });
                        action.setCallback(this, function(response) {

                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var userRole = response.getReturnValue();
                                if(userRole == 'Adviser'){
                                    //Show Adviser
                                    component.set("v.showAdviserConfirmation", true);

                                }else if(userRole == 'Assistant'){
                                    //Show Assistant
                                    component.set("v.showAssistantConfirmation", true);
                                }else{
                                    //Show Error no Access
                                    component.set("v.showNoAccess", true);
                                }
                            }
                        });
                        $A.enqueueAction(action);

                    }
                } else if (component.find("emailSelectSharing").get("v.value") == 'None') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "Please Select Email for Documents Sharing.",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else {
                    component.set("v.selectedClientEmail", component.find("emailSelectSharing").get("v.value"));
                    //component.set("v.showAdviserConfirmation", true);
                    component.set("v.electronicSharing", true);

                    var oppId = component.get("v.recordId");
                    var action = component.get("c.getUserRole");
                    action.setParams({
                        "oppId": oppId
                    });
                    action.setCallback(this, function(response) {

                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var userRole = response.getReturnValue();
                            if(userRole == 'Adviser'){
                                //Show Adviser
                                component.set("v.showAdviserConfirmation", true);

                            }else if(userRole == 'Assistant'){
                                //Show Assistant
                                component.set("v.showAssistantConfirmation", true);
                            }else{
                                //Show Error no Access
                                component.set("v.showNoAccess", true);
                            }
                        }
                    });
                    $A.enqueueAction(action);
                }
                break;
            case 'download':
                let lines3 = [];
                lines3 = component.find('linesTable').getSelectedRows();
                if (lines3.length === 0) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "To view document(s) please make a selection.",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else if (lines3.length > 10) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "To view document(s) please select maximum of 10 documents.",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else {
                    //if confirmation box is needed for On Screen sharing
                    //component.set("v.showAdviserConfirmation", true);
                    //component.set("v.onScreenSharing", true);

                    //if confirmation box is not needed for On Screen sharing
                    for (var i = 0; i < lines3.length; i++) {
                        helper.download(component, lines3[i].Id, lines3[i].Name);
                    }
                    helper.refresh(component);
                }
                break;
            case 'delete':
                var row = event.getParam('row');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams ({
                    "title": "Error!",
                    "message": "The document '" + row.Name + "' cannot be deleted.",
                    "type": "error"
                });
                toastEvent.fire();
                break;
        }
    },

    handleRowActionSignatory: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'update_details':
                var row = event.getParam('row');
                if (row.Role == 'Client') {
                    component.set("v.signatoryId", row.Id);
                    helper.fetchAllClientEmailsSignature(component);
                    helper.getMobile(component);
                    helper.fetchMethodPickListVal(component, 'Preferred_Method__c', row);
                    component.set("v.showSignatoryUpdatePanel", true);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "Only 'Client' values can be overridden.",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                break;
        }
    },

    closeConfirmation: function(component, event, helper) {
        component.set("v.showESignaturePanel", false);
    },

    confrimAndClose: function(component, event, helper) {
        component.set("v.showESignaturePanel", false);
    },

    sendForSignature: function(component, event, helper) {
        //var draftValues = event.getParam('draftValues');
        //helper.sendForSignature(component, JSON.stringify(draftValues));
        helper.checkIfDocumentRestricted(component, event, helper, 'sendForSignature', JSON.stringify(component.get("v.signatoriesOutput")));
    },

    confrimAndCloseSignatory: function(component, event, helper) {
        component.set("v.updateSignatoryError", false);
        var checkCmp = component.find("completedCheckboxEmail");
        if(checkCmp.get("v.value") == true) {
            if(component.get("v.alternativeEmail") == '') {
                component.set("v.updateSignatoryError", true);

                var toastEvent2 = $A.get("e.force:showToast");
                toastEvent2.setParams ({
                    "title": "Error!",
                    "message": "Use Alternative Email for E-Signature? checkbox is selected, please capture Alternative Email.",
                    "type": "error"
                });
                toastEvent2.fire();
            } else {
                component.set("v.selectedEmailSignatory", component.get("v.alternativeEmail"));
            }
        } else if (component.get("v.selectedEmail") != 'Choose one...') {
            component.set("v.selectedEmailSignatory", component.get("v.selectedEmail"));
        }

        checkCmp = component.find("completedCheckboxMobile");
        if(checkCmp.get("v.value") == true) {
            if(component.get("v.alternativeMobile") == '') {
                component.set("v.updateSignatoryError", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams ({
                    "title": "Error!",
                    "message": "Use Alternative Mobile for E-Signature? checkbox is selected, please capture Alternative Mobile.",
                    "type": "error"
                });
                toastEvent.fire();
            } else {
                component.set("v.selectedMobileSignatory", component.get("v.alternativeMobile"));
            }
        } else if (component.get("v.selectedMobile") != '') {
            component.set("v.selectedMobileSignatory", component.get("v.selectedMobile"));
        }

        if (!component.get("v.updateSignatoryError")) {
            component.set("v.showSignatoryUpdatePanel", false);
            helper.updateSignatories(component, JSON.stringify(component.get("v.signatoriesOutput")));
            helper.refreshSignatories(component); // added to refresh signatory list data, email was not displaying - Tinashe 21-05-2020
        }
    },

    onPicklistMethodChange: function(component, event, helper) {
        component.set("v.selectedMethod", event.getSource().get("v.value"));
    },

    closeConfirmationSignatory: function(component, event, helper) {
        component.set("v.showSignatoryUpdatePanel", false);
    },

    refreshSignatories: function(component, event, helper) {
        component.set("v.isButtonSignatureDisabled", false);
        helper.refreshSignatories(component);
    },

    refreshDocuments: function(component, event, helper) {
        helper.fetchData(component);
        helper.refresh(component);
        helper.checkStage(component);
    },

    onCompletedCheckEmail: function(component, event) {
        var checkCmp = component.find("completedCheckboxEmail");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true){
            component.find("emailSelect").set("v.disabled", true);
            component.set("v.showAlternativeEmail", true);
        }
        else{
            component.find("emailSelect").set("v.disabled", false);
            component.set("v.showAlternativeEmail", false);
        }
    },

    onCompletedCheckMobile: function(component, event) {
        var checkCmp = component.find("completedCheckboxMobile");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true) {
            component.find("mobileSelect").set("v.disabled", true);
            component.set("v.showAlternativeMobile", true);
        }
        else {
            component.find("mobileSelect").set("v.disabled", false);
            component.set("v.showAlternativeMobile", false);
        }
    },

    onPicklistEmailChangeSharing: function(component, event, helper) {
        component.set("v.selectedEmailSharing", event.getSource().get("v.value"));
    },

    onPicklistEmailChangeSignature: function(component, event, helper) {
        component.set("v.selectedEmail", event.getSource().get("v.value"));
    },

    onCompletedCheckEmailSharing: function(component, event, helper) {
        var checkCmp = component.find("completedCheckboxEmailSharing");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true) {
            component.find("emailSelectSharing").set("v.disabled", true);
            component.set("v.showAlternativeEmailSharing", true);
        }
        else {
            component.find("emailSelectSharing").set("v.disabled", false);
            component.set("v.showAlternativeEmailSharing", false);
        }
    },

    // Tinashe Shoko: 20200726: Sort Documents List
    handleSort: function(component, event, helper) {
        helper.sortData(component, event);
    }
})
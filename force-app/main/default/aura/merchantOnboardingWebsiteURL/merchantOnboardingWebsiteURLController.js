({
    doInit: function (component, event, helper) {
        //helper.fetchFileTypesPickListVal(component);
        var actions = [
            /*{ label: "View File Details", name: "viewFileDetails" },
            { label: "Add Document", name: "addDocument" },
            { label: "Generate Document", name: "generateDocument" },
            { label: "Write Document", name: "writeDocument" },
            { label: "Sign Document", name: "signDocument" },
            { label: "Share Document", name: "shareDocument" }*/
        ];
        component.set("v.columns", [
            {
                label: "URL",
                fieldName: component.get("v.fieldName"),
                type: "url",
                editable: "true",
                initialWidth: "500"
            },
            { type: "action", typeAttributes: { rowActions: actions } }
        ]);
        var data = [
            {
                id: "1",
                documentType: "Document Type"
            }
        ];
        component.set("v.data", data);
        helper.fetchWebsiteData(component, event, helper);
        helper.fetchDocumentMetadata(component);
    },
    
    handleURLOnChange: function (component, event, helper) {
        $A.util.removeClass(component.find("savebtn"), "slds-hide");
    },
    
    handleSelect: function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        var selectedMenuItemValue = event.getParam("value");
        if (selectedMenuItemValue == "addDocument") {
        } else {
            console.log("Unhandled Menu Selection");
        }
    },
    
    /**
   * @description handleFilesChange function.
   **/
    handleFilesChange: function (component, event, helper) {
        var fileName = "No File Selected..";
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]["name"];
        }
        component.set("v.fileName", fileName);
    },
    
    /**
   * @description doSave function.
   **/
    doSave: function (component, event, helper) {
        if (!component.get("v.disableRadioButtonGroup")) {
            var checkCmp = component.find("radioGrp");
            if (
                component.find("fileId").get("v.files") &&
                component.find("fileId").get("v.files").length > 0
            ) {
                if (component.get("v.fileType").length > 0) {
                    helper.upload(component, event);
                } else {
                    alert("Please Select File Type");
                }
            } else {
                alert("Please Select a Valid File");
            }
        } else if (
            component.find("fileId").get("v.files") &&
            component.find("fileId").get("v.files").length > 0
        ) {
            if (
                component.get("v.fileType").length > 0 &&
                component.get("v.fileType") != "Choose one..."
            ) {
                helper.upload(component, event);
            } else {
                alert("Please Select File Type");
            }
        } else {
            alert("Please Select a Valid File");
        }
    },
    
    onload: function (component, event, helper) {
        $A.util.addClass(component.find("savebtn"), "slds-hide");
    },
    
    handleSuccess: function (component, event, helper) {
        // Show toast
        helper.fireToast(
            "Success!",
            "URL has been updated successfully.",
            "success"
        );
        $A.util.addClass(component.find("savebtn"), "slds-hide");
    },
    
    handleError: function (component, event, helper) {
        // Show toast
        helper.fireToast(
            "Error!",
            "URL has not updated successfully. Please enter a valid URL format starting wth http:// or https://.",
            "error"
        );
        $A.util.addClass(component.find("savebtn"), "slds-hide");
    },
    
    handleApplicationEvent: function (component, event, helper) {
        var opportunityProductId = event.getParam("opportunityProductId");
        if (!$A.util.isEmpty(opportunityProductId)) {
            component.set("v.opportunityProductId", opportunityProductId);
            helper.fetchAccountContactRelation(component, event, helper);
        }
    },
    
    // PJAIN: 20200630
    opportunityRecordUpdated: function (component, event, helper) {
        var eventParams = event.getParams();
        if (eventParams.changeType === "LOADED") {
            var approvalStatus = component.get(
                "v.opportunityRecord.Approval_Status__c"
            );
            if (approvalStatus === "Pending") {
                component.set("v.isApprovalPending", true);
            } else {
                component.set("v.isApprovalPending", false);
            }
        } else if (eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            var changedFields = eventParams.changedFields;
            if (changedFields) {
                var approvalStatusChanged = changedFields.Approval_Status__c;
                if (approvalStatusChanged) {
                    if (approvalStatusChanged.value === "Pending") {
                        component.set("v.isApprovalPending", true);
                    } else {
                        component.set("v.isApprovalPending", false);
                    }
                }
            }
        }
    },
    
    /* This function is
   * to save modified records
   * */
    onSave: function (component, event, helper) {
        var editedRecords = event.getParam("draftValues");
        var action = component.get("c.updateURLs");
        action.setParams({
            oppId: component.get("v.recordId"),
            objectApiName: component.get("v.objectApiName"),
            editedRecords: editedRecords[0],
            urlField: component.get("v.fieldName")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data == true) {
                    helper.fireToast(
                        "Success!",
                        "URL has updated successfully.",
                        "success"
                    );
                } else {
                    helper.fireToast(
                        "Error!",
                        "URL has not updated successfully. Please enter a valid URL format starting wth http:// or https://.",
                        "error"
                    );
                }
                $A.get("e.force:refreshView").fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log(
                    "Callback to updateURLs Failed. Error : [" +
                    JSON.stringify(errors) +
                    "]"
                );
            } else {
                console.log("Callback to updateURLs Failed.");
            }
        });
        $A.enqueueAction(action);
    }
});
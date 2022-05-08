({
    doInit: function (component, event, helper) {
        
        //check already exist such file and then delete the older one
        var action = component.get("c.getExistDocument");
        
        action.setParams({
            oppId: component.get("v.recordId"), 
            docType:component.get("v.fileType")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('return value--',returnValue);
                component.set("v.existDoc",returnValue);
                component.set("v.existDocId",returnValue.Id);
                component.set("v.isDocExist",true);
            }else{
                console.log("failed with status:",response.getReturnValue());
            }
            
        });
        $A.enqueueAction(action);    
        
        
        //helper.fetchFileTypesPickListVal(component);
        var actions = [
            { label: "View File Details", name: "viewFileDetails" },
            { label: "Add Document", name: "addDocument" },
            { label: "Generate Document", name: "generateDocument" },
            { label: "Write Document", name: "writeDocument" },
            { label: "Sign Document", name: "signDocument" },
            { label: "Share Document", name: "shareDocument" }
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
            //show upload section
            component.set("v.showUploadSection",true);
        }else if(selectedMenuItemValue == "viewFileDetails"){
            //navigate to file
            var fileId = component.get("v.existDoc.File_Id__c");
            console.log("fileId---",fileId);
             console.log("fileId---",component.get("v.existDoc").File_Id__c);
            //window.location.href='/servlet/servlet.FileDownload?file='+fileId;
           window.open('/servlet/servlet.FileDownload?file='+fileId,'_blank');
            
        } 
            else if(selectedMenuItemValue == 'downloadDocument'){
                var fileNamedwd=component.get('v.fileNamedwd');
                helper.download(component,helper,fileNamedwd);
                
            }
                else {
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
            var fileId = event.getSource().get("v.files")[0]["Id"];
        }
        console.log('fileName'+fileName);
        console.log('fileId'+fileId);
        component.set("v.fileName", fileName);
        component.set('v.fileNamedwd',fileName);
    },
    
    /**
   * @description doSave function.
   **/
    doSave: function (component, event, helper) {
        //check if document existed delete it
        
        var docId = component.get("v.existDocId");
        console.log('docId--- before saving--',docId);
        if(docId != null){
            //check already exist such file and then delete the older one
            var action = component.get("c.deleteExistDocument");
            
            action.setParams({
                oppId: component.get("v.recordId"),
                docType:component.get("v.fileType"),
                docId:component.get("v.existDocId")
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    
                    console.log('return value--',returnValue);
                    console.log('exisitng doc deleted successfully')
                    //component.set("v.existDocId",returnValue);
                    component.set("v.isDocExist",false);
                }else{
                    console.log("failed with status:",response.getReturnValue());
                }
                
            });
            $A.enqueueAction(action);    
            
        }
        //upload the new one latest 
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
     
})
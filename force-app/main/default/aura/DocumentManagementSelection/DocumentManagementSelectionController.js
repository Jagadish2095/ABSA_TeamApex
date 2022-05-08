({
	loadDocumentPlaceholders : function(component, event, helper) {
        helper.loadInfo(component, helper);  
        helper.getOppDetails(component, helper);
        
        component.set('v.columns', [{label: '', fieldName: 'Type__c', type: 'text'},
                                    {label: 'Upload', type: 'button', initialWidth: 135, typeAttributes: {iconName: 'utility:upload', label: 'Upload', name: 'upload_document', title: 'Click to Upload', class: {fieldName: 'isbutton'}, disabled: {fieldName: 'upload_disabled'}}},
                       {label: 'Generate', type: 'button', initialWidth: 135, typeAttributes: {iconName: 'utility:download', label: 'Generate', name: 'generate_document', title: 'Click to Generate', class: {fieldName: 'isbutton'}, disabled: {fieldName: 'generate_disabled'}}},
                       {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { iconName: 'utility:preview' ,label: 'View', name: 'view_document', title: 'Click to View', class: {fieldName: 'isbutton'}, disabled: {fieldName: 'view_disabled'}}},
                       {label: 'Delete', type: 'button', initialWidth: 135, typeAttributes: { iconName: 'utility:delete',label: 'Delete', name: 'delete_document', title: 'Delete to View' , class: {fieldName: 'isbutton'}, disabled: {fieldName: 'delete_disabled'}}},
                       {label: 'E-Sign', type: 'button', initialWidth: 135, typeAttributes: { iconName: 'standard:record_signature_task',label: 'ESign', name: 'sign_document', title: 'E-Sign' , class: {fieldName: 'isbutton'}, disabled: {fieldName: 'sign_disabled'}}}
                                   ]);
        //component.set("v.data" , [{Id: '0',Type__c: 'ABC Properties Private Ltd','upload_document':'slds-hide',"_children":[{Id: '1',Type__c: 'AW 042 EX - Foreign Exchange Authority 1'} , {Id: '1',Type__c: 'AW 042 EX - Foreign Exchange Authority'}]}]);
		 var actions2 = [
            { label: 'Update Signatory Details', iconName: 'utility:edit', name: 'update_details' }
        ];
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
        //helper.fetchAllClientEmails(component);
        helper.fetchImpressionRequest(component);
        helper.updateImpressionRequest(component);

    },
    
    saveDocuments: function(component, event, helper) {
        helper.saveInfo(component, helper);
    },
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var fileType = cmp.set("v.fileType" , row.Type__c);
        switch (action.name) {
            case 'generate_document':
                helper.generateNewDocument(cmp, event, helper,row.Type__c, row.Account__c, row.Contact__c,row.Id);
                break;
            case 'upload_document':
                cmp.set("v.isModalOpen", true);
                cmp.set("v.docId" , row.Id);
                cmp.set("v.accountId" , row.Account__c);
                cmp.set("v.contactId" , row.Contact__c);
                break;
            case 'view_document':
                helper.getDocumentData(cmp,event,helper,row.Id);
                break;
            case 'delete_document':
                var flag = confirm("Are you sure, you want to delete document ?");
                if(flag){
                 helper.restrictSystemDocs(cmp, event,helper, row.Id);   
                }
                break;
            case 'sign_document' :
                cmp.set("v.documentId",row.Id);
                helper.checkIfDocumentRestricted(cmp,event ,helper, 'sign', '' , row.Id);
                break;
                
        }
     }
    ,
   /**
   * @description handleFilesChange function.
   **/
    handleFilesChange: function(component, event, helper) {
        var fileName = "No File Selected..";
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]["name"];
            var fExtension=fileName.split('.').pop();
            component.set("v.fileExtension",fExtension);
        }
        component.set("v.fileName", fileName);
    }
    ,
    
    /**
   * @description doSave function.
   **/
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files") && component.find("fileId").get("v.files").length > 0) {
           
            if (component.get("v.fileType").length > 0 && component.get("v.fileType") != 'Choose one...') {
                
                helper.upload(component, event);                
            } else {
                alert("Please Select File Type");
            }
        }else {
            alert("Please Select a Valid File");
        }
    }
    ,
    
   openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
    handleCloseModal : function(component, event, helper){
        component.set("v.isShowPreview", false);
    },
    
    submitDetails : function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
   refreshSignatories: function(component, event, helper) {
        component.set("v.isButtonSignatureDisabled", false);
        helper.refreshSignatories(component);
       	
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
     onPicklistMethodChange: function(component, event, helper) {
        component.set("v.selectedMethod", event.getSource().get("v.value"));
    },
    closeConfirmationSignatory: function(component, event, helper) {
        component.set("v.showSignatoryUpdatePanel", false);
    }
    ,

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
     sendForSignature: function(component, event, helper) {
         //var draftValues = event.getParam('draftValues');
        //helper.sendForSignature(component, JSON.stringify(draftValues));
        //W-012954
        var preSelectedRows = component.get("v.preSelectedRows");
        console.log('preSelectedRows -> ' + preSelectedRows.length);
        var checkselectedRowsIdsList = component.get("v.selectedRowsIdsList");
        console.log('checkselectedRowsIdsList -> ' + checkselectedRowsIdsList.length);
        if(checkselectedRowsIdsList.length == 0){
             component.set("v.showSpinner", true);
              var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please select at least one signatory to sign the document.",
                        "type":"error"
                    });
              
             toastEvent.fire();
             component.set("v.showSpinner", false);
             //helper.hideSpinner(component); //hide the spinner
        }else{
             helper.fetchSignatoriesSelected(component);
        }
    },
    // Added method to set attribute whenever the selection changes : W-12954
    handleRowSelectionChange : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRows', selectedRows);
        var selectedRowsIds = [];
        for(var i=0;i<selectedRows.length;i++){
            selectedRowsIds.push(selectedRows[i].Id); 
            component.set("v.selectedRowsIdsList", selectedRowsIds);
        }  
        var checkselectedRowsIdsList = component.get("v.selectedRowsIdsList");
        console.log('checkselectedRowsIdsList -> ' + checkselectedRowsIdsList);
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
    
    onCompletedCheckOrder: function(component, event) {
        var checkCmp = component.find("completedCheckboxOrder");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true){
            component.find("orderSelect").set("v.disabled", true);
            component.set("v.showAlternativeOrder", true);
        }
        else{
            component.find("orderSelect").set("v.disabled", false);
            component.set("v.showAlternativeOrder", false);
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

        }

        if (!component.get("v.updateSignatoryError")) {
            component.set("v.showSignatoryUpdatePanel", false);
            helper.updateSignatories(component, JSON.stringify(component.get("v.signatoriesOutput")));
            helper.refreshSignatories(component); // added to refresh signatory list data, email was not displaying - Tinashe 21-05-2020
            
        }
    },
    refreshDocuments: function (component, event, helper) {
        helper.refreshDoc(component, helper);
        helper.getPrimayClientMandatoryDocs(component);
    }

    
})
//Generic Signatories component developed by Tinashe, Masechaba and Tracy used for Signatories selection and esign
//Origninal component: DocumentShare and DocumentGenerate
//
({
    doInit: function(component, event, helper) {
        var processName =  component.get("v.processName");
        var actions2 = [
            { label: 'Update Signatory Details', iconName: 'utility:edit', name: 'update_details' }
        ];

        //Add by Masechaba
        component.set('v.columns2', [
           // { label: 'Document Name', fieldName: 'Document_Name', type: 'text' },
            { label: 'Document Type', fieldName: 'Document_Type', type: 'text' },
            { label: 'Title', fieldName: 'Title', type: 'text' },
            { label: 'Initials', fieldName: 'Initials', type: 'text' },
            { label: 'Last Name', fieldName: 'Last_Name', type: 'text' },
            { label: 'Mobile', fieldName: 'Mobile_Phone', type: 'text' },
            { label: 'Email', fieldName: 'Email', type: 'text' },
           // { label: 'Order', fieldName: 'Order', type: 'number' },
            { label: 'Role', fieldName: 'Role', type: 'text' },
            { label: 'Method', fieldName: 'Method', type: 'text' }
          //  { type: 'action', typeAttributes: { rowActions: actions2 } }
        ]);

        if(processName == "Select Signatories") { 
            component.set("v.isButtonSaveSignatoriesShow", true);
        } else {
            helper.fetchData(component);
            helper.fetchUserName(component);
            helper.fetchOwnerName(component);
            helper.fetchImpressionRequest(component);
            helper.fetchAllClientEmails(component);
            component.set("v.isButtonSignatureShow", true);
        }
        helper.getAppId(component, event, helper);
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

    //Adde by Masechaba to create Signature Request  Records
    createRecords: function(component, event, helper) {
        helper.showSpinner(component);
        if (component.get('v.showAbsa4060Options') == true) {
            component.find('absa4060OptionsForm').submit();
        }
        var records = component.get("v.selectedAccts");
        var opportunityId = component.get("v.recordId");
        var templateName = component.get("v.docTemplateName");

        console.log('opportunityId - ' + opportunityId);
        console.log('templateName - ' + templateName);

        var ids = new Array();
        for (var i= 0 ; i < records.length ; i++){
            ids.push(records[i].Id);
        }

        var idListJSON=JSON.stringify(ids);

        console.log('idListJSON - ' + idListJSON);

        var action = component.get("c.createDocumentSignatureRequests");
        action.setParams({
            "opportunityId":opportunityId,
            "documentTemplateName":templateName,
            "selectedIds":idListJSON});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                //TdB - Set signature Event
                var setEvent = $A.get("e.c:SetDocumentSignatories");
                setEvent.setParams({ signatureRequests: response.getReturnValue() });
                setEvent.fire();

                helper.fireToast('Success', 'Signatories created successfully', 'success');
                component.set("v.isButtonSaveSignatoriesDisabled", true);
            }else if(state === "ERROR"){
                var errors = response.getError();
                helper.fireToast('Error', errors, 'error');
            } else {
                helper.fireToast('Signatories Error', 'Signatories Creation Failed: Please contact your System Administrator', 'Error');
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    sendForSignature: function(component, event, helper) {
        var records = component.get("v.selectedAccts");
        console.log('records.length - ' + records.length);
        helper.checkIfDocumentRestricted(component, event, helper, 'sendForSignature', JSON.stringify(component.get("v.signatoriesOutput")));
    },

    doAction : function(component, event, helper) {
        var parentValue = event.getParam('arguments');
        var documentTemplate;
        component.set("v.showAbsa4060Options", false);
        if (parentValue) {
            documentTemplate = parentValue.documentTemplateName;
            console.log('DocumentSignatories: documentTemplate - ' + documentTemplate);
            component.set("v.docTemplateName", documentTemplate);
            if (documentTemplate == 'ABSA 4060 - Opening of an Account') {
                component.set("v.showAbsa4060Options", true);
            }
            if(component.get("v.processName") == "Select Signatories") { 
                helper.fetchSignatories(component);
            }
        }
    },

    //Added by Masechaba - Set selected Signatories
    handleSelect : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
        }
        component.set("v.selectedAccts", setRows);
        console.log('setRows - ' + setRows);
    },

    handleabsa4060radioGroupChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        if (changeValue != component.find('newOrExistingMandatedOfficial').get('v.value')){
            component.find('newOrExistingMandatedOfficial').set('v.value',changeValue);
        }
    },

    onloadAbsa4060Options: function (component, event, helper) {
        component.set('v.absa4060value',component.find('newOrExistingMandatedOfficial').get('v.value'));
    },
})
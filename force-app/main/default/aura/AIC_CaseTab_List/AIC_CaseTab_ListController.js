({
    doInit: function(component, event, helper) {
        helper.checkUser(component, event, helper);
        component.set('v.mycolumn', [
				{
                    label: 'Case Number',
                    fieldName: 'CaseNumber',
                    type: 'text',

                },
                {
                    label: 'Status',
                    fieldName: 'Status',
                    type: 'Text'
                },
            	{
                    label: 'Process',
                    fieldName: 'Comments__c',
                    type: 'Text'
                },
                {
                    label: 'Source System',
                    fieldName: 'Origin',
                    type: 'Text'
                },
            	{
                    label: 'Product',
                    fieldName: 'Description',
                    type: 'Text'
                },
                {
                    label: 'Unique Customer Identifier',
                    fieldName: 'CIF_Custom__c',
                    type: 'Text'
                },
                {
                    label: 'Entity Type',
                    fieldName: 'Account.Client_Type__c',
                    type: 'text'
                },
                {
                    label: 'Name',
                    fieldName: 'ClientName__c',
                    type: 'text'
                },
                {
                    label: 'SurName',
                    fieldName: 'Surname__c',
                    type: 'text'
                },
				{
                    label: 'Age',
                    fieldName: 'Age1__c',
                    type: 'text'
                },
				{
                    label: 'Case Type',
                    fieldName: 'Type__c',
                    type: 'text'
                },
				{
                    label: 'Date & Time of Case Creation',
                    fieldName: 'CreatedDate',
                    type: 'date',
                    typeAttributes: {  
                        day: 'numeric',  
                        month: 'short',  
                        year: 'numeric',  
                        hour: '2-digit',  
                        minute: '2-digit',  
                        second: '2-digit',  
                        hour12: true
                    },
                 },	                                                                   
                {
                    label: 'Record Type',
                    fieldName: 'recordType',
                    type: 'text',
                    typeAttributes: {
                        label: {
                            fieldName: 'RecordTypeId'
                        }
                    }
                }
            ]);
        let action = component.get("c.getCasesFromQueues");
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    
                    let NTBCasesRecords = responseData.ntbCases
                    NTBCasesRecords.forEach(function(NTBCasesRecords) {
                        NTBCasesRecords.linkName = '/' + NTBCasesRecords.Id;
                        NTBCasesRecords.recordType = NTBCasesRecords.RecordType.Name;
                    });
                    
                    let UnassignedCasesRecords = responseData.unassignedCases
                    UnassignedCasesRecords.forEach(function(UnassignedCasesRecords) {
                        UnassignedCasesRecords.linkName = '/' + UnassignedCasesRecords.Id;
                        UnassignedCasesRecords.recordType = UnassignedCasesRecords.RecordType.Name;
                    });
                    let verificationCases = responseData.verificationCases
                    verificationCases.forEach(function(verificationCase) {
                        verificationCase.linkName = '/' + verificationCase.Id;
                        verificationCase.recordType = verificationCase.RecordType.Name;
                    });
                    let JunkCasesRecords = responseData.junkCases
                    JunkCasesRecords.forEach(function(JunkCasesRecords) {
                        JunkCasesRecords.linkName = '/' + JunkCasesRecords.Id;
                        JunkCasesRecords.recordType = JunkCasesRecords.RecordType.Name;
                    });
                    let AwaitingDocumentCasesRecords = responseData.awaitingDocumentsCases
                    AwaitingDocumentCasesRecords.forEach(function(AwaitingDocumentCasesRecords) {
                        AwaitingDocumentCasesRecords.linkName = '/' + AwaitingDocumentCasesRecords.Id;
                        AwaitingDocumentCasesRecords.recordType = AwaitingDocumentCasesRecords.RecordType.Name;
                    });
                    
                    let productManagerCasesRecords = responseData.productManagerCases
                    productManagerCasesRecords.forEach(function(productManagerCasesRecord) {
                        productManagerCasesRecord.linkName = '/' + productManagerCasesRecord.Id;
                        productManagerCasesRecord.recordType = productManagerCasesRecord.RecordType.Name;
                    });
                    let voiceOutboundCasesRecords = responseData.voiceOutboundCases
                    voiceOutboundCasesRecords.forEach(function(voiceOutboundCasesRecord) {
                        voiceOutboundCasesRecord.linkName = '/' + voiceOutboundCasesRecord.Id;
                        voiceOutboundCasesRecord.recordType = voiceOutboundCasesRecord.RecordType.Name;
                    });
                    
                    let ArchivedRequestCasesRecords = responseData.archivedCases
                    ArchivedRequestCasesRecords.forEach(function(ArchivedRequestCasesRecords) {
                        ArchivedRequestCasesRecords.linkName = '/' + ArchivedRequestCasesRecords.Id;
                        ArchivedRequestCasesRecords.recordType = ArchivedRequestCasesRecords.RecordType.Name;
                    });
                    let AssignedCasesRecords = responseData.assignedCases
                    AssignedCasesRecords.forEach(function(AssignedCasesRecords) {
                        AssignedCasesRecords.linkName = '/' + AssignedCasesRecords.Id;
                        AssignedCasesRecords.recordType = AssignedCasesRecords.RecordType.Name;
                    });
                   

                    console.log(responseData)
                    component.set("v.NTBCases", responseData.ntbCases);
                    component.set("v.verificationCases", responseData.verificationCases);
                    component.set("v.junkCases", responseData.junkCases);                    
                    component.set("v.unassignedCases", responseData.unassignedCases);
                    component.set("v.awaitingDocumentsCases", responseData.awaitingDocumentsCases);
                    component.set("v.productManagerCases", responseData.productManagerCases);
                    component.set("v.voiceOutboundCases", responseData.voiceOutboundCases);
                    component.set("v.archivedCases", responseData.archivedCases);
                    component.set("v.assignedCases", responseData.assignedCases);
                    component.set("v.CasesFromLocalSearch", null);
                    component.set("v.showNTB", true);
                    component.set("v.showJunk", true);
                    component.set("v.showVerification", true);
                    component.set("v.showUnassigned", true);
                    component.set("v.showAwaitingDocuments", true);
                    component.set("v.showProductManager", true);
                    component.set("v.showVoiceOutbound", true);
                    component.set("v.showAssigned", true);
                    component.set("v.CaseKeyLocalSearch", '')
                }

            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    findCase: function(component, event, helper) {
        helper.getCase(component, event, helper)
    },

    findLocalCase: function(component, event, helper) {
        helper.getCaseFromQueue(component, event, helper)
    },

    findLocalArchiveCase: function(component, event, helper) {
        helper.getArchiveCaseFromQueue(component, event, helper)
    },
    getCaseIdFromTable: function(component, event, helper) {
        let selRows = event.getParam('selectedRows');
        component.set("v.chosenCase", selRows[0])
    },

})
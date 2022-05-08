({
    doInit: function(component, event, helper) {
        helper.checkUser(component, event, helper)
        if (component.get("v.superUser")) {
            component.set('v.mycolumn', [{
                    label: 'Case Number',
                    fieldName: 'linkName',
                    type: 'url',
                    typeAttributes: {
                        label: {
                            fieldName: 'CaseNumber'
                        },
                        target: '_blank'
                    }
                },
                {
                    label: 'Subject',
                    fieldName: 'Subject',
                    type: 'Text'
                },
                {
                    label: 'Status',
                    fieldName: 'Status',
                    type: 'Text'
                },
                {
                    label: 'Client Name',
                    fieldName: 'ClientName__c',
                    type: 'Text'
                },
                {
                    label: 'CIF Number',
                    fieldName: 'CIF__c',
                    type: 'Text'
                },
                {
                    label: 'CASA reference',
                    fieldName: 'FIC_CASA_Reference_Number__c',
                    type: 'text'
                },
                {
                    label: 'CASA sequence',
                    fieldName: 'FIC_CASA_Sequence_Number__c',
                    type: 'text'
                },

                {
                    label: 'Priority',
                    fieldName: 'Priority',
                    type: 'text'
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
        } else {
            component.set('v.mycolumn', [{
                    label: 'Case Number',
                    fieldName: 'CaseNumber',
                    type: 'text',

                },
                {
                    label: 'Subject',
                    fieldName: 'Subject',
                    type: 'Text'
                },
                {
                    label: 'Status',
                    fieldName: 'Status',
                    type: 'Text'
                },
                {
                    label: 'Client Name',
                    fieldName: 'ClientName__c',
                    type: 'Text'
                },
                {
                    label: 'CIF Number',
                    fieldName: 'CIF__c',
                    type: 'Text'
                },
                {
                    label: 'CASA reference',
                    fieldName: 'FIC_CASA_Reference_Number__c',
                    type: 'text'
                },
                {
                    label: 'CASA sequence',
                    fieldName: 'FIC_CASA_Sequence_Number__c',
                    type: 'text'
                },

                {
                    label: 'Priority',
                    fieldName: 'Priority',
                    type: 'text'
                },
                 {
                           label: 'Origin',
                           fieldName: 'Origin',
                           type: 'text'
                  },
                  {
                           label: ' Date and Time Received',
                           fieldName: 'CreatedDate',
                           type: 'text'
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

       component.set('v.myCasesColumn', [{
                           label: 'Case Number',
                           fieldName: 'linkName',
                           type: 'url',
                           typeAttributes: {
                               label: {
                                   fieldName: 'CaseNumber'
                               },
                               target: '_blank'
                           }
                       },
                       {
                           label: 'Subject',
                           fieldName: 'Subject',
                           type: 'Text'
                       },
                       {
                           label: 'Status',
                           fieldName: 'Status',
                           type: 'Text'
                       },
                       {
                           label: 'Client Name',
                           fieldName: 'ClientName__c',
                           type: 'Text'
                       },
                       {
                           label: 'CIF Number',
                           fieldName: 'CIF__c',
                           type: 'Text'
                       },
                       {
                           label: 'CASA reference',
                           fieldName: 'FIC_CASA_Reference_Number__c',
                           type: 'text'
                       },
                       {
                           label: 'CASA sequence',
                           fieldName: 'FIC_CASA_Sequence_Number__c',
                           type: 'text'
                       },

                       {
                           label: 'Priority',
                           fieldName: 'Priority',
                           type: 'text'
                       },
                       {
                           label: 'Origin',
                           fieldName: 'Origin',
                           type: 'text'
                       },
                       {
                           label: ' Date and Time Received',
                           fieldName: 'CreatedDate',
                           type: 'text'
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




        }
        let action = component.get("c.getCasesFromQueues");
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {

                    let ReferralCasesRecords = responseData.referralCases
                    ReferralCasesRecords.forEach(function(ReferralCasesRecords) {
                        ReferralCasesRecords.linkName = '/' + ReferralCasesRecords.Id;
                        ReferralCasesRecords.recordType = ReferralCasesRecords.RecordType.Name;
                    });
                    let NTBCasesRecords = responseData.ntbCases
                    NTBCasesRecords.forEach(function(NTBCasesRecords) {
                        NTBCasesRecords.linkName = '/' + NTBCasesRecords.Id;
                        NTBCasesRecords.recordType = NTBCasesRecords.RecordType.Name;
                    });
                    let NTPCasesRecords = responseData.ntpCases
                    NTPCasesRecords.forEach(function(NTPCasesRecords) {
                        NTPCasesRecords.linkName = '/' + NTPCasesRecords.Id;
                        NTPCasesRecords.recordType = NTPCasesRecords.RecordType.Name;
                    });
                    let MaintenanceCasesRecords = responseData.maintenanceCases
                    MaintenanceCasesRecords.forEach(function(MaintenanceCasesRecords) {
                        MaintenanceCasesRecords.linkName = '/' + MaintenanceCasesRecords.Id;
                        MaintenanceCasesRecords.recordType = MaintenanceCasesRecords.RecordType.Name;
                    });

                    let DisputeCasesRecords = responseData.disputeCases
                    DisputeCasesRecords.forEach(function(DisputeCasesRecords) {
                        DisputeCasesRecords.linkName = '/' + DisputeCasesRecords.Id;
                        DisputeCasesRecords.recordType = DisputeCasesRecords.RecordType.Name;
                    });
                    let RemediationCasesRecords = responseData.remediationCases
                    RemediationCasesRecords.forEach(function(RemediationCasesRecords) {
                        RemediationCasesRecords.linkName = '/' + RemediationCasesRecords.Id;
                        RemediationCasesRecords.recordType = RemediationCasesRecords.RecordType.Name;
                    });
                    let NewRequestCasesRecords = responseData.newRequestCases
                    NewRequestCasesRecords.forEach(function(NewRequestCasesRecords) {
                        NewRequestCasesRecords.linkName = '/' + NewRequestCasesRecords.Id;
                        NewRequestCasesRecords.recordType = NewRequestCasesRecords.RecordType.Name;
                    });
                    let UnassignedCasesRecords = responseData.unassignedCases
                    UnassignedCasesRecords.forEach(function(UnassignedCasesRecords) {
                    UnassignedCasesRecords.linkName = '/' + UnassignedCasesRecords.Id;
                    UnassignedCasesRecords.recordType = UnassignedCasesRecords.RecordType.Name;
                    });
                    let voiceInboundCasesRecords = responseData.voiceInboundCases
                    voiceInboundCasesRecords.forEach(function(voiceInboundCasesRecords) {
                    voiceInboundCasesRecords.linkName = '/' + voiceInboundCasesRecords.Id;
                    voiceInboundCasesRecords.recordType = voiceInboundCasesRecords.RecordType.Name;
                    });
                    let voiceOutboundCasesRecords = responseData.voiceOutboundCases
                    voiceOutboundCasesRecords.forEach(function(voiceOutboundCasesRecords) {
                    voiceOutboundCasesRecords.linkName = '/' + voiceOutboundCasesRecords.Id;
                    voiceOutboundCasesRecords.recordType = voiceOutboundCasesRecords.RecordType.Name;
                    });
                    let AwaitingDocumentCasesRecords = responseData.awaitingDocumentsCases
                    AwaitingDocumentCasesRecords.forEach(function(AwaitingDocumentCasesRecords) {
                        AwaitingDocumentCasesRecords.linkName = '/' + AwaitingDocumentCasesRecords.Id;
                        AwaitingDocumentCasesRecords.recordType = AwaitingDocumentCasesRecords.RecordType.Name;
                    });
                    let ArchivedRequestCasesRecords = responseData.archivedCases
                    ArchivedRequestCasesRecords.forEach(function(ArchivedRequestCasesRecords) {
                        ArchivedRequestCasesRecords.linkName = '/' + ArchivedRequestCasesRecords.Id;
                        ArchivedRequestCasesRecords.recordType = ArchivedRequestCasesRecords.RecordType.Name;
                    });
                    let AssignedCasesRecords = responseData.archivedCases
                    AssignedCasesRecords.forEach(function(AssignedCasesRecords) {
                        AssignedCasesRecords.linkName = '/' + AssignedCasesRecords.Id;
                        AssignedCasesRecords.recordType = AssignedCasesRecords.RecordType.Name;
                    });
                    let UserCasesRecords = responseData.userCases
                         UserCasesRecords.forEach(function(UserCasesRecords) {
                         UserCasesRecords.linkName = '/' + UserCasesRecords.Id;
                         UserCasesRecords.recordType = UserCasesRecords.RecordType.Name;
                     });

                    console.log(responseData)
                    component.set("v.NTBCases", responseData.ntbCases);
                    component.set("v.NTPCases", responseData.ntpCases);
                    component.set("v.MaintenanceCases", responseData.maintenanceCases);
                    component.set("v.ReferralCases", responseData.referralCases);
                    component.set("v.DisputeCases", responseData.disputeCases);
                    component.set("v.RemediationCases", responseData.remediationCases);
                    component.set("v.newRequestCases", responseData.newRequestCases);
                    component.set("v.unassignedCases", responseData.unassignedCases);
                    component.set("v.awaitingDocumentsCases", responseData.awaitingDocumentsCases);
                    component.set("v.archivedCases", responseData.archivedCases);
                    component.set("v.assignedCases", responseData.assignedCases);
                    component.set("v.voiceInboundCases", responseData.voiceInboundCases);
                    component.set("v.voiceOutboundCases", responseData.voiceOutboundCases);
                    component.set("v.userCases", responseData.userCases);
                    component.set("v.CasesFromLocalSearch", null);
                    component.set("v.CasesFromLocalSearch", null);
                    component.set("v.showMaintenance", true);
                    component.set("v.showReferral", true);
                    component.set("v.showNTP", true);
                    component.set("v.showNTB", true);
                    component.set("v.showDispute", true);
                    component.set("v.showRemediation", true);
                    component.set("v.showNewRequest", true);
                    component.set("v.showUnassigned", true);
                    component.set("v.showAwaitingDocuments", true);
                    component.set("v.showRemediation", true);
                    component.set("v.showAssigned", true);
                    component.set("v.showUserCases", true);
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
/**
* @description Default Case trigger handler that extends the TriggerHandler framework
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-10-10
*
**/
public class CaseTriggerHandler extends TriggerHandler {

    public virtual override void beforeInsert(List<sObject> newRecords) {
        // Start Added for VA Record
        Id BrokerNoteRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();
        list<case> CsLst = new list<case>();
        for(case cs : (list<case>) Trigger.new)
        {
            if(cs.RecordTypeId != BrokerNoteRecordTypeId )
            {
                CsLst.add(cs);
            }
        }
        // End Added for VA Record
    	   CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeInsert(CsLst);
           CaseTriggerFunctions.CheckValidAdvisorCode(Trigger.new);
    }

    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {

        Map<Id, Case> oldCaseValues = new Map<Id, Case>();
        Map<Id, Case> newCaseValues = new Map<Id, Case>();
        Map<Id, Case> rejectedCaseMap = new Map<Id, Case>();

        for(Id newRecordId: newRecords.keySet()) {

            //Get old and new values for the Case
            Case newCase = (Case)newRecords.get(newRecordId);
            Case oldCase = (Case)oldRecords.get(newRecordId);
            oldCaseValues.put(oldCase.id, oldCase);
            newCaseValues.put(newCase.id, newCase);

            if (oldCase.Approval_Status__c != 'Rejected' && newCase.Approval_Status__c == 'Rejected') {
                rejectedCaseMap.put(newRecordId, newCase);
            }
         }

        //Call method to display error if rejected
        if(!rejectedCaseMap.isEmpty()) {
            CaseTriggerFunctions.rejectedCaseLogic(rejectedCaseMap);
        }

		//Call method to log pause status time
        CaseTriggerFunctions.pauseSLA(newRecords,oldRecords);

        //Track the actual age of the Case in the hands of the client and the time it spent with support
        CaseTriggerFunctions.trackTransfer(Trigger.oldMap, Trigger.newMap);

        //Track Case Age based on status update
        CaseTriggerFunctions.trackCaseAge(newRecords,oldRecords);

        //Call method to update Service Type/Classification
        CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeUpdate(Trigger.New,oldCaseValues);

        //Call method to update Consultant, SME and Manager Case Duration Fields
        CaseTriggerFunctions.calculateCaseDuration(Trigger.New, oldCaseValues);

        //Call method to close Cases flagged as unwanted and change owner to Queue
        CaseTriggerFunctions.closeUnwantedCases(Trigger.New, oldCaseValues);

        //Call method to reopen case and extend the SLA
        CaseTriggerFunctions.reopenClosedCase(Trigger.New);

         //Call method to validate active task on case MVP 5.1.4 VJ
        CaseTriggerFunctions.validateActiveTaskOnCase(Trigger.New);

        // Added by Anu Dhaka
        // Call method to email, update status and update Queue for AIC
        CaseTriggerFunctions.validateCaseAccordingAIC(Trigger.oldMap,Trigger.New);

	}

    /* Uncomment if needed
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override beforeDelete');
    }*/

    public virtual override void afterInsert(Map<Id, sObject> newRecords) {

        Id BrokerNoteRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();// Added for VA Record

            List<sObject> communicationPlanList = new List<sObject>();
            List<Case> notificationsNewList = new List<Case>();

            for(Id newRecordId: newRecords.keySet()) {
                case CsRec= (case) newRecords.get(newRecordId);
               if(BrokerNoteRecordTypeId != CsRec.RecordTypeID) // Added for VA Record
               {
                    Case newCase = (Case)newRecords.get(newRecordId);
                    if(Test.isRunningTest()){
                        CaseTriggerFunctions.callDocPredictionService(newRecordId);
                    }
                    //check if a communication plan was configured for the service group relevant to this case

                    if( String.isBlank( newCase.sd_Communication_Plan_Id__c ) ) {
                        notificationsNewList.add(newCase);
                    }else{
                        communicationPlanList.add(newRecords.get(newRecordId));
                    }
                    if(newCase.ID_Type__c != null && newCase.Customer_ID__c != null){
                        CaseTriggerFunctions.refreshCaseClient(newCase.Id);
                    }
                    if(newCase.Type__c == 'PEP High Risk and Very High Risk'){
                        CaseTriggerFunctions.createEDDCase(newCase.Id , newCase.Type__c , newCase.AccountId);
                    }
             }
            }

            //Pass through if NO communication plan were detected
            if(notificationsNewList.size() > 0){
                CaseTriggerFunctions.emailResponse(notificationsNewList, null, 'create');
            }

            //Only pass through if a communication plan were detected
            if( communicationPlanList.size() > 0 ){
                CaseTriggerFunctions.createCommunicationPlanTasks(communicationPlanList);
            }

            //Track the actual age of the Case in the hands of the client and the time it spent with support
            CaseTriggerFunctions.trackTransferInsert(Trigger.new);

    }


    public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {

        CaseTriggerFunctions.updateApplicationOnCaseStatusRejected( Trigger.New, (Map<Id, Case>)oldRecords );   

        Map<Id, Case> oldCaseValues = new Map<Id, Case>();

        Map<Id, sObject> notificationsOldMap = new Map<Id, sObject>();
        List<Case> notificationsNewList = new List<Case>();
        List<sObject> communicationPlanOldList = new List<sObject>();
        List<sObject> communicationPlanNewList = new List<sObject>();
        Map<Id, Case> refundsMap = new Map<Id, Case>();
        List<case> CaseLst = new List<Case>();

        for(Id newRecordId: newRecords.keySet()) {

            //Get old and new values for the Case
            Case oldCase = (Case)oldRecords.get(newRecordId);
            Case newCase = (Case)newRecords.get(newRecordId);
            oldCaseValues.put(oldCase.id, oldCase);

            if(newCase.Extended_Request_Data__c != oldCase.Extended_Request_Data__c){
                CaseLst.add(newCase);
             }

            //check if a communication plan was configured for the service group relevant to this case
            if( String.isBlank( newCase.sd_Communication_Plan_Id__c ) ) {
                 notificationsOldMap.put(newRecordId, oldRecords.get(newRecordId));
                 notificationsNewList.add( newCase);
            }else{
                 communicationPlanOldList.add(oldRecords.get(newRecordId));
                 communicationPlanNewList.add(newRecords.get(newRecordId));
            }

          /*  if (oldCase.Refund_Approval_Stage__c != newCase.Refund_Approval_Stage__c && newCase.Refund_Approval_Stage__c == 'Level 3') {
                RefundApprovalProcessController.submitLevel3ApprovalProcess(newCase.Id);
            }
            if (oldCase.Refund_Approval_Stage__c != newCase.Refund_Approval_Stage__c && newCase.Refund_Approval_Stage__c == 'Level 2') {
                RefundApprovalProcessController.submitLevel2ApprovalProcess(newCase.Id);
            }
            if (oldCase.Refund_Approval_Stage__c != newCase.Refund_Approval_Stage__c && newCase.Refund_Approval_Stage__c == 'Level 1') {
                RefundApprovalProcessController.submitLevel1ApprovalProcess(newCase.Id);
            }
            if (oldCase.Mandate_Level_1_Escalation__c != newCase.Mandate_Level_1_Escalation__c && newCase.Mandate_Level_1_Escalation__c	 == true) {
                RefundApprovalProcessController.sendEscalationEmailsToLevel1(newCase.Id);
            }*/

             //Added for W-7233
        if(newCase.Status =='Closed'){
            CaseTriggerFunctions.sendUpdateToPCO(Trigger.New, oldCaseValues);
            }
        }

        //RN : Pass through if NO communication plans were detected
        //if(notificationsNewList.size()>0){
          //   CaseTriggerFunctions.emailResponse( notificationsNewList, notificationsOldMap, 'update');
       // }

        //RN : Only pass through if a communication plans were detected
        if( communicationPlanNewList.size() > 0 ){
            CaseTriggerFunctions.evaluateCommunicationPlanTasks(communicationPlanNewList, communicationPlanOldList);
        }

        //Call method to insert case comment
        CaseTriggerFunctions.insertTransferCaseComment(Trigger.New, oldCaseValues);

        //Call method to block spam junk email
        CaseTriggerFunctions.blockSpamJunkEmails(Trigger.New);
        //bank codes assignee
        if(CaseLst.size()>0){
            CaseTriggerFunctions.ControllerOfficerCaseAssignment(CaseLst);
        }
    }

    /* Uncomment if needed
    public virtual override void afterDelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override afterDelete');
    }*/

    /* Uncomment if needed
    public virtual override void afterUndelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override afterUndelete');
    }*/

}
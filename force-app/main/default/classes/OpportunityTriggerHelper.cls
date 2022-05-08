/**
 * @description QA Enhancement-  OpportunityTriggerHelper
 * @author Rajesh - 01/12/2020
 * W-006870 
*/

public class OpportunityTriggerHelper {

    /**
    * @description to update approver data
    * @param oppList
    */
    public static void updateApprovalData(List<Opportunity> oppList){
        Set<String> oppIdList = new Set<String>();
        for(Opportunity opp : oppList){
            //if(opp.RecordType.Name == 'Product Onboarding' || Test.isRunningTest()){
            oppIdList.add(opp.Id);
            //}
        }

        List<String>  processInstanceIds = new List<String>();
        for (Opportunity a : [SELECT Id,(SELECT ID FROM ProcessInstances  ORDER BY CreatedDate DESC) FROM Opportunity WHERE ID  IN : oppIdList])
        {
            for(ProcessInstance pi :a.ProcessInstances)
                processInstanceIds.add(pi.Id);
        }

        for (ProcessInstance pw : [SELECT TargetObjectId,LastActorId,LastActor.Name,ElapsedTimeInDays,Status,ProcessDefinitionId
                                   FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate ASC])
        {

            for(Opportunity opp : oppList){
                if(opp.Id == pw.TargetObjectId){
                    if(pw.Status == 'Rejected' || pw.Status == 'Pending' || pw.Status == 'Started'){
                        opp.IsAlreadyRejected__c = true;
                        if(pw.LastActorId != null){
                            opp.QA_Consultant__c = pw.LastActorId;
                            opp.Rejected_LastActorId__c = pw.LastActorId;
                        }

                        if((pw.Status == 'Pending' || pw.Status == 'Started') && opp.IsAlreadyRejected__c == false){
                            opp.QA_Submission_Status__c	 = 'Submitted';
                        }else if((pw.Status == 'Pending' || pw.Status == 'Started') && opp.IsAlreadyRejected__c == true){
                            if(opp.Rejected_LastActorId__c != null){
                              opp.QA_Consultant__c = opp.Rejected_LastActorId__c;
                            }
                            opp.QA_Submission_Status__c	 = 'Submitted';

                        }
                        else{
                            opp.QA_Submission_Status__c	 = pw.Status;
                        }
                        Date todaysDate = Date.today();
                        opp.QA_Submission_Date__c = todaysDate.addDays(-Integer.valueOf(pw.ElapsedTimeInDays));
                    } else{
                        opp.QA_Consultant__c = null;
                        opp.QA_Submission_Status__c	 = '';
                        opp.QA_Submission_Date__c = null;
                    }
                }
            }
        }
        // }

    }
    /**
    * @description W-008562 validation on closed opportunity so that banker will not able to update any information in onboarding process like account,opportunity
    * @param triggerNewMap
    * @param triggerOldMap
    */
    public static void closedOpportunityValidation(Map<Id,Opportunity> triggerNewMap,Map<Id,Opportunity> triggerOldMap) {
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Account> relatedParties = new  List<Account>();
        List<Account> updAccounts = new List<Account>();
        for(Opportunity opportunity : triggerNewMap.values()){
            opportunities.add(opportunity);
        }
        String OppProcessType;
        for(Opportunity opportunity : opportunities){
            if(triggerOldMap.get(opportunity.id).StageName  != opportunity.StageName &&  opportunity.StageName == 'Closed'){
                opportunity.ByPassValidationInApex__c = true;
                opportunity.IsFutureExecute__c = false;
                OppProcessType = opportunity.Process_Type__c;
               
            }
        }

    }
}
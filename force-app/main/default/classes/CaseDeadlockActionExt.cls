/**
* Apex controller class for the Aura bundle DeadlockAction.
* Allow a user set the Case as Deadlock and send approval request to Manager
*
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-07-16
*
**/

public without sharing class CaseDeadlockActionExt {
    
	/*
    * See if there ia an existing approval process in place
    * 
    * @param recId - Case Id
    * @return Boolean
    */     
    @AuraEnabled
    public static Boolean approvalProccessChecks(String recId)
    {
        Boolean approvalProcessInProgress;
        List<ProcessInstance> existingApprovalRequest = new List<ProcessInstance> ();
        
        //Existing/Pending Approval?
        existingApprovalRequest = [
            Select Id, TargetObjectId, isDeleted, Status,
            (
                Select Id, ProcessInstanceId, ActorId, Actor.Name, StepStatus, Comments 
                From StepsAndWorkItems
                Where 
                StepStatus = 'Pending'  and
                isDeleted = false 
                Order By 
                Createddate Desc
                Limit 1
            )
            From ProcessInstance
            Where
            isDeleted = false and
            TargetObjectId = :recId and
            Status = 'Pending'
            Order By 
            Createddate Desc
            Limit 1
        ];
        
        if(existingApprovalRequest.isEmpty())
        {
             approvalProcessInProgress =  false;
        }
        else
        {
             approvalProcessInProgress = true;
        }
        
        return approvalProcessInProgress;
    } 
    
    
    /*
    * Submit Case for Deadlock approval                     
    * <p>
    * Submit Case for approvak
    * 
    * @param  recId String Case Id
    * @param  reason String Deadlock Reason/Motivation 
    * @return void
    */
    @AuraEnabled
    public static void deadlockApproval(String recId, String reason)
    {
        System.debug('recId : ' + recId);
        System.debug('reason : ' + reason);
        
        
        Case caseRecord = [Select Id, Status, Deadlock_Reason_Motivation__c From Case Where Id = :recId];
        
        //Update Case Status to Deadlock
        caseRecord.Deadlock_Approval_Required__c = True;
        caseRecord.Deadlock_Reason_Motivation__c = reason;
        
        try{
            update caseRecord;
        }catch(DMLException ex){
            System.debug('There was an error trying to update the Case');
        }
        
        Try
        {
            // Create an approval request for the Case
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(reason);
            req1.setObjectId(recId);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            // Verify the result
            System.assert(result.isSuccess());
            
            Approval.UnlockResult lrList = Approval.unlock(caseRecord, TRUE);
            
        }catch(Exception ex){
            caseRecord.Approval_Status__c.addError(ex);
            System.debug('There was an error trying to Submit the Case for Approval');
            throw new AuraHandledException(ex.getMessage()); 
        }        
    } 
}
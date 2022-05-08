/**
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-10-12
* 
* @update 2020-06-26 - Rudolf Niehaus
* @description Include service requests without effecting the current features for complaints. 
**/
public without sharing class CaseReopenActionExt {
    /**
     * @description loadData description
     *
     * @param recId (String): recId
     * @return Return DataLoad: Return description
     */
    @AuraEnabled
    public static DataLoad loadData(String recId) {
        
        //Get record types for cases
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id serviceRequestRecordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId();

        DataLoad at = new DataLoad();
        Set<Id> idSet = new Set<Id>();
        idSet.add(recId);
        List<Case> caseList = new CasesSelector().selectByIdWithClassification(idSet, 1);
        
        //Check if Case is open
        if( caseList[0].isClosed == false ){
            at.isOpen = true;
        } 
        
        //check if service request case
        if( caseList[0].RecordTypeId == serviceRequestRecordTypeId){

            at.isServiceRequest = true;
            at.isExistingApprovalProcess =  false;

        }else{

            at.isServiceRequest = false;

            //Check if approval in progress
            Boolean approvalProcessInProgress;
            List<ProcessInstance> existingApprovalRequest = new List<ProcessInstance>();
            
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
        
            if(existingApprovalRequest.isEmpty()){
                at.isExistingApprovalProcess =  false;
            }else{
                at.isExistingApprovalProcess = true;
            }
        } 

        return at;
    }
        
    
    
    /**
     * @description approvalProccessChecks description
     *
     * @param recId (String): recId
     * @return Return Boolean: Return description
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
    
     /**
      * @description caseOpenCheck description
      *
      * @param recId (String): recId
      * @return Return Boolean: Return description
      */
    @AuraEnabled
    public static Boolean caseOpenCheck(String recId){
        
		Boolean isCaseOpen = true;
        Set<Id> idSet = new Set<Id>();
        idSet.add(recId);
        List<Case> caseList = new CasesSelector().selectByIdWithClassification(idSet, 1);
        
        if( caseList[0].isClosed == true){
            isCaseOpen = false;
        } 
        
        return isCaseOpen;
    }
        
    /**
     * @description reopenCase description
     *
     * @param recId (String): recId
     * @param reason (String): reason
     */
    @AuraEnabled
    public static void reopenCase(String recId, String reason){

        //Get record types for cases
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id serviceRequestRecordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId();
        
		Set<Id> idSet = new Set<Id>();
        idSet.add(recId);
        
        List<Case> caseList = new CasesSelector().selectByIdWithClassification(idSet, 1); 
        
        try{
            
            if(caseList.size() > 0) {  
                
                if( caseList[0].recordTypeId != serviceRequestRecordTypeId){

                    caseList[0].Reopen_Case_Approval_Required__c = true;
                
                }else{
                    caseList[0].Reopen_Case_Approval_Required__c = false;
                    caseList[0].Reopen_Case_Approval_Status__c = 'Approved';
                    caseList[0].Is_Case_Reopened__c = true;
                    caseList[0].Status = 'New';
                }
                
                caseList[0].Reopen_Case_Reason__c = reason;
                
                update caseList[0];
            }
            
        }catch(Exception ex){
            System.debug('There was an error trying to update and reopen the case: ' + ex.getMessage());
             throw new AuraHandledException(ex.getMessage()); 
        }
        

        if( caseList[0].recordTypeId != serviceRequestRecordTypeId){

            Try{

                // Create an approval request for the Case
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments(reason);
                req1.setObjectId(recId);
                
                // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req1);
                
                // Verify the result
                System.assert(result.isSuccess());
                
                Approval.UnlockResult lrList = Approval.unlock(caseList[0], TRUE);

            }catch(Exception ex){
                
                System.debug('There was an error trying to Submit the Case for Approval' + ex.getMessage());
                
                throw new AuraHandledException(ex.getMessage()); 
            }
            
        }     
    } 
      /**
       * @description DataLoad Description
       *
       */
      public class DataLoad{
        /**
         * @description isOpen
         */
        @AuraEnabled public Boolean isOpen {get;set;}
        /**
         * @description isExistingApprovalProcess
         */
        @AuraEnabled public Boolean isExistingApprovalProcess {get;set;}
        /**
         * @description isServiceRequest
         */
        @AuraEnabled public Boolean isServiceRequest {get;set;}
        /**
         * @description DataLoad description
         *
         */
        public DataLoad(){
            isOpen = false;
            isExistingApprovalProcess = false;
            isServiceRequest = false;
        }
    } 
}
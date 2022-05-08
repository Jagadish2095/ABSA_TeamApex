/**
* Descripton: Apex controller to execute ROT Approval Process.
* Class Name: ROTApprovalProcessController
**/
public class ROTApprovalProcessController {

    @auraEnabled
    public static void submitROTApprovalProcess(Id caseId, Case caseRecord){
        // Create an approval request for the Case
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting Request for Approval');
        req1.setObjectId(caseId);
        if(caseRecord.ROT_Approval_Stage__c == null || caseRecord.ROT_Approval_Stage__c == 'Leg 1'){
        req1.setProcessDefinitionNameOrId('Restriction_of_Transaction_Leg1Approval');
        }
        else if(caseRecord.ROT_Approval_Stage__c == 'Leg 2'){
            req1.setProcessDefinitionNameOrId('Restriction_of_Transaction_Leg2_Approval');
        }
        req1.setSkipEntryCriteria(false);
        
        // Submit the approval request for the Case
        Approval.ProcessResult result = Approval.process(req1);
        //ROTSchedulerHandler.caseROTStartDateUpdate(caseId);//Added by Bhanumurty for Pre-Lapse/Lapse dates.
    }
    
    @AuraEnabled
    public static ValidateWrapper validateRequest(Id caseId){
        ValidateWrapper wrap = new ValidateWrapper();
        List<RestrictionGroupWrapper> restrictionGrpWraps = new List<RestrictionGroupWrapper>();
        
        for(RestrictionGroup__c rotGroupRestriction : [SELECT Id,Name,GroupID__c,Restriction_ID__c,Case__c,EffectiveStartDate__c,EffectiveEndDate__c,Status__c,Description__c, 
                                                       (select id,Name,EffectiveStartDate__c, EffectiveEndDate__c,RestrictionGroupId__c,CustomerKey__c from RestrictionGroupCustomers__r Where Status__c !='Deleted'),
                                                       (select id,Name,EffectiveStartDate__c, EffectiveEndDate__c,RestrictionGroupId__c,Excluded_Account__c,AccountNumber__c from RestrictionGroupAccount__r Where Excluded_Account__c = false and Status__c !='Deleted'),
                                                       (select id,Name,Effective_Start_Date__c, Effective_End_Date__c,Restriction_Group_ID__c,Description__c from RestrictionGroupTransactionTypes__r Where Status__c !='Deleted')
                                                       FROM RestrictionGroup__c
                                                       where Case__c =: caseId])
        {
            RestrictionGroupWrapper restrictionGrpWrap = new RestrictionGroupWrapper();
            restrictionGrpWrap.restriction = rotGroupRestriction;
            restrictionGrpWrap.customers = rotGroupRestriction.RestrictionGroupCustomers__r.size() > 0 ? rotGroupRestriction.RestrictionGroupCustomers__r : new List<RestrictionGroupCustomer__c>();
            restrictionGrpWrap.accounts = rotGroupRestriction.RestrictionGroupAccount__r.size()>0 ? rotGroupRestriction.RestrictionGroupAccount__r : new List<RestrictionGroupAccount__c>();
            restrictionGrpWrap.transactionTypes = rotGroupRestriction.RestrictionGroupTransactionTypes__r.size()>0 ? rotGroupRestriction.RestrictionGroupTransactionTypes__r : new List<RestrictionGroupTransactionType__c>();
            restrictionGrpWraps.add(restrictionGrpWrap);
        }
        
        List<ContentDocumentLink> rotDocuments = new List<ContentDocumentLink >();
        rotDocuments = [SELECT ContentDocumentId,ContentDocument.Title, ContentDocument.CreatedDate,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId =: caseId  ];
        wrap.documents = rotDocuments;
        wrap.groupRestrictions = restrictionGrpWraps;
        return wrap;
    }
    
    public class ValidateWrapper{
        @AuraEnabled public List<RestrictionGroupWrapper> groupRestrictions ;
		@AuraEnabled public List<ContentDocumentLink> documents;
    }
    public class RestrictionGroupWrapper {
        @AuraEnabled public RestrictionGroup__c restriction;
        @AuraEnabled public List<RestrictionGroupCustomer__c> customers;
        @AuraEnabled public List<RestrictionGroupAccount__c> accounts;
        @AuraEnabled public List<RestrictionGroupTransactionType__c> transactionTypes;
    }
    
    
}
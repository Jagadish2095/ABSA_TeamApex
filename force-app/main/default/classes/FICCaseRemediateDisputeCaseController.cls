/**
 *
 * @author  Kamil Rega
 * @since   2021-05-10
 * @description  FICCaseRemediateDisputeCaseController
 * 
**/
public  with sharing class FICCaseRemediateDisputeCaseController {
    /**
     * @comment : getCase
     * @description  FICCaseRemediateDisputeCaseController
     * @return cas
     * @param caseId
     * */   
    @AuraEnabled
    public static Case getCase(String caseId) {
        if(Case.SObjectType.getDescribe().isAccessible()){
        List<Case> listCases = [SELECT Id, Status,FIC_Dispute_Comments__c,Referral_Reason__c, Fail_Additional_Information__c, Fail_Reason__c, Additional_Information__c, Show_Pass_Button__c  FROM Case WHERE Id = :caseId];
        if (!listCases.isEmpty()) {
            return listCases[0];
        }
        else{
            throw new ApplicationException('There is no Case for this Id');
        }
    }else{
    return null;
    }
       
    }
    /**
     * @comment : updateDisputeCase
     * @description  FICCaseRemediateDisputeCaseController
     *
     * @param caseToAssign
     * @param status
     * */
    @AuraEnabled
    public static void updateDisputeCase(Case caseToAssign,String status) {
       if( Case.SObjectType.getDescribe().isUpdateable()){
         update caseToAssign;
       }
        assignCase(caseToAssign); 

    }
     /**
     * @comment : assignCase
     * @description  FICCaseRemediateDisputeCaseController
     * 
     * @param caseToAssign
     * */
    private static void assignCase(Case caseToAssign) {
        AssignmentRule aR = new AssignmentRule();
        if( AssignmentRule.SObjectType.getDescribe().isAccessible()){
        aR = [SELECT id from AssignmentRule where SobjectType = 'Case' and Name = 'FICQueues' limit 1];
        }
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId = aR.id;
        caseToAssign.setOptions(dmlOpts);
        if( Case.SObjectType.getDescribe().isUpdateable()){
        update caseToAssign;
        }
    }
     /**
     * @comment : assignCase
     * @description  FICCaseRemediateDisputeCaseController
     * @param caseToAssign
     * @param nameOfQueue
     * */
    @AuraEnabled
    public static Void enrouteCase(Case caseToAssign, String nameOfQueue) {
        List<Group>  grp = new List<Group>();
        if( Group.SObjectType.getDescribe().isAccessible()){
         grp =  [SELECT Id from GROUP WHERE (type='Queue' AND Name =: nameOfQueue) WITH SECURITY_ENFORCED];
        }        
    
        caseToAssign.OwnerId = grp[0].Id ;
        if( Case.SObjectType.getDescribe().isUpdateable()){
        update caseToAssign;        
        }
    }  
    

}
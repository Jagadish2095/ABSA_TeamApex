/**
 * @description       : RelatedPartiesCofirController
 * @author            : khaliq Abdul
 * @group             : 
 * Ver   Date         Author                               Modification
 * 1.0   04-11-2021   khaliq Abdul						   Initial Version
 **/
public without sharing class RelatedPartiesCofirController 
{
    /**
	 * @description closeCase	 
	 * @param caseId
	 *  
	*/
    @AuraEnabled
    public static void closeCase(String caseId) 
    {
        Case targetCase = [Select Id, AccountId,Status, Out_Of_SLA_Comments__c, Out_Of_SLA_Reason__c from Case where Id = :caseId];
		//Account account = [Select Id,Name from Account where Id = :targetCase.AccountId];        
       // targetCase.Surname__c = account.Name;        
        targetCase.Status = 'Closed';        
        targetCase.Out_Of_SLA_Comments__c = 'Maintanace Related Parties';        
       targetCase.Out_Of_SLA_Reason__c = 'Add or Delete Related Parties';        
        update targetCase;
    }
}
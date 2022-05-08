/**
* Apex Enterprise Design Patterns
* Selector Layer for AccountContactRelation objects
*
* @author       Tinashe Mutsungi Shoko (CloudSmiths)
* @since        2020-05-28
*/
public class SignatureRequestSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return SignatureRequest__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            SignatureRequest__c.Id,
                SignatureRequest__c.Name,
                SignatureRequest__c.Signature_Name__c
                };
                    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    
    public List<SignatureRequest__c> selectById(Set<Id> idSet) {
        return (List<SignatureRequest__c>) selectSObjectsById(idSet);
    }
    
    //INHERIT FROM BASE CLASS - STOP
    
    //CUSTOM SELECTORS - START
    
    /**
* Returns Account-Contact Relations
*
* @param requestId
* @return List of SignatureRequest__c
*/
    public SignatureRequest__c selectbyRequestId(String requestId) {
        return [SELECT Id, impressionRequestID__C, signatureId__c, Processed__c, Step__c 
                FROM SignatureRequest__c WHERE signatureId__c = :requestId LIMIT 1];
    }
    
    //CUSTOM SELECTORS - END
}
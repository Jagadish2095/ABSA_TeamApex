public class DocumentAuditsSelector extends fflib_SObjectSelector {
	public Schema.SObjectType getSObjectType(){
        return Document_Audit__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Document_Audit__c.CreatedById,
            Document_Audit__c.CurrencyIsoCode,
            Document_Audit__c.Document__c,
            Document_Audit__c.Name,
            Document_Audit__c.LastModifiedById,
            Document_Audit__c.Opportunity__c,
            Document_Audit__c.Document_Name__c,
            Document_Audit__c.Document_Reference__c,
            Document_Audit__c.Document_Sharing_Email__c,
            Document_Audit__c.Document_Sharing_Method__c,
            Document_Audit__c.Document_Type__c
        };
    }
    
    public List<Document_Audit__c> selectDocumentsShare(Id opportunityId) {
		return [SELECT Id, Document_Name__c, Document_Type__c, Document_Reference__c, Document_Sharing_Method__c, Document_Sharing_Email__c, CreatedDate, Created_By_Name__c, Document__c FROM Document_Audit__c WHERE Opportunity__c =: opportunityId ORDER BY CreatedDate DESC];
    }
    
    public List<Document_Audit__c> selectDocumentsShareByEmail(Id opportunityId) {
        return [SELECT Id, Document_Name__c, Document_Type__c, Document_Reference__c, Document_Sharing_Method__c, Document_Sharing_Email__c, CreatedDate, Created_By_Name__c, Document__c 
                FROM Document_Audit__c 
                WHERE Opportunity__c =: opportunityId 
                AND Document_Sharing_Method__c = 'Email'
                ORDER BY CreatedDate DESC];
    }
}
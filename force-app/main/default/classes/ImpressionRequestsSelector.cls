/**
 * @description ImpressionRequestsSelector Description
 *
 */
public class ImpressionRequestsSelector extends fflib_SObjectSelector {
/**
 * @description getSObjectType description
 *
 * @return Schema.SObjectType: Return description
 */
    public Schema.SObjectType getSObjectType(){
        return ImpressionRequest__c.sObjectType;
    }

    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            ImpressionRequest__c.Id
        };
    }

    /**
     * @description selectRequestsByOpptyId description
     *
     * @param opportunityId (Id): opportunityId
     * @return List<ImpressionRequest__c>: Return description
     */
    public List<ImpressionRequest__c> selectRequestsByOpptyId(Id opportunityId) {
		return [SELECT Id, Document_Name__c, Name, Created_By_Name__c, Status__c, CreatedDate FROM ImpressionRequest__c WHERE Opportunity__c =: opportunityId ORDER BY CreatedDate DESC];
    }

    /**
     * @description selectInProgressRequestsByOpptyIdDocId description
     *
     * @param opportunityId (Id): opportunityId
     * @param documentId (Id): documentId
     * @param status (String): status
     * @return List<ImpressionRequest__c>: Return description
     */
    public List<ImpressionRequest__c> selectInProgressRequestsByOpptyIdDocId(Id opportunityId, Id documentId, String status) {
		return [SELECT Id FROM ImpressionRequest__c WHERE Opportunity__c =: opportunityId AND Document__c =: documentId AND Status__c =: status];
    }

    /**
     * @description selectAllRequests description
     *
     * @return List<ImpressionRequest__c>: Return description
     */
    public List<ImpressionRequest__c> selectAllRequests() {
        return Database.query(
            newQueryFactory().
            selectField('LastModifiedDate').
            selectField('requestID__c').
            selectField('createdByID').
            toSOQL()
        );
    }
    //End -  - Added by Tinashe M Shoko - W-003951, W-004228/9 20-05-2020

    /**
     * @description selectByRequestId description
     *
     * @param impressionRequestID (String): impressionRequestID
     * @return ImpressionRequest__c: Return description
     */
    public ImpressionRequest__c selectByRequestId(String impressionRequestID) {
        return [SELECT Id, RequestId__c, completed__c, Opportunity__c, Document__c 
                FROM ImpressionRequest__c WHERE requestID__c = :impressionRequestID LIMIT 1];
    }


    /**
    * @description select by id
    * @param recordId 
    * @return ImpressionRequest__c 
    **/
    public ImpressionRequest__c selectById(String recordId) {
        return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('RequestId__c')
				.selectField('Opportunity__c')
				.setCondition('Id = :recordId')
				.toSOQL()
		);
    }
}
/**
 * @description DigitalSignatorySignatoriesSelector Description
 *
 */
public class DigitalSignatorySignatoriesSelector extends fflib_SObjectSelector {
/**
 * @description getSObjectType description
 *
 * @return Schema.SObjectType: Return description
 */
    public Schema.SObjectType getSObjectType() {
        return Digital_Signature_Signatory__c.sObjectType;
    }
    
    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Digital_Signature_Signatory__c.Id
        };
    }

    /**
     * @description selectSignatory description
     *
     * @param adminId (Id): adminId
     * @return List<Digital_Signature_Signatory__c>: Return description
     */
    public List<Digital_Signature_Signatory__c> selectSignatory(Id adminId) {
		return [SELECT Id, Signatory_Type__c, order__c, Preferred_Method__c FROM Digital_Signature_Signatory__c WHERE Digital_Signature_Admin__c =: adminId ORDER BY order__c];
    }

        /**
     * @description selectSignatoryByRecordType description
     *
     * @param adminId (Id): adminId
     * @param oppRecordTypeName (string): oppRecordTypeName
     * @return List<Digital_Signature_Signatory__c>: Return description
     */
    public List<Digital_Signature_Signatory__c> selectSignatoryByRecordType(Id adminId, string oppRecordTypeName) {
		return [SELECT Id, Signatory_Type__c, order__c, Preferred_Method__c FROM Digital_Signature_Signatory__c WHERE Digital_Signature_Admin__c =: adminId AND Opportunity_Record_Types_Applicable_To__c includes (:oppRecordTypeName) ORDER BY order__c];
    }
}
/**
 * @description DigitalSignatureAdminsSelector Description
 *
 */
public class DigitalSignatureAdminsSelector extends fflib_SObjectSelector {
/**
 * @description getSObjectType description
 *
 * @return Schema.SObjectType: Return description
 */
    public Schema.SObjectType getSObjectType() {
        return Digital_Signature_Admin__c.sObjectType;
    }

    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Digital_Signature_Admin__c.Id
        };
    }
    
    /**
     * @description selectDigitalSignatureAdminByType description
     *
     * @param documentType (string): documentType
     * @return List<Digital_Signature_Admin__c>: Return description
     */
    public List<Digital_Signature_Admin__c> selectDigitalSignatureAdminByType(string documentType) {
		return [SELECT Id FROM Digital_Signature_Admin__c WHERE Document_Type__c =: documentType];
    }
}
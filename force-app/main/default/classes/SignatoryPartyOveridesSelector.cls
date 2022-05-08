/**
* @description A selector class for Signatory Party Overide object
* @author Vladimir Panajic
* @created 2019-10-14
**/
public class SignatoryPartyOveridesSelector extends fflib_SObjectSelector {
/**
 * @description getSObjectType description
 *
 * @return Schema.SObjectType: Return description
 */
    public Schema.SObjectType getSObjectType(){
        return Signatory_Party_Overide__c.sObjectType;
    }

    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Signatory_Party_Overide__c.Id
        };
    }

    /**
     * @description getSignatoryPartyOverides description
     *
     * @param opportunityId (Id): opportunityId
     * @param signatoryId (Id): signatoryId
     * @param recordLimit (Integer): recordLimit
     * @return List<Signatory_Party_Overide__c>: Return description
     */
    public List<Signatory_Party_Overide__c> getSignatoryPartyOverides(Id opportunityId, Id signatoryId, Integer recordLimit) {
		return [SELECT Id, Opportunity__c, Preferred_Email__c, Preferred_Method__c, Preferred_Mobile__c, Signatory_Party__c,Preferred_Order__c FROM Signatory_Party_Overide__c WHERE Signatory_Party__c =: signatoryId AND Opportunity__c =: opportunityId];
    }
}
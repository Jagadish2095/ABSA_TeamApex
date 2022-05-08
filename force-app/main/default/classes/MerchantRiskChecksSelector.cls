/**
* Apex Enterprise Design Patterns
* Selector Layer for Merchant_Risk_Check__c objects
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2020-05-28
*/
public class MerchantRiskChecksSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Merchant_Risk_Check__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Merchant_Risk_Check__c.Id,
                Merchant_Risk_Check__c.Name,
                Merchant_Risk_Check__c.Business_Name__c,
                Merchant_Risk_Check__c.City__c,
                Merchant_Risk_Check__c.Country__c,
                Merchant_Risk_Check__c.Date_Added_On__c,
                Merchant_Risk_Check__c.JSON_Response__c,
                Merchant_Risk_Check__c.Match_Type__c,
                Merchant_Risk_Check__c.Opportunity__c,
                Merchant_Risk_Check__c.Response_Code__c,
                Merchant_Risk_Check__c.Termination_Reason_Code__c
                };
                    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    //get Merchant_Risk_Check__c by id's 
    public List<Merchant_Risk_Check__c> selectById(Set<Id> idSet) {
        return (List<Merchant_Risk_Check__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END
    
    //TdB: 20200528
    public List<Merchant_Risk_Check__c> selectByOpportunityId(Id oppId) {
        
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Business_Name__c').
            selectField('City__c').
            selectField('Country__c').
            selectField('Date_Added_On__c').
            selectField('JSON_Response__c').
            selectField('JSON_Request__c').
            selectField('Match_Type__c').
            selectField('Opportunity__c').
            selectField('Response_Code__c').
            selectField('Termination_Reason_Code__c').
            selectField('CreatedBy.Name').
            selectField('CreatedDate').
            setCondition('Opportunity__c =: oppId').
            toSOQL()
        );
    }
}
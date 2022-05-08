/**
* Apex Enterprise Design Patterns
* Selector Layer for Opportunity Party objects
*
* @author  Kyle Alexander
* @since   2018-09-04
*/

public class OpportunityPartiesSelector extends fflib_SObjectSelector {
	
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Opportunity_Party__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Opportunity_Party__c.id,
                Opportunity_Party__c.name
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get cases by id's
    public List<Opportunity_Party__c> selectById(Set<Id> idSet) {
        return (List<Opportunity_Party__c>) selectSObjectsById(idSet);
    }

    //CUSTOM SELECTORS - START

    /**
     * Method that gets a list of opp parties given certain criteria
     *
     * @return Opportunity_Party__c -  list of OpportunityParties
     */
    public List<Opportunity_Party__c> selectByOpportunityIdAndPartyType(Id oppId, String partyType) {
        return Database.query(
                newQueryFactory().
                    selectField('First_Name__c').
                    selectField('Last_Name__c').
                    selectField('Name').
                    selectField('ID_Type__c').
            		selectField('Initials__c').
                    selectField('RSA_ID_Number__c').
                    selectField('Date_of_Birth__c').
                    selectField('Relationship__c').
                    selectField('Age__c').
            		selectField('Age_As_Number__c'). //Added for Direct Delivery Sales Opportunity 
            		selectField('Gender__c'). //Added for Flexi funeral functionality
            		selectField('DD_Cross_Sell_Product_Member_Type__c'). //Added for Flexi funeral functionality
            		selectField('Beneficiary_Product__c'). //Added for Flexi funeral functionality
                    selectField('Benefit_Split__c').
                    selectField('Party_Type__c').
					selectField('Opportunity__r.Opportunity_Record_Type_Name__c').   //Added for Direct Delivery Sales Opportunity         
            		setCondition('Opportunity__c = :oppId AND Party_Type__c INCLUDES (:partyType)').
            		toSOQL()
        );
    }
    
    /**=================================================================================================================================
* Created By Eduardo Salia 26/10/2020
* Returns an array of Opportunity_Party__c
* Method that gets a list of all dependants added to an opportunity
* Param 1: opportunityId is our Opportunity Id from the Process Flow
* Param 2: partyTypes is a Unique Set of all Opportunity Party Types
===================================================================================================================================**/
    public List<Opportunity_Party__c> selectByOpportunityIdForQuoteSummary(Id oppId)
    {
        return Database.query(
                newQueryFactory().
                    selectField('First_Name__c').
                    selectField('Last_Name__c').
                    selectField('Name').
                    selectField('ID_Type__c').
            		selectField('Initials__c').
                    selectField('RSA_ID_Number__c').
                    selectField('Date_of_Birth__c').
                    selectField('Relationship__c').
                    selectField('Age__c').
            		selectField('Age_As_Number__c'). //Added for Direct Delivery Sales Opportunity 
            		selectField('Gender__c'). //Added for Flexi funeral functionality
                    selectField('Benefit_Split__c').
                    selectField('Party_Type__c').
					selectField('Opportunity__r.Opportunity_Record_Type_Name__c').   //Added for Direct Delivery Sales Opportunity         
            		setCondition('Opportunity__c = :oppId AND Party_Type__c INCLUDES (\'Dependant\',\'Spouse\')').
            		toSOQL()
        );
    }
    
    /**
     * Method that gets a list of opp parties given certain criteria
     *
     * @return Opportunity_Party__c -  list of OpportunityParties
     */
    public List<Opportunity_Party__c> selectByOpportunityId(Id oppId) {
        return Database.query(
                newQueryFactory().
                    selectField('First_Name__c').
                    selectField('Last_Name__c').
            		selectField('Initials__c').
                    selectField('RSA_ID_Number__c').
                    selectField('Date_of_Birth__c').
                    selectField('Relationship__c').
                    selectField('Age__c').
            		selectField('Age_As_Number__c'). //Added for Direct Delivery Sales Opportunity
                    selectField('Benefit_Split__c').
                    selectField('Party_Type__c').
           			selectField('Rider_Type__c').//Added for Flexi funeral functionality
                    selectField('Gender__c'). //Added for Flexi funeral functionality
					selectField('DD_Cross_Sell_Product_Member_Type__c'). //Added for Flexi funeral functionality
            		selectField('Beneficiary_Product__c'). //Added for Flexi funeral functionality
                    selectField('ID_Type__c'). //Added for Flexi funeral functionality
                    //selectField('DD_Policy_Member_Type__c'). //Added for Direct Delivery Sales Opportunity
            		setCondition('Opportunity__c = :oppId').
            		toSOQL()
        );
    }
    
    /**
     * Method that gets a list of opp parties given certain criteria
     *
     * @return Opportunity_Party__c -  list of OpportunityParties
     */
    public List<Opportunity_Party__c> selectByOpportunityPartyId(Id oppPartyId) {
        return Database.query(
                newQueryFactory().
                    selectField('First_Name__c').
                    selectField('Last_Name__c').
            		selectField('Initials__c').
                    selectField('RSA_ID_Number__c').
                    selectField('Date_of_Birth__c').
                    selectField('Relationship__c').
                    selectField('Age__c').
            		selectField('Age_As_Number__c'). //Added for Direct Delivery Sales Opportunity
            		selectField('Gender__c'). //Added for Flexi funeral functionality
            		selectField('DD_Cross_Sell_Product_Member_Type__c'). //Added for Flexi funeral functionality
            		selectField('Beneficiary_Product__c'). //Added for Flexi funeral functionality
                    selectField('Benefit_Split__c').
                    selectField('Party_Type__c').    
            		selectField('Opportunity__c').
            		setCondition('Id = :oppPartyId').
            		toSOQL()
        );
    }

    /**
     * Method that gets a list of opp parties given certain criteria
     *
     * @return Opportunity_Party__c -  list of OpportunityParties
     */
    public List<Opportunity_Party__c> selectByOpportunityPartyIdSet(set<Id> oppPartyId) {
        return Database.query(
                newQueryFactory().
                    selectField('First_Name__c').
                    selectField('Last_Name__c').
            		selectField('Initials__c').
                    selectField('RSA_ID_Number__c').
                    selectField('Date_of_Birth__c').
                    selectField('Relationship__c').
                    selectField('Age__c').
            		selectField('Age_As_Number__c'). //Added for Direct Delivery Sales Opportunity
            		selectField('Gender__c'). //Added for Flexi funeral functionality
                    selectField('Benefit_Split__c').
                    selectField('Party_Type__c').    
            		selectField('Opportunity__c').
            		setCondition('Id = :oppPartyId').
            		toSOQL()
        );
    }
    
    //CUSTOM SELECTORS - END
}
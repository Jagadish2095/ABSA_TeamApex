/**
* Apex Enterprise Design Patterns
* Selector Layer for EPP Pricing Matrix objects
*
* @author  Kyle Alexander
* @since   2018-09-04
*/

public class PricingMatricesSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return EPP_Pricing_Matrix__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                EPP_Pricing_Matrix__c.id,
                EPP_Pricing_Matrix__c.name
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get cases by id's
    public List<EPP_Pricing_Matrix__c> selectById(Set<Id> idSet) {
        return (List<EPP_Pricing_Matrix__c>) selectSObjectsById(idSet);
    }

    //CUSTOM SELECTORS - START

    /**
     * Method that gets a list of pricing matrices given certain criteria
     *
     * @return EPP_Pricing_Matrix__c -  list of EPP_Pricing_Matrix__c
     */
    public List<EPP_Pricing_Matrix__c> selectSumAndAgeAndRecordType(Double sumInsured, Double age, String recordType) {
        return Database.query(
                newQueryFactory().
            			selectField('Premium__c').
                        setCondition('Sum_Insured__c = :sumInsured AND Start_age__c <= :age AND End_Age__c >= :age AND Recordtype.Name = :recordType').           
                        toSOQL()
        );
    }
    
    /**
     * Method that gets a list of pricing discount matrices given certain criteria
     *
     * @return EPP_Pricing_Matrix__c -  list of EPP_Pricing_Matrix__c
     */
    public List<EPP_Pricing_Matrix__c> selectPremiumDiscountRecordType(Double sumInsured , String recordType) {
        return Database.query(
                newQueryFactory().
            			selectField('FF_Main_Member_Discount_Rate__c').
            			selectField('FF_Spouse_Discount_Rate__c').
            			selectField('FF_Child_Discount_Rate__c').
            			selectField('FF_Extended_Member_Discount_Rate__c').
            			selectField('FF_Grocery_Benefit_Discount_Rate__c').
                        setCondition('Sum_Insured__c = :sumInsured AND Recordtype.Name = :recordType').           
                        toSOQL()
        );
    }
    
     /**
     * Method that gets a list of pricing discount matrices given certain criteria
     *
     * @return EPP_Pricing_Matrix__c -  list of EPP_Pricing_Matrix__c
     */
    public List<EPP_Pricing_Matrix__c> selectCreditLifePlanRecordType(String planName , String recordType) {
        return Database.query(
                newQueryFactory().
            			selectField('Credit_Life_Gross_Premium_Rate__c').
            			selectField('Credit_Life_Secondary_Life_Rate__c').
            			selectField('Credit_Life_Staff_Rate__c').
            			selectField('Credit_Life_Plan__c').
                        setCondition('Credit_Life_Plan__c = :planName AND Recordtype.Name = :recordType').           
                        toSOQL()
        );
    }
    
    /**
     * Method that gets a list of pricing discount matrices given certain criteria
     *
     * @return EPP_Pricing_Matrix__c -  list of EPP_Pricing_Matrix__c
     */
    public List<EPP_Pricing_Matrix__c> selectCreditLifeDiscountRecordType(Double lowestRange , Double highestRange , String recordType) {
        return Database.query(
                newQueryFactory().
            			selectField('Credit_Life_Plan_A_Discount_Rate__c').
            			selectField('Credit_Life_Plan_B_Discount_Rate__c').
            			selectField('Credit_Life_Plan_C_Discount_Rate__c').
            			selectField('Credit_Life_Plan_D_Discount_Rate__c').
            			selectField('Credit_Life_Plan_E_Discount_Rate__c').
            			selectField('Without_Additional_Cover_Premium__c').
            			selectField('Without_Additional_Cover_Commission__c').
            			selectField('With_Additional_Cover_Premium__c').
            			selectField('With_Additional_Cover_Commission__c').
            			selectField('Staff_Without_Additional_Cover__c').
            			selectField('Staff_With_Additional_Cover__c').
            			selectField('Staff_Photo_Finish_Premium__c').
            			selectField('Photo_Finish_Premium__c').
                        setCondition('Credit_Life_Lowest_Range_Amount__c = :lowestRange AND Credit_Life_Highest_Range_Amount__c = :highestRange AND Recordtype.Name = :recordType').           
                        toSOQL()
        );
    }
    
    /**
     * Method that gets a list of pricing rate matrices given certain criteria
     *
     * @return EPP_Pricing_Matrix__c -  list of EPP_Pricing_Matrix__c
     */
    public List<EPP_Pricing_Matrix__c> selectPremiumRecordType(Double age, String recordType) {
        return Database.query(
                newQueryFactory().
            			selectField('After_Burial_Benefit_Rate__c').
            			selectField('Child_Rate__c').
            			selectField('Extended_Member_Rate__c').
            			selectField('Grocery_Benefit_Rate__c').
            			selectField('Main_Member_Rate__c').
            			selectField('Spouse_Rate__c').
            			selectField('Unveiling_Benefit_Rate__c').
                        setCondition('Start_age__c = :age AND Recordtype.Name = :recordType').           
                        toSOQL()
        );
    }
    /**
     * Method that gets a list of pricing matrices by record type name
     *
     * @return EPP_Pricing_Matrix__c -  list of EPP_Pricing_Matrix__c
     */
    public List<EPP_Pricing_Matrix__c> selectByRecordTypeName(String recordType, Integer recordLimit) {
        return Database.query(
                newQueryFactory().
            			selectField('Premium__c').
            			selectField('Sum_Insured__c').
            			setCondition('Recordtype.Name = :recordType').
            			setLimit(recordLimit).
                        toSOQL()
        );
    }
    //CUSTOM SELECTORS - END

}
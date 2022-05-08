/*
* Selector Layer for Terms_Of_Business__c objects
*
* @author  Almas Aleem
* @since   2020-10-23
*
*/
public class TermsOfBusinessSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Terms_Of_Business__c.sObjectType;
    }
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Terms_Of_Business__c.Id
                };
                    }
    
  public List<Terms_Of_Business__c> selectByAppProductId(Id prodId){
         return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Adjusted_by_Sanctioner__c').
            selectField('Application_Product__c').
            selectField('Comments__c').
            selectField('Existing_Account__c').
            selectField('Final_Offered__c').
            selectField('Offered_by_Powercurve__c').
            selectField('Requested_Amount__c').
            selectField('Existing_Account_Number__c').
            selectField('Final_Offered_Number__c').
            selectField('PowerCurve_Offered_Number__c').
            selectField('Adjusted_Number__c').
            selectField('Adjusted_Date__c').
            selectField('Existing_Account_Date__c').
            selectField('Final_Offered_Date__c').
            selectField('PowerCurve_Offered_Date__c').
            selectField('Requested_Date__c').
            selectField('Requested_Number__c').
            selectField('TOB_Classification__c').
            selectField('Tob_Description__c').
            setCondition('Application_Product__c =: prodId').
            toSOQL()
        );
    }
    public List<Terms_Of_Business__c> selectByAppProducts(List<Application_Product__c> appPrdList){
        
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Adjusted_by_Sanctioner__c').
            selectField('Application_Product__c').
            selectField('Comments__c').
            selectField('Existing_Account__c').
            selectField('Final_Offered__c').
            selectField('Offered_by_Powercurve__c').
            selectField('Requested_Amount__c').
            selectField('Existing_Account_Number__c').
            selectField('Final_Offered_Number__c').
            selectField('PowerCurve_Offered_Number__c').
            selectField('Adjusted_Number__c').
            selectField('Adjusted_Date__c').
            selectField('Existing_Account_Date__c').
            selectField('Final_Offered_Date__c').
            selectField('PowerCurve_Offered_Date__c').
            selectField('Requested_Date__c').
            selectField('Requested_Number__c').
            selectField('TOB_Classification__c').
            selectField('Tob_Description__c').
            setCondition('Application_Product__c in :appPrdList').
            toSOQL()
        );
        
    } 
    public List<Terms_Of_Business__c> selectByAppProductsByPricing(List<Application_Product__c> appPrdList){
        
        String classification= 'Pricing And Fees';
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Adjusted_by_Sanctioner__c').
            selectField('Application_Product__c').
            selectField('Comments__c').
            selectField('Existing_Account__c').
            selectField('Final_Offered__c').
            selectField('Offered_by_Powercurve__c').
            selectField('Requested_Amount__c').
            selectField('Existing_Account_Number__c').
            selectField('Final_Offered_Number__c').
            selectField('PowerCurve_Offered_Number__c').
            selectField('Adjusted_Number__c').
            selectField('Adjusted_Date__c').
            selectField('Existing_Account_Date__c').
            selectField('Final_Offered_Date__c').
            selectField('PowerCurve_Offered_Date__c').
            selectField('Requested_Date__c').
            selectField('Requested_Number__c').
            selectField('TOB_Classification__c').
            selectField('Tob_Description__c').
            selectField('Pricing_Decision__c').
            setCondition('Application_Product__c in :appPrdList AND TOB_Classification__c =\'' + classification + '\'').
            toSOQL()
        );
        
    }  
}
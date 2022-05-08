/**
* Selector Layer for Application_Product_Credit__c objects
*
* @author  Thabo K Senkomane
* @since   2020-05-19
*/
public class ApplicationProductCreditSelector 
{    
    public List<Application_Product_Credit__c> selectByOpportunityId(Id opportunityId) {
        
        List<Application_Product_Credit__c> appProdCreditList = new List<Application_Product_Credit__c>();
        
        List<OpportunityLineItem> OpportunityLineItemList = [SELECT Id,OpportunityId FROM OpportunityLineItem WHERE OpportunityId =: opportunityId
                                                             AND Parent_Opportunity_Line_Item_Id__c = null];
        
        if(OpportunityLineItemList.size() > 0){
            
            String query = ' SELECT ';
            String field_name = null;
            Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Application_Product_Credit__c').getDescribe().Fields.getMap();
            List<Schema.SObjectField> field_object_values_map = field_oject_map.values();
            for( Schema.SObjectField s : field_object_values_map ){
                field_name = s.getDescribe().getName();
                query += field_name + ', ';
            }
            query = query.subStringBeforeLast(',');
            query += ' FROM Application_Product_Credit__c WHERE Opportunity_Product_Id__c =  \'' + OpportunityLineItemList[0].OpportunityId + '\'';
            appProdCreditList = (List<Application_Product_Credit__c>)Database.query( query );
            System.debug('appProdCreditList: ' + appProdCreditList);
            
        }
        return appProdCreditList;
    }
     public List<Application_Product_Credit__c> selectIdsByOpportunityId(Id opportunityId) {
        
        List<Application_Product_Credit__c> applicationProductCreditList = new List<Application_Product_Credit__c>();
        List<OpportunityLineItem> OpportunityLineItemList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: opportunityId 
                                                             AND Parent_Opportunity_Line_Item_Id__c = null];
        
        if(OpportunityLineItemList.size() > 0){
            applicationProductCreditList = [SELECT Id FROM Application_Product_Credit__c 
                                              WHERE Opportunity_Product_Id__c =: OpportunityLineItemList[0].Id];
        }
        return applicationProductCreditList;
    }
    
    /**
 * Method that takes an opportunity ID
 *
 * @return Id Field
*/
    public List<Application_Product_Credit__c> selectIdsByOpportunityLineItemId(Id opportunityLineItemId) {
        
        List<Application_Product_Credit__c> applicationProductCreditList = [SELECT Id
                                                                            FROM Application_Product_Credit__c
                                                                            WHERE Opportunity_Product_Id__c =: opportunityLineItemId];
        
        return applicationProductCreditList;
    }

 /*Return Application Product Credit Based on Application Credit Product Id
	* Author : Almas Aleem :Absa 
	* Date : 2020-06-30
    * @param String Id
    * @return Application Product Credit
*/
 public Application_Product_Credit__c SelectApplicationProuductById(String appcredId){
        
        Application_Product_Credit__c appProdCredit ; 
         String query = ' SELECT ';
         String field_name = null;
            Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Application_Product_Credit__c').getDescribe().Fields.getMap();
            List<Schema.SObjectField> field_object_values_map = field_oject_map.values();
            for( Schema.SObjectField s : field_object_values_map ){
                field_name = s.getDescribe().getName();
                query += field_name + ', ';
            }
            query = query.subStringBeforeLast(',');
            query += ' FROM Application_Product_Credit__c WHERE Id =  \'' + appcredId + '\'';
            appProdCredit = (Application_Product_Credit__c)Database.query( query );
            System.debug('appProdCredit: ' + appProdCredit);
        
          return appProdCredit;
    }
}
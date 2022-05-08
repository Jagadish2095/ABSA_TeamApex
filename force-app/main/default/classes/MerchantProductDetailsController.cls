/**
* Controller used by the Merchant Product Details Component
*
* @author  Jason Quevauvilliers / Prashant Jain
* @version v1.0
* @since   2020-05-06
*/
public class MerchantProductDetailsController {

    /**
    * Method that gets all data needed for the Merchant Product Details Component
    *
    */
    @AuraEnabled
    public static Map<String, String> getData(String opportunityIdP, String applicationProdMerchIdP, List<String> picklistFieldNameListP) {

        Map<String, String> returnMap = new Map<String, String>();

        //Get Select Options
        for(String picklistFieldName : picklistFieldNameListP){
            String allOpts = '';
            String allOptsValues = '';

            Schema.sObjectType objType = Application_Product_Merchant__c.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

            map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

            list <Schema.PicklistEntry> values = fieldMap.get(picklistFieldName).getDescribe().getPickListValues();

            for (Schema.PicklistEntry a: values) {
                allOpts += a.getLabel() + ';';
                allOptsValues += a.getValue() + ';';
            }
            
            allOptsValues = allOptsValues.removeEnd(';');
            allOpts = allOpts.removeEnd(';');
            returnMap.put(picklistFieldName, allOpts);
            returnMap.put(picklistFieldName + 'Values', allOptsValues);
        }

        //Get applicationProdMerchId if it is null
        if(String.isBlank(applicationProdMerchIdP)){
            ApplicationProductMerchantsSelector apmSelector = new ApplicationProductMerchantsSelector();
            List<Application_Product_Merchant__c> appMerchList = apmSelector.selectIdsByOpportunityId(opportunityIdP);
            if(appMerchList != null && appMerchList.size() > 0) {
                returnMap.put('applicationProdMerchId', appMerchList[0].Id);
            }
        } else {
            returnMap.put('applicationProdMerchId', applicationProdMerchIdP);
        }

        //Get Product Name and Classification
        OpportunityLineItemsSelector oppProdSelector = new OpportunityLineItemsSelector();
        List<OpportunityLineItem> oppProdList = oppProdSelector.selectByOpportunityId(opportunityIdP);
        if(oppProdList.size() > 0){
            returnMap.put('productName', oppProdList[0].Product2.Name);
            returnMap.put('productClassification', oppProdList[0].Product2.Product_Classification__c);
        }

        return returnMap;
    }

    /**
    * Method that setermines Field Visibility for the component
    * Tinashe M Shoko - 2020-07-21
    * W-004983
    */
    @AuraEnabled
    public static List<Field_Visibility_Per_Product__mdt> determineFieldVisibility(String pName, String compName) {
        return [select id, Label, Component_Name__c, Product_Family__c, Product_Name__c, Section_Name__c, Type__c, 
                                                  Field_Label__c, Field_Name__c, Is_Required__c 
                                                  from Field_Visibility_Per_Product__mdt 
                                                 WHERE Component_Name__c =: compName AND Product_Name__c =: pName];
    }
}
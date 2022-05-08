/*@ Author: Danie Booysen
**@ Date: 19/05/2020
**@ Description: Controller for the DeviceMerchant Component*/
public with sharing class MerchantDeviceController {

    /**
    * @Author: Danie Booysen
    * @Date: 19/05/2020
    *
    * Returns a List of Device - Merchant linked to the Application Product - Merchant
    *
    * @param opportunityIdP     The Opportunity Id
    * @return deviceList        List<Device_Merchant__c>
    */
    @AuraEnabled
    public static List<Device_Merchant__c> getMerchDevices(Id opportunityIdP) {

        List<Device_Merchant__c> deviceList;

        List<Application_Product_Merchant__c> appMerchList = new ApplicationProductMerchantsSelector().selectIdsByOpportunityId(opportunityIdP);
        if(appMerchList != null && appMerchList.size() > 0){
            deviceList = new DevicesMerchantSelector().selectByAppProdMerchId(appMerchList[0].Id);
        }
        return deviceList;
    }

    /*
     * Method to determine field visibility as defined in Custom Metadata
     * Tinashe M Shoko - 2020-07-20
    */
    @AuraEnabled
    public static List<Field_Visibility_Per_Product__mdt> determineFieldVisibility(Id opportunityIdP, String compName) {
        String productName;
        //Get Product Name and Classification
        OpportunityLineItemsSelector oppProdSelector = new OpportunityLineItemsSelector();
        List<OpportunityLineItem> oppProdList = oppProdSelector.selectByOpportunityId(opportunityIdP);
        if(oppProdList.size() > 0){
            productName = oppProdList[0].Product2.Name;
        }
        return [select id, Label, Component_Name__c, Product_Family__c, Product_Name__c, Section_Name__c, Type__c, 
                Field_Label__c, Field_Name__c, Is_Required__c 
                from Field_Visibility_Per_Product__mdt 
                WHERE Component_Name__c =: compName AND Product_Name__c =: productName];
    }
}
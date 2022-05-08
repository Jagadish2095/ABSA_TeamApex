/**
* Controller used by lightning components for the Merchant Onboarding
*
* @author  Jason Quevauvilliers / Danie Booysen
* @version v1.0
* @since   2020-04-02
*/
public class MerchantSalesActivityController {
    private static final String ERROR = 'MERCHANT ERROR APPLICATION NOT FOUND';


    /**
    * Method that gets all picklist data
    *
    * @param objObject - Id of the specific opportunity party being removed
    * @param fld - field name i.e. Clause_Name__c
    */
    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String>();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
    }

    /**
    * Method that returns the Application_Product_Merchant__c obj for the Opportunity
    *
    * @param opportunityIdP - Id of the opportunity
    */
   @AuraEnabled
    public static Application_Product_Merchant__c getApplicationProductMerchant(Id opportunityIdP) {

        ApplicationProductMerchantsSelector apmSelector = new ApplicationProductMerchantsSelector();
        Application_Product_Merchant__c appProdMerch;

        //Currently Hardcoded until Quote Builder is complete
        List<Application_Product_Merchant__c> appProdMerchList = apmSelector.selectByOpportunityId(opportunityIdP);
        //List<Application_Product_Merchant__c> appProdMerchList = apmSelector.selectByOpportunityId('0063O000005SiYUQA0');
        if(appProdMerchList.size() > 0){
            appProdMerch = appProdMerchList[0];
        }
        return appProdMerch;
    }

    /**
    * Method that returns the ID of the Application_Product_Merchant__c obj for the Opportunity
    *
    * @param opportunityIdP - Id of the opportunity
    */
    @AuraEnabled
    public static Id getApplicationProductMerchantId(Id opportunityIdP) {

        Id appMerchId;
        ApplicationProductMerchantsSelector apmSelector = new ApplicationProductMerchantsSelector();

        //Currently Hardcoded until Quote Builder is complete
        List<Application_Product_Merchant__c> appMerchList = apmSelector.selectIdsByOpportunityId(opportunityIdP);
        //List<Application_Product_Merchant__c> appMerchList = apmSelector.selectIdsByOpportunityId('0063O000005SiYUQA0');
        if(appMerchList.size() > 0){
            appMerchId = appMerchList[0].Id;
        }
        return appMerchId;
    }

    /**
    * Method that returns the Product Classification for the Product linked to that Opportunity
    *
    * @param opportunityIdP - Id of the opportunity
    */
    @AuraEnabled
    public static Product2 getProductClassification(Id opportunityIdP) {

        Product2 productClassification;
        OpportunityLineItemsSelector oppProdSelector = new OpportunityLineItemsSelector();
        List<OpportunityLineItem> oppProdList = oppProdSelector.selectByOpportunityId(opportunityIdP);

        if(oppProdList.size() > 0){
            productClassification = oppProdList[0].Product2;
        }
        return productClassification;
    }

    /**
    * Method that returns the Application__c linked to that Opportunity
    *
    * @param opportunityIdP - Id of the opportunity
    */
    @AuraEnabled
    public static Application__c getApplication(Id opportunityIdP) {

        Application__c app;
        ApplicationsSelector appSelector = new ApplicationsSelector();


        List<Application__c> appList = appSelector.selectByOpportunityId(opportunityIdP);//'0063O000005Fst9QAC'
        if(  appList!= null && appList.size() > 0){
            app = appList[0];
            return app;
        } else {
            app.AddError(ERROR);
            return null;
        }

    }

    //Danie Booysen: 2020-08-12 (W-005252)
    //Method to determine field visibility for the product of the component
    @AuraEnabled
    public static List<Field_Visibility_Per_Product__mdt> determineFieldVisibility(String componentNameP, String opportunityIdP){
        List<OpportunityLineItem> oppProdList = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityIdP);
        if(oppProdList != null && oppProdList.size() > 0){
            return Sys_Utilities_Metadata.getFieldVisibilityMetadataByProductName(componentNameP, oppProdList[0].Product2.Name);
        }
        return null;
    }
}
/**
 * @description       : 
 * @author            : Rudolf Niehaus - CloudSmiths
 * @group             : 
 * @last modified on  : 09-12-2020
 * @last modified by  : Ignecious Mushanguri
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2020-12-09   Lesibe Manaka
**/

public with sharing class CAF_SalesProcessBase {

    /**
     * 
     * @param  Id accountId : The Id of the Account that the Opportunity would be linked to
     * @param  String productCode : The product code on the std Products2 object
     * @param  String productType : The product type
     * @param  String contextRef : The context reference i.e. The name of the selected job (What do you want to do today)
     * @return Map<String, String> : The new Opportunity and linked Application Record Ids
     */
    public static Map<String, String> createOpportunityWithLineItems( Id accountId , String productCode, String productType, String contextRef ){

        Map<String, String> newOppApplicationMap = new Map<String, String>();

        SalesProcessData processWrapper = new SalesProcessData();

        if(String.isNotBlank(contextRef)){

            processWrapper = getSalesProcessData(contextRef);

        }

        Opportunity newOpp = new Opportunity();

        if(String.isNotBlank(accountId)){

            List<PriceBook2> stdPriceBook = new PriceBooksSelector().selectByName('Standard Price Book');           

            Account acc = new AccountsSelector().selectById(accountId);

            newOpp.Name = acc.Name + ' - ' + productType;
            newOpp.Opp_Type__c = 'CAF Application';
            newOpp.AccountId = accountId;
            newOpp.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
            newOpp.CloseDate = System.today().addDays(70);
            newOpp.priceBook2Id = stdPriceBook[0].Id;
            newOpp.RecordTypeId = processWrapper.oppRecordTypeId;

            if(Test.isRunningTest()){
                newOpp.CBPIndicator__c = '';
            }else{
                //newOpp.CBPIndicator__c = String.valueOf( CBPIndicatorController.getCBPIndicator() );
            }
            
            Savepoint sp = Database.setSavepoint();
            
            try{

                insert newOpp;
            }catch(DmlException ex){

                throw ex;
            }

           
            //String productCodeOnly = productCode.substring(0,productCode.indexOf(' '));

            List<Product_Product_Entry__c> relatedProducts = new ProductProductEntriesSelector().selectByParentProductCode( productCode );
            Set<Id> productIds = new Set<Id>();

            for(Product_Product_Entry__c product : relatedProducts){
                
                productIds.add( product.Related_Product__c );
            }

            List<PricebookEntry> linePriceBookEntry = new PriceBookEntriesSelector().selectByProduct2Ids(productIds);
            Map<Id, Id> productEntryMap = new Map<Id, Id>();

            for(PricebookEntry priceEntry :linePriceBookEntry){

                productEntryMap.put(priceEntry.Product2Id , priceEntry.Id);
            }


            List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();

            for(Product_Product_Entry__c product : relatedProducts){

                OpportunityLineItem lineItem = new OpportunityLineItem();

                lineItem.OpportunityId = newOpp.Id;
                lineItem.Product2Id = product.Related_Product__c;
                lineItem.Price_Scheme_Code__c = product.Related_Product__r.Price_Scheme_Code__c;
                lineItem.Quantity = 1;
                lineItem.TotalPrice = 0;

                if(productEntryMap.containsKey(product.Related_Product__c)){
                    
                    lineItem.PricebookEntryId = productEntryMap.get(product.Related_Product__c);

                    lineItems.add(lineItem);

                }
            }

            try{

                //insert lineItems;

            }catch(DmlException ex){

                Database.rollback( sp );

                throw ex;
            }

            //Create Application and Application product records
            Application__c newApplication = new Application__c();

            newApplication.Account__c = accountId;
            newApplication.Opportunity__c = newOpp.Id;
        
            try{

                insert newApplication;

            }catch(DmlException ex){

                Database.rollback( sp );

                throw ex;
            }
		
            List<Application_Product__c> appProducts = new List<Application_Product__c>();

            for(OpportunityLineItem oppProduct : lineItems){

                Application_Product__c newAppProduct = new Application_Product__c();
                newAppProduct.Opportunity__c = newOpp.Id;
                newAppProduct.Opportunity_Product_Id__c = oppProduct.Product2Id;

                appProducts.add(newAppProduct);

            }

            try{

               // insert appProducts;

            }catch(DmlException ex){
                Database.rollback( sp );
                throw ex;
            }
            
            String appCafId = '';
            //For Application Product ACF
            if(contextRef.contains('CAF')){
                List<Application_Product_CAF__c> appProductsCAF = new List<Application_Product_CAF__c>();
                
                for(OpportunityLineItem oppProductCAF : lineItems){
                    
                    Application_Product_CAF__c newAppProductCAF = new Application_Product_CAF__c();
                   // newAppProductCAF.Opportunity_Product_Id__c = oppProductCAF.Product2Id;
                    newAppProductCAF.VAT_Pay_Back__c ='MONTH 4';
                    appProductsCAF.add(newAppProductCAF);
                    
                }
                
                try{
                    
                   //insert appProductsCAF;
                    
                }catch(DmlException ex){
                    Database.rollback( sp );
                    throw ex;
                }
                

            }
            newOppApplicationMap.put('opportunityId',newOpp.Id);
            newOppApplicationMap.put('applicationId',newApplication.Id);

            return newOppApplicationMap;

        }else{
            return null;
        }

    }
    
   
    /**
     * @param  String request : The name of the flow in context
     * @return SalesProcessData : inner class
     */
    private static SalesProcessData getSalesProcessData(String request){

        SalesProcessData processData = new SalesProcessData();
        List<Sales_Process_Type__c> salesProcess = new SalesProcessTypesSelector().selectByRequestName(request);

        if( salesProcess.size() > 0){

            processData.oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(salesProcess[0].Opportunity_Record_Type__c).getRecordTypeId();
        
        }else{

            processData.oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId();
        
        }

        return processData;

    }


    public class SalesProcessData{

        public String oppRecordTypeId {get;set;}
        
        public SalesProcessData(){
            this.oppRecordTypeId = oppRecordTypeId;
        }
    }


}
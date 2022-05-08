/**
 * @description       : 
 * @author            : Rudolf Niehaus - CloudSmiths
 * @group             : 
 * @last modified on  : 09-12-2020
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2020-12-01   Rudolf Niehaus - CloudSmiths   Initial Version
**/

public with sharing class SalesProcessBase {

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
            newOpp.AccountId = accountId;
            newOpp.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
            newOpp.CloseDate = System.today().addDays(7);
            newOpp.priceBook2Id = stdPriceBook[0].Id;
            newOpp.RecordTypeId = processWrapper.oppRecordTypeId;
			
            IZcreateUniqueKeyV1_Resp_IB_v1  IZcreateUniqueKeyV1_Resp = CBPIndicatorController.getCBPIndicator();

            if(Test.isRunningTest()){
                newOpp.CBPIndicator__c = '';
            }else{
                //newOpp.CBPIndicator__c = String.valueOf( CBPIndicatorController.getCBPIndicator() );
                newOpp.CBPIndicator__c = String.valueOf( IZcreateUniqueKeyV1_Resp.IZBKEYO.OutputDetails.uniqueKey );
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

                insert lineItems;

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

                insert appProducts;

            }catch(DmlException ex){
                Database.rollback( sp );
                throw ex;
            }
            newOppApplicationMap.put('opportunityId',newOpp.Id);
            newOppApplicationMap.put('applicationId',newApplication.Id);

            return newOppApplicationMap;

        }else{
            throw new AuraHandledException('Failed to create Opportunity and line items');
        }

    }

    /**
     * 
     * @param  Id accountId : The Id of the Account that the Opportunity would be linked to
     * @param  String productCode : The product code on the std Products2 object
     * @param  String productType : The product type
     * @param  String contextRef : The context reference i.e. The name of the selected job (What do you want to do today)
     * @return Map<String, String> : The new Opportunity and linked Application Record Ids
     */
    public static String createOpportunityForStandAloneProduct(Id accountId, String productCode, String productType, String contextRef){
        SalesProcessData processWrapper = new SalesProcessData();
        if(String.isNotBlank(contextRef)){
            processWrapper = getSalesProcessData(contextRef);
        }

        Opportunity newOpp = new Opportunity();
        if(String.isNotBlank(accountId)){
            List<PriceBook2> stdPriceBook = new PriceBooksSelector().selectByName('Standard Price Book');           

            Account acc = new AccountsSelector().selectById(accountId);
            newOpp.Name = acc.Name + ' - ' + productType;
            newOpp.AccountId = accountId;
            newOpp.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
            newOpp.CloseDate = System.today().addDays(7);
            newOpp.priceBook2Id = stdPriceBook[0].Id;
            newOpp.RecordTypeId = processWrapper.oppRecordTypeId;
            
            Savepoint sp = Database.setSavepoint();            
            try{
                insert newOpp;
            }catch(DmlException ex){
                throw ex;
            }

            Product2 product = [SELECT Id, Name, ProductCode, Price_Scheme_Code__c 
                FROM Product2 
                WHERE Name =: productType 
                AND ProductCode != '' AND Price_Scheme_Code__c != '' LIMIT 1];

            PricebookEntry linePriceBookEntry = new PriceBookEntriesSelector().selectByProduct2Id(product.Id);

            OpportunityLineItem lineItem = new OpportunityLineItem();
            lineItem.OpportunityId = newOpp.Id;
            lineItem.Product2Id = product.Id;
            lineItem.Price_Scheme_Code__c = product.Price_Scheme_Code__c;
            lineItem.Quantity = 1;
            lineItem.TotalPrice = 0;
            lineItem.PricebookEntryId = linePriceBookEntry.Id;

            try{
                insert lineItem;
            }catch(DmlException ex){
                Database.rollback(sp);
                throw ex;
            }

            //Create Application and Application product records
            Application__c newApplication = new Application__c();

            newApplication.Account__c = accountId;
            newApplication.Opportunity__c = newOpp.Id;
        
            try{
                insert newApplication;
            }catch(DmlException ex){
                Database.rollback(sp);
                throw ex;
            }

            Application_Product__c newAppProduct = new Application_Product__c();
            newAppProduct.Opportunity__c = newOpp.Id;
            newAppProduct.Opportunity_Product_Id__c = lineItem.Id;

            try{
                insert newAppProduct;
            }catch(DmlException ex){
                Database.rollback(sp);
                throw ex;
            }

            return newOpp.Id;
        }else{
            throw new AuraHandledException('Failed to create Opportunity and line items');
        }

    }

     /**
     * 
     * @param  Id accountId : The Id of the Account that the Opportunity would be linked to
     * @param  String productCode : The product code on the std Products2 object
     * @param  String productType : The product type
     * @param  String contextRef : The context reference i.e. The name of the selected job (What do you want to do today)
     * @return Map<String, String> : The new Opportunity and linked Application Record Ids
     */
    public static Map<String, String> createOpportunityWithLineItemsRoa( Id accountId , String productCode, String productType, String contextRef,string listOfQuestions ){

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
            newOpp.AccountId = accountId;
            newOpp.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
            newOpp.CloseDate = System.today().addDays(7);
            newOpp.priceBook2Id = stdPriceBook[0].Id;
            newOpp.RecordTypeId = processWrapper.oppRecordTypeId;
			
            if (productType == 'PACKAGES') {
                IZcreateUniqueKeyV1_Resp_IB_v1 IZcreateUniqueKeyV1_Resp = CBPIndicatorController.getCBPIndicator();
                if (IZcreateUniqueKeyV1_Resp.IZBKEYO.OutputDetails.uniqueKey > 0) {
                    newOpp.CBPIndicator__c = String.valueOf(IZcreateUniqueKeyV1_Resp.IZBKEYO.OutputDetails.uniqueKey);
                } else {
                    throw new AuraHandledException('No CBP Indicator created');
                }
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

                insert lineItems;

            }catch(DmlException ex){

                Database.rollback( sp );

                throw ex;
            }

            //Create Application and Application product records
            Application__c newApplication = new Application__c();

            newApplication.Account__c = accountId;
            newApplication.Opportunity__c = newOpp.Id;
        	newApplication.ROAQuestionnaire__c = listOfQuestions;
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
                newAppProduct.Opportunity_Product_Id__c = oppProduct.Id;
                appProducts.add(newAppProduct);

            }
			 
            try{

                insert appProducts;

            }catch(DmlException ex){
                Database.rollback( sp );
                throw ex;
            }
            
            newOppApplicationMap.put('opportunityId',newOpp.Id);
            newOppApplicationMap.put('applicationId',newApplication.Id);

            return newOppApplicationMap;

        }else{
            throw new AuraHandledException('Failed to create Opportunity and line items');
        }

    }

    
    /**
     * 
     * @param  Id accountId : The Id of the Account that the Opportunity would be linked to
     * @param  String productCode : The product code on the std Products2 object
     * @param  String productType : The product type
     * @param  String contextRef : The context reference i.e. The name of the selected job (What do you want to do today)
     * @param  String caseServiceGroup : The name of the service group for the support case 
     * @return Map<String, String> : The new Opportunity and linked Application Record Ids
     */
    // public static Map<String, String> createOpportunityWithLineItemsAndSupportCase( Id accountId , String productCode, String productType, String contextRef, String caseServiceGroup){
    
    //     Map<String, String> oppMap = createOpportunityWithLineItems( accountId , productCode, productType, contextRef );

    //     createFICCase( oppMap.get('opportunityId'), accountId, caseServiceGroup);

    //     return oppMap;

    // }

    // public static Case createFICCase(String oppId, String accountId, String serviceGroupName) {
        
    //     Case ficCase = new Case();
      
    //     if(serviceGroupName != null) {

    //         //Get Service Group details based on Name
    //         Set<String> serviceGroupNames = new Set<String>();

    //         serviceGroupNames.add(serviceGroupName);

    //         List<Service_Group__c> serviceGroups = new ServiceGroupsSelector().selectByName(serviceGroupNames);
            
    //         //Get Service Group Type based on Service Group
    //         if(serviceGroups != null && serviceGroups.size() > 0) {

    //             Set<Id> serviceGroupIds = new Set<Id>();

    //             serviceGroupIds.add(serviceGroups[0].Id);

    //             List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(serviceGroupIds);
                
    //             map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();
                
    //             if(serviceGroupTypes != null && serviceGroups.size() > 0){
                    
    //                 ficCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
    //                 ficCase.sd_Original_Service_Queue__c = serviceGroupTypes[0].Service_Group__r.Queue__c;
    //                 ficCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
    //                 ficCase.sd_Service_Group_Id__c = serviceGroups[0].Id;
    //                 ficCase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
    //                 ficCase.sd_Service_Group__c = serviceGroups[0].Name;
    //                 ficCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
    //                 ficCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
    //                 ficCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
    //                 ficCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
    //                 ficCase.Internal_SLA_Notification_User__c  = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;   
    //                 ficCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
                    
    //                 List<Group> caseQueues = new GroupsSelector().selectByNameAndType(serviceGroups[0].Queue__c , 'Queue');

    //                 if(!caseQueues.isEmpty()) {
    //                     ficCase.OwnerId = caseQueues[0].Id;
    //                 }
                    
    //                 ficCase.Subject = serviceGroupName;
    //                 ficCase.Description = 'Support Case for ' + serviceGroupName;
    //                 ficCase.AccountId = accountId;
    //                 ficCase.Opportunity__c = oppId;
    //                 ficCase.RecordTypeId = caseRecordTypeMap.get(serviceGroups[0].Assign_Record_Type__c).getRecordTypeId();
    //                 ficCase.Bypass_Validation_Rules__c = true;
    //                 ficCase.Skip_Auto_Response__c = true;
                    
    //                 insert ficCase;

    //             }else{
    //                 throw new AuraHandledException('No Service Group Type found. Please contact your System Administrator'); 
    //             }
    //         }else{
    //             throw new AuraHandledException('No Service Group is found. Please contact your System Administrator'); 
    //         }
            
    //     }else{
    //         throw new AuraHandledException('No Service Group is Setup. Please contact your System Administrator'); 
    //     }

    //     return ficCase;
    // }

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

            processData.oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        
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
/**
* @description PackageLinkController
* @author  Satya Boyenepalli: Absa
* @version v1.0
* @since   2021-02-26
*/

public with sharing class PackageLinkController {
    /**
	 * @description GetLinkProductsByCif
	 * @return string
	 * @param CifKey
	 */
    @AuraEnabled    
    public static string GetLinkProductsByCif(string CifKey)
    {
        ClientKey_Resp_IB_v1 PackageProducts  = new ClientKey_Resp_IB_v1();
        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c,Teller_Operator_Code__c FROM User WHERE Id = :usr];
        
        try{
            ClientKey_Req_IB_v1 requestBean = new ClientKey_Req_IB_v1();
            requestBean.Channel = new ClientKey_Req_IB_v1.Channel();
            requestBean.Channel.agentUserId=userInfo.AB_Number__c;
            requestBean.Channel.branch=userInfo.SiteCode__c;
            requestBean.Channel.deviceId='deviceid';
            requestBean.Channel.deviceType='laptop';
            requestBean.Channel.siteCode =integer.valueof(userInfo.SiteCode__c);
            requestBean.Channel.tellerId=userInfo.Teller_Operator_Code__c;
            requestBean.Channel.employeeNumber= '113';//userInfo.EmployeeNumber;
            requestBean.clientKey=CifKey;
            PackageProducts = (ClientKey_Resp_IB_v1)ClientKey_IH_v1.GetLinkProductsByClientKey(requestBean);            
        } catch(Exception exc){
            
            throw new AuraHandledException(exc.getMessage());
            
        }
        return  JSON.serialize(PackageProducts);
        
    }
    /**
	 * @description GetLinkProductsById
	 * @return string
	 * @param idNumber	 
	 */
    @AuraEnabled    
    public static string  GetLinkProductsById(string idNumber)
    {
        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c,Teller_Operator_Code__c FROM User WHERE Id = :usr];
        
        idNumber_Resp_IB_v1 PackageProducts  = new idNumber_Resp_IB_v1();
        try{
            idNumber_Req_IB_v1 requestBean = new idNumber_Req_IB_v1();
            requestBean.ClientClassification= new idNumber_Req_IB_v1.ClientClassification();
            requestBean.ClientClassification.idNumber=idNumber;
            requestBean.ClientClassification.idDocumentType='ID_NUMBER';
            requestBean.ClientClassification.cifClientGroup='I';
            requestBean.ClientClassification.cifClientType='0';
            requestBean.Channel = new  idNumber_Req_IB_v1.Channel();
            requestBean.Channel.agentUserId=userInfo.AB_Number__c;
            requestBean.Channel.branch=userInfo.SiteCode__c;
            requestBean.Channel.deviceId='deviceid';
            requestBean.Channel.deviceType='laptop';
            requestBean.Channel.siteCode =integer.valueof(userInfo.SiteCode__c);
            requestBean.Channel.tellerId=userInfo.Teller_Operator_Code__c;
            requestBean.Channel.employeeNumber=userInfo.EmployeeNumber;
             PackageProducts = (idNumber_Resp_IB_v1)idNumber_IH_v1.GetLinkProductsByIdnumber(requestBean);
            
        } catch(Exception exc){
            
            throw new AuraHandledException(exc.getMessage());
            
        }
        return JSON.serialize(PackageProducts);
        
    }
    /**
	 * @description CreatePackageLink
	 * @return string
	 * @param tclientKey
	 * @param tchequeAccountNumber	
	 * @param tcreditAccountNumber
	 * @param tpricingCode
	 * @param tpackageName	 
	 */
    @AuraEnabled    
    public static string CreatePackageLink(string tclientKey,string tchequeAccountNumber,string tcreditAccountNumber, string tpricingCode,string tpackageName)
    {
        Create_Resp_IB_v1 PackageCreate  = new Create_Resp_IB_v1();
        string usr = System.UserInfo.getUserId();
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c,Teller_Operator_Code__c FROM User WHERE Id = :usr];
       // try{
            Create_Req_IB_v1 requestBean = new Create_Req_IB_v1();
            requestBean.clientKey=tclientKey;
            requestBean.chequeAccountNumber=tchequeAccountNumber;
            requestBean.creditAccountNumber=tcreditAccountNumber;
            requestBean.pricingCode=tpricingCode;
            requestBean.packageName=tpackageName;
            requestBean.Channel = new  Create_Req_IB_v1.Channel();
             requestBean.Channel.branch=userInfo.SiteCode__c;
            requestBean.Channel.deviceId='deviceid';
            requestBean.Channel.deviceType='laptop';
            requestBean.Channel.siteCode =integer.valueof(userInfo.SiteCode__c);
            requestBean.Channel.tellerId=userInfo.Teller_Operator_Code__c;
            requestBean.Channel.employeeNumber=  userInfo.EmployeeNumber;
            PackageCreate = (Create_Resp_IB_v1)Create_IH_v1.CreatePackage(requestBean);
            
       // } catch(Exception exc){
            
          //  throw new AuraHandledException(exc.getMessage());
            
       // }
       return  JSON.serialize(PackageCreate);
        
    }
    //Method for getting feature and benefits from salesforce
    /**
	 * @description getDetails
	 * @return List<FnbSynopsesWrapper.Product>
	 * @param stringproduct	 
	 */
    @AuraEnabled
    public static List<FnbSynopsesWrapper.Product> getDetails(string stringproduct){
      
        List<FnbSynopsesWrapper.Product> returnProducts = new List<FnbSynopsesWrapper.Product>();
        List <ROAProduct__c> productList = [select ProductId__c,Description__c,Code__c,PackageChargeOption__c, Synopsis__c from ROAProduct__c where Description__c = 'Gold Package' WITH SECURITY_ENFORCED];
       
        List<String> productsListDescription = new List<String>();
		for (ROAProduct__c product : productList) {
			productsListDescription.add(product.Description__c);
		}
        ROAFeature__c roaFeatures = [
                    SELECT Recommended_Income__c, Montly_Fee__c, Cheque_Monthly_Fee__c,Credit_Card_Monthly_Account_Fee__c,Credit_Card_Facility_Fee__c,Pdf_Url__c from ROAFeature__c where Name IN :productsListDescription WITH SECURITY_ENFORCED];
                
        
        if (productList != null) {
            for (ROAProduct__c productInSF : productList) {
                FnbSynopsesWrapper.Product prod = new FnbSynopsesWrapper.Product();
                if (roaFeatures != null) {
                    prod.RecommendedIncome = roaFeatures.Recommended_Income__c;
                    prod.MonthlyFee = roaFeatures.Montly_Fee__c;                    
                    prod.ChequeFee = roaFeatures.Cheque_Monthly_Fee__c;
                    prod.CreditCardFee = roaFeatures.Credit_Card_Monthly_Account_Fee__c;
                    prod.FacilityFee = roaFeatures.Credit_Card_Facility_Fee__c;
					prod.PdfUrl = roaFeatures.Pdf_Url__c; 
                }
                
                prod.Description = productInSF.Description__c;
                prod.ProductId = productInSF.ProductId__c;
                prod.Synopsis = productInSF.Synopsis__c;
                prod.IsSelected = false;
                returnProducts.add(prod);
                
            }
      
        } 
        return returnProducts;
        
    }
    /**
	 * @description getDetails2
	 * @return List<FnbSynopsesWrapper.Product>
	 * @param stringproduct	 
	 */
    @AuraEnabled
    public static List<FnbSynopsesWrapper.Product> getDetails2(string stringproduct){
        List<FnbSynopsesWrapper.Product> returnProducts = new List<FnbSynopsesWrapper.Product>();
        List <ROAProduct__c> productList = [select ProductId__c,Description__c,Code__c,PackageChargeOption__c, Synopsis__c from ROAProduct__c where Description__c = 'Premium Package' WITH SECURITY_ENFORCED];
        List<String> productsListDescription = new List<String>();
		for (ROAProduct__c product : productList) {
			productsListDescription.add(product.Description__c);
		}        
        ROAFeature__c roaFeatures = [
                    SELECT Recommended_Income__c, Montly_Fee__c, Cheque_Monthly_Fee__c,Credit_Card_Monthly_Account_Fee__c,Credit_Card_Facility_Fee__c,Pdf_Url__c from ROAFeature__c where Name IN :productsListDescription WITH SECURITY_ENFORCED];
                
        if (productList != null) {
            for (ROAProduct__c productInSF : productList) {
                FnbSynopsesWrapper.Product prod = new FnbSynopsesWrapper.Product();
                if (roaFeatures != null) {
                    prod.RecommendedIncome = roaFeatures.Recommended_Income__c;
                    prod.MonthlyFee = roaFeatures.Montly_Fee__c;                    
                    prod.ChequeFee = roaFeatures.Cheque_Monthly_Fee__c;
                    prod.CreditCardFee = roaFeatures.Credit_Card_Monthly_Account_Fee__c;
                    prod.FacilityFee = roaFeatures.Credit_Card_Facility_Fee__c;
					prod.PdfUrl = roaFeatures.Pdf_Url__c;                                       
                    
                }
                
                prod.Description = productInSF.Description__c;
                prod.ProductId = productInSF.ProductId__c;
                prod.Synopsis = productInSF.Synopsis__c;
                prod.IsSelected = false;
                returnProducts.add(prod);
                //stringproduct = string.valueOf(returnProducts);
                system.debug(returnProducts);
                //FnbSynopses.stringproduct('');
                
            }
        }
        return returnProducts;
        
    }
    /**
	 * @description UpdatePackage
	 * @return string
	 * @param oppId
	 * @param PackageId	 
	 */
    @AuraEnabled
    public static string  UpdatePackage(string oppId, string PackageId)
    {
        string result;
        
        try{
            List<Opportunity> opp = new List<Opportunity>{};
                opp = [Select CBPIndicator__c From Opportunity where Id=:oppId];
            
            if(opp.size()>0)
            {
                opp[0].CBPIndicator__c = PackageId;
                update opp;
                result ='Success';
            }
            
        }
        catch(Exception exc){
            result ='fail';
            throw new AuraHandledException(exc.getMessage());
            
        }
        return result;
    }
    
    //Create Opportunity
     /**
	 * @description getNewOpportunity
	 * @return Map<String,String>
	 * @param accountID
	 * @param productCode
	 * @param productType
	 * @param flowname
	 * @param packageId 
	 */
    @AuraEnabled
    public static Map<String,String> getNewOpportunity(string accountID, string productCode, string productType, string flowname,string packageId){
        
        return PackageLinkController.createOpportunityWithLineItems(accountId, productCode, productType, flowname,packageId);
    }

    /**
	 * @description createOpportunityWithLineItems
	 * @return Map<String,String>
	 * @param accountId
	 * @param productCode
	 * @param productType
	 * @param contextRef
	 * @param packageId 
	 */
    public static Map<String, String> createOpportunityWithLineItems( Id accountId , String productCode, String productType, String contextRef ,string packageId){
        
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
            newOpp.CBPIndicator__c = packageId;
            
            Savepoint sp = Database.setSavepoint();
            
            try{
                insert newOpp;
                
            }catch(DmlException ex){
                
                throw ex;
            }
            
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
            return null;
        }
        
    }
     /**
	 * @description getSalesProcessData
	 * @return SalesProcessData
	 * @param request
	 */
    public static SalesProcessData getSalesProcessData(String request){
        
        SalesProcessData processData = new SalesProcessData();
        List<Sales_Process_Type__c> salesProcess = new SalesProcessTypesSelector().selectByRequestName(request);
        
        if( salesProcess.size() > 0){
            
            processData.oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(salesProcess[0].Opportunity_Record_Type__c).getRecordTypeId();
            
        }else{
            
            processData.oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
            
        }
        
        return processData;
        
    }
     /**
	 * @description SalesProcessData	 
	 */
    public class SalesProcessData{
        /**
	 * @description oppRecordTypeId	 
	 */
        public String oppRecordTypeId {get;set;}
        /**
	 * @description SalesProcessData	 
	 */
        public SalesProcessData(){
            this.oppRecordTypeId = oppRecordTypeId;
        }
    }
    
    //end Opportunity
     /**
	 * @description GetPackageIndicator
	 * @return string
	 * @param oppId
	 */
    @AuraEnabled
    public static string  GetPackageIndicator(string oppId)
    {
        string result;
        try{ 
            List<Opportunity> opps = new List<Opportunity>{};
                //Opportunity opp = [Select CBPIndicator__c From Opportunity where Id=:oppId];
                opps = [Select CBPIndicator__c From Opportunity where Id=:oppId]; 
            if(opps.size()>0)
                result = opps[0].CBPIndicator__c;
            else
                result='Opp Not Found';
            
        }
        catch(DmlException exc){
            System.debug('Satya opp error' + exc);
            //throw new AuraHandledException(exc.getMessage());
            system.assertEquals(exc.getMessage(), exc.getMessage());
        }
        return result;
    }  
    
}
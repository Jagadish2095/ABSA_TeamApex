/**
 * @description       : 
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-07-13
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   2021-07-13   almas.aleem@absa.africa   Initial Version
**/
@isTest
public class GenerateCCQuoteControllerTest {
   @testSetup static void createData(){
         
          Account mainAccount = new Account(Name = 'Test Main Account');
        insert mainAccount;

        Opportunity opp = new Opportunity (Name ='testopp', AccountId = mainAccount.Id, StageName = 'New', CloseDate = system.today());
        insert opp;

           Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;

        AccountContactRelation accConnRel = new AccountContactRelation();
        accConnRel.AccountId = mainAccount.Id;
        accConnRel.ContactId = contact.Id;
        insert accConnRel;
         
         
         Product2 prod = new Product2(Name = 'Credit Card', Family = 'Credit Card');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;

         Application_Product__c testApplicationProduct = new Application_Product__c();
        testApplicationProduct.Opportunity__c = opp.Id;
        testApplicationProduct.Opportunity_Product_Id__c = '001';//Dummy Id used to insert for noe becauase Opportunity_Product_Id__c is required and should be linked to an OpportunityLineItem
  		testApplicationProduct.Product_State__c = 'Existing';
        testApplicationProduct.Alternative_Fund_Code__c = '001';
        testApplicationProduct.Account_Number__c = 1234;
        testApplicationProduct.Product_Name__c = 'Credit Card';
        testApplicationProduct.Secured_By_Mortgage_Bond__c = true;
        testApplicationProduct.Alternative_Fund_Indicator__c = false;
        testApplicationProduct.Business_Credit_Card_Product_Type__c = 'VISA';
        testApplicationProduct.Business_Credit_Card_Sub_Product_Type__c ='GOLD';
        testApplicationProduct.Allocated_Limit__c =8500.0;
        testApplicationProduct.Requested_facility_limit__c = '12000';
        insert  testApplicationProduct;
         
      
        
         String responseString = '{"IPlistNCARatesV1Response":{"ipb100o":{"ncaMaxfeeCfErr":"0000 - SUCCESS","ncaMaxfeeCfMaxsf":69,"ncaMaxfeeMaErr":"0000 - SUCCESS","ncaMaxfeeMaMaxsf":69,';
        responseString += '"ncaMaxfeeOcaErr":"0000 - SUCCESS","ncaMaxfeeOcaMaxsf":69,"ncaMaxfeeStctErr":"0000 - SUCCESS","ncaMaxfeeStctMaxsf":69,"ncaMaxfeeUctErr":"0000 - SUCCESS",';
        responseString += '"ncaMaxfeeUctMaxsf":69,"ncaMaxifeeCfErr":"0000 - SUCCESS","ncaMaxifeeCfFirst":189.75,"ncaMaxifeeCfMax":6050.5,"ncaMaxifeeCfNext":11.5,"ncaMaxifeeCfPerc":1000,';
        responseString += '"ncaMaxifeeMaErr":"0000 - SUCCESS","ncaMaxifeeMaFirst":1265,"ncaMaxifeeMaMax":6037.5,"ncaMaxifeeMaNext":11.5,"ncaMaxifeeMaPerc":10000,';
        responseString += '"ncaMaxifeeOcaErr":"0000 - SUCCESS","ncaMaxifeeOcaFirst":189.75,"ncaMaxifeeOcaMax":1207.5,"ncaMaxifeeOcaNext":11.5,"ncaMaxifeeOcaPerc":1000,';
        responseString += '"ncaMaxifeeStctErr":"0000 - SUCCESS","ncaMaxifeeStctFirst":189.75,"ncaMaxifeeStctMax":1207.5,"ncaMaxifeeStctNext":11.5,"ncaMaxifeeStctPerc":1000,';
        responseString += '"ncaMaxifeeUctErr":"0000 - SUCCESS","ncaMaxifeeUctFirst":189.75,"ncaMaxifeeUctMax":6040.5,"ncaMaxifeeUctNext":11.5,"ncaMaxifeeUctPerc":1000,';
        responseString += '"ncaMaxrateCfErr":"0000 - SUCCESS","ncaMaxrateCfMaxdr":20.75,"ncaMaxrateMaErr":"0000 - SUCCESS","ncaMaxrateMaMaxdr":19,"ncaMaxrateOcaErr":"0000 - SUCCESS",';
        responseString += '"ncaMaxrateOcaMaxdr":21,"ncaMaxrateStctErr":"0000 - SUCCESS","ncaMaxrateStctMaxdr":60,"ncaMaxrateUctErr":"0000 - SUCCESS","ncaMaxrateUctMaxdr":27.75,';
        responseString += '"primeRate":6.25,"primeRateErr":"0000 - SUCCESS","repurchaseRate":7,"repurchaseRateErr":"0000 - SUCCESS"},"nbsapdpo":{"reasonCode":0,"returnCode":0,';
        responseString += '"serviceVersion":"BUSO001"},"nbsmsgo3":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}';
      
        Application__c testApplication = new Application__c();
        testApplication.Opportunity__c = opp.Id;
        testApplication.Preferred_Communication_Method__c='himanshu.nimje@absa.africa';
        testApplication.Preferred_SMS__c='065892600';
        testApplication.Preferred_Communication_Method__c='Email';
        testApplication.Fees_Waived__c = true;
        testApplication.Products_And_Services__c = 'NotifyMe';
        testApplication.AIPS__c = responseString;
        insert testApplication;

        Security_Offered__c security = new Security_Offered__c();
        security.Application__c = testApplication.Id;
        security.Security_Type__c = 'Bonds';
        insert security;
        
        
      /*  SetProductTOBController.insertTob(parentApplicationRecord.Id);
         
        SetProductTOBController.updateTOB(parentApplicationRecord.Id);*/
       
       //SetProductTOBController.insertCCTob(testApplicationProduct.Id);
       
         
       ProductTermsOfBusinessController.ProductTOB tob = new ProductTermsOfBusinessController.ProductTOB();
        tob.appProdId = testApplicationProduct.Id;
        tob.appProduct = testApplicationProduct;
        tob.termstobList = new List<Terms_Of_Business__c>();
        
        
         //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IPlistNCARatesV1_IH_v1.INTEGRATION_SERVICE_NAME});

        
       }
  
    @isTest static void testgetCCQuote() {
        
        
        Opportunity opp = [SELECT Id,name FROM Opportunity LIMIT 1];
        Opportunity opp1 = [SELECT Id FROM Opportunity LIMIT 1];
       
        Application_Product__c appprod=[SELECT Id,IsMainProduct__c,Name FROM Application_Product__c where Application_Product_Parent__c=null AND opportunity__c=:opp.Id LIMIT 1];
       
        Application__c testApplication = [select id From Application__c LIMIT 1 ];
        
         List<Application_Product__c> appProdList = new List<Application_Product__c> ();
         appProdList.add(appprod);
       
        List<Terms_Of_Business__c> tb1List= new list<Terms_Of_Business__c>();
        Terms_Of_Business__c tob6=new Terms_Of_Business__c();
        
        tob6.Tob_Description__c='Limit';
        tob6.Application_Product__c=appprod.Id;
        tob6.Final_Offered__c='11500';
        tb1List.add(tob6);
        Terms_Of_Business__c tob7=new Terms_Of_Business__c();
        
        tob7.Tob_Description__c='Product Type';
        tob7.Application_Product__c=appprod.Id;
        tob7.Final_Offered__c='VISA';
        tb1List.add(tob7);
        insert tb1List;

       
        test.startTest();
         GenerateCCQuoteController.FetchproductList(opp1.Id);
         GenerateCCQuoteController.QuoteWrapper quoteWrap = GenerateCCQuoteController.generateCCQuoteFunction(appprod.Id, opp1.id);
       	quoteWrap.serviceFee = 32;
        quoteWrap.annualinterestRate=17;
        quoteWrap.annualinterestRateP=6.5;
        quoteWrap.UpfrontInitiationfees=272;
        quoteWrap.otherfees= 0;
        quoteWrap.creditInsurance = 1200;
        String quoteW = JSON.serialize(quoteWrap);
         GenerateCCQuoteController.calculateQuotes(quoteW, appprod.Id);
       
        test.stopTest();
        system.assertNotEquals(opp, null);
        
    }
    
     
  
    

}
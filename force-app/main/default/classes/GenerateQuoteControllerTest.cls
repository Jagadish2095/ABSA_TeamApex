/**
 * @description       :
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-07-13
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-07-13   almas.aleem@absa.africa   Initial Version
**/
@isTest
public class GenerateQuoteControllerTest {
    @testSetup static void createData(){

        Account mainAccount = new Account(Name = 'Test Main Account');
        insert mainAccount;

        Opportunity opp = new Opportunity (Name ='testopp', AccountId = mainAccount.Id, StageName = 'New', CloseDate = System.today());
        insert opp;

           Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;

        AccountContactRelation accConnRel = new AccountContactRelation();
        accConnRel.AccountId = mainAccount.Id;
        accConnRel.ContactId = contact.Id;
        insert accConnRel;


         Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
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

        Application_Product__c parentApplicationRecord = new Application_Product__c();
        parentApplicationRecord.Opportunity__c = opp.Id;
        parentApplicationRecord.Product_Name__c = 'Cheque';
        parentApplicationRecord.Product_Type__c = '11021';//API picklist value for CLASSIC BUSINESS ACCOUNT
       // parentApplicationRecord.Account_Number__c = 123456789;
        parentApplicationRecord.Product_State__c = 'New';
        parentApplicationRecord.Opportunity_Product_Id__c =''+ opp.Id;
        parentApplicationRecord.Product_Status__c = 'Accepted';
        parentApplicationRecord.Accept_TOB__c = true;
        parentApplicationRecord.Maximum_NCA_Rate__c='25';
        parentApplicationRecord.IsMainProduct__c = true;
        insert parentApplicationRecord;

        Application_Product__c childApplicationRecord = new Application_Product__c();
        childApplicationRecord.Opportunity__c = opp.Id;
        childApplicationRecord.Product_Name__c = 'Overdraft';
        childApplicationRecord.Product_Amount__c = 1000000.00;
        childApplicationRecord.Product_State__c = 'New';
        childApplicationRecord.Product_Status__c = 'Accepted';
        childApplicationRecord.Opportunity_Product_Id__c = ''+opp.Id;
        childApplicationRecord.Limit_Type__c='Reducing - Once Off Only';
        childApplicationRecord.Once_Off_Amount__c=20000;
        childApplicationRecord.Application_Product_Parent__c = parentApplicationRecord.Id;
        insert childApplicationRecord;

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

        SetProductTOBController.insertTob(parentApplicationRecord.Id);

        SetProductTOBController.updateTOB(parentApplicationRecord.Id);

        ProductTermsOfBusinessController.ProductTOB tob = new ProductTermsOfBusinessController.ProductTOB();
        tob.appProdId = parentApplicationRecord.Id;
        tob.appProduct = parentApplicationRecord;
        tob.termstobList = new List<Terms_Of_Business__c>();

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IPlistNCARatesV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testgetProductFacility() {
        Opportunity opp = [SELECT Id,name FROM Opportunity LIMIT 1];
        Opportunity opp1 = [SELECT Id FROM Opportunity LIMIT 1];
        Application_Product__c appprod = [SELECT Id,IsMainProduct__c,Name FROM Application_Product__c where Application_Product_Parent__c=null AND opportunity__c=:opp.Id LIMIT 1];
        Application__c testApplication = [select id From Application__c LIMIT 1 ];

        List<Application_Product__c> appProdList = new List<Application_Product__c> ();
        appProdList.add(appprod);

        List<Terms_Of_Business__c> tb1List= new list<Terms_Of_Business__c>();
        Terms_Of_Business__c tob6=new Terms_Of_Business__c();

        tob6.Tob_Description__c='Overdraft Limit Type';
        tob6.Application_Product__c=appprod.Id;
        tob6.Final_Offered__c='Variable';
        tb1List.add(tob6);
        Terms_Of_Business__c tob7=new Terms_Of_Business__c();

        tob7.Tob_Description__c ='Initiation Fee';
        tob7.Application_Product__c=appprod.Id;
        tob7.Final_Offered__c ='Variable2';
        tob7.Final_Offered_Number__c=1.0;
        tb1List.add(tob7);
        insert tb1List;

        SetProductTOBController.mapFromPCOResponse(appProdList,'7');
        Test.startTest();
        GenerateQuoteController.generateQuote(appprod.Id, opp.Id);
        Test.stopTest();
        System.assertNotEquals(opp, null);
    }

    @isTest static void testgetProductFacility2() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Opportunity opp1 = [SELECT Id FROM Opportunity LIMIT 1];
        Application_Product__c appprod = [SELECT Id,IsMainProduct__c,Name FROM Application_Product__c where Application_Product_Parent__c=null AND opportunity__c=:opp.Id LIMIT 1];
        Application__c testApplication = [select id From Application__c LIMIT 1 ];
        Application_scoring__c appScore = new Application_scoring__c();
        appScore.name='a1';
        appScore.Stage__c='7';
        appScore.SYST_Decision__c='A';
        appScore.Application_Number__c=testApplication.Id;
        appScore.Reason__c='Reason 1,Reason 2,Reason 3,Reason 4,Reason 5';
        appScore.Reason_Description__c='aaaa,bbbb,cccc,dddd,eeee';
        appScore.Exception__c='Exception 1,Exception 2,Exception 3,Exception 4,Exception 5';
        appScore.Exception_Description__c='uuuu,vvvv,wwww,xxxx,yyyy,zzzz';
        appScore.ReqTotAddPotentialOc__c=0;
        appScore.ReqPotentialTotGroup__c=0;
        appScore.ReqPotentialTgae__c=0;
        appScore.ReqPotentialTgbe__c=0;
        appScore.ReqPotentialTfl__c=0;
        appScore.Potential_OC_Offered__c=0;
        appScore.Potential_TGE_Offered__c=0;
        appScore.Potential_TGAE_Offered__c=0;
        appScore.Potential_TGBE_Offered__c=0;
        appScore.Potential_TGBOE_Offered__c=0;
        appScore.Potential_OC_Final__c=0;
        appScore.Potential_TGE_Final__c=0;
        appScore.Potential_TGAE_Final__c=0;
        appScore.Potential_TGBE_Final__c=0;
        appScore.Potential_TGBOE_Final__c=0;
        insert appScore;

        Application_Scoring_Product__c scoProduct1=new Application_Scoring_Product__c();
        scoProduct1.Unique_Product_ID__c = String.valueof(appprod.Name);
        scoProduct1.Application_Scoring__c=appScore.Id;
        scoProduct1.Final_Decision__c='A';
        scoProduct1.Final_Init_Fee_Amount__c =2000;
        scoProduct1.Offer_Init_Fee_Amount__c=1200;
        scoProduct1.Offer_Int_Rate__c =6;
        scoProduct1.Final_Int_Rate__c=6;
        scoProduct1.Final_Int_Rate_Prime_Plus__c=6;
        scoProduct1.Offer_Int_Rate_Prime_Plus__c=6;
        scoProduct1.Offer_OD_Limit_Type__c=3;
        scoProduct1.Final_OD_Limit_Type__c=3;
        scoProduct1.Offer_Total_Amount__c =100000;
        scoProduct1.Final_Total_Amount__c=100000;
        scoProduct1.Offer_Reduction_Amount__c=4000;
        scoProduct1.Final_Reduction_Amount__c=4000;
        scoProduct1.NCA_Max_Rate__c =25;
        scoProduct1.Offer_Service_Fee__c = 69;
        scoProduct1.Final_Service_Fee__c = 69;
        insert scoProduct1;

        System.debug('appprod'+appprod);
        List<Application_Product__c> appProdList = new List<Application_Product__c> ();
        appProdList.add(appprod);

        SetProductTOBController.mapFromPCOResponse(appProdList,'7');
        string QuotWrap='{"appPrdLst":[],"generalBankingFacility":"No","monthlyServiceFee":0,"reviewFeeType":"","reviewFeeValue":0,"totalFacilityCount":0,"totalLimitValue":0,"unutilisedFacilityFee":0,"signedDate":"2021-05-12"}';
        string Facilitywrap = '{"ACBLimit":"No","accountNumber":"1234567","reviewFeeType":"","instructionId":"88686878","Primeinterestrate":0,"Interestrate":0.0,"InterestrateType":"abc","RegularpaymentDate":"2021-05-12"}';
        Test.startTest();
        GenerateQuoteController.saveApplicationFacilityWrap(QuotWrap, opp1.Id);
        GenerateQuoteController.fetchOutNCAproductLst(opp.Id);
        GenerateQuoteController.FetchproductList(opp.Id);
        GenerateQuoteController.getProductFacility(appprod.Id,opp.Id);

        GenerateQuoteController.saveQuoteS(QuotWrap, appprod.Id);
        GenerateQuoteController.saveFacilityWrap(Facilitywrap, appprod.Id);

        Test.stopTest();
        System.assertNotEquals(opp, null);
    }
}
/**
 * @description       :
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-07-13
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-07-13   almas.aleem@absa.africa   Initial Version
**/
@isTest
public class PricingAndFeesControllerTest {
     public static String pcoResponse = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":0,"DERPCOUNIQUENUMBER":"000000007587","DerivedCalcAppData":{"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":100000,"REQPOTENTIALTOTDIRECT":7482303,"REQPOTENTIALTOTGROUP":196437408,"REQPOTENTIALTGBE":173022119,"REQPOTENTIALTGAE":37839935,"REQPOTENTIALTGOE":157649061,"REQPOTENTIALTFL":173022119}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30},"RESAPPCMNG":{"REMAXOFFSETREDUC":0.00,"REMINPLUSMINRATE":1.00,"SMMAXOFFSETREDUC":0.50,"SMMINPLUSMINRATE":0.50,"PMMAXOFFSETREDUC":1.00,"PMMINPLUSMINRATE":0.00,"HOCMMAXOFFSETREDUC":8.00,"HOCMMINPLUSMINRATE":0.00}},"Entity01":{"INTENTCLIENTCODE1":"SBSOUTP001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0},"INTENTBUR":{"COMMINPREGNUMBER":199001151523}},"DerivedCalcEntity01":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"},"DERENTINST":{"TOTALINSTALLMENTS":2136},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":6109597},"DERENTARRS":{"TOTALAMNT":298267}},"Entity02":{"INTENTAPRF":{"RETAILOCE":8005540,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0},"APPENTBUR":{"CONSINPNATID":7010075121089}},"DerivedCalcEntity02":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"}},"DerivedCalcEntity03":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity04":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity05":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"APPERRMSG":"DA Error","ExistingProducts01":{"INTPRDEXST":{"ACCOUNTNUMBER":1000157283}},"RequestedProducts01":{"APPPRDNEWF":{"UNIQUEPRODID":"APC-00000916"}}}}}';
    public static String pcoUpdateResponse = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":0,"DERPCOUNIQUENUMBER":"000000007587","DerivedCalcAppData":{"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":100000,"REQPOTENTIALTOTDIRECT":7482303,"REQPOTENTIALTOTGROUP":8105546,"REQPOTENTIALTGBE":100006,"REQPOTENTIALTGAE":1,"REQPOTENTIALTGOE":8105543,"REQPOTENTIALTFL":100006}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30},"RESAPPCMNG":{"REMAXOFFSETREDUC":0.00,"REMINPLUSMINRATE":1.00,"SMMAXOFFSETREDUC":0.50,"SMMINPLUSMINRATE":0.50,"PMMAXOFFSETREDUC":1.00,"PMMINPLUSMINRATE":0.00,"HOCMMAXOFFSETREDUC":8.00,"HOCMMINPLUSMINRATE":0.00}},"Entity01":{"INTENTCLIENTCODE1":"SBSOUTP001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity01":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"},"DERENTINST":{"TOTALINSTALLMENTS":2136},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":6109597},"DERENTARRS":{"TOTALAMNT":298267}},"Entity02":{"INTENTCLIENTCODE1":"FOURIBM001","APPENTIDTYPE":"01","APPENTBUR":{"CONSINPNATID":7010075121089}},"Entity03":{"INTENTAPRF":{"RETAILOCE":8005540,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity03":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity04":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity05":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity06":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"ExistingProducts01":{"INTPRDEXST":{"ACCOUNTNUMBER":1000157283}},"APPERRMSG":"DA Error"}}}';

    @isTest
    public static void testGetPricing() {


        OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Profile profile1 = [SELECT Id FROM Profile WHERE Name='Standard User (RBB Manager)'];
        User user1 = new User(FirstName = 'test1', LastName= 'last_test1', Email='testSf@test1.com',
                             Phone='111-111-1111', alias = 'test1', EmailEncodingKey='UTF-8', ProfileId = profile1.Id,
                             LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
                             UserName = 'sftest1Case@test.com', IsActive = true);
        insert user1;
         Profile profile2 = [SELECT Id FROM Profile WHERE Name='Standard User (Business Banker)'];
        User user2 = new User(FirstName = 'test2', LastName= 'last_test2', Email='testSf@test2.com',managerId=user1.Id,
                             Phone='111-111-1100', alias = 'test2', EmailEncodingKey='UTF-8', ProfileId = profile2.Id,
                             LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
                             UserName = 'sftest2Case@test.com', IsActive = true);
        insert user2;  //giving permission error

		Application_Product__c childApprod = [select Id FROM Application_Product__c where Application_Product_Parent__c=null  LIMIT 1];

        SetProductTOBController.insertPricing(childApprod.Id);
           // ();
        system.runAs(user2){
     	test.startTest();

        List< PricingAndFeesController.PricingWrapper> pricingWrapper  = new List< PricingAndFeesController.PricingWrapper>();
          PricingAndFeesController.getproductPricing(opp.Id);
          PricingAndFeesController.getfWrapperList();
          PricingAndFeesController.submitApprovalProcess(opp.Id);
          PricingAndFeesController.submitPricing(opp.Id);
          PricingAndFeesController.updateApprovePricing(opp.Id);
		  PricingAndFeesController.isPricingApproval(opp.Id);

       	test.stopTest();

        }
       system.assertNotEquals(opp, null);

    }

    @testSetup static void createData(){

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

        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Onboarding').getRecordTypeId();
        opp.RecordTypeId = recordTypeId;
        opp.Trigger_Approval_Process__c = 'Pricing';
        Insert opp;

        //Products
        Id pricebookId = Test.getStandardPricebookId();

        //For Policy without Spouse
        Product2 product1 = new Product2();
        product1.name = 'EPP Executor Fees Policy';
        product1.IsActive = true;
        insert product1;
        PricebookEntry pricebookEntry1 = new PricebookEntry();
        pricebookEntry1.UnitPrice = 0;
        pricebookEntry1.Product2Id = product1.id;
        pricebookEntry1.Pricebook2Id = pricebookId;
        pricebookEntry1.IsActive = true;
        insert pricebookEntry1;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.Product2Id = product1.Id;
        oppLineItem.PricebookEntryId = pricebookEntry1.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        Insert oppLineItem;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        app.AIPS__c = responseString;
        insert app;

        Application_Product__c apc = new Application_Product__c();
        apc.Opportunity_Product_Id__c = opp.Id;
        apc.Opportunity__c = opp.Id;
        apc.Annual_Turnover__c = 11000000;
        apc.Asset_Value__c = 200000000;
        apc.IsMainProduct__c = true;
        insert apc;


            Application_Product__c apc1 = new Application_Product__c();
            apc1.Opportunity_Product_Id__c = opp.Id;
            apc1.Opportunity__c = opp.Id;


                apc1.Account_Number__c = Decimal.valueOf('4047854674');
                apc1.Account_Balance__c = 200000000;

            apc1.IsMainProduct__c = false;
         	apc1.Product_State__c = 'Existing';
            apc1.Product_Status__c='Accepted';
            insert apc1;

            apc.Application_Product_Parent__c = apc1.Id;
            update apc;





     	apc1.Sanctioning_Status__c = 'Accepted';
         update apc1;


       /*ProductTermsOfBusinessController.ProductTOB tob = new ProductTermsOfBusinessController.ProductTOB();
        tob.appProdId = apc1.Id;
        tob.appProduct = apc1;
        tob.termstobList = new List<Terms_Of_Business__c>();
        tob.appProductHistory = new List<ProductTermsOfBusinessController.appProdHistory> ();

        ProductTermsOfBusinessController.appProdHistory appHis = new ProductTermsOfBusinessController.appProdHistory();*/

       }

}
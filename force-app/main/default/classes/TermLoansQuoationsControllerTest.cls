/**
* This is the Test Class for the Term Loans Quoations and Agreement Controller
*
* @author  Himanshu Nimje
* @since   2020-12-01
*/

@isTest
public class TermLoansQuoationsControllerTest {
    
    @testSetup
    public static void dataCreation() {
       
        /*
        ClientDetailsSectionCreditTest.dataCreation();
        
        IntegrationTestDataFactory.insertIntegrationSettings(ChequeServicesOrchestration_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{IPlistNCARatesV1_IH_v1.INTEGRATION_SERVICE_NAME}); 
        IntegrationTestDataFactory.insertIntegrationSettings(ABFgetQuoteInfoForEspV4_IH_V1.INTEGRATION_SERVICE_NAME, new List<String>{ABFgetQuoteInfoForEspV4_IH_V1.INTEGRATION_SERVICE_NAME}); 
        */
        insertUser();
        
       Account account = new Account();
        account.Name = 'Test Account001';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;
        
        Contact testContact = new Contact();
        testContact.FirstName = 'Test Contact';
        testContact.LastName = '1';
        insert testContact; 
        
        Opportunity oppCovid = new Opportunity();
        oppCovid.Name = 'Covid Onboarding';
        oppCovid.CloseDate = Date.today();
        oppCovid.StageName = 'New';
        oppCovid.AccountId = account.Id;
        insert oppCovid;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name='Standard Pricebook', isActive=true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppCovid.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        
         Application__c  appcovid = new Application__c();
        appcovid.Opportunity__c = oppCovid.id;
        appcovid.Title__c = 'Dr';
        appcovid.FirstNameSignature__c = 'Rob';
        appcovid.SurnameSignature__c = 'Robbello';
        appcovid.Signing_Date__c = System.today();
        insert appcovid;
        
        Application_Product__c apcCovid = new Application_Product__c();
        apcCovid.Opportunity_Product_Id__c = oppCovid.id;
        apcCovid.Opportunity__c = oppCovid.id;
        apcCovid.Annual_Turnover__c = 11000000;
        apcCovid.Asset_Value__c = 200000000;
        apcCovid.IsMainProduct__c = true;
        insert apcCovid;
        
        BusinessHours bh = [SELECT Id, Name FROM BusinessHours where Name = '24 Hours including Public Holidays'];
        User u = [SELECT Id, UserRoleId FROM User LIMIT 1];
        
        Case caseRec = new Case();
        caseRec.BusinessHoursId = bh.Id;
        caseRec.Subject = 'Test Case';
        caseRec.AccountId = account.Id;
        caseRec.Banker_RE__c = u.UserRoleId;
        caseRec.ContactId=testContact.Id;
        caseRec.Application_Product_Id__c = apcCovid.Id;


        caseRec.Opportunity__c = oppCovid.id;


        insert caseRec;
        
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IPlistNCARatesV1_IH_v1.INTEGRATION_SERVICE_NAME});
         IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFgetQuoteInfoForEspV5_IH_V1.INTEGRATION_SERVICE_NAME});
        
        
    }
    
    @future
    private static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Banker%' LIMIT 1];
        UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];
        
        User futureUser = new User(
            ProfileId = p.Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            SiteCode__c = '8198',
            SiteType__c = '034',
            Teller_Operator_Code__c = '12345',
            Supervisor__c = '0',
            Division__c = 'RBB',
            UserRoleId = r.Id
        );
        insert(futureUser);
    }
    
    
    public static testMethod void testgetPrimeRates() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,  '{"IPlistNCARatesV1Response":{"ipb100o":{"ncaMaxfeeCfErr":"0000 - SUCCESS","ncaMaxfeeCfMaxsf":69,"ncaMaxfeeMaErr":"0000 - SUCCESS","ncaMaxfeeMaMaxsf":69,"ncaMaxfeeOcaErr":"0000 - SUCCESS","ncaMaxfeeOcaMaxsf":69,"ncaMaxfeeStctErr":"0000 - SUCCESS","ncaMaxfeeStctMaxsf":69,"ncaMaxfeeUctErr":"0000 - SUCCESS","ncaMaxfeeUctMaxsf":69,"ncaMaxifeeCfErr":"0000 - SUCCESS","ncaMaxifeeCfFirst":189.75,"ncaMaxifeeCfMax":6050.5,"ncaMaxifeeCfNext":11.5,"ncaMaxifeeCfPerc":1000,"ncaMaxifeeMaErr":"0000 - SUCCESS","ncaMaxifeeMaFirst":1265,"ncaMaxifeeMaMax":6037.5,"ncaMaxifeeMaNext":11.5,"ncaMaxifeeMaPerc":10000,"ncaMaxifeeOcaErr":"0000 - SUCCESS","ncaMaxifeeOcaFirst":189.75,"ncaMaxifeeOcaMax":1207.5,"ncaMaxifeeOcaNext":11.5,"ncaMaxifeeOcaPerc":1000,"ncaMaxifeeStctErr":"0000 - SUCCESS","ncaMaxifeeStctFirst":189.75,"ncaMaxifeeStctMax":1207.5,"ncaMaxifeeStctNext":11.5,"ncaMaxifeeStctPerc":1000,"ncaMaxifeeUctErr":"0000 - SUCCESS","ncaMaxifeeUctFirst":189.75,"ncaMaxifeeUctMax":6040.5,"ncaMaxifeeUctNext":11.5,"ncaMaxifeeUctPerc":1000,"ncaMaxrateCfErr":"0000 - SUCCESS","ncaMaxrateCfMaxdr":20.75,"ncaMaxrateMaErr":"0000 - SUCCESS","ncaMaxrateMaMaxdr":19,"ncaMaxrateOcaErr":"0000 - SUCCESS","ncaMaxrateOcaMaxdr":21,"ncaMaxrateStctErr":"0000 - SUCCESS","ncaMaxrateStctMaxdr":60,"ncaMaxrateUctErr":"0000 - SUCCESS","ncaMaxrateUctMaxdr":27.75,"primeRate":6.25,"primeRateErr":"0000 - SUCCESS","repurchaseRate":7,"repurchaseRateErr":"0000 - SUCCESS"},"nbsapdpo":{"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO001"},"nbsmsgo3":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}'));
        Test.startTest();
        System.assert((TermLoansQuoationsController.getPrimeRates())!= null);
        Test.stopTest();
    }
    
    public static testMethod void testgetCalculateQuotes() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,'{"ABFgetQuoteInfoForEspV4Response":{"nbsapdpo":{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO005","version":null},"nbsmsgo3":{"nbrUserErrs":0,"nbrUserMsgs":0,"sysErrTxt":null,"version":"MSG3001"},"plpa71o":{"acctType":1,"agreementType":"L","applicationNumber":0,"brokenPeriodInd":null,"brokenPeriodInst":0,"clBusinessInd":null,"clifePremium":0,"clifeSchemeCode":0,"complexStr":"N","conditionsOther":null,"contractDate":20201021,"creditCostMultiple":1.31,"creditLife":0,"crlifeBenefit":null,"crlifeComm":0,"crlifeNetPrem":0,"crlifePolicyFee":0,"crlifeReq":"N","crlifeScheme":0,"date1stInst":20201130,"dateLastInst":20260430,"dteFrstCapIntInst":0,"dteFrstIntInst":0,"dteLastCapInst":0,"dteLastIntInst":0,"empowerCode":null,"finalInst":19733.22,"freq":1,"frequency":"MONTHLY","hiMthIntInstAmt":0,"inclCrlpInst":19733.56,"initFee":42350,"initMethod":"P","intFeesCrlife":227462.58,"interestRate":7.25,"loanAmnt":855000,"maxRateType":60,"nbrCapIntInst":0,"nbrIntInst":0,"ncaInd":null,"nlrRefNo":0,"noInsts":66,"noRegularInsts":65,"noSkipIns":9,"payMethod":"DEBIT ORDER","payment":"Y","productCode":"LOAN","purposeOfLoan":2,"quoteCreatedBy":null,"quoteNumber":"00000000000848160","rateFactorInd":"+","rateFactorValue":1.75,"rateType":"P","regCapIntInstAmt":0,"regInst":19733.56,"schemeCode":0,"schemeType":null,"secInfo":null,"securityReq":"N","serviceFee":0,"settlement":null,"settlementAmnt":0,"skipInsAmount":0,"skipMonths":9,"smsinfoReq":null,"termLoanType":null,"totAllInstAmt":0,"totAmntRepay":1302414.62,"totCapIntAmt":0,"totIntOnlyAmt":0,"totalAmntDef":897350,"totalCoc":1124812.58,"totalCreditLife":0,"totalInst":19733.56,"totalInterest":227462.58,"totalServiceFee":0,"totalSettleAmount":0,"versionNo":0,"visibleCredit":null}}}' ));
        Test.startTest();
        System.assert((TermLoansQuoationsController.getCalculateQuotes(caseData().Id,'855000.00','20201021','20201130','01','66','N','Y','N','7.25000','42350','0','9','N','Y','848160','N','P','00','02','060','0','0','0','TLON','E','0','0','0','0','0','N'  ))!= null);
        Test.stopTest();
    }
    
    private static case caseData() {
        case cs = [SELECT Id FROM case WHERE Subject = 'Test Case' LIMIT 1];
        return cs;
    }
}
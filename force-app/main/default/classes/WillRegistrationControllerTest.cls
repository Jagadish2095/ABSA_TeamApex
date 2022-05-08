@isTest
public class WillRegistrationControllerTest {
    
    
    // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Positive Starts here $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    
    
    public static testMethod void PositiveTestWillRegistrationController(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        //IntegrationTestDataFactory.insertIntegrationTranslations();
        List<Integration_Service__c> ISStock = [SELECT Id, Username__c, URL_Extension__c, Password__c, Method__c, Integration_API_ID__c, Content_Type__c, LastReferencedDate, Name FROM Integration_Service__c where Name =: StringConstants.CREATE_WILL_RECORD Limit 1];
        System.debug('ISStock'+ISStock);
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        
        willRegistrationController.checkInitValidity(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
        
        
        
    }
    
    public static testMethod void PositiveTestWillRegistrationController1(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.checkRegistrationError(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
        
    }  
    public static testMethod void PositiveTestWillRegistrationController2(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();        
        Test.startTest();
        willRegistrationController.getAccountData(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
        
    }  
    
    public static testMethod void PositiveTestWillRegistrationController3(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getOpportunityData(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
        
    }  
    
    public static testMethod void PositiveTestWillRegistrationController4(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getAssetData(testDataFactory.testOpportunity.Id);
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController5(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getApplicationData(testDataFactory.testOpportunity.Id);
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController6(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getStockService(testDataFactory.testOpportunity.Id,'','WILLS','E','STD','','','001','410','410','3232');
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController7(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createAssetInSf(testDataFactory.testOpportunity,testDataFactory.testOpportunity.Id,testDataFactory.testAsset);
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController8(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createAssetInWillSystem(testDataFactory.testOpportunity.Id,'41000049999','AFIFTAP001','ABS',3232,0);
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController9(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createTracker(testDataFactory.testOpportunity.Id,'WILLS','WILLS','41000049999','D','A','Arkcdxiqbsmyglenftph','','','Application Received','','3232');
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController10(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getAssetFromWillSystem(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController11(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.UpdateWill(testDataFactory.testOpportunity.Id ,'41000049999','{"RC":0,"RCMessage":"TRANSACTION SUCCESSFUL","WillNo":41000049999,"ProductType":"WILL","ProductStatus":"OPEN","EffectiveDate":20190306,"BrokerCode":0,"BrokerName":"","CIFKey":"WILLM 0778","DomicileSite":3232,"LanguageCode":"","BigPrint":"","UsrId":"","Testator":"","Testatrix":"","DeliverMethod":"","AdvisorCode":0,"AdvisorName":"","SpecialistCode":0,"SpecialistName":"","SubmittedBy":"","SubmitterTelno":"","OldWillNo":"","OldFilingNumber":"","WillFiled":"N","WillLegal":"","FillNo":"","DateSigned":0,"DateFiled":0,"DateWithdrawn":0,"TimeWithdrawn":"00:00:00","ReasonWithdrawn":"","WithdrawnCode":"","WithdrawUserId":0,"ReferalReason":"","WhoDied":"","CorpCode":"0","TransactionSite":"3232","CurrentBalance":0.0,"BranchCode":"0","DeceasedDate":0,"RegistrationDate":0,"WillStatus":"S","WillError":"N","NewAmendRevise":"N","WillOrigin":"","AcknowledgeLetter":"N","TrackerStatus":"","PricingFlag":"N","CaseNo":0,"SalaryNo":0,"DispatchDate":0,"DraftingBranch":3232,"Correction":"N","RevisionDate":0,"ExecutorFeePlan":"","FirstFileDate":0,"safeCustodyFee":"N","EmergencyWill":"N","DateReturned":0,"StandAlone":"","Date1stScfLetter":0,"EisDate":0,"LeadCode":0,"LeadName":"","CSASent":"","TrustIndicator":"N","SpecialBequestVal":0.0,"CasaNo":"","CasaDate":0,"CasaIndicator":"","FeePaid":"N","AmountDue":0.0,"PayDate":0,"FilePath":"","FileName":"","FileAction":"","FileSize":0}');
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController12(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.debitOrderInstruction(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController13(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createWillBankingDetail(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController14(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.updateWillToCIF(testDataFactory.testOpportunity.Id ,'AFIFTAP001', '41000049999','8994','1057488','WILL','20','','','','1'); 
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController15(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.sendWillRegCommunication(testDataFactory.testOpportunity.Id);
        
        
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController16(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createAssetLiabilities(testDataFactory.testOpportunity.Id,'41000049999');
        
        
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController17(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createRegistrationTracker(testDataFactory.testOpportunity.Id,'WILLS','WILLS','41000049999','D','AR','ARkcdxiqbsmyglenftph','','','Registration Information','','3232');
        
        
        Test.stopTest();
        
    } 
    
    //#####################################################   REVISION STARTS   ##################################################
    
    
    public static testMethod void PositiveTestWillRegistrationController18(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionDebitOrderInstruction(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController19(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionGetWillBankingDetail(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController20(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionUpdateWillbankingDetail(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController21(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionCreateWillBankingDetail(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    
    public static testMethod void PositiveTestWillRegistrationController22(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionCreateAssetLiabilities(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    
    
    public static testMethod void PositiveTestWillRegistrationController23(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionGetAssetFromWillSystem(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController24(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));   
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();        
        String todaysdate = Datetime.now().format('yyyyMMdd');        
        Test.startTest();
        willRegistrationController.revisionUpdateWill(testDataFactory.testOpportunity.Id ,'41000049999','{"Fault":null,"WithdrawUserId":0,"WithdrawnCode":"","WillStatus":"S","WillOrigin":"","WillNo":41000049999,"WillLegal":"","WillFiled":"N","WillError":"N","WhoDied":"","UsrId":"","TrustIndicator":"N","TransactionSite":"3232","TrackerStatus":"","TimeWithdrawn":"00:00:00","Testatrix":"","Testator":"","SubmitterTelno":"","SubmittedBy":"","statusCode":200,"status":"OK","StandAlone":"","SpecialistName":"","SpecialistCode":0,"SpecialBequestVal":0.0,"SalaryNo":0,"safeCustodyFee":"N","RevisionDate":0,"RegistrationDate":20190709,"ReferalReason":"","ReasonWithdrawn":"","RCMessage":"TRANSACTION SUCCESSFUL","RC":"0","ProductType":"WILL","ProductStatus":"OPEN","PricingFlag":"N","PayDate":0,"OldWillNo":"","OldFilingNumber":"","NewAmendRevise":"N","moreInformation":null,"message":null,"LeadName":"","LeadCode":0,"LanguageCode":"","httpMessage":null,"httpCode":null,"FirstFileDate":0,"FillNo":"","FileSize":0,"FilePath":"","FileName":"","FileAction":"","FeePaid":"N","ExecutorFeePlan":"","EmergencyWill":"N","EisDate":0,"EffectiveDate":20190306,"DraftingBranch":3232,"DomicileSite":3232,"DispatchDate":0,"DeliverMethod":"","DeceasedDate":0,"DateWithdrawn":0,"DateSigned":0,"DateReturned":0,"DateFiled":0,"Date1stScfLetter":0,"CurrentBalance":0.0,"CSASent":"","Correction":"N","CorpCode":"0","CIFKey":"WILLM 0778","CaseNo":0,"CasaNo":"","CasaIndicator":"","CasaDate":0,"BrokerName":"","BrokerCode":0,"BranchCode":"0","BigPrint":"","AmountDue":0.0,"AdvisorName":"","AdvisorCode":0,"AcknowledgeLetter":"N"}');
        willRegistrationController.revisionUpdateWill(testDataFactory.testOpportunity.Id ,'41000049999','{"Fault":null,"WithdrawUserId":0,"WithdrawnCode":"","WillStatus":"S","WillOrigin":"","WillNo":41000049999,"WillLegal":"","WillFiled":"N","WillError":"N","WhoDied":"","UsrId":"","TrustIndicator":"N","TransactionSite":"3232","TrackerStatus":"","TimeWithdrawn":"00:00:00","Testatrix":"","Testator":"","SubmitterTelno":"","SubmittedBy":"","statusCode":200,"status":"OK","StandAlone":"","SpecialistName":"","SpecialistCode":0,"SpecialBequestVal":0.0,"SalaryNo":0,"safeCustodyFee":"N","RevisionDate":0,"RegistrationDate":'+todaysdate+',"ReferalReason":"","ReasonWithdrawn":"","RCMessage":"TRANSACTION SUCCESSFUL","RC":"0","ProductType":"WILL","ProductStatus":"OPEN","PricingFlag":"N","PayDate":0,"OldWillNo":"","OldFilingNumber":"","NewAmendRevise":"N","moreInformation":null,"message":null,"LeadName":"","LeadCode":0,"LanguageCode":"","httpMessage":null,"httpCode":null,"FirstFileDate":0,"FillNo":"","FileSize":0,"FilePath":"","FileName":"","FileAction":"","FeePaid":"N","ExecutorFeePlan":"","EmergencyWill":"N","EisDate":0,"EffectiveDate":20190306,"DraftingBranch":3232,"DomicileSite":3232,"DispatchDate":0,"DeliverMethod":"","DeceasedDate":0,"DateWithdrawn":0,"DateSigned":0,"DateReturned":0,"DateFiled":0,"Date1stScfLetter":0,"CurrentBalance":0.0,"CSASent":"","Correction":"N","CorpCode":"0","CIFKey":"WILLM 0778","CaseNo":0,"CasaNo":"","CasaIndicator":"","CasaDate":0,"BrokerName":"","BrokerCode":0,"BranchCode":"0","BigPrint":"","AmountDue":0.0,"AdvisorName":"","AdvisorCode":0,"AcknowledgeLetter":"N"}');
        Test.stopTest();        
    } 
    
    public static testMethod void PositiveTestWillRegistrationController25(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionCreateRegistrationTrackerApplication(testDataFactory.testOpportunity.Id,'WILLS','WILLS','41000049999','Dfdgfd','AR','ARkcdxiqbsmyglenftph','','','Registration Information','','3232');
        
        
        Test.stopTest();
        
    }     
    public static testMethod void PositiveTestWillRegistrationController26(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionCreateRegistrationTracker(testDataFactory.testOpportunity.Id,'WILLS','WILLS','41000049999','D','AR','ARkcdxiqbsmyglenftph','','','Registration Information','','3232');
        
        
        Test.stopTest();
        
    } 
    
    // ##################################################### Negative Start Here ######################################################
    
    public static testMethod void NegativeTestWillRegistrationController0(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        
        Test.startTest();
        
        willRegistrationController.checkInitValidity(testOpportunity.Id);
        
        Test.stopTest();
        
    }  
    
    
    public static testMethod void NegativeTestWillRegistrationController(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        List<Integration_Service__c> ISStock = [SELECT Id, Username__c, URL_Extension__c, Password__c, Method__c, Integration_API_ID__c, Content_Type__c, LastReferencedDate, Name FROM Integration_Service__c where Name =: StringConstants.CREATE_WILL_RECORD Limit 1];
        System.debug('ISStock'+ISStock);
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        
        willRegistrationController.checkInitValidity(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
        
    }
    
    public static testMethod void NegativeTestWillRegistrationController1(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        testDataFactory.testApplication.Will_Stock_Confirmation__c = true;
        testDataFactory.testApplication.Will_Reg_Stock_Service_Error__c='ERROR :';
        testDataFactory.testApplication.Will_Reg_Asset_creation_in_SF_Error__c='ERROR :';
        testDataFactory.testApplication.Will_Reg_Asset_creation_in_Will_Sy_Error__c='ERROR :';
        testDataFactory.testApplication.Will_Initialise_Tracker_Created_Error__c='ERROR :';
        testDataFactory.testApplication.Will_Reg_Get_Asset_from_Will_Error__c='ERROR :';
        testDataFactory.testApplication.Will_Reg_Asset_update_in_Will_Sys_Error__c='ERROR :';
        testDataFactory.testApplication.Will_Reg_Crete_Will_Banking_Detail_Error__c='ERROR :';
        testDataFactory.testApplication.Will_Reg_Asset_update_In_CIF_Sys_Error__c='ERROR :';
        
        
        
        Test.startTest();
        willRegistrationController.checkRegistrationError(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
        
    }  
    public static testMethod void NegativeTestWillRegistrationController2(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();        
        Test.startTest();
        willRegistrationController.getAccountData(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
        
    }  
    
    public static testMethod void NegativeTestWillRegistrationController3(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getOpportunityData(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
        
    }  
    
    public static testMethod void NegativeTestWillRegistrationControllerr4(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getAssetData(testDataFactory.testOpportunity.Id);
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController5(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getApplicationData(testDataFactory.testOpportunity.Id);
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController6(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, 'Stock Number Fail'));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getStockService(testDataFactory.testOpportunity.Id,'','WILLS','E','STD','','','001','410','410','3232');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController7(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createAssetInSf(testDataFactory.testOpportunity,testDataFactory.testOpportunity.Id,testDataFactory.testAsset);
        Test.stopTest();
        
    } 
    
    
    public static testMethod void NegativeTestWillRegistrationController8(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, 'Create Will Record Fail'));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createAssetInWillSystem(testDataFactory.testOpportunity.Id,'41000049999','AFIFTAP001','ABS',3232,0);
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController9(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, 'Create Tracker Entry Fail'));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createTracker(testDataFactory.testOpportunity.Id,'WILLS','WILLS','41000049999','D','A','Arkcdxiqbsmyglenftph','','','Application Received','','3232');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController10(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.getAssetFromWillSystem(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController11(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, 'Debit Order Instruction Fail'));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.debitOrderInstruction(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController12(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, 'Create Will banking Details Fail'));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createWillBankingDetail(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationControllerr13(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.updateWillToCIF(testDataFactory.testOpportunity.Id ,'AFIFTAP001', '41000049999','8994','1057488','WILL','20','','','','1'); 
        Test.stopTest();
        
    } 
    
    
    
    public static testMethod void NegativeTestWillRegistrationController14(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.sendWillRegCommunication(testDataFactory.testOpportunity.Id);
        
        
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController15(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createAssetLiabilities(testDataFactory.testOpportunity.Id,'41000049999');
        
        
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController16(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.createRegistrationTracker(testDataFactory.testOpportunity.Id,'WILLS','WILLS','41000049999','D','AR','ARkcdxiqbsmyglenftph','','','Registration Information','','3232');
        
        
        Test.stopTest();
        
    } 
    
    
    /*************************************************************** NEGATIVE REVISION STARTS   ******************************************************/
    
    public static testMethod void NegativeTestWillRegistrationController17(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionDebitOrderInstruction(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController18(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionGetWillBankingDetail(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController19(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionUpdateWillbankingDetail(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    public static testMethod void NegativeTestWillRegistrationController20(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionCreateWillBankingDetail(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController21(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionCreateAssetLiabilities(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController22(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionGetAssetFromWillSystem(testDataFactory.testOpportunity.Id ,'41000049999');
        Test.stopTest();
        
    } 
    
    public static testMethod void NegativeTestWillRegistrationController23(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.CREATE_TRACKER_RECORD});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionUpdateWill(testDataFactory.testOpportunity.Id ,'41000049999','{"Fault":null,"WithdrawUserId":0,"WithdrawnCode":"","WillStatus":"S","WillOrigin":"","WillNo":41000049999,"WillLegal":"","WillFiled":"N","WillError":"N","WhoDied":"","UsrId":"","TrustIndicator":"N","TransactionSite":"3232","TrackerStatus":"","TimeWithdrawn":"00:00:00","Testatrix":"","Testator":"","SubmitterTelno":"","SubmittedBy":"","statusCode":200,"status":"OK","StandAlone":"","SpecialistName":"","SpecialistCode":0,"SpecialBequestVal":0.0,"SalaryNo":0,"safeCustodyFee":"N","RevisionDate":0,"RegistrationDate":20190304,"ReferalReason":"","ReasonWithdrawn":"","RCMessage":"TRANSACTION SUCCESSFUL","RC":"0","ProductType":"WILL","ProductStatus":"OPEN","PricingFlag":"N","PayDate":0,"OldWillNo":"","OldFilingNumber":"","NewAmendRevise":"N","moreInformation":null,"message":null,"LeadName":"","LeadCode":0,"LanguageCode":"","httpMessage":null,"httpCode":null,"FirstFileDate":0,"FillNo":"","FileSize":0,"FilePath":"","FileName":"","FileAction":"","FeePaid":"N","ExecutorFeePlan":"","EmergencyWill":"N","EisDate":0,"EffectiveDate":20190306,"DraftingBranch":3232,"DomicileSite":3232,"DispatchDate":0,"DeliverMethod":"","DeceasedDate":0,"DateWithdrawn":0,"DateSigned":0,"DateReturned":0,"DateFiled":0,"Date1stScfLetter":0,"CurrentBalance":0.0,"CSASent":"","Correction":"N","CorpCode":"0","CIFKey":"WILLM 0778","CaseNo":0,"CasaNo":"","CasaIndicator":"","CasaDate":0,"BrokerName":"","BrokerCode":0,"BranchCode":"0","BigPrint":"","AmountDue":0.0,"AdvisorName":"","AdvisorCode":0,"AcknowledgeLetter":"N"}');
        Test.stopTest();
        
    } 
    
    /*
    public static testMethod void NegativeTestWillRegistrationController24(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, 'Create Tracker Entry Fail'));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionCreateRegistrationTrackerApplication(testDataFactory.testOpportunity.Id,'WILLS','WILLS','41000049999','Dfdgfd','AR','ARkcdxiqbsmyglenftph','','','Registration Information','','3232');
        
        
        Test.stopTest();
        
    } 
    */
    
    public static testMethod void NegativeTestWillRegistrationController25(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WillRegistrationMock_ApiRest(StringConstants.NEGATIVE_STRING, 'Create Tracker Entry Fail'));
        
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER, StringConstants.CREATE_WILL_RECORD, StringConstants.CREATE_TRACKER_RECORD, StringConstants.GET_WILL_DETAILS, StringConstants.UPDATE_WILL_DETAIL, StringConstants.DEBIT_ORDER_INSTRUCTION,StringConstants.CREATE_WILL_BANKING_DETAILS, StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        willRegistrationController.revisionCreateRegistrationTracker(testDataFactory.testOpportunity.Id,'WILLS','WILLS','41000049999','Dfdgfd','AR','ARkcdxiqbsmyglenftph','','','Registration Information','','3232');
        
        
        Test.stopTest();
        
    } 
    
    
}
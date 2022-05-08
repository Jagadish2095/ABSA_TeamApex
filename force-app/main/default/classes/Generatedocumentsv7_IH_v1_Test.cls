@isTest
public class Generatedocumentsv7_IH_v1_Test {
     @isTest static void getGeneratedocumentsv7() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Generatedocumentsv7_Req_IB_v1.createDummyRequest();
         
        Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Generatedocumentsv7_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Generatedocumentsv7_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
        
       
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Registration__c='South Africa';
        testAccount.Client_Group__c = 'Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Country_of_Registration__c = 'South Africa';
      	testAccount.Source_of_Income__c = 'Salary';
        insert testAccount;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode = '1234' );
        insert prod;
        system.debug('testAccount'+testAccount);
        
        Test.startTest();
        Generatedocumentsv7_IH_v1.generateDocuments(testAccount, false);
        Test.stopTest();
        Generatedocumentsv7_Resp_IB_v1.createdummyResponse();
        Generatedocumentsv7_IU_v1.mapRequestFields(testAccount);
    }

    
    @isTest static void getGeneratedocumentsClientException(){
        Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.NEGATIVE_STRING));
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Generatedocumentsv7_STRING});
        
        Test.startTest();
        Generatedocumentsv7_IH_v1.generateDocuments(testDataFactory.testAccount,false);
        Test.stopTest();
        Generatedocumentsv7_Resp_IB_v1.createdummyResponse();
    }
    
    @isTest static void getGeneratedocumentsClientNoIntegrationSettings(){
        
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
        testDataFactory.testAccount.Occupation_Status__pc=null;
        testDataFactory.testAccount.Occupation_Category__pc=null;
        testDataFactory.testAccount.Income_Source__pc=null;
        
        Test.startTest();
       Generatedocumentsv7_IH_v1.generateDocuments(testDataFactory.testAccount, false);
        Test.stopTest();
        Generatedocumentsv7_Resp_IB_v1.createdummyResponse();
    }
    
    @isTest static void getGeneratedocumentsClientNoSettings() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
       
       
        Generatedocumentsv7_Req_IB_v1.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Generatedocumentsv7_STRING});
         List<Integration_API__c> integrationRec= [select id from Integration_API__c];
        delete integrationRec;
        Test.startTest();
        Generatedocumentsv7_IH_v1.generateDocuments(testDataFactory.testAccount, false);
        //Generatedocumentsv7_IH_v1.generateDocuments(null, null);
        Test.stopTest();
        Generatedocumentsv7_Resp_IB_v1.createdummyResponse();
    }
}
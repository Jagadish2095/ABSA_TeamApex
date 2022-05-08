@isTest
public class GenerateClientCIFpty_IH_v1_Test {
 /****************************************************************** BUSINESS ************************************************************************/
  
    //Positive
    @isTest static void testCreateClientBusinessPositive(){
        
         GenerateClientCIFpty_Req_IB_v1 dummyBean = GenerateClientCIFpty_Req_IB_v1.createDummyRequest();
 		// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_CLIENT_CIF, StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS, StringConstants.UPD_JNT_PART_BY_CLIENT_CODE});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Account testAccount= new Account();
        testAccount.Client_Type__c = 'Private Company';
        testAccount.Name = 'Test Name';
        insert testAccount;
        
        Test.startTest();
        // Call the method to test 
        map<GenerateClientCIFpty_Resp_IB_v1,List<Sys_Log_Integration__c>> responseBean = GenerateClientCIFpty_IH_v1.createClient(testAccount, UserInfo.getUserId(),'Business Prospect');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
       GenerateClientCIFpty_Resp_IB_v1.dummyResponse();
    }
    
   //No Settings 1
    @isTest static void testCreateClientBusinessNoIntegrationSettings(){
        GenerateClientCIFpty_Req_IB_v1 dummyBean = GenerateClientCIFpty_Req_IB_v1.createDummyRequest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Account testAccount= new Account();
        testAccount.Client_Type__c = 'Private Company';
        testAccount.Name = 'Test Name';
        insert testAccount;
        Test.startTest();
        // Call the method to test
         map<GenerateClientCIFpty_Resp_IB_v1,List<Sys_Log_Integration__c>> responseBean = GenerateClientCIFpty_IH_v1.createClient(testAccount, UserInfo.getUserId(),'Business Prospect');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        GenerateClientCIFpty_Resp_IB_v1.dummyResponse();
    }
    
    //No Mock
    @isTest static void testCreateClientBusinessNoMock(){
        GenerateClientCIFpty_Req_IB_v1 dummyBean = GenerateClientCIFpty_Req_IB_v1.createDummyRequest();
         IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_CLIENT_CIF});
        IntegrationTestDataFactory.insertIntegrationTranslations();
          Account testAccount= new Account();
        testAccount.Client_Type__c = 'Private Company';
        testAccount.Name = 'Test Name';
        insert testAccount;
        Test.startTest();
        // Call the method to test
         map<GenerateClientCIFpty_Resp_IB_v1,List<Sys_Log_Integration__c>> responseBean = GenerateClientCIFpty_IH_v1.createClient(testAccount, UserInfo.getUserId(),'Business Prospect');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        GenerateClientCIFpty_Resp_IB_v1.dummyResponse();
    }
    
    //No Translations
    @isTest static void testCreateClientBusinessNoTranslations(){
        GenerateClientCIFpty_Req_IB_v1 dummyBean = GenerateClientCIFpty_Req_IB_v1.createDummyRequest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_CLIENT_CIF, StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS});
        Account testAccount= new Account();
        testAccount.Client_Type__c = 'Private Company';
        testAccount.Name = 'Test Name';
        insert testAccount;
        Test.startTest();
        // Call the method to test
         map<GenerateClientCIFpty_Resp_IB_v1,List<Sys_Log_Integration__c>> responseBean = GenerateClientCIFpty_IH_v1.createClient(testAccount, UserInfo.getUserId(),'Business Prospect');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        GenerateClientCIFpty_Resp_IB_v1.dummyResponse();
    }
    }
@isTest
public class AccountRefreshControllerTest {
   
    
    
    public static testMethod void testAccountCreateCIFControllerIndividual(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        system.debug('test'+testDataFactory);
        testDataFactory.testAccount.CIF__c = 'T0231';  //T0231
        testDataFactory.testAccount.Monthly_Income__pc = 'R0 - 499';
        testDataFactory.testAccount.Preferred_Communication_Method__pc = 'Email';
        update testDataFactory.testAccount;
        
         // Set mock callout class 
         
        Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CMS_GET_ACCOUNTDEATILS});

        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_CLIENT_CIF, StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
       

        Test.startTest();
        AccountRefreshController.getAccount(testDataFactory.testAccount.id);
        AccountRefreshController.UpdateAccountsFromMDM(testDataFactory.testAccount.id);
        
        Test.stopTest();
    }
    
   public static testMethod void testAccountCreateCIFControllerIndividualwithID(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        system.debug('test'+testDataFactory);
        testDataFactory.testAccount.ID_Type__pc = 'SA Identity Document';
        testDataFactory.testAccount.ID_Number__pc = '1234567890';
        testDataFactory.testAccount.CIF__c = '';
        testDataFactory.testAccount.Monthly_Income__pc = 'R0 - 499';
        testDataFactory.testAccount.Preferred_Communication_Method__pc = 'Email';
        update testDataFactory.testAccount;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_CLIENT_CIF, StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        AccountRefreshController.getAccount(testDataFactory.testAccount.id);
        AccountRefreshController.UpdateAccountsFromMDM(testDataFactory.testAccount.id);
        
        Test.stopTest();
    }
    
     public static testMethod void testAccountCreateCIFControllerIndividualwithPassport(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        system.debug('test'+testDataFactory);
        testDataFactory.testAccount.ID_Type__pc = 'Passport';
        testDataFactory.testAccount.ID_Number__pc = '1234567890';
        testDataFactory.testAccount.CIF__c = '';
        testDataFactory.testAccount.Monthly_Income__pc = 'R0 - 499';
        testDataFactory.testAccount.Preferred_Communication_Method__pc = 'Email';
        update testDataFactory.testAccount;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_CLIENT_CIF, StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        AccountRefreshController.getAccount(testDataFactory.testAccount.id);
        AccountRefreshController.UpdateAccountsFromMDM(testDataFactory.testAccount.id);
        
        Test.stopTest();
    }
    
        public static testMethod void testCallCMSservice(){
        
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 

                     User newUser = new User();
                newUser.Alias = 'dummyusr'; 
                newUser.Email='testuser1@absa.com'; 
                newUser.EmailEncodingKey='UTF-8';
                newUser.FirstName = 'Test';
                newUser.LastName='User'; 
                newUser.LanguageLocaleKey='en_US';
                newUser.LocaleSidKey='en_US'; 
                newUser.ProfileId = p.Id;
                newUser.TimeZoneSidKey='Africa/Johannesburg';
                newUser.UserName='testuser1@absa2.com';
                newUser.EmployeeNumber='9016067';
            insert newUser;	
            
   
            
            
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        system.debug('test'+testDataFactory);
            
      
            
            
        testDataFactory.testAccount.CIF__c = 'VDBERPJ350';
        testDataFactory.testAccount.Monthly_Income__pc = 'R0 - 499';
        testDataFactory.testAccount.Preferred_Communication_Method__pc = 'Email';
         testDataFactory.testAccount.Relationship_Banker_name__c=newUser.id;
        update testDataFactory.testAccount;
            

        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CMSServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CMS_GET_ACCOUNTDEATILS});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        Test.startTest();
        AccountRefreshController.getAccount(testDataFactory.testAccount.id);
        AccountRefreshController.UpdateAccountsFromMDM(testDataFactory.testAccount.id);
        
        Test.stopTest();
    }
    
    public static testMethod void testCallVAPMservice(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        system.debug('test'+testDataFactory);
        testDataFactory.testAccount.CIF__c = 'VDBERPJ350';
        testDataFactory.testAccount.Monthly_Income__pc = 'R0 - 499';
        testDataFactory.testAccount.Preferred_Communication_Method__pc = 'Email';
        update testDataFactory.testAccount;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new getCustomerVAPMSummaryMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_DEV, new list<String> {StringConstants.GET_CUSTOMER_VAPM_SUMMARY});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        
        Test.startTest();
        
        AccountRefreshController.getAccount(testDataFactory.testAccount.id);
        AccountRefreshController.UpdateAccountsFromMDM(testDataFactory.testAccount.id);
        
        Test.stopTest();
    }
    

}
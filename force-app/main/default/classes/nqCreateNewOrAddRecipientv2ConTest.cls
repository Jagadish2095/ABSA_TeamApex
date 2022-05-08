@isTest
public class nqCreateNewOrAddRecipientv2ConTest {
    
    @testSetup static void setup() {
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Registration__c='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = 'AATTORN003';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Country_of_Registration__c = 'South Africa';
       // testAccount.Source_of_Income__c = 'Salary';
        testAccount.Registration_Number__c = '1223333';
        testAccount.CASA_Screening_Date__c = System.today();
        testAccount.CASA_Risk_Status__c = '';
        testAccount.Client_Type__c = '';
        
        insert testAccount;
        
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
        insert con;
        Case cse = new Case(Communication_Method__c = 'Email',
                            Status = 'New',
                            Origin = 'Email', 
                            AccountId = testAccount.Id,
                            Risk_Management_Centre__c = 'Digital Fraud',
                            Email__c = 'test@test.com',
                            //recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                            Subject = 'test',
                            Type__c = 'test',
                            Out_Of_SLA_Reason__c = 'Account Closed',
                            Out_Of_SLA_Comments__c = 'test',
                            Description = 'test',
                            Expectation_of_the_Customer__c = 'test',
                            Incident_Date__c = date.today());
        insert cse;
    }
    @isTest static void validateAcctLinkedToClientCodePositive() 
    {  
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        String response = nqCreateNewOrAddRecipientv2Controller.getAccountDetails([select Id from case limit 1].Id);
        System.assertNotEquals(null, response);
        String responseAccount = nqCreateNewOrAddRecipientv2Controller.getAccountName([select Id from case limit 1].Id);
        System.assertNotEquals(null, responseAccount);
        Test.stopTest();
    }
   
     @isTest static void validateAccRegisterNegative() {
            
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nqcreateneworaddrecipientv2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.nqcreateneworaddrecipientv2_STRING
        });
        
        Test.startTest();
            
       // nqCreateNewOrAddRecipientv2Controller.getRequestSubmitInfo('12342', [select Id from case limit 1].Id, 'true', 'true', 'true'
          //                                                        , 'true', 'true', 'true', 'true', 'true','O', 'monday', '123',
           //                                                       '876545678', 'E','S','test@test.com','CQ','register');
        Test.stopTest();
    }
    
     @isTest static void validateAccRegisterPositive() {        
      // Set mock callout class
        	Test.setMock(HttpCalloutMock.class, new nqcreateneworaddrecipientv2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        	IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.nqcreateneworaddrecipientv2_STRING
        	});        
        	Test.startTest();
           
            String response = nqCreateNewOrAddRecipientv2Controller.registerNotifyMe('9050544469', [select Id from case limit 1].Id, true, false, true, false, false, false, false, 'L', 'daily', '200', 'Muvhuso', '0714476653', 'E', 'S', 'muvhuso.nekhubvi@absa.africa', 'SAVINGS');
            System.assertNotEquals(null, response);
            Test.stopTest();
    }
    
     @isTest static void validateAccUpdatePositive() {        
       		Test.setMock(HttpCalloutMock.class, new nqupdatenotificationsv1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
            IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.nqupdatenotificationsv1_STRING
            });            
           Test.startTest();
           String response  = nqCreateNewOrAddRecipientv2Controller.updateNotifyMe('9050544469', [select Id from case limit 1].Id, true, false, true, false, false, false, false, 'L', 'daily', '200', 'SAVINGS');
           System.assertNotEquals(null, response);
           Test.stopTest();
            }
              
     @isTest static void validateAccCancelPositive() {   
                
             Test.setMock(HttpCalloutMock.class, new nqcancelacctnotificationv1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
             IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
              StringConstants.nqcancelacctnotificationv1_STRING
              });
              Test.startTest();
        
              String response = nqCreateNewOrAddRecipientv2Controller.cancelNotifyMe('9050544469', [select Id from case limit 1].Id);
              System.assertNotEquals(null, response);
         	  Test.stopTest();
    }
    
    @isTest static void validatenQgetRegisteredPositive() {  
    	Test.setMock(HttpCalloutMock.class, new nQlistRecipientsRegV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        	IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING
        	});        
        	Test.startTest();
           
           String response = nqCreateNewOrAddRecipientv2Controller.getRecipientRegistered([select Id from case limit 1].Id);
           System.assertNotEquals(null, response);
           Test.stopTest();
    }
    
    @isTest static void validatenUpdateRegisteredPositive() {  
    	Test.setMock(HttpCalloutMock.class, new nQreplaceRecipientsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        	IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING
        	});        
        	Test.startTest();
           
            String response = nqCreateNewOrAddRecipientv2Controller.updateRecipientRegistered([select Id from case limit 1].Id, 'Muvhuso', 'E', 'E', 'absa@absa.co.za', '');
            System.assertNotEquals(null, response);
            Test.stopTest();
    }
          
    
}
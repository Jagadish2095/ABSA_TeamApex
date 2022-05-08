@isTest
public class TravelNoticeControllerTest {
	@isTest 
    public static void validatesgetProductsPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'AATTORN003'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE
        });

        Test.startTest();
        String respose = TravelNoticeController.getAccountDetails(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
    @isTest 
    public static void validatesgetTravelEnquiryPositive(){
       
        Test.setMock(HttpCalloutMock.class, new nHenquiryPauseCardV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NHENQUIRYPAUSECARDV1_STRING
        });

        Test.startTest();
        
        String responseBean = TravelNoticeController.getTravelEnquiry('4047404906', 'E', 'READ', '04483870000020440');
        System.assertNotEquals(null, responseBean);
        
        Test.stopTest();    
    }
    @isTest 
    public static void validatesgetTravelEnquiryNegative(){
       

        Test.startTest();
        
        String responseBean = TravelNoticeController.getTravelEnquiry('4047404906', null, 'READ', '04483870000020440');
        System.assertEquals(null, responseBean);
        
        Test.stopTest();    
    }
     @isTest 
    public static void validatesupdateTravelNoticePositive(){
        
        
        Test.setMock(HttpCalloutMock.class, new nHupdatePauseCardV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NHUPDATEPAUSECARDV1_STRING
        });

        Test.startTest();
        
        String responseBean = TravelNoticeController.updateTravelNotice('4047404906', 'Y', 'N', 'N', 'Y', 'Y', 'N', 'N', '2020-5-28', 'E', 'UPDT', '04483870000020440');
        System.assertNotEquals(null, responseBean);
        
        Test.stopTest();    
    }
     @isTest 
    public static void validatesupdateTravelNoticeNegative(){
      
        Test.startTest();
        
        String responseBean = TravelNoticeController.updateTravelNotice('4047404906', null, 'N', 'N', 'Y', 'Y', 'N', 'N', '2020-5-28', 'E', 'UPDT', '04483870000020440');
        System.assertEquals(null, responseBean);
        
        Test.stopTest();    
    }
    
    @isTest //RN - Need this as the ConnectAPI is called in the casetriggerfunctions 
    public static void testSendEmail() {
        
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account account = new Account(Name = 'Test Account');
        insert account;
		Contact con = new Contact();
        con.AccountId = account.id;
        con.LastName = 'testNatis';
        con.FirstName = 'NatisTest';
        con.Email = 'Natis@test.co.za';
        
        insert con;
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = account.Id,
                                Email__c = 'Natis@test.co.za',
                               	recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                               	Type__c = 'abc',
                                Out_Of_SLA_Comments__c = 'Test',
                           		Out_Of_SLA_Reason__c = 'Account Closed',
                                Bypass_Validation_Rules__c = true);
        
        insert caseRec;
        
       
        String emailAddress = 'Natis@test.co.za';
        
        Test.startTest();
        
        String response =  TravelNoticeController.sendEmail(emailAddress, caseRec.Id);
		System.assertNotEquals(null, response);
        Test.stopTest();

    }
    
    
}
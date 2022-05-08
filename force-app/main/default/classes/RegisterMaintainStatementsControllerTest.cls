@isTest
public class RegisterMaintainStatementsControllerTest {
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
        String respose = RegisterMaintainStatementsController.getAccountDetails(ac.Id);
        //system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
    @isTest 
    public static void validatesRegisterMaintainStatementsPositive(){
       
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new EImaintainESDDetailsV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.EI_maintain_ESD_DetailsV3
        });

        Test.startTest();
        String respose = RegisterMaintainStatementsController.registerMantain('E', '4051212002', 'CQ', 'muvhuso.nekhubvi@absa.africa');
        //system.assertNotEquals(null, respose);
        Test.stopTest();
    }
}
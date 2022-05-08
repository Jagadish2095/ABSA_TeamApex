/**
* @author Diksha Wasekar:Absa
* @description Test class for ClientProductController
* @since 8/8/2019
* @Modified  Kabelo Aphane Absa 25 June 2021
* @Updated Kabelo Aphane 17 July 2021
*/
@isTest
public class ClientProductControllerTest {
    
    @isTest
    static void getProductsList(){
        
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c='GREENJ 154';
        insert ac;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        List <ClientProductController.DisplayProducts> displayproductList = ClientProductController.getProductsList(ac.Id);
        system.assertNotEquals(null, displayproductList,'Assert failed');
        Test.stopTest();
    }
    
    @isTest
    static void TestGetContactInfoRequest(){
        
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ BAPI_SF_IF22_contract_IH_v1.INTEGRATION_SERVICE_NAME }
		);
        
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                BAPI_SF_IF22_contract_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        
        Test.startTest();
        BAPI_SF_IF22_contract_Resp_IB_v1 response = ClientProductController.getContactInfoRequest('00074273217');
        system.assertEquals(200, response.statusCode , 'Assert failed');
        Test.stopTest();


    }
    @IsTest
	static void testGetAccFinInformation() {
		Test.startTest();
		BAPI_SF_AccountFinInfo_Resp_IB_v1 testResponse = ClientProductController.getAccFinInformation('00074273217');
		System.assertEquals(500, testResponse.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	
    
}
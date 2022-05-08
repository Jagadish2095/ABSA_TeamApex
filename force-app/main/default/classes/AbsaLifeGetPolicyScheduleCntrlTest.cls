/**
 * @description Test Controller for the Absa Life Send Policy Schedule
 * @author Bhanumurty Rayala
 * @created 2021-10-25
 */

@isTest
public class AbsaLifeGetPolicyScheduleCntrlTest {
    
    @testSetup
	static void dataCreation() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ PolicyLoadByRefNo_IH_v1.INTEGRATION_SERVICE_NAME });
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ AbsaLifeGetPolicySchedule_IH_v1.INTEGRATION_SERVICE_NAME });
	}

	@isTest
	static void testFetchPolicyDetails() {
		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String response = AbsaLifeGetPolicyScheduleCntrl.fetchPolicyDetails('6637984772');
		Test.stopTest();
        System.assert(response.StartsWith('{'), 'Assert Failed');
	}
       
    /*
     * System.LimitException: Apex heap size too large: 7251828. 
     * 
	*/
    @isTest
	static void testGetPolicyDocument() {
		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AbsaLifeGetPolicySchedule_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		AbsaLifeGetPolicySchedule_Resp_IB_v1 response = AbsaLifeGetPolicyScheduleCntrl.getPolicyDocument('6637984770');
		Test.stopTest();
        System.assertNotEquals('Successful', response.header?.response, 'Assert Failed');
	}   
    
    @isTest
	static void testSendEmail() {
        String pdfData = 'JVBERi0xLjQKJeLjz9MKMSAwIG9iago8PC9BdXRob3IoKS9DcmVhdG9yKDrRoQ6BkuXDNiRbdvs0SGvo6okO+gemThe/p4Ul3OuAvlx00G69C6OHPykvS2V5d29yZHMoKS9TdWJqZWN0KCkvVGl0bGUoKS9Qcm9kdWNlcig60aEOgZLlwzYkW3b7NEhr6OqJDvoHpk4Xv6eFJdzrgL5cdNBuvQujhzaCxpbn';
        Map<String,String> sendPolicyParams = new Map<String,String>();
        sendPolicyParams.put('clientEmail', 'test@test.com');
        sendPolicyParams.put('clientName', 'Test');
        sendPolicyParams.put('policyNumber', '6637984770');
		Test.startTest();
		String testEmail = AbsaLifeGetPolicyScheduleCntrl.sendEmail(sendPolicyParams,pdfData);
		Test.stopTest();
        System.assertNotEquals('false', testEmail, 'Assert Failed');
	}   
    
}
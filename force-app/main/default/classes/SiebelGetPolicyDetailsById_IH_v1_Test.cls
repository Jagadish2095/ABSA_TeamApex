/*
 * Request Integration Bean for SiebelGetPolicyDetailsById Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */

@isTest
public class SiebelGetPolicyDetailsById_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"Response": {"Message": {"GetPoliciesByIDResponse": {"ListOfPolicy": [{"policyNumber": "6511674871","productDesc": "Premium Insure","coverAmt": 6281850,"premium": 2074.23, "outstandingAmt": 30855.57,"itcFlag": "Y","sasriaFlag": "Y","policyStatus": "APPROVED","actionCode": "ENDORSE","sourceSystem": "PORTALMQE","endorseFlag": "N","inceptionDate": "2018-05-30","effectiveDate": "2020-05-01","renewDate": "2020-05-01"}]}},"Result": {"TransactionId": "47528876-b9ee-423f-9cd5-f4fd48b1b8e1","Code": 0,"Status": "Success","Description": "Query successful."}}}';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ SiebelGetPolicyDetailsById_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@isTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

		Test.startTest();

		SiebelGetPolicyDetailsById_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode);

		Test.stopTest();
	}

	private static SiebelGetPolicyDetailsById_Resp_IB_v1 callHandlerMethod() {
		SiebelGetPolicyDetailsById_Req_IB_v1 dummyBean = SiebelGetPolicyDetailsById_Req_IB_v1.createDummyRequest();
		SiebelGetPolicyDetailsById_Resp_IB_v1 responseBean = SiebelGetPolicyDetailsById_IH_v1.SiebelGetPolicyDetailsById(
			'SAIdentityDocument',
			dummyBean.Request.Message.GetPoliciesByIDRequest.idNumber
		);
		return responseBean;
	}
}
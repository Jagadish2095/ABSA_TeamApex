/**
 * @description       : CASAScreenPrimaryClientV7 Test class
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-09-08
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/

@isTest
public class CASAScreenPrimaryClientV7_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"Envelope":{"Body":{"GetDocsResponse":{"DocNo":"2","VersionNo":"1","msgNo":"200","msg":"Success","documentation":[{"docCode":"0001","docDesc":"Doc1"},{"docCode":"0002","docDesc":"Doc2"}]}}}}';

	@TestSetup
	static void setup() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CASAScreenPrimaryClientV7_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@isTest
	static void serviceCall() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			CASAScreenPrimaryClientV7_Req_IB_v1 CASAclass = CASAScreenPrimaryClientV7_Req_IB_v1.GetInstance();
			CASAScreenPrimaryClientV7_Resp_IB_v1 responseBean = CASAScreenPrimaryClientV7_IH_v1.CASAScreenPrimaryClientV7(CASAclass);
			System.assert(responseBean != null, 'Failed');
			Test.stopTest();
		}
	}
}
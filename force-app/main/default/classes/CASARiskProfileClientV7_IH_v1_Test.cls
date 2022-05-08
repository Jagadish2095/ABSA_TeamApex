/**
 * @description       : CASARiskProfileClientV7_IH_v1 test class
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-09-08
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/

@isTest
public class CASARiskProfileClientV7_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"Envelope":{"Body":{"GetDocsResponse":{"DocNo":"2","VersionNo":"1","msgNo":"200","msg":"Success","documentation":[{"docCode":"0001","docDesc":"Doc1"},{"docCode":"0002","docDesc":"Doc2"}]}}}}';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CASARiskProfileClientV7_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	@isTest
	public static void setup() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			CASARiskProfileClientV7_Req_IB_v1 CASAclass = CASARiskProfileClientV7_Req_IB_v1.GetInstance();
			string responseBean = CASARiskProfileClientV7_IH_v1.CASARiskProfileClientRiskStatus(CASAclass);
			System.assert(responseBean != null, 'Failed');
			Test.stopTest();
		}
	}
}
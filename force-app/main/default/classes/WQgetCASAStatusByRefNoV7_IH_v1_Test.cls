/**
 * @description       : WQgetCASAStatusByRefNoV7_IH_v1 Test class
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-09-08
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/

@isTest
public class WQgetCASAStatusByRefNoV7_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY_GetStatus = '{"WQgetCASAStatusByRefNoV7Response":{"wqp102o":{"surnameComp":"BOOTH","casaStatus":"I","pepSts":null,"msgNo":0,"msg":"INCOMPLETE-RISKP","idType":1,"idRegNo":8805240649081,"firstName":"MAYA","documentSts":"I","comments":null,"approvedSts":null},"nbsapdpo":{"version":"APLO003","serviceVersion":"BUSO001","returnCode":0,"reasonCode":0,"echoKey":null}}}';
	public static final String NULL_RESPONSE_BODY_GetStatus = '{""}';
	public static final String ErrorMessage_RESPONSE_BODY_GetStatus = '{"WQgetCASAStatusByRefNoV7Response":{"wqp102o":{"surnameComp":"BOOTH","casaStatus":"I","pepSts":null,"msgNo":10,"msg":"Service Failed","idType":1,"idRegNo":8805240649081,"firstName":"MAYA","documentSts":"I","comments":null,"approvedSts":null},"nbsapdpo":{"version":"APLO003","serviceVersion":"BUSO001","returnCode":0,"reasonCode":0,"echoKey":null}}}';

	/**
	 * @description dataCreation
	 * @author PaulJohn.duRand@absa.africa | 2021-08-06
	 **/
	@testSetup
	public static void dataCreation() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ WQgetCASAStatusByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		String accountId = TestMetaDataFactory.insertTestObject('Account', 'BranchNTPAccount');
	}

	@isTest
	public static void testCallScreening() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GetStatus));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			Account account = [SELECT CASA_Reference_Number__pc FROM Account WHERE id = :accountId LIMIT 1];
			string res = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(account.CASA_Reference_Number__pc);
			System.assert(res == 'INCOMPLETE-RISKP', 'Screening Failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void testCallScreeningNullResponse() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, NULL_RESPONSE_BODY_GetStatus));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			Account account = [SELECT CASA_Reference_Number__pc FROM Account WHERE id = :accountId LIMIT 1];
			string res = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(account.CASA_Reference_Number__pc);
			System.assert(res == 'Error : The getCASAStatusByRefNoV7 service returned an invalid response', 'Wrong null response');
			Test.stopTest();
		}
	}

	@isTest
	public static void testCallScreeningErrorMessageResponse() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, ErrorMessage_RESPONSE_BODY_GetStatus));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			Account account = [SELECT CASA_Reference_Number__pc FROM Account WHERE id = :accountId LIMIT 1];
			string res = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(account.CASA_Reference_Number__pc);
			System.assert(res == 'Error :Service Failed', 'Wrong Error Message response');
			Test.stopTest();
		}
	}
}
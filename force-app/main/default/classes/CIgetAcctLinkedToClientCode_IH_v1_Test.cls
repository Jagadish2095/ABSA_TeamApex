/**
 * @description Test Integration Handler for CIgetAcctLinkedToClientCode Service
 * @author Pitso Sekhu
 * @created 2019-03-04
 */

@isTest
public class CIgetAcctLinkedToClientCode_IH_v1_Test {
	@isTest
	static void validateAcctLinkedToClientCodePositive() {
		CIgetAcctLinkedToClientCode_Req_IB_v1 dummyBean = new CIgetAcctLinkedToClientCode_Req_IB_v1();
		dummyBean.createDummyRequest();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();

		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode('WILLS', 'GREENJ 154');
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

		Test.stopTest();
	}

	@isTest
	static void validateAcctLinkedToClientCodeNegative() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.NEGATIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode('', '');
		System.assertEquals(500, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void validateAcctLinkedToClientCodeNoIntegrationSettings() {
		// This causes a fake response to be sent from the class that implements HttpCalloutMock.
		Test.startTest();
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode('WILLS', 'GREENJ 154');
		System.assertEquals(500, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void validateAcctLinkedToClientCodeException() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode('WILLS', 'GREENJ 154');
		System.assertEquals(500, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void ciGetAcctLinkedToClientCodeWithOutInsertLogTestPositive() {
		CIgetAcctLinkedToClientCode_Req_IB_v1 dummyBean = new CIgetAcctLinkedToClientCode_Req_IB_v1();
		dummyBean.createDummyRequest();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();

		Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCodeWithOutInsertLog(
			'WILLS',
			'GREENJ 154'
		);
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = (new List<CIgetAcctLinkedToClientCode_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

		Test.stopTest();
	}

	@isTest
	static void ciGetAcctLinkedToClientCodeWithOutInsertLogTestNegative() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.NEGATIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();
		Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCodeWithOutInsertLog(
			'',
			''
		);
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = (new List<CIgetAcctLinkedToClientCode_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void ciGetAcctLinkedToClientCodeWithOutInsertLogTestNoIntegrationSettings() {
		// This causes a fake response to be sent from the class that implements HttpCalloutMock.
		Test.startTest();

		Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCodeWithOutInsertLog(
			'WILLS',
			'GREENJ 154'
		);
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = (new List<CIgetAcctLinkedToClientCode_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void ciGetAcctLinkedToClientCodeWithOutInsertLogTestException() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();
		Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCodeWithOutInsertLog(
			'WILLS',
			'GREENJ 154'
		);
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = (new List<CIgetAcctLinkedToClientCode_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}
}
/*
 * Test Integration Handler for ExergyChangeBankInformation Service
 * @author Humbelani Denge
 * @created 2021-02-17
 * Updated by Koketso Mpshane - 05-03-21
 */

@isTest
public class ExergyChangeBankInformation_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ExergyChangeBankInformation';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ExergyChangeBankInformation_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@IsTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		ExergyChangeBankInformation_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

		Test.stopTest();
	}

	private static ExergyChangeBankInformation_Resp_IB_v1 callHandlerMethod() {
		ExergyChangeBankInformation_Req_IB_v1 dummyBean = ExergyChangeBankInformation_Req_IB_v1.createDummyRequest();
		ExergyChangeBankInformation_Resp_IB_v1 responseBean = ExergyChangeBankInformation_IH_v1.ExergyChangeBankInformation(
			dummyBean.Contract_ChangeBankInformation.pstrPolicyNumber,
			dummyBean.Contract_ChangeBankInformation.pobjBankContract.AccountName,
			dummyBean.Contract_ChangeBankInformation.pobjBankContract.AccountNo,
			dummyBean.Contract_ChangeBankInformation.pobjBankContract.AccountTypeID,
			dummyBean.Contract_ChangeBankInformation.pobjBankContract.BankBranchID,
			dummyBean.Contract_ChangeBankInformation.pobjBankContract.BankID,
			dummyBean.Contract_ChangeBankInformation.pintDayofPayment,
			dummyBean.Contract_ChangeBankInformation.pintSourceofFundsID
		);
		return responseBean;
	}
}
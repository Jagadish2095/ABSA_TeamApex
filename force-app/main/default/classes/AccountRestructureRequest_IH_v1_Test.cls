/**
 * @description       : 
 * @author            : Mradul Maheshwari
 * @last modified on  : 08-23-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-005674
**/
@isTest
public with sharing class AccountRestructureRequest_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AccountRestructureRequest_v1';

     @TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
               StringConstants.JITTERBIT2,
               new List<String>{ AccountRestructureRequest_IH_v1.INTEGRATION_SERVICE_NAME }
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

		AccountRestructureRequest_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert Passed');

		Test.stopTest();
	}

     private static AccountRestructureRequest_Resp_IB_v1 callHandlerMethod() {
		AccountRestructureRequest_Req_IB_v1 dummyBean = AccountRestructureRequest_Req_IB_v1.createDummyRequest();
		AccountRestructureRequest_Resp_IB_v1 responseBean = AccountRestructureRequest_IH_v1.accountRestructureRequest(
            dummyBean.accountNumber,
            dummyBean.advanceAmount, 
            dummyBean.restructureOption, 
            dummyBean.email,
            dummyBean.consent, 
            dummyBean.newInstallment, 
            dummyBean.newCalculatedInstallmentsNo, 
            dummyBean.newTerm,
            dummyBean.newContractEndDate, 
            dummyBean.newResidualAmount
		);
		return responseBean;
	}
}
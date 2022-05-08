/**
 * @description       : 
 * @author            : Mradul Maheshwari
 * @last modified on  : 08-23-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-005674
**/
@isTest
public with sharing class CalculatorRequest_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_CalculatorRequest_v1';

     @TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
               StringConstants.JITTERBIT2,
               new List<String>{ CalculatorRequest_IH_v1.INTEGRATION_SERVICE_NAME }
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

		CalculatorRequest_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert Passed');

		Test.stopTest();
	}

     private static CalculatorRequest_Resp_IB_v1 callHandlerMethod() {
		CalculatorRequest_Req_IB_v1 dummyBean = CalculatorRequest_Req_IB_v1.createDummyRequest();
		CalculatorRequest_Resp_IB_v1 responseBean = CalculatorRequest_IH_v1.calculatorRequest(
			dummyBean.accountNumber,
			dummyBean.advanceAmount
		);
		return responseBean;
	}

}
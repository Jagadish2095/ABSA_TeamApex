/**
 * @description       : 
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
@isTest

public with sharing class XDSSubmitQuestions_IH_v2_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_NEGATIVE_BLOCKED = 'Mock_Negative_AlreadyProcessed_SubmitXDSQuestions_v2';	

    @isTest
    public static void testSubmitXdsQuestions() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'SubmitXDSQuestionsV2'});
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_NEGATIVE_BLOCKED)
		);

		Test.startTest();

		XDSSubmitQuestions_Resp_IB_v2 responseBean = callHandlerMethod();

		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}
	/**
	 * @description Method to callHandlerMethod
	 * @return XDSGetQuetions_Resp_IB_v2
	 */
	private static XDSSubmitQuestions_Resp_IB_v2 callHandlerMethod() {
		XDSSubmitQuestions_Req_IB_v2 dummyBean = XDSSubmitQuestions_Req_IB_v2.createDummyRequest();
		XDSSubmitQuestions_Resp_IB_v2 responseBean = XDSSubmitQuestions_IH_v2.xdsSubmitQuestions(dummyBean);

		return responseBean;
	}


}
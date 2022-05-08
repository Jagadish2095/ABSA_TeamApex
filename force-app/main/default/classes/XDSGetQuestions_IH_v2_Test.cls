/**
 * @description       : XDS 2.3 handler test
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Koketso Mpshane
**/
@isTest

public  class XDSGetQuestions_IH_v2_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_NEGATIVE_BLOCKED = 'Mock_Negative_Blocked_GetXDSQuestions_v2';
	
    @isTest
    public static void testGetXdsQuestions() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'GetXDSQuestions'});
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_NEGATIVE_BLOCKED)
		);

		Test.startTest();

		XDSGetQuetions_Resp_IB_v2 responseBean = callHandlerMethod();

		System.assertEquals(200, responseBean.statusCode, 'Assert failed');        

		Test.stopTest();
	}
    
    @isTest
    public static void testAnswerDocument() {
        
		Test.startTest();

		XDSGetQuetions_Resp_IB_v2.AnswerDocument xdsAnswerDoc = new XDSGetQuetions_Resp_IB_v2.AnswerDocument();

		System.assertEquals(null, xdsAnswerDoc.answerIdString, 'Assert failed');
        

		Test.stopTest();
	}
	/**
	 * @description Method to callHandlerMethod
	 * @return XDSGetQuetions_Resp_IB_v2
	 */
	private static XDSGetQuetions_Resp_IB_v2 callHandlerMethod() {
		XDSGetQuetions_Req_IB_v2 dummyBean = XDSGetQuetions_Req_IB_v2.createDummyRequest();
		XDSGetQuetions_Resp_IB_v2 responseBean = XDSGetQuestions_IH_v2.getXDSQuestions(
			dummyBean.cellularNo,
			dummyBean.idNumber,
			dummyBean.passportNo
		);
      
		return responseBean;
	}
}
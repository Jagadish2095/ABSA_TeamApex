/*
 * Request Integration Bean for ExergyPolicyGetCover Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */
 
 
	@isTest
	public class ExergyPolicyGetCover_IH_v1_Test {

        public static final String POSITIVE_RESPONSE_BODY = '{"Envelope":{"Body": {"ResponseHeader": {"TransId": "ea6f7ab9-00b8-4d25-a20c-a66d5864745e","SourceTransId": "?","Result": {"code": "200","status": "Success","message": "Successfully invoked exergy service"}},"ResponseMessage": {"ActivityId": "00000000-0000-0000-0000-000000000000","Policy_GetClientExposureExergyResponse": {"Policy_GetClientExposureExergyResult": {"TotalCover": "0","TotalCoverAvailable": "100000","ValidationMessage": "Client not found on both systems"},"pstrValidationMessage": "Client not found on both systems"},"Fault": {"faultcode": null,"faultstring": null,"detail": {"ExceptionDetail": {"HelpLink": null,"InnerException": {"HelpLink": null,"Message": null,"StackTrace": null,"Type": null},"Message": null,"StackTrace": null,"Type": null}}}}}}}';
		
    	@TestSetup
    	static void makeData(){
        	IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ExergyPolicyGetCover_IH_v1.INTEGRATION_SERVICE_NAME});
    	}

    	@isTest static void testPositive() {
        	// Set mock callout class
        	

        	Test.startTest();
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        	ExergyPolicyGetCover_Resp_IB_v1 responseBean = callHandlerMethod();
        	System.assertEquals(200, responseBean.statusCode);

        	Test.stopTest();
    	}

    	private static ExergyPolicyGetCover_Resp_IB_v1 callHandlerMethod() {
        	ExergyPolicyGetCover_Req_IB_v1 dummyBean = ExergyPolicyGetCover_Req_IB_v1.createDummyRequest();
        	ExergyPolicyGetCover_Resp_IB_v1 responseBean = ExergyPolicyGetCover_IH_v1.ExergyPolicyGetCover('1',dummyBean.Service.RequestMessage.Policy_GetClientExposureExergy.pstrIdentifier);
        	return responseBean;
    	}
	}
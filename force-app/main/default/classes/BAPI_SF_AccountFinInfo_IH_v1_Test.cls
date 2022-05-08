/**
* @description Integartion handler test for BAPI_SF_AccountFinInfo_IH_v1 class
* @author Bhanumurty Rayala
* @created 2021-06-08
*/
@isTest
public class BAPI_SF_AccountFinInfo_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_BAPI_SF_AccountFinInfo_v1';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ BAPI_SF_AccountFinInfo_IH_v1.INTEGRATION_SERVICE_NAME }
		);
    }
    @isTest
    static void accountFinancialInformationTest(){
        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);
        Test.startTest();
        BAPI_SF_AccountFinInfo_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
    }

    private static BAPI_SF_AccountFinInfo_Resp_IB_v1 callHandlerMethod() {
		BAPI_SF_AccountFinInfo_Req_IB_v1 dummyBean = BAPI_SF_AccountFinInfo_Req_IB_v1.createDummyRequest();
		BAPI_SF_AccountFinInfo_Resp_IB_v1 responseBean = BAPI_SF_AccountFinInfo_IH_v1.accountFinancialInformation(
			dummyBean.BAPI_SF_IF42.I_ACCOUNT,
			dummyBean.BAPI_SF_IF42.I_USER
		);
		return responseBean;
	}
}
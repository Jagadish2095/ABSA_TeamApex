/**
* @description Test class for FPCustomerSmsCntrl
* @author Jagadish Thummala
* @created on 2022-04-06
*/
@IsTest
public with sharing class FPCustomerSmsCntrl_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GBlistCommentsV1';

    @TestSetup
    static void makeData(){

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ GBlistCommentsV1_IH_v1.INTEGRATION_SERVICE_NAME }
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

        GBlistCommentsV1_Resp_IB_V1 responseBean = FPCustomerSmsCntrl.getSmsDetails('XI JINPING','20220316');

		System.assertEquals(200, responseBean.statusCode, 'Assert failed');


        Test.stopTest();
    }
}
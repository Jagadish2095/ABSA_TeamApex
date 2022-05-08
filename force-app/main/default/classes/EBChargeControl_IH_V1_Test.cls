/**
 * @description Test class Everyday Banking Charge Control Services
 * @author  Koketso Mpshane
 * @date    19/08/2021
 */
@isTest
public class EBChargeControl_IH_V1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_EBChargeControl_v1';
	/**
	 * @description Method to create test data
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBChargeControl_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	/**
	 * @description Method to testEBChargeControl
	 */
	@IsTest
	static void testEBChargeControl() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		EBChargeControl_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}
	/**
	 * @description Method to callHandlerMethod
	 * @return EBChargeControl_Resp_IB_v1
	 */
	private static EBChargeControl_Resp_IB_v1 callHandlerMethod() {
		List<Charge_Control__c> records = ChargeControlTestDataFactory.chargeControlRecords();
        
		EBChargeControl_Resp_IB_v1 responseBean = EBChargeControl_IH_v1.ChargeControl(records);

		return responseBean;
	}

}
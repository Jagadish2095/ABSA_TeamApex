/**
 * @description Test class for EBChargeControlProcessSchedule
 * @author  Koketso Mpshane
 * @date    25/08/2021
 */
@isTest
public class EBChargeControlProcessScheduleTest {
    
    /**
	 * @description Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		ChargeControlTestDataFactory.chargeControlRecords();
        
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBChargeControl_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	/**
	 * @description method to test sendChargeControlProcessErrors
	 */
    @isTest
	static void testChargeControlProcessErrors() {
		List<Messaging.SendEmailResult> results;
		
        Test.startTest();
        
        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, EBChargeControl_IH_V1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);
        
		EBChargeControlProcessSchedule instance = new EBChargeControlProcessSchedule();

		String cronExp = '0 0 23 * * ?';
		System.schedule('Test EBChargeControlProcessSchedule', cronExp, instance);
		results = EBChargeControlProcessSchedule.sendChargeControlProcessErrors('Test');
		Test.stopTest();

		System.assert(results[0].isSuccess(), 'Assert Failed');
	}

}
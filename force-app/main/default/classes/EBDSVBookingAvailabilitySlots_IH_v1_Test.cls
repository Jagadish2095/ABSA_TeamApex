/**
 * @description Test Integration Handler for EBDSVBookingAvailabilitySlots Service
 * @author Bhanumurty Rayala.
 * @created 2021-03-25
 */
@isTest
public class EBDSVBookingAvailabilitySlots_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'EBDSVBookingAvailabilitySlots_Mock_Positive_v1';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBDSVBookingAvailabilitySlots_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		Integration_Translation__c townCode = new Integration_Translation__c();
        townCode.Name = 'CAPE TOWN';
        townCode.Internal_Value__c = 'CAPE TOWN';
        townCode.External_Value__c = 'CPT';
        townCode.System_Name__c = 'DSV';
        townCode.Value_Type__c = 'Town';
        townCode.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		insert townCode;
	}
	@isTest
	static void testBookingAvailSlotsGet() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		String townCode = 'CAPE TOWN';
		String suburbName = 'ROSEBANK';
		String clientName = 'MR J NORMANDY';
		String clientIDPassport = '8108269811082';
		String searchRefValue = '10/03AVLA110013';

		EBDSVBookingAvailabilitySlots_Resp_IB_v1 responseBean = EBDSVBookingAvailabilitySlots_IH_v1.bookingAvailSlotsGet(
			townCode,
			suburbName,
			clientName,
			clientIDPassport,
			searchRefValue
		);
		System.assertEquals(200, responseBean.StatusCode, 'Assert Failed');
		Test.stopTest();
	}
}
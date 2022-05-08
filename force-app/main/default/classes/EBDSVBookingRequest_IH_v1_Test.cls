/**
 * @description Test Integration Handler for EBDSVBookingRequest Service
 * @author Bhanumurty Rayala
 * @created 2021-03-26
 */
@isTest
public class EBDSVBookingRequest_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'EBDSVBookingRequest_Mock_Positive_v1';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBDSVBookingRequest_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		List<Integration_Translation__c> integrationTrsalationList = new List<Integration_Translation__c>();
		Integration_Translation__c country = new Integration_Translation__c();
        country.Name = 'South Africa';
        country.Internal_Value__c = 'South Africa';
        country.External_Value__c = 'ZAF';
        country.System_Name__c = 'DSV';
        country.Value_Type__c = 'Country';
        country.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		integrationTrsalationList.add(country);

		Integration_Translation__c province = new Integration_Translation__c();
        province.Name = 'Western Cape';
        province.Internal_Value__c = 'Western Cape';
        province.External_Value__c = '9';
        province.System_Name__c = 'DSV';
        province.Value_Type__c = 'Province';
        province.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		integrationTrsalationList.add(province);
		insert integrationTrsalationList;
	}
	@isTest
	static void testBookingRequestGet() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);
		Test.startTest();
		String deliveryTownCode = 'CAPE TOWN';
		String deliverySuburb = 'Vredehoek';
		String clientName = 'MR J NORMANDY';
		String clientIDPassport = '8108269811082';
		String clientContactNo = '0830000000';
		String clientDelivery1 = '90 OWL STREET';
		String clientDelivery2 = 'Vredehoek';
		String clientDelivery3 = 'Cape Town';
		String referenceValue = '10/03AVLA110022';
		String productCode = 'AMBB';
		String deliveryPostalCode = '8001';
		String deliveryCountryCode = 'South Africa';
		String deliveryDateTime = '2021-04-14';
		String tripSheetID = 'M8RH300M023103202106000';
		String tripServiceTime = '9:00AM -  1:00PM';
		String notificationCellNo = '0830000000';
		String clientSpecialInstructions = '0';
		Integer deliveryType = 1;
		String deliveryProvinceCode = 'Western Cape';
		String bookedBy = 'Asanda Mandla';
		EBDSVBookingRequest_Resp_IB_v1 responseBean = EBDSVBookingRequest_IH_v1.bookingRequestGet(
			deliveryTownCode,
			deliverySuburb,
			clientName,
			clientIDPassport,
			clientContactNo,
			clientDelivery1,
			clientDelivery2,
			clientDelivery3,
			referenceValue,
			productCode,
			deliveryPostalCode,
			deliveryCountryCode,
			deliveryDateTime,
			tripSheetID,
			tripServiceTime,
			notificationCellNo,
			clientSpecialInstructions,
			deliveryType,
			deliveryProvinceCode,
			bookedBy
		);
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}
}
/**
 * @description Test class for EBDSVCardDeliveryDetails component
 * @author Jason Quevauvilliers
 * @created 2021-03-26
 * @modified 2021-05-07
 */
@IsTest
public class EBDSVCardDeliveryDetailsControllerTest {
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CClistCardSummaryTrackingInfo_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		Account account = new Account();
		account.Name = 'Test Account';
		insert account;
		Address__c address = new Address__c();
		address.Account__c = account.Id;
		address.Shipping_Street__c = '90 ABSA road';
		insert address;

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

		Integration_Translation__c townCode = new Integration_Translation__c();
        townCode.Name = 'CAPE TOWN';
        townCode.Internal_Value__c = 'CAPE TOWN';
        townCode.External_Value__c = 'CPT';
        townCode.System_Name__c = 'DSV';
        townCode.Value_Type__c = 'Town';
        townCode.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		integrationTrsalationList.add(townCode);
		insert integrationTrsalationList;
	}
    
    @isTest
    static void testGetCardDeliveryDetails() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                CClistCardSummaryTrackingInfo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        
        CClistCardSummaryTrackingInfo_Req_IB_v1 req = CClistCardSummaryTrackingInfo_Req_IB_v1.createDummyRequest();
        
        Test.startTest();
        List<EBDSVCardDeliveryDetailsController.CardDetails> cardDetailList = EBDSVCardDeliveryDetailsController.getCardDeliveryDetails(
            req.CClistCardSummaryTrackingInfoV2.ccp401i.clientCode
        );
        System.assertEquals(1, cardDetailList.size(), 'Assert Failed');
        Test.stopTest();
    }

	@isTest
	static void testGetAccountAddress() {
		Test.startTest();
		Account acc = [SELECT Id FROM Account LIMIT 1];
		String accid = acc.Id;
		List<Address__c> addLists = EBDSVCardDeliveryDetailsController.getAccountAddress(accid);
		System.assertEquals(true, addLists.size()>0, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testBookingAvailSlots() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBDSVBookingAvailabilitySlots_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		//Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				EBDSVBookingAvailabilitySlots_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String townCode = 'CAPE TOWN';
		String suburbName = 'ROSEBANK';
		String clientName = 'MR J NORMANDY';
		String clientIDPassport = '8108269811082';
		String searchRefValue = '10/03AVLA110013';
		Test.startTest();
		String testBean = EBDSVCardDeliveryDetailsController.bookingAvailSlots(townCode, suburbName, clientName, clientIDPassport, searchRefValue);
		Boolean result = String.isBlank(testBean);
		System.assertEquals(false, result, 'Assert failed');
		Test.stopTest();
	}

	@isTest
	static void testGetDateTimeData() {
		String jsonStr = '{"Successful": "Y","ErrorMessages": [], "BookingAvailabilitySlots":  [  {"ServiceDate": "2021-05-14T00:00:00","ServiceTime": "8:00AM -  1:00PM"},{"ServiceDate": "2021-08-14T00:00:00","ServiceTime": "9:00AM -  12:00PM"},{"ServiceDate": "2021-05-14T00:00:00","ServiceTime": "12:00AM -  1:00PM"}],"ServiceDays":[{"Version": "01112017","Mon": "Y"}]}';

		Test.startTest();
		Map<String, List<String>> testBean = EBDSVCardDeliveryDetailsController.getDateTimeData(jsonStr);
		System.assertEquals(true, testBean.size()>0, 'Assert failed');
		Test.stopTest();
	}

	@isTest
	static void testBookingRequest() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBDSVBookingRequest_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		//Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				EBDSVBookingRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		String deliveryTownCode = 'CPT';
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
		String deliveryDateTime = '2021-04-13';
		String tripSheetID = 'M8RH300M023103202106000';
		String tripServiceTime = '9:00AM -  1:00PM';
		String notificationCellNo = '0830000000';
		String clientSpecialInstructions = '0';
		Integer deliveryType = 1;
		String deliveryProvinceCode = 'Western Cape';
		Test.startTest();
		EBDSVBookingRequest_Resp_IB_v1 testBean = EBDSVCardDeliveryDetailsController.bookingRequest(
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
			deliveryProvinceCode
		);
		System.assertEquals(200, testBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testReceiveInstructionArrayKnockNDrop() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBDSVReceiveInstructionArray_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		//Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				EBDSVReceiveInstructionArray_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String branchCode = ''; //'008913';
		String cardIssueType = 'D';
		String cellNumber = '0832342345';
		String idPassportNumber = '92061704383083';
		String operatorName = 'MR J NORMANDY';
		Integer noOfItems = 1;
		String secureItemNo = '10/03AVLA110012';
		String stockType = 'AVLA'; //'AMBB';
		String deliveryAddress1 = '90 ORANGE ROAD';
		String deliveryAddress2 = 'Abcd';
		String deliveryTown = 'CAPE TOWN';
		String deliverySuburb = 'Rosebank';
		String postalCode = '8001';
        String altNumber = '1234567890';
     	String splInstruction = 'Test Instruction';
		Test.startTest();
		EBDSVReceiveInstructionArray_Resp_IB_v1 testBean = EBDSVCardDeliveryDetailsController.receiveInstructionArray(
			branchCode,
			cardIssueType,
			cellNumber,
			idPassportNumber,
			operatorName,
			noOfItems,
			secureItemNo,
			stockType,
			deliveryAddress1,
			deliveryAddress2,
			deliveryTown,
			deliverySuburb,
			postalCode,
            altNumber,
            splInstruction
		);
		System.assertEquals(200, testBean.statusCode, 'Assert failed');
		Test.stopTest();
	}

	@isTest
	static void testReceiveInstructionArrayBranch() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBDSVReceiveInstructionArray_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		//Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				EBDSVReceiveInstructionArray_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String branchCode = '008913';
		String cardIssueType = 'D';
		String cellNumber = '0832342345';
		String idPassportNumber = '92061704383083';
		String operatorName = 'MR J NORMANDY';
		Integer noOfItems = 1;
		String secureItemNo = '10/03AVLA110012';
		String stockType = 'AVLA';
		String deliveryAddress1 = '';
		String deliveryAddress2 = '';
		String deliveryTown = '';
		String deliverySuburb = '';
		String postalCode = '';
        String altNumber = '';
     	String splInstruction = '';
		Test.startTest();
		EBDSVReceiveInstructionArray_Resp_IB_v1 testBean = EBDSVCardDeliveryDetailsController.receiveInstructionArray(
			branchCode,
			cardIssueType,
			cellNumber,
			idPassportNumber,
			operatorName,
			noOfItems,
			secureItemNo,
			stockType,
			deliveryAddress1,
			deliveryAddress2,
			deliveryTown,
			deliverySuburb,
			postalCode,
            altNumber,
            splInstruction
		);
		System.assertEquals(200, testBean.statusCode, 'Assert failed');
		Test.stopTest();
	}

	@isTest
	static void testSendEmailUrgentDelivery() {
        Map<String,String> testMap = new Map<String,String>();
        testMap.put('perName', 'MR J NORMANDY');
        testMap.put('refValue', '10/03AVLA110013');
        testMap.put('deliv1', '90 OWL STREET');
        testMap.put('deliv2', 'KING ROAD');
        testMap.put('suburb', 'BRUNSWICK');
        testMap.put('town', 'CAPE TOWN');
        testMap.put('province', 'WESTERN CAPE');
        testMap.put('country', 'SOUTH AFRICA');
        testMap.put('postcode', '8001');
        testMap.put('urgentDeliveryEmail', 'abc@example.com;abc2@example.com');
        testMap.put('splInstruction', '0');
		
		Test.startTest();
		String testMail = EBDSVCardDeliveryDetailsController.sendEmailUrgentDelivery(testMap);
		System.assertEquals('true', testMail, 'Assert Failed');
		Test.stopTest();
		
	}
}
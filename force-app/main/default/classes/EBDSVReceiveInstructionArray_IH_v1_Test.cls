@isTest
public class EBDSVReceiveInstructionArray_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'EBDSVReceiveInstructionArray_Mock_Positive_v1';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ EBDSVReceiveInstructionArray_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();
	}

	@isTest
	static void testDummyPositive() {
		EBDSVReceiveInstructionArray_Req_IB_v1 dummyBean = EBDSVReceiveInstructionArray_Req_IB_v1.createDummy();
		System.assertNotEquals(null, dummyBean, 'Assert Failed');
	}

	@isTest
	static void testReceiveInstructionArray() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);
		Test.startTest();
		String branchCode = '008913';
		String cardIssueType = 'D';
		String cellNumber = '0832342345';
		String idPassportNumber = '92061704383083';
		String operatorName = 'MR J NORMANDY';
		Integer noOfItems = 1;
		String secureItemNo = '10/03AVLA110012';
		String stockType = 'AMBB';
		String deliveryAddress1 = '90 ORANGE ROAD';
		String deliveryAddress2 = 'Abcd';
		String deliveryTown = 'CAPE TOWN';
		String deliverySuburb = 'Rosebank';
		String postalCode = '8001';
		String deliveryType = 'K';
        String altNumber = '1234567890';
     	String splInstruction = 'Test Instruction';
		EBDSVReceiveInstructionArray_Resp_IB_v1 responseBean = EBDSVReceiveInstructionArray_IH_v1.receiveInstructionArray(
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
			deliveryType,
            altNumber,
            splInstruction
		);
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}
}
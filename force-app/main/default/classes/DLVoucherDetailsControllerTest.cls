/**
 * @description Test class for DLVoucherDetailsController
 * @author Jason Quevauvilliers
 * @created 2021-03-31
 */
@IsTest
public class DLVoucherDetailsControllerTest {
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ DLGetExceptionReport_IH_v1.INTEGRATION_SERVICE_NAME, DLGetPaymentHistoryForCustomer_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		Case newCase = new Case();
		insert newCase;
	}

	@isTest
	static void testGetVoucherDetails() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				DLGetPaymentHistoryForCustomer_IH_v1Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		DLGetPaymentHistoryForCustomer_Req_IB_v1 req = DLGetPaymentHistoryForCustomer_Req_IB_v1.createDummyRequest();

		Test.startTest();
		DLGetPaymentHistoryForCustomer_Resp_IBv1 response = DLVoucherDetailsController.getVoucherDetails(req.cifKey, req.idNumber);
		System.assertEquals(2, response.paymentHistoryList.size(), 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testGetExceptionReport() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				DLGetExceptionReport_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		DLGetExceptionReport_Req_IB_v1 req = DLGetExceptionReport_Req_IB_v1.createDummyRequest();

		Test.startTest();
		List<DLGetExceptionReport_Resp_IB_v1.CustomerDigitalLifestyleException_cls> exceptionList = DLVoucherDetailsController.getExceptionReport(req.cifKey);
		System.assertEquals(2, exceptionList.size(), 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testAttachVouchersToCase() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				DLGetPaymentHistoryForCustomer_IH_v1Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		String voucherList = '[{"paymentReference":"qwert98765","dateCreated":"2021-02-01","dateModified":"2021-02-01","voucherDescription":"PlayStation Wallet Top Up R200","voucherPaymentAmount":"100","sourceAccountNumber":"4047562205","transactionStatus":"PAYMENT_SUCCESSFUL","exceptionMessage":"","voucherExpiryDate":"2024-02-01"},{"paymentReference":"poiuy12345","dateCreated":"2021-02-05","dateModified":"2021-02-05","voucherDescription":"Mock - Digital (Non Void)","voucherPaymentAmount":"250","sourceAccountNumber":"4047562205","transactionStatus":"PAYMENT_SUCCESSFUL","exceptionMessage":"","voucherExpiryDate":"2024-02-05"}]';
		Case newCase = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		String response = DLVoucherDetailsController.attachVouchersToCase(newCase.Id, voucherList);
		System.assertEquals('SUCCESS', response, 'Assert Failed');
		Test.stopTest();
	}
}
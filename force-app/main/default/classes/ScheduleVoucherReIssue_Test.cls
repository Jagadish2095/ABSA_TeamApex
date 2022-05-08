/** 
 * @description Test Integration Handler for GetAvailableVouchers Service
 * @author Simangaliso Mathenjwa.
 * @since 29 November 2021
 */
@IsTest
public class ScheduleVoucherReIssue_Test {

    @IsTest
	public static void ScheduleVoucherReIssueTest() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ReIssueVoucher';
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ReIssueVoucher_IH_IB_v1.INTEGRATION_SERVICE_NAME}
		);

        Map<String, String> requestFieldsMap = new Map<String, String>();
		requestFieldsMap.put('txnReference', '344aecf2-95a0-48bc-9e32-504e6fc127ac');
		requestFieldsMap.put('cifKey', 'MADIDNJ001');
		requestFieldsMap.put('idNumber', '9101265784089');
		requestFieldsMap.put('partnerId', 'GI50');
		requestFieldsMap.put('offerTier', 'Bronze');
		requestFieldsMap.put('oldRewardPinVoucher', '****XCMHYADP');
		requestFieldsMap.put('challengeId', 'X.101');

        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        String hour = String.valueOf(Datetime.now().addHours(2).hour());
		String min = String.valueOf(Datetime.now().minute());
		String ss = String.valueOf(Datetime.now().second());

		//parse to cron expression
		String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
		ScheduleVoucherReIssue reissueVoucher = new ScheduleVoucherReIssue(requestFieldsMap);
        Test.startTest();
		
		String jobId = System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, reissueVoucher);
        //reissueVoucher.execute(null);
        //lreissueVoucher.finish(null);
		System.assertNotEquals(null, jobId, 'Assert Failed');
		Test.stopTest();
    }
    
}
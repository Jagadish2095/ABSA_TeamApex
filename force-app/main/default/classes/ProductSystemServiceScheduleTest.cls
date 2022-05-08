/**
 * @description       : ProductSystemServiceScheduleTest
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-09-10
 * @last modified by  : André Pietersen (IQ Business)
 **/
@isTest
public class ProductSystemServiceScheduleTest {
	public static final String POSITIVE_RESPONSE_BODY_REWARDS = '{"GetLookupsResponse":{"GetLookupsResult":{"DebitOrderAmounts":{"NonStaffAnnualFee":278.4,"NonStaffMonthlyFee":23.2,"StaffAnnualFee":139.2,"StaffMonthlyFee":11.6},"Languages":{"Language":[{"Code":"CLAAFR","Description":"Afrikaans"},{"Code":"CLAENG","Description":"English"},{"Code":"CLANDE","Description":"Ndebele"},{"Code":"CLANSO","Description":"North Sotho"},{"Code":"CLAOTH","Description":"Other"},{"Code":"CLASSO","Description":"South Sotho"},{"Code":"CLASWA","Description":"Swazi"},{"Code":"CLATSO","Description":"Tsonga"},{"Code":"CLATSW","Description":"Tswana"},{"Code":"CLAVEN","Description":"Venda"},{"Code":"CLAXHO","Description":"Xhosa"},{"Code":"CLAZUL","Description":"Zulu"}]},"MethodResponse":{"ErrorCode":"E0001","ErrorReferenceNumber":"8a558baf-223b-43b4-a21b-934bc6779dda"},"NotificationMethods":{"NotificationMethod":[{"Code":"NOMEMA","Description":"E-Mail"},{"Code":"NOMPOS","Description":"Post"},{"Code":"NOMSMS","Description":"Sms"},{"Code":"NOMTEL","Description":"Telephone"}]},"RedemptionTypes":null,"StatementNotificationMethods":{"StatementNotificationMethod":[{"Code":"NOMEMA","Description":"E-Mail"},{"Code":"NOMPOS","Description":"Post"}]}}}}';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ RewardsGetlookups_IH_v1.INTEGRATION_SERVICE_NAME });
		Product2 prod = new Product2(Name = 'Test Product', Product_System__c = 'Absa Rewards System');
		insert prod;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;
	}
	@isTest
	public static void testProductSystemServiceSchedule() {
		Test.startTest();

		// This test runs a scheduled job at midnight Sept. 3rd. 2022
		String CRON_EXP = '0 0 0 3 9 ? 2022';
		// Schedule the test job
		String jobId = System.schedule('ProductSystemServiceScheduleTest', CRON_EXP, new ProductSystemServiceSchedule());
		// Get the information from the CronTrigger API object
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		// Verify the expressions are the same System.assertEquals(CRON_EXP, ct.CronExpression);
		// Verify the job has not run
		System.assertEquals(0, ct.TimesTriggered);
		// Verify the next time the job will run
		System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
		Test.stopTest();
	}
}
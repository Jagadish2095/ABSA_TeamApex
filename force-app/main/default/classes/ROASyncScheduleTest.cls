/**
 * @description       : ROASyncScheduleTest
 * @author            : Celliers Inggs
 * @last modified on  : 2021-11-15
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-07-07   André Pietersen (IQ Business)   PMD compliance
 * 1.1   2021-11-03   André Pietersen (IQ Business)   Implemented StringBody class
 **/
@isTest
public class ROASyncScheduleTest {
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ROAQuestionAnswerService_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	
	@isTest
	static void testROASyncSchedule() {
		Test.setMock(
			HttpCalloutMock.class,
			new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, ROAQuestionAnswerService_IH_v1_Test.POSITIVE_RESPONSE_BODY)
		);
		Test.startTest();

		// This test runs a scheduled job at midnight Sept. 3rd. 2022
		String CRON_EXP = '0 0 0 3 9 ? 2022';
		// Schedule the test job
		String jobId = System.schedule('ROASyncScheduleTest', CRON_EXP, new ROASyncSchedule());
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
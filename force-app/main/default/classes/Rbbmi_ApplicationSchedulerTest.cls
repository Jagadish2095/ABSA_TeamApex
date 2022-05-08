/**
 * @description       : Rbbmi_ApplicationSchedulerTest class.
 * @author            : Rajesh
 * @last modified on  : 2021-07-14
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2020-09-23   Rajesh                 Initial Version
 **/

@isTest
public class Rbbmi_ApplicationSchedulerTest {
	public static final String POSITIVE_RESPONSE_BODY = '[{"cost_centre_desc_4":"1234","ACCOUNT_ACTIVE":"","Open_bucket":"","ACCOUNT_STATUS":"","Closed_Bucket":"","TRANSACT_READY_IND":"","Last_INActiveDays":"","CURRENT_MONTH_TURNOVER":"","DayInactive":"","DORMANT_IND":"","ClientNumber":"","CLOSE_DATE":"","NumberOfdayswithNoTransaction":"1","OPEN_DATE":"","NumDaysAccountnotactivated":"1","Product_Descr_New":"","NameofTrigger":"","CUSTOMER_KEY":"","ClientName":"","Account_Number":"13543","ClientEmail":"","INFORMATION_DATE":""}]';

	@testSetup
	static void dataCreation() {
		User u = UserTDF.addUser('System Administrator (Custom)', 'UserAdmin', 'UserAdmin@testorg.com');
		System.runAs(u) {
			List<String> serviceNameList = new List<String>();
			serviceNameList.add('rbbmi');
			Account clietnAccJoint = AccountTDF.addClient('Joint & Several', 'TEST MR JA & TEST MRS J');
			sd_Communication_Plan__c commPlan = CommunicationPlanTDF.addCommPlan('Business Banking ECM Triggers on Application');
			IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT, serviceNameList);
			Contact businessCon = ContactTDF.addBusiness('Test contact');
			businessCon.AccountId = clietnAccJoint.Id;
			businessCon.Email = 'agents@support.co.za';
			update businessCon;
			Opportunity opp = OpportunityTDF.addGeneralOpp('Test Opp Onboarding 1', 'New', Date.today(), clietnAccJoint.Id);
			Product2 prod = Product2TDF.addProduct('Cheque Product', true, 'Cheque', null);
			Id pricebookId = Test.getStandardPricebookId();
			Pricebook2 customPB = Pricebook2TDF.addPriceBook('Standard Pricebook', true);
			PricebookEntry standardPrice = PricebookEntryTDF.addPriceBookEntry(pricebookId, prod.Id, 10000, true);
			PricebookEntry customPrice = PricebookEntryTDF.addPriceBookEntry(customPB.Id, prod.Id, 12000, true);
			Application__c app = ApplicationTDF.addOnboardingApp(opp.Id);
			OpportunityLineItem oppLineItem = OpportunityLineItemTDF.addOppLineItem(opp.id, prod.id, customPrice.id, 1, 100, app.Id, '13543');
		}
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 **/
	@isTest
	static void test200() {
		User uA = new User();
		String email = 'UserAdmin@testorg.com';
		uA = UserTDF.getUser(email);
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		System.runAs(uA) {
			Rbbmi_ApplicationScheduler schedule = new Rbbmi_ApplicationScheduler();
			Rbbmi_ApplicationScheduler batch = new Rbbmi_ApplicationScheduler();
			String cronExp = '0 0 0 15 3 ? *';
			test.startTest();
			Id jobId = System.schedule('ScheduleApexClassTest', cronExp, schedule);
			Id batchId = Database.executeBatch(batch, 2000);
			CronTrigger ctbefore = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
			AsyncApexJob aajbefore = [
				SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
				FROM AsyncApexJob
				WHERE Id = :batchId
			];
			System.assertEquals('0 0 0 15 3 ? *', ctbefore.CronExpression, 'System.schedule falied');
			System.assertEquals(0, aajbefore.NumberOfErrors, 'Database.executeBatch falied');
			System.assertEquals('Queued', aajbefore.Status, 'Database.executeBatch - Status before falied');
			test.stopTest();
			Application__c testApp = [
				SELECT
					Id,
					Number_of_days_account_has_not_activated__c,
					Product_Name__c,
					Account_Number__c,
					Client_Name__c,
					Client_Number__c,
					Client_Email__c,
					sd_Response_Email_Address__c
				FROM Application__c
				WHERE OwnerId = :uA.Id
				LIMIT 1
			];
			AsyncApexJob aajAfter = [
				SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
				FROM AsyncApexJob
				WHERE Id = :batchId
			];
			System.assertEquals('Completed', aajAfter.Status, 'Database.executeBatch - Status after falied');
			System.assertEquals(0, aajAfter.NumberOfErrors, 'Database.executeBatch -NumberOfErrors falied');
			System.assertEquals(1, aajAfter.JobItemsProcessed, 'Database.executeBatch - JobItemsProcessed falied');
			System.assertEquals('13543', testApp.Account_Number__c, 'testScheduler test falied');
		}
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 **/
	@isTest
	static void test400() {
		User uA = new User();
		String email = 'UserAdmin@testorg.com';
		uA = UserTDF.getUser(email);
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null));
		System.runAs(uA) {
			Rbbmi_ApplicationScheduler schedule = new Rbbmi_ApplicationScheduler();
			Rbbmi_ApplicationScheduler batch = new Rbbmi_ApplicationScheduler();
			String cronExp = '0 0 0 15 3 ? *';
			test.startTest();
			Id jobId = System.schedule('ScheduleApexClassTest', cronExp, schedule);
			Id batchId = Database.executeBatch(batch, 2000);
			test.stopTest();
			Application__c testApp = [
				SELECT
					Id,
					Number_of_days_account_has_not_activated__c,
					Product_Name__c,
					Account_Number__c,
					Client_Name__c,
					Client_Number__c,
					Client_Email__c,
					sd_Response_Email_Address__c
				FROM Application__c
				WHERE OwnerId = :uA.Id
				LIMIT 1
			];
			System.assertEquals(null, testApp.Account_Number__c, 'testScheduler test falied');
		}
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 **/
	@isTest
	static void test500() {
		User uA = new User();
		String email = 'UserAdmin@testorg.com';
		uA = UserTDF.getUser(email);
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS, null));
		System.runAs(uA) {
			Rbbmi_ApplicationScheduler schedule = new Rbbmi_ApplicationScheduler();
			Rbbmi_ApplicationScheduler batch = new Rbbmi_ApplicationScheduler();
			String cronExp = '0 0 0 15 3 ? *';
			test.startTest();
			Id jobId = System.schedule('ScheduleApexClassTest', cronExp, schedule);
			Id batchId = Database.executeBatch(batch, 2000);
			test.stopTest();
			Application__c testApp = [
				SELECT
					Id,
					Number_of_days_account_has_not_activated__c,
					Product_Name__c,
					Account_Number__c,
					Client_Name__c,
					Client_Number__c,
					Client_Email__c,
					sd_Response_Email_Address__c
				FROM Application__c
				WHERE OwnerId = :uA.Id
				LIMIT 1
			];
			System.assertEquals(null, testApp.Account_Number__c, 'testScheduler test falied');
		}
	}
		/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 **/
	@isTest
	static void testIntegrationService() {
		User uA = new User();
		String email = 'UserAdmin@testorg.com';
		uA = UserTDF.getUser(email);
		List<Integration_Service__c> integrationServices = [SELECT Id FROM Integration_Service__c WHERE Name = 'rbbmi' ];
		System.debug('<<<<< integrationServices : '+integrationServices);
		delete integrationServices;
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		System.runAs(uA) {
			Rbbmi_ApplicationScheduler schedule = new Rbbmi_ApplicationScheduler();
			Rbbmi_ApplicationScheduler batch = new Rbbmi_ApplicationScheduler();
			String cronExp = '0 0 0 15 3 ? *';
			test.startTest();
			Id jobId = System.schedule('ScheduleApexClassTest', cronExp, schedule);
			Id batchId = Database.executeBatch(batch, 2000);
			test.stopTest();
			Application__c testApp = [
				SELECT
					Id,
					Number_of_days_account_has_not_activated__c,
					Product_Name__c,
					Account_Number__c,
					Client_Name__c,
					Client_Number__c,
					Client_Email__c,
					sd_Response_Email_Address__c
				FROM Application__c
				WHERE OwnerId = :uA.Id
				LIMIT 1
			];
			System.assertEquals(null, testApp.Account_Number__c, 'testScheduler test falied');
		}
	}
}
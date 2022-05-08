/**
 * @description Test class for LeadsManagementNotificationSchedule
 * @author  Kabelo Aphane
 * @date    05/03/2021
 */
@isTest
public class LeadsManagementNotificationScheduleTest {
	/**
	 * @description Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		Financial_Product__c testFinancialProduct = new Financial_Product__c(Name = 'Test', Product_Type__c = '', Business_Unit__c = 'Business Banking');
		insert testFinancialProduct;

		Campaign cmp = new Campaign(Name = 'Test Name');
		insert cmp;

		RecordType retailRecordType = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Retail_Sales_Lead'];

		Lead leadRecord1 = new Lead();
		leadRecord1.FirstName = 'Hot';
		leadRecord1.LastName = 'Lead';
		leadRecord1.Status = 'Unallocated';
		leadRecord1.Hot_Deal__c = true;
		leadRecord1.RecordTypeId = retailRecordType.Id;
		leadRecord1.SLA_Start_Date__c = Date.today();
		leadRecord1.Product_Interest_1__c = testFinancialProduct.Id;
		leadRecord1.leadSource = 'IB Campaign';
		leadRecord1.Campaign__c = cmp.Id;
		insert leadRecord1;

		Lead leadRecord2 = new Lead();
		leadRecord2.FirstName = 'Cold';
		leadRecord2.LastName = 'Lead';
		leadRecord2.Status = 'Unallocated';
		leadRecord2.Hot_Deal__c = false;
		leadRecord2.RecordTypeId = retailRecordType.Id;
		leadRecord2.SLA_Start_Date__c = Date.today();
		leadRecord2.Product_Interest_1__c = testFinancialProduct.Id;
		leadRecord2.leadSource = 'IB Campaign';
		leadRecord2.Campaign__c = cmp.Id;
		insert leadRecord2;
	}
	/**
	 * @description method to test sendEmailToManagement
	 */
	static testMethod void testLeadsManagementNotification() {
		List<Messaging.SendEmailResult> results;
		Test.startTest();
		LeadsManagementNotificationSchedule instance = new LeadsManagementNotificationSchedule();

		String cronExp = '0 0 23 * * ?';
		System.schedule('Test LeadsManagementNotificationSchedule', cronExp, instance);
		results = LeadsManagementNotificationSchedule.sendEmailToManagement('Test');
		Test.stopTest();

		System.assert(results[0].isSuccess(), 'Assert Failed');
	}
}
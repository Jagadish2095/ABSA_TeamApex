/**
 * @description       :
 *
 * @group             :
 * @last modified on  : 2021-12-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   2021-05-26   jacobuschristiaan.delange@absa.africa   Initial Version
 **/
@isTest
public class AccountTriggerTest {
	@isTest
	static void testAccountTrigger() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '6211275132089';
		accountList[0].AccountNumber = '6211275132089';
		accountList[0].Country_of_Citizenship__c = 'South Africa';
		accountList[0].PersonBirthdate = Date.valueOf('1962-11-27');
		accountList[0].Gender__pc = 'Male';
		insert accountList;
		system.assertEquals('ABSA TEST', accountList[0].LastName, 'assert failed');

		test.startTest();
		AccIdValidationHelper.validateAccId(accountList[0]);
		test.stopTest();
	}
	/**
	 * @description
	 * 
	 **/
	// feature/W-016905-1 no changes made to the test class for this user story
	@isTest
	static void testAccountTrigger2() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '6211275132089';
		accountList[0].AccountNumber = '6211275132089';
		accountList[0].Country_of_Citizenship__c = 'South Africa';
		accountList[0].PersonBirthdate = Date.valueOf('1962-11-27');
		accountList[0].Gender__pc = 'Male';
		accountList[0].FinServ__Status__c = 'InActive';
		insert accountList;
		system.assertEquals('ABSA TEST', accountList[0].LastName, 'assert failed');

		Application__c app = new Application__c(Product_Interest__c = 'Merchant Smartpay', Account__c = accountList[0].Id);
		insert app;
		system.assertEquals('Merchant Smartpay', app.Product_Interest__c, 'assert failed');

		Account acc = [SELECT Id, FinServ__Status__c FROM Account WHERE Id = :accountList[0].Id];
		system.debug('Inserted Account rec : ' + acc);
		acc.FinServ__Status__c = 'Active';
		update acc;
	}

	/**
	 * @description
	 * 2021-05-26
	 **/
	@isTest
	static void testAccountTrigger3() {
		map<String, Schema.RecordTypeInfo> accRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		Account businessAcc = new Account(Name = 'testbussacc', recordTypeId = accRecordTypeMap.get('Client').getRecordTypeId());
		insert businessAcc;
		system.assertEquals('testbussacc', businessAcc.Name, 'assert failed');

		businessAcc.Registration_Number__c = '123456';
		businessAcc.Risk_Status__c = 'Incomplete';
		update businessAcc;

		Opportunity opp = new Opportunity(Name = 'testopp', AccountId = businessAcc.Id, StageName = 'Won', CloseDate = system.today());
		insert opp;
		system.assertEquals('testopp', opp.Name, 'assert failed');
	}
}
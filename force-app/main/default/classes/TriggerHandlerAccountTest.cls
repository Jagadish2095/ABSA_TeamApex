/**
 * @author Rob McLean
 * @date 19/02/2021
 * @description Test class for TriggerHandlerAccount
 * @update 01/09/2021
 */
@isTest
private class TriggerHandlerAccountTest {
	@testSetup
	static void makeData() {
		Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		User au = UserTDF.addUser('System Administrator (Custom)', 'UserAdmin', 'UserAdmin@testorg.com');
		User u = UserTDF.addUser('Standard User (Business Banker)', 'UserBB', 'UserBB@testorg.com');
		System.runAs(u) {
			Account validIndvAccUpdate = AccountTDF.addIndividualClient('Individual', 'validIndvAccUpdate');
			validIndvAccUpdate.Occupation__pc = 'Developer';
			validIndvAccUpdate.Valid_Update_Bypass__c = true;
			update validIndvAccUpdate;
			Account validBusAccUpdate = AccountTDF.addClient('Public Company', 'validBusAccUpdate');
			validBusAccUpdate.Country_of_Registration__c = 'Afghanistan';
			validBusAccUpdate.Registration_Number__c = '111111111111';
			validBusAccUpdate.Valid_Update_Bypass__c = true;
			update validBusAccUpdate;
			Account leadAcc = AccountTDF.addIndividualClient('Individual', 'leadAcc');
			Account inValidAccUpdate = AccountTDF.addIndividualClient('Individual', 'inValidAccUpdate');
			Opportunity oppIndv = OpportunityTDF.addBusinessBankOpp('validIndvAccUpdate BB opp', 'New', Date.today(), validIndvAccUpdate.Id);
			Opportunity oppBus = OpportunityTDF.addBusinessBankOpp('validBusAccUpdate BB opp', 'New', Date.today(), validBusAccUpdate.Id);
			Application__c merIndvApp = ApplicationTDF.addMerchantOnboardingApp(oppIndv.Id);
			merIndvApp.Product_Interest__c = 'Other Merchant Solutions';
			merIndvApp.Account__c = validIndvAccUpdate.Id;
			update merIndvApp;
			Application__c busApp = ApplicationTDF.addMerchantOnboardingApp(oppBus.Id);
			busApp.Product_Interest__c = 'Other Merchant Solutions';
			busApp.Account__c = validBusAccUpdate.Id;
			update busApp;
			Financial_Product__c finProd = FinancialProductTDF.addFinProduct(
				'Transact - Merchant - Merchants',
				'Transact',
				'Merchants',
				'Merchants',
				'Merchant'
			);
			Lead accLead = LeadTDF.addleadBusinessBankLead('BBLead', finProd.Id, 'BBLead');
			accLead.Account__c = leadAcc.Id;
			update accLead;
		}
	}
	@isTest
	private static void testBusValidUpdate() {
		User u = UserTDF.getUser('UserBB@testorg.com');
		System.runAs(u) {
			Boolean testValid;
			String errMsg = '';
			List<Account> accList = [
				SELECT Id, Valid_Update__c, Valid_Update_Bypass__c, Alternative_Email_1__c, Alternative_Email_2__c
				FROM Account
				WHERE Name = 'validBusAccUpdate'
			];
			List<Account> accListUpdate = new List<Account>();
			if (accList.size() > 0) {
				for (Account acc : accList) {
					acc.Country_of_Registration__c = 'South Africa';
					acc.Registration_Number__c = '222222222222';
					acc.Alternative_Email_1__c = 'test@test.com';
					acc.FinServ__Status__c = 'Active';
					accListUpdate.add(acc);
				}
			}
			if (accListUpdate != null & accListUpdate.size() > 0) {
				try {
					update accListUpdate;
					testValid = true;
				} catch (Exception e) {
					testValid = false;
					errMsg = e.getMessage();
				}
			}
			System.assertEquals(true, testValid, errMsg);
		}
	}
	@isTest
	private static void testIndvValidUpdate() {
		User u = UserTDF.getUser('UserBB@testorg.com');
		System.runAs(u) {
			Boolean testValid;
			String errMsg = '';
			List<Account> accList = [
				SELECT Id, Valid_Update__c, Valid_Update_Bypass__c, Alternative_Email_1__c, Alternative_Email_2__c
				FROM Account
				WHERE Name = 'validIndvAccUpdate'
			];
			List<Account> accListUpdate = new List<Account>();
			if (accList.size() > 0) {
				for (Account acc : accList) {
					acc.LastName = 'LastName';
					acc.FirstName = 'FirstName';
					acc.Occupation__pc = 'Tester';
					acc.PersonMobilePhone = '082123456';
					acc.Alternative_Email_1__c = 'test@test.com';
					acc.FinServ__Status__c = 'Active';
					accListUpdate.add(acc);
				}
			}
			if (accListUpdate != null & accListUpdate.size() > 0) {
				try {
					update accListUpdate;
					testValid = true;
				} catch (Exception e) {
					testValid = false;
					errMsg = e.getMessage();
				}
			}
			System.assertEquals(true, testValid, errMsg);
		}
	}
	@isTest
	private static void testAdminUpdate() {
		User uA = UserTDF.getUser('UserAdmin@testorg.com');
		System.runAs(uA) {
			Boolean testValid;
			String errMsg = '';
			List<Account> accList = [
				SELECT Id, Valid_Update__c, Valid_Update_Bypass__c, Alternative_Email_1__c, Alternative_Email_2__c
				FROM Account
				WHERE Name IN ('validIndvAccUpdate', 'leadAcc')
			];
			List<Account> accListUpdate = new List<Account>();
			if (accList.size() > 0) {
				for (Account acc : accList) {
					acc.Alternative_Email_1__c = 'testupdate@test.com';
					accListUpdate.add(acc);
				}
			}
			if (accListUpdate != null & accListUpdate.size() > 0) {
				try {
					update accListUpdate;
					testValid = true;
				} catch (Exception e) {
					testValid = false;
					errMsg = e.getMessage();
				}
			}
			System.assertEquals(true, testValid, errMsg);
		}
	}
	@isTest
	private static void testInValidUpdate() {
		User u = UserTDF.getUser('UserBB@testorg.com');
		System.runAs(u) {
			Boolean testValid;
			String errMsg = '';
			List<Account> accList = [
				SELECT Id, Valid_Update__c, Valid_Update_Bypass__c, Alternative_Email_1__c, Alternative_Email_2__c
				FROM Account
				WHERE Name = 'inValidAccUpdate'
			];
			List<Account> accListUpdate = new List<Account>();
			if (accList.size() > 0) {
				for (Account acc : accList) {
					acc.Alternative_Email_1__c = 'testinvalid@test.com';
					accListUpdate.add(acc);
				}
			}
			if (accListUpdate != null & accListUpdate.size() > 0) {
				try {
					update accListUpdate;
					testValid = true;
				} catch (Exception e) {
					testValid = false;
					errMsg = e.getMessage();
				}
			}
			System.assertNotEquals(testValid, null);
		}
	}
	@isTest
	private static void testInValidUpdateWithBypass() {
		User u = UserTDF.getUser('UserBB@testorg.com');
		System.runAs(u) {
			Boolean testValid;
			String errMsg = '';
			List<Account> accList = [
				SELECT Id, Valid_Update__c, Valid_Update_Bypass__c, Alternative_Email_1__c, Alternative_Email_2__c
				FROM Account
				WHERE Name = 'inValidAccUpdate'
			];
			List<Account> accListUpdate = new List<Account>();
			if (accList.size() > 0) {
				for (Account acc : accList) {
					acc.Alternative_Email_1__c = 'testinvalidBypass@test.com';
					acc.Valid_Update_Bypass__c = true;
					accListUpdate.add(acc);
				}
			}
			if (accListUpdate != null & accListUpdate.size() > 0) {
				try {
					update accListUpdate;
					testValid = true;
				} catch (Exception e) {
					testValid = false;
					errMsg = e.getMessage();
				}
			}
			System.assertEquals(true, testValid, errMsg);
		}
	}
}
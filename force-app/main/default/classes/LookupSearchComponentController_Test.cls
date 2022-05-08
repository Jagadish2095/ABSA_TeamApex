/**
 * @description       : 
 * @author            : deepthi.narayanappa@absa.africa
 * @last modified on  : 2021-09-27
 * @last modified by  : deepthi.narayanappa@absa.africa
**/
@isTest
class LookupSearchComponentController_Test {
	@testSetup
	static void testSetup() {
		UserRole role = new UserRole(Name = 'WIMI-Distribution-Virtual Adviser');
		insert role;

		User uObj = new User();
		uObj.ProfileId = UserInfo.getProfileId();
		uObj.LastName = 'LookupSearchUser';
		uObj.Email = 'LookupSearchUser123@absa.com';
		uObj.Username = 'LookupSearchUser123@absa.com';
		uObj.CompanyName = 'TEST';
		uObj.Title = 'Mr.';
		uObj.EmailEncodingKey = 'ISO-8859-1';
		uObj.Alias = 'ls123';
		uObj.TimeZoneSidKey = 'America/Los_Angeles';
		uObj.LocaleSidKey = 'en_US';
		uObj.LanguageLocaleKey = 'en_US';
		uObj.Advisor_Code__c = '112233';
		uObj.UserRoleId = role.Id;
		insert uObj;
	}

	@isTest
	static void test1() {
		User testUser = [SELECT Id, Name FROM User WHERE UserName = 'LookupSearchUser123@absa.com'];
		LookupSearchComponentController.getResults('User', 'Name', 'LookupSearchUser', 'VA');
		LookupSearchComponentController.getResults('User', 'Name', 'LookupSearchUser', 'non-VA');
		system.assertEquals(true, testUser != null);
	}
}
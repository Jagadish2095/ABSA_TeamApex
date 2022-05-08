/*
Controller Test Class For BranchCustomerController class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2020-11-17
*
*/

@isTest
public class BranchCustomerControllerTest {
	@testSetup
	static void dataCreation() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;

		System.runAs(au) {
			Date birthDate = Date.newInstance(2000, 3, 9);

			Account account = new Account();
			account.ID_Number__pc = '9308305015082';
			account.FirstName = 'TestBranchCustomerController';
			account.LastName = 'Tester';
			account.PersonBirthdate = birthDate;
			account.Gender__pc = 'Male';
			account.Date_Issued__pc = Date.today();
			account.Next_of_Kin_Last_Name__pc = 'Testing';
			account.Next_of_Kin_First_Name_s__pc = 'Testing';
			account.PersonOtherPhone = '0837224589';
			insert account;

			Address__c employersAddress = new Address__c(Account__c = account.Id, Address_Type__c = 'Employers');
			Address__c residentialAddress = new Address__c(Account__c = account.Id, Address_Type__c = 'Residential');
			Address__c postalAddress = new Address__c(Account__c = account.Id, Address_Type__c = 'Postal');

			insert employersAddress;
			insert residentialAddress;
			insert postalAddress;
		}
	}

	@isTest
	public static void validateFieldsTest() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}

		System.runAs(au) {
			Account account = [SELECT Id FROM Account WHERE FirstName = 'TestBranchCustomerController' LIMIT 1];
			List<Map<String, String>> fieldMappings = new List<Map<String, String>>();
			Map<String, String> personTitle = new Map<String, String>();
			personTitle.put('Value', 'Mr');
			personTitle.put('CMPField', 'PersonTitle');
			personTitle.put('ServiceField', 'titleCode');
			Map<String, String> firstName = new Map<String, String>();
			firstName.put('Value', 'Testname');
			firstName.put('CMPField', 'FirstName');
			firstName.put('ServiceField', 'firstNames');
			fieldMappings.add(personTitle);
			fieldMappings.add(firstName);
			Test.startTest();
			Map<String, String> errorText = BranchCustomerController.validateFields(account.Id, fieldMappings);
			System.assert(errorText != null, 'Test Working');
			Test.stopTest();
		}
	}

	@isTest
	public static void getAddressTest() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}

		System.runAs(au) {
			Account account = [SELECT Id FROM Account WHERE FirstName = 'TestBranchCustomerController' LIMIT 1];
			List<String> addressTypes = new List<String>();
			addressTypes.add('Employers');
			addressTypes.add('Postal');

			Test.startTest();
			Map<String, String> errorText = BranchCustomerController.getAddress(account.Id, addressTypes);
			System.assert(errorText != null, 'Test Working');
			Test.stopTest();
		}
	}

	@isTest
	public static void getTranslationValues() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}

		System.runAs(au) {
			String systemName = 'CIF';
			String valueType = 'Country';
			String direction = 'Outbound';
			SObject objObject = Address__c.SObjectType.newSObject();
			String objField = 'Shipping_Country__c';

			Test.startTest();
			Map<String, String> translationValues = BranchCustomerController.getTranslationValues(systemName, valueType, direction, objObject, objField);
			System.assert(translationValues != null, 'Test Working');
			Test.stopTest();
		}
	}

	@isTest
	public static void getFieldPickListValues() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}

		System.runAs(au) {
			SObject objObject = Address__c.SObjectType.newSObject();
			String objField = 'Shipping_Country__c';

			Test.startTest();
			List<String> addresses = BranchCustomerController.getFieldPickListValues(objObject, objField);
			System.assert(addresses != null, 'Test Working');
			Test.stopTest();
		}
	}

	@isTest
	public static void createOrUpdateTest() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}

		System.runAs(au) {
			Account account = [SELECT Id FROM Account WHERE FirstName = 'TestBranchCustomerController' LIMIT 1];

			Test.startTest();
			String errorText = BranchCustomerController.createOrUpdate(account.Id);
			System.assert(errorText != null, 'Test Working');
			Test.stopTest();
		}
	}

	@isTest
	public static void updateAccountwithCIF() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}

		System.runAs(au) {
			Account account = [SELECT Id FROM Account WHERE FirstName = 'TestBranchCustomerController' LIMIT 1];
			String responseCIF = 'Test';

			Test.startTest();
			String errorText = BranchCustomerController.updateAccountwithCIF(account.Id, responseCIF);
			System.assert(errorText != null, 'Test Working');
			Test.stopTest();
		}
	}
}
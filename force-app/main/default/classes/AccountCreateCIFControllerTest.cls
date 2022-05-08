/***
 *@description Test class for AccountCreateCIFControllerTest
 *@Updated: 2021/10/19
 */
@isTest
public class AccountCreateCIFControllerTest {
	@TestSetup
	static void makeData() {
		User adm = new User();
		String uniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String email = 'UserAdmin@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		adm = new User(
			Alias = 'standt',
			Email = email,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = p.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = uniqueUserName,
			MobilePhone = '0823389021'
		);
		insert adm;
		System.runAs(adm) {
			Map<String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			Map<String, Schema.RecordTypeInfo> ContactRecordTypeMap = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			List<Account> accList = new List<Account>();
			Account individualAccount;
			individualAccount = new Account();
			individualAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
			individualAccount.Client_Type__c = null;
			individualAccount.PersonTitle = 'Mr.';
			individualAccount.Initials__pc = 'T';
			individualAccount.FirstName = 'Tony';
			individualAccount.LastName = 'Stark';
			individualAccount.Gender__pc = 'Male';
			individualAccount.PersonBirthdate = Date.valueOf('1981-07-11');
			individualAccount.ID_Number__pc = '8107115017084';
			individualAccount.ID_Type__pc = 'SA Identity Document';
			individualAccount.PersonEmail = 'test@test.co.za';
			individualAccount.Alternative_Email__c = 'test@test.com';
			individualAccount.Phone = '0114453322';
			individualAccount.PersonMobilePhone = '0747003747';
			individualAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
			individualAccount.Credit_Marketing_Consent__pc = 'Yes';
			individualAccount.Non_Credit_Marketing_Indicator__pc = 'Email;SMS';
			individualAccount.Credit_Marketing_Indicator__pc = 'Email;SMS';
			accList.add(individualAccount);
			Account jointAccount;
			jointAccount = new Account();
			jointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
			jointAccount.Name = 'TEST MR JA & TEST MRS J';
			jointAccount.Client_Type__c = 'Joint & Several';
			accList.add(jointAccount);
			Account prmAccount = new Account();
			prmAccount.FirstName = 'JA';
			prmAccount.LastName = 'Test';
			prmAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
			accList.add(prmAccount);
			Account secondAccount = new Account();
			secondAccount.FirstName = 'J';
			secondAccount.LastName = 'Test';
			secondAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
			accList.add(secondAccount);
			insert accList;
		}
	}

	@isTest
	static void testAccountCreateCIFControllerIndividualA() {
		User adm = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					adm = u;
				}
			}
		}
		System.runAs(adm) {
			String response = null;
			Boolean check = null;
			Datetime td = System.today();
			List<Account> accList = new List<Account>();
			accList = new AccountsSelector().selectByIdNumber('8107115017084', 25);
			Account IndvAccount = new Account();
			if (accList != null && accList.size() > 0) {
				for (Account acc : accList) {
					if (acc.ID_Number__pc == '8107115017084') {
						IndvAccount = acc;
					}
				}
				//IndvAccount = new AccountsSelector().selectAllById(accList.get(0).Id);
				check = AccountCreateCIFController.validateIfCIFExists(IndvAccount.id);
				System.assertEquals(false, check);
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Client Type Cannot be blank - please amend on the account', response);
				IndvAccount.Client_Type__c = 'Individual Client';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals(
					'Error: CASA Reference Number cannot be blank - please do CASA Screening for this client first through one of their opportunities',
					response
				);
				IndvAccount.CASA_Reference_Number__pc = '1712994';
				IndvAccount.CASA_Risk_Status__pc = 'Low';
				IndvAccount.CASA_Screening_Date__pc = Date.valueOf(td);
				IndvAccount.CASA_Screening_Status__pc = 'Approved';
				IndvAccount.ID_Type__pc = 'Passport';
				IndvAccount.Country_of_Origin__pc = null;
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Country Passport cannot be blank if ID Type is Passport - please amend on the account', response);
				IndvAccount.Passport_Number__pc = null;
				IndvAccount.Country_of_Origin__pc = 'South Africa';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Passport Number cannot be blank if ID Type is Passport - please amend on the account', response);
				IndvAccount.ID_Number__pc = '8107115017084';
				IndvAccount.ID_Type__pc = 'SA Identity Document';
				IndvAccount.Occupation_Status__pc = 'Full Time Employed';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals(
					'Error: If the Occupation status is "Full Time Employed", "Self Employed Non Professional", "Self Employed Professional","Part Time Employed", "Temporary Employed" then the employers address must be added onto the Address related list - please amend on the account',
					response
				);
				IndvAccount.Occupation_Status__pc = null;
				IndvAccount.Non_Credit_Marketing_Consent__pc = null;
				IndvAccount.Non_Credit_Marketing_Indicator__pc = null;
				IndvAccount.Credit_Marketing_Consent__pc = null;
				IndvAccount.Credit_Marketing_Indicator__pc = null;
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Non-Credit Marketing Consent must be completed - please amend on the account', response);
				IndvAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals(
					'Error: If Non-Credit Marketing Consent is "Yes" then atleast one Non-Credit Marketing Indicator must be selected - please amend on the account',
					response
				);
				IndvAccount.Non_Credit_Marketing_Indicator__pc = 'Email;SMS';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Credit Marketing Consent must be completed - please amend on the account', response);
				IndvAccount.Credit_Marketing_Consent__pc = 'Yes';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals(
					'Error: If Credit Marketing Consent is "Yes" then atleast one Credit Marketing Indicator must be selected - please amend on the account',
					response
				);
			}
		}
	}

	@isTest
	static void testAccountCreateCIFControllerIndividualB() {
		User adm = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					adm = u;
				}
			}
		}
		System.runAs(adm) {
			String response = null;
			Datetime td = System.today();
			List<Account> accList = new List<Account>();
			accList = new AccountsSelector().selectByIdNumber('8107115017084', 25);
			Account IndvAccount = new Account();
			if (accList != null && accList.size() > 0) {
				for (Account acc : accList) {
					if (acc.ID_Number__pc == '8107115017084') {
						IndvAccount = acc;
					}
				}
				//IndvAccount = new AccountsSelector().selectAllById(accList.get(0).Id);
				IndvAccount.Client_Type__c = 'Individual Client';
				IndvAccount.CASA_Reference_Number__pc = '1712994';
				IndvAccount.CASA_Risk_Status__pc = 'Low';
				IndvAccount.CASA_Screening_Date__pc = Date.valueOf(td);
				IndvAccount.CASA_Screening_Status__pc = 'Approved';
				IndvAccount.ShippingCity = null;
				IndvAccount.ShippingCountry = null;
				IndvAccount.ShippingStreet = null;
				IndvAccount.ShippingPostalCode = null;
				IndvAccount.BillingCity = null;
				IndvAccount.BillingCountry = null;
				IndvAccount.BillingStreet = null;
				IndvAccount.BillingPostalCode = null;
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Monthly Income is required when submitting to CIF and must be completed - please amend on the account', response);
				IndvAccount.Monthly_Income__pc = 'R0 - 499';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Communication Language cannot be blank - please amend on the account', response);
				IndvAccount.Communication_Language__pc = 'English';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Shipping Street cannot be blank - please amend on the account', response);
				IndvAccount.ShippingStreet = '01 PUERTA DEL SOL';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Shipping City cannot be blank - please amend on the account', response);
				IndvAccount.ShippingCity = 'GROBLERSDAL';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Shipping Postal Code cannot be blank - please amend on the account', response);
				IndvAccount.ShippingPostalCode = '8001';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Shipping Country cannot be blank - please amend on the account', response);
				IndvAccount.ShippingCountry = 'South Africa';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Billing Street cannot be blank - please amend on the account', response);
				IndvAccount.BillingStreet = '01 PUERTA DEL SOL';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Billing City cannot be blank - please amend on the account', response);
				IndvAccount.BillingCity = 'GROBLERSDAL';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Billing Postal Code cannot be blank - please amend on the account', response);
				IndvAccount.BillingPostalCode = '8001';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Billing Country cannot be blank - please amend on the account', response);
				IndvAccount.BillingCountry = 'South Africa';
				update IndvAccount;
			}
		}
	}

	@isTest
	static void testAccountCreateCIFControllerIndividualC() {
		User adm = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					adm = u;
				}
			}
		}
		System.runAs(adm) {
			String response = null;
			Datetime td = System.today();
			List<Account> accList = new List<Account>();
			accList = new AccountsSelector().selectByIdNumber('8107115017084', 25);
			Account IndvAccount = new Account();
			if (accList != null && accList.size() > 0) {
				for (Account acc : accList) {
					if (acc.ID_Number__pc == '8107115017084') {
						IndvAccount = acc;
					}
				}
				//IndvAccount = new AccountsSelector().selectAllById(accList.get(0).Id);
				IndvAccount.Client_Type__c = 'Individual Client';
				IndvAccount.CASA_Reference_Number__pc = '1712994';
				IndvAccount.CASA_Risk_Status__pc = 'Low';
				IndvAccount.CASA_Screening_Date__pc = Date.valueOf(td);
				IndvAccount.CASA_Screening_Status__pc = 'Approved';
				IndvAccount.Monthly_Income__pc = 'R0 - 499';
				IndvAccount.Communication_Language__pc = 'English';
				IndvAccount.ShippingStreet = '01 PUERTA DEL SOL';
				IndvAccount.ShippingCity = 'GROBLERSDAL';
				IndvAccount.ShippingPostalCode = '8001';
				IndvAccount.ShippingCountry = 'South Africa';
				IndvAccount.BillingStreet = '01 PUERTA DEL SOL';
				IndvAccount.BillingCity = 'GROBLERSDAL';
				IndvAccount.BillingPostalCode = '8001';
				IndvAccount.BillingCountry = 'South Africa';
				IndvAccount.Preferred_Communication_Method__pc = null;
				IndvAccount.PersonEmail = null;
				IndvAccount.PersonHomePhone = null;
				IndvAccount.PersonOtherPhone = null;
				IndvAccount.PersonMobilePhone = null;
				IndvAccount.Marital_Status__pc = null;
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Preferred Communication Method cannot be blank - please amend on the account', response);
				IndvAccount.Preferred_Communication_Method__pc = 'Email';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals(
					'Error: Email cannot be blank if the preferred communication method is set to email - please amend on the account',
					response
				);
				IndvAccount.Preferred_Communication_Method__pc = 'Phone';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals(
					'Error: At least one phone needs to be added if the preferred communication method is set to phone - please amend on the account',
					response
				);
				IndvAccount.Preferred_Communication_Method__pc = 'SMS';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals(
					'Error: Mobile Phone cannot be blank if the preferred communication method is set to SMS - please amend on the account',
					response
				);
				IndvAccount.PersonMobilePhone = '0821234568';
				update IndvAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('Error: Marital Status cannot be blank - please amend on the account', response);
				IndvAccount.Marital_Status__pc = 'Single';
				update IndvAccount;
				Test.setMock(
					HttpCalloutMock.class,
					new CreateClientCIFMock_ApiRest(
						StringConstants.POSITIVE_STRING,
						StringConstants.POSITIVE_STRING,
						StringConstants.POSITIVE_STRING,
						StringConstants.POSITIVE_STRING
					)
				);
				IntegrationTestDataFactory.insertIntegrationSettings(
					StringConstants.API_MANAGER,
					new List<String>{ StringConstants.CREATE_CLIENT_CIF, StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
				);
				IntegrationTestDataFactory.insertIntegrationTranslations();
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(IndvAccount.id);
				System.assertEquals('', response);
			}
		}
	}

	@isTest
	static void testAccountCreateCIFControllerJointA() {
		User adm = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					adm = u;
				}
			}
		}
		System.runAs(adm) {
			String response = null;
			Datetime td = System.today();
			List<Account> accList = new List<Account>();
			Set<String> accNames = new Set<String>();
			accNames.add('TEST MR JA & TEST MRS J');
			accList = new AccountsSelector().selectByName(accNames);
			Account jntAccount = new Account();
			if (accList != null && accList.size() > 0) {
				jntAccount = accList.get(0);
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
				System.assertEquals(
					'Error: CASA Reference Number cannot be blank - please do CASA Screening for this client first through one of their opportunities',
					response
				);
				jntAccount.CASA_Reference_Number__c = '1712994';
				update jntAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
				System.assertEquals('Error: At least 1 contact needs to be marked as a primary client - please amend on the account; ', response);
				List<Contact> contListNames = new List<Contact>();
				Set<String> contactNames = new Set<String>();
				contactNames.add('JA Test');
				contactNames.add('J Test');
				contListNames = new ContactsSelector().selectByName(contactNames);
				Contact prmContact = new Contact();
				Contact secContact = new Contact();
				if (contListNames != null && contListNames.size() > 0) {
					List<Contact> contactLists = new List<Contact>();
					Set<Id> contactIds = new Set<Id>();
					for (Contact cont : contListNames) {
						contactIds.add(cont.Id);
					}
					contactLists = new ContactsSelector().selectCifFieldsBySetContactIds(contactIds);
					for (Contact cont : contactLists) {
						if (cont.Name == 'JA Test') {
							prmContact = cont;
						} else if (cont.Name == 'J Test') {
							secContact = cont;
						}
					}
					jntAccount.Primary_Client__c = prmContact.Id;
				}
				update jntAccount;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
				System.assertEquals('Error: Please ensure your primary client is also listed as a related contact; ', response);
				AccountContactRelation acrPrm = new AccountContactRelation();
				acrPrm.AccountId = jntAccount.Id;
				acrPrm.ContactId = prmContact.Id;
				insert acrPrm;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
				System.assertEquals(
					'Please fix the following errors for: No Name - Title cannot be blank; Communication Language cannot be blank; Occupation Status cannot be blank; Occupation Category cannot be blank; Preferred Communication Method cannot be blank; At least one phone number must be added; Shipping Street cannot be blank; Shipping City cannot be blank; Shipping Postal Code cannot be blank; Shipping Country cannot be blank; Error: At least 2 related contacts need to be created; ',
					response
				);
				AccountContactRelation acrSec = new AccountContactRelation();
				acrSec.AccountId = jntAccount.Id;
				acrSec.ContactId = secContact.Id;
				insert acrSec;
				response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
				System.assertEquals(
					'Please fix the following errors for: No Name - Title cannot be blank; Communication Language cannot be blank; Occupation Status cannot be blank; Occupation Category cannot be blank; Preferred Communication Method cannot be blank; At least one phone number must be added; Shipping Street cannot be blank; Shipping City cannot be blank; Shipping Postal Code cannot be blank; Shipping Country cannot be blank; Please fix the following errors for: No Name - Title cannot be blank; Communication Language cannot be blank; Occupation Status cannot be blank; Occupation Category cannot be blank; Preferred Communication Method cannot be blank; At least one phone number must be added; Shipping Street cannot be blank; Shipping City cannot be blank; Shipping Postal Code cannot be blank; Shipping Country cannot be blank; ',
					response
				);
				List<Account> participantAccounts = new AccountContactRelationSelector().selectListByAccId(jntAccount.Id);
				Set<Id> accIdSet = new Set<Id>();
				for (Account acc : participantAccounts) {
					accIdSet.add(acc.Id);
				}
				List<Account> accNamesList = new List<Account>();
				accNamesList = new AccountsSelector().selectCasaFieldsBySetId(accIdSet);
				Account prmAcc = new Account();
				Account secAcc = new Account();
				for (Account acc : accNamesList) {
					if (acc.FirstName == 'J') {
						secAcc = acc;
					} else if (acc.FirstName == 'JA') {
						prmAcc = acc;
					}
				}
				if (prmAcc != null && secAcc != null) {
					prmAcc.FirstName = null;
					prmAcc.PersonTitle = 'Mr.';
					prmAcc.Communication_Language__pc = 'English';
					prmAcc.Occupation_Status__pc = 'Full Time Employed';
					prmAcc.Occupation_Category__pc = 'Accountant';
					prmAcc.ShippingStreet = '01 PUERTA DEL SOL';
					prmAcc.ShippingCity = 'GROBLERSDAL';
					prmAcc.ShippingPostalCode = '8001';
					prmAcc.ShippingCountry = 'South Africa';
					prmAcc.Preferred_Communication_Method__pc = 'Email';
					prmAcc.PersonEmail = null;
					prmAcc.PersonHomePhone = null;
					prmAcc.PersonOtherPhone = null;
					prmAcc.PersonMobilePhone = null;
					update prmAcc;
					secAcc.Communication_Language__pc = 'English';
					secAcc.Occupation_Status__pc = 'Full Time Employed';
					secAcc.Occupation_Category__pc = 'Accountant';
					secAcc.ShippingStreet = '01 PUERTA DEL SOL';
					secAcc.ShippingCity = 'GROBLERSDAL';
					secAcc.ShippingPostalCode = '8001';
					secAcc.ShippingCountry = 'South Africa';
					secAcc.Preferred_Communication_Method__pc = 'Email';
					secAcc.PersonEmail = 'test@test.com';
					secAcc.Phone = '0821234567';
					update secAcc;
					response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
					System.assertEquals(
						'Please fix the following error for: No Name - Title cannot be blank; Please fix the following errors for: No Name - First Name or Last Name cannot be blank; Email cannot be blank if the preferred communication method is set to email; At least one phone number must be added; ',
						response
					);
					prmAcc.Preferred_Communication_Method__pc = 'Phone';
					prmAcc.FirstName = 'JA';
					update prmAcc;
					secAcc.PersonTitle = 'Mrs.';
					update secAcc;
					response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
					System.assertEquals(
						'Please fix the following errors for: No Name - At least one phone needs to be added if the preferred communication method is set to phone; At least one phone number must be added; ',
						response
					);
					prmAcc.Preferred_Communication_Method__pc = 'SMS';
					update prmAcc;
					response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
					System.assertEquals(
						'Please fix the following errors for: No Name - Mobile Phone cannot be blank if the preferred communication method is set to SMS; At least one phone number must be added; ',
						response
					);
					prmAcc.Phone = '0821234567';
					prmAcc.PersonEmail = 'test@test.com';
					update prmAcc;
					response = AccountCreateCIFController.createOrUpdateAccountInCIF(jntAccount.id);
					//System.assertEquals('',response);
				}
			}
		}
	}
}
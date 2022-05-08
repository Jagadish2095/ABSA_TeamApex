/**
 * @description       : Test Class for ContactsSelector
 * @last modified on  : 2021-09-27
 * @last modified by  : Manish.battu@absa.africa
 **/
@isTest
private class ContactsSelectorTest{
	@isTest
	private static void testSelectById(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		Set<Id> contactIdSet = new Set<Id>();
		contactIdSet.add(testContact.Id);
		List<Contact> contactTestList = contactSelectorTest.selectById(contactIdSet);
		system.assertNotEquals(0, contactTestList.size());
	}

	@isTest
	private static void testselectAccountIdBySetIds(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '2';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		Set<Id> contactIdSet = new Set<Id>();
		contactIdSet.add(testContact.Id);
		List<Contact> contactTestList = contactSelectorTest.selectAccountIdBySetIds(contactIdSet);
		system.assertNotEquals(0, contactTestList.size());
	}

	@isTest
	private static void testselectCifFieldsBySetContactIds(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		Set<Id> contactIdSet = new Set<Id>();
		contactIdSet.add(testContact.Id);
		List<Contact> contactTestList = contactSelectorTest.selectCifFieldsBySetContactIds(contactIdSet);
		system.assertNotEquals(0, contactTestList.size());
	}

	@isTest
	private static void testselectByName(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		Set<String> contactStringSet = new Set<String>();
		contactStringSet.add(testContact.FirstName + ' ' + testContact.LastName);
		List<Contact> contactTestList = contactSelectorTest.selectByName(contactStringSet);
		system.assertNotEquals(0, contactTestList.size());
	}

	@isTest
	private static void testSelectByPersonId(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		Contact contactTest = contactSelectorTest.selectByPersonId(testContact.Id, 2);
		system.assertNotEquals(null, contactTest);
	}

	@isTest
	private static void testSelectByListContactIds(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		Set<Id> contactIdSet = new Set<Id>();
		contactIdSet.add(testContact.Id);
		List<Contact> contactTestList = contactSelectorTest.selectByListContactIds(contactIdSet);
		system.assertNotEquals(0, contactTestList.size());
	}

	@isTest
	private static void testSelectByIdNumber(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		testContact.ID_Number__c = '8578586652845';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		List<Contact> contactTestList = contactSelectorTest.selectByIdNumber(testContact.ID_Number__c);
		system.assertNotEquals(0, contactTestList.size());
	}

	@isTest
	private static void testSelectCifFieldsByAccountId(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		List<Contact> contactTestList = contactSelectorTest.selectCifFieldsByAccountId(testContact.AccountId);
		system.assertNotEquals(0, contactTestList.size());

		List<Id> conIds = new List<Id>();
		conIds.add(testContact.Id);
		Set<String> clientTypes = new Set<String>{'Sole Trader', 'Individual', 'Individual - Minor'};
		List<Contact> cons = new ContactsSelector().selectMaritalDeclarationList(conIds, testContact.AccountId, clientTypes);
	}

	@isTest
	private static void testSelectByAccountId(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		Set<Id> accountIdSet = new Set<Id>();
		accountIdSet.add(testContact.AccountId);
		List<Contact> contactTestList = contactSelectorTest.selectByAccountId(accountIdSet);
		system.assertNotEquals(0, contactTestList.size());
	}

	@isTest
	private static void testselectRandomContacts(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		insert testContact;
		ContactsSelector contactSelectorTest = new ContactsSelector();
		List<Contact> contactTestList = contactSelectorTest.selectRandomContacts(10);
		system.assertNotEquals(0, contactTestList.size());
	}

	@isTest
	private static void testselectByEmail(){
		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		testContact.Email = 'test@test.co.za';
		insert testContact;

		ContactsSelector contactSelectorTest = new ContactsSelector();
		Set<String> accountEmailSet = new Set<String>();
		accountEmailSet.add(testContact.Email);
		List<Contact> contactTestList = contactSelectorTest.selectByEmail(accountEmailSet, 10);
		system.assertNotEquals(0, contactTestList.size());
	}

	// Tinashe - New Document Generation
	@isTest
	private static void testselectRelatedPartiesByAddressType(){
		Test.startTest();
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Set<Id> ids = new Set<Id>();
		ids.add(testDataFactory.testContact.id);
		new ContactsSelector().selectCifFieldsByContactId(testDataFactory.testContact.id);
		Set<String> emailAddress = new Set<String>();
		emailAddress.add('test123@test.com');
		new ContactsSelector().selectByEmails(emailAddress);
		List<Contact> conList = new ContactsSelector().selectRelatedPartiesByAddressType(ids, testDataFactory.testAccount.Id);
         List<Contact> conList1 = new ContactsSelector().selectRelatedPartiesByConIds(ids, new set<Id>{testDataFactory.testAccount.Id});
		system.assertNotEquals(0, conList.size());
		test.stopTest();
	}

	// end
}
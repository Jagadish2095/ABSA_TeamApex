/**
 * @description       : Helper class for CVS ServiceCalls/This class has methods used by Aura components to call the CVS services(CVSValidate/CVSCreate/CVSValidate)
 * @author            : PaulJohn.duRand@absa.africa
 * @created 2020-10-29
 * @last modified on  : 2021-10-11
 * @last modified by  : PaulJohn.duRand@absa.africa
 * @modified 2021-06-10 - PaulJohn.duRand@absa.africa
 * @modified 2021-06-25 - Aaron Castelyn : ABSA - Added Residential and Postal Street 2
 * @modified 2021-06-25 - PaulJohn.duRand@absa.africa - Update VAS Indicators
 * @modified 2021-09-06 - PaulJohn.duRand@absa.africa - Initials fix for name with special char
 * @modified 2021-09-06 - brian.maswanganyi@absa.africa - added test for update CIF With Group Scheme Code
 **/

@isTest
public class CVSServicesHelperTest 
{
	@testSetup
	static void dataCreation() {
		Date birthDate = Date.newInstance(2000, 3, 9);
		Account account = new Account();
		account.ID_Number__pc = '9308305015082';
		account.FirstName = 'TestCVSServicesHelper';
		account.LastName = 'Tester';
		account.PersonBirthdate = birthDate;
		account.Gender__pc = 'Male';
		account.Date_Issued__pc = Date.today();
		account.Next_of_Kin_Last_Name__pc = 'Testing';
		account.Next_of_Kin_First_Name_s__pc = 'Testing';
		account.PersonOtherPhone = '0834527788';
		account.Employer_Phone__c = '0834527788';
		insert account;
		Account accountFemale = new Account();
		accountFemale.ID_Number__pc = '9308305015082';
		accountFemale.FirstName = 'TestCVSServicesFemale';
		accountFemale.LastName = 'TesterFemale';
		accountFemale.PersonBirthdate = birthDate;
		accountFemale.Gender__pc = 'Female';
		accountFemale.Date_Issued__pc = Date.today();
		accountFemale.Next_of_Kin_Last_Name__pc = 'Testing';
		accountFemale.Next_of_Kin_First_Name_s__pc = 'Testing';
		accountFemale.PersonOtherPhone = '0834527788';
		accountFemale.Employer_Phone__c = '0834527788';
		insert accountFemale;
		Address__c employersAddress = new Address__c(Account__c = account.Id, Address_Type__c = 'Employers');
		Address__c residentialAddress = new Address__c(Account__c = account.Id, Address_Type__c = 'Residential');
		Address__c postalAddress = new Address__c(Account__c = account.Id, Address_Type__c = 'Postal');
		insert employersAddress;
		insert residentialAddress;
		insert postalAddress;
	}
	@isTest
	public static void validateFieldsTest() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestCVSServicesHelper' LIMIT 1];
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
		Map<String, String> errorText = CVSServicesHelper.validateFields(account.Id, fieldMappings);
		System.assert(errorText != null, 'Test Working');
		Test.stopTest();
	}
	@isTest
	public static void validateFieldsTestFemale() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestCVSServicesFemale' LIMIT 1];
		List<Map<String, String>> fieldMappings = new List<Map<String, String>>();
		Map<String, String> personTitle = new Map<String, String>();
		personTitle.put('Value', 'Miss');
		personTitle.put('CMPField', 'PersonTitle');
		personTitle.put('ServiceField', 'titleCode');
		Map<String, String> firstName = new Map<String, String>();
		firstName.put('Value', 'Testname');
		firstName.put('CMPField', 'FirstName');
		firstName.put('ServiceField', 'firstNames');
		fieldMappings.add(personTitle);
		fieldMappings.add(firstName);
		Test.startTest();
		Map<String, String> errorText = CVSServicesHelper.validateFields(account.Id, fieldMappings);
		System.assert(errorText != null, 'Test Working');
		Test.stopTest();
	}
	@isTest
	public static void createOrUpdateTest() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestCVSServicesHelper' LIMIT 1];
		Test.startTest();
		String errorText = CVSServicesHelper.createOrUpdate(account.Id);
		System.assert(errorText != null, 'Test Working');
		Test.stopTest();
	}
	@isTest
	public static void createCIFTest() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestCVSServicesHelper' LIMIT 1];
		Test.startTest();
		String errorText = CVSServicesHelper.createCIF(account.Id);
		System.assert(errorText != null, 'Test Working');
		Test.stopTest();
	}
	@isTest
	public static void updateCIFTest() {
		Account account = [SELECT Id, CIF__pc FROM Account WHERE FirstName = 'TestCVSServicesHelper' LIMIT 1];
		Test.startTest();
		String errorText = CVSServicesHelper.updateCIF(account.Id, account.CIF__pc);
		System.assert(errorText != null, 'Test Working');
		Test.stopTest();
	}

	@isTest
	public static void updateCIFWithGroupSchemeCodeTest()
	{
		Account account = [SELECT Id, CIF__pc FROM Account WHERE FirstName = 'TestCVSServicesHelper' LIMIT 1];
		Test.startTest();
		CVSUpdateCIFv22_Req_IB_v1.createDummyRequest();
		String errorText = CVSServicesHelper.updateCIFWithGroupSchemeCode(account.Id, account.CIF__pc, 'Vodacom');
		
		System.assert(errorText != null, 'Test Working');
		Test.stopTest();
	}
	@isTest
	public static void getDateForSalesforceTest() {
		Date testDate = Date.newInstance(2016, 3, 9);
		Test.startTest();
		String errorText = CVSServicesHelper.getDateForSalesforce(testDate);
		System.assert(errorText != null, 'Test Working');
		Test.stopTest();
	}
}
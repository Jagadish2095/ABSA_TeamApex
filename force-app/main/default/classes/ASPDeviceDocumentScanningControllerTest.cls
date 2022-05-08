/**
 * @description       :
 * @author            : PaulJohn.duRand@absa.africa
 * @group             :
 * @last modified on  : 2021-09-07
 * @last modified by  : PaulJohn.duRand@absa.africa
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   07-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 2.0   27-07-2021   rajani.bommasani@absa.africa         Updated Version
 * 2.0   07-09-2021   PaulJohn.duRand@absa.africa          ProofOfIncome Indicator and SOF
 **/
@isTest
public class ASPDeviceDocumentScanningControllerTest {
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
		insert account;

		Address__c residentialAddress = new Address__c(Account__c = account.Id, Address_Type__c = 'Residential');
		insert residentialAddress;

		Date birthDatem = Date.newInstance(2000, 3, 9);
		Account accountM = new Account();
		accountM.ID_Number__pc = '9308305015086';
		accountM.FirstName = 'TestCVSServicesHelperCPB';
		accountM.LastName = 'Tester';
		accountM.PersonBirthdate = birthDatem;
		accountM.Gender__pc = 'Male';
		accountM.Date_Issued__pc = Date.today();
		accountM.Next_of_Kin_Last_Name__pc = 'Testing';
		accountM.Next_of_Kin_First_Name_s__pc = 'Testing';
		accountM.PersonOtherPhone = '0834527788';
		insert accountM;

		Address__c residentialAddressM = new Address__c(Account__c = accountM.Id, Address_Type__c = 'Residential');

		residentialAddressM.Shipping_Street__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('30 COLLETT STREET');
		residentialAddressM.Shipping_Suburb__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('RACEVIEW');
		residentialAddressM.Shipping_City__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('ALBERTON');
		String Postal = '1449';
		residentialAddressM.Shipping_Zip_Postal_Code__c = Postal.leftPad(4, '0');
		insert residentialAddressM;

		Date birthDatemt = Date.newInstance(2000, 3, 9);
		Account accountMt = new Account();
		accountMt.ID_Number__pc = '9308305015012';
		accountMt.FirstName = 'MTest';
		accountMt.LastName = 'Tester';
		accountMt.PersonBirthdate = birthDatemt;
		accountMt.Gender__pc = 'Male';
		accountMt.Date_Issued__pc = Date.today();
		accountMt.Next_of_Kin_Last_Name__pc = 'Testing';
		accountMt.Next_of_Kin_First_Name_s__pc = 'Testing';
		accountMt.PersonOtherPhone = '0834527788';
		insert accountMt;

		Address__c residentialAddressMT = new Address__c(Account__c = accountMt.Id, Address_Type__c = 'Residential');

		residentialAddressMT.Shipping_Street__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('2601 DUTYWA MKOLWENI');
		residentialAddressMT.Shipping_Suburb__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('DUTYWA');
		residentialAddressMT.Shipping_City__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('IDUTYWA');
		String Postalm = '5000';
		residentialAddressMT.Shipping_Zip_Postal_Code__c = Postalm.leftPad(4, '0');
		insert residentialAddressMT;

		Date birthDatemLowRisk = Date.newInstance(2000, 3, 9);
		Account accountLowRisk = new Account();
		accountLowRisk.ID_Number__pc = '9308305015088';
		accountLowRisk.FirstName = 'TestLowRisk';
		accountLowRisk.LastName = 'Tester';
		accountLowRisk.PersonBirthdate = birthDatemLowRisk;
		accountLowRisk.Gender__pc = 'Male';
		accountLowRisk.Date_Issued__pc = Date.today();
		accountLowRisk.Next_of_Kin_Last_Name__pc = 'Testing';
		accountLowRisk.Next_of_Kin_First_Name_s__pc = 'Testing';
		accountLowRisk.PersonOtherPhone = '0834527788';
		accountLowRisk.CASA_Risk_Status__c = 'High';
		insert accountLowRisk;

		Address__c residentialAddressLowRisk = new Address__c(Account__c = accountLowRisk.Id, Address_Type__c = 'Residential');

		residentialAddressLowRisk.Shipping_Street__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('2601 DUTYWA MKOLWENI');
		residentialAddressLowRisk.Shipping_Suburb__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('DUTYWA');
		residentialAddressLowRisk.Shipping_City__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('IDUTYWA');
		String PostalLow = '5000';
		residentialAddressLowRisk.Shipping_Zip_Postal_Code__c = Postalm.leftPad(4, '0');
		insert residentialAddressLowRisk;

		Account acc = new Account();
		acc.FirstName = 'Test';
		acc.LastName = 'Account';
		acc.PersonEmail = 'test@account.com';
		acc.PersonMobilePhone = '0123456789';
		acc.ID_Number__pc = '8412117626084';
		acc.PersonBirthdate = Date.valueOf('1984-12-11');
		acc.Titles__pc = 'Mr';
		acc.CIF__c = 'TESTCUST01';
		acc.Next_of_Kin_Cellphone_Number__pc = '0123456789';
		acc.Next_of_Kin_Telephone_Number__pc = '0123456789';
		insert acc;

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
	}

	@isTest
	public static void testDummyResponse() {
		ASPDeviceDocumentScanningResponse test = new ASPDeviceDocumentScanningResponse();
		test.DummyResponse();
		System.assert(test != null, 'Received a response');
	}

	@isTest
	public static void ValidateFieldsTest() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestCVSServicesHelper' LIMIT 1];
		string documentUptakeProcess = 'IndividualOnboarding';
		string customerVerification = '{"WasHANISCancelled":false,"HANISCancelReason":null,"WasBioConsentGiven":false,"WasHANISServiceCallSuccessful":true,"HANISServiceResponse":{"ErrorCode":"0","errorDescription":null,"transactionID":null,"idNumber":"9308295015083","fpInd1":null,"finger1Result":"G","finger1Score":"0","fpInd2":null,"finger2Result":null,"finger2Score":"0","name":"PAUL JOHN","surname":"DU RANDT","maritalStatus":null,"image":"Y","dateIssued":"20180719","hasSmartCard":"Y","cert":"Y","sCallCentreNoField":null,"responseStatusDescription":null,"responseStatusCode":null,"sessionID":null},"WasCPBServiceCallSuccessful":true,"CPBServiceResponse":{"ErrorCode":null,"ErrorMessage":null,"SearchInformation":{"SearchUserName":"T_3000090001","Reference":"","SearchToken":"1fd9e183-dc7b-40e5-857a-098cb5a8bae2","SearchTypeDescription":"","SearchDescription":"9308295015083 DU RANDT","CallerModule":"BureauHouseAPI","SearchID":"1618840353.8586931","DataSupplier":"Consumer Profile Bureau","SearchType":"ProofOfResidence","ExtendedSections":"","ResponseType":"ProofOfResidence","ResponseObjectType":"Person"},"Person":{"PersonInformation":{"PersonID":"a58137f74f27718f37ec18e0eaf8bf2d","Title":"","Initials":"PJ","FirstName":"PAUL","Surname":"DU RANDT","IdNumber":"9308295015083","PassportNumber":"","MaritalStatus":"SINGLE","Gender":"Male","MiddleName1":"JOHN","MiddleName2":"","MiddleName3":"","Reference":"1fd9e183-dc7b-40e5-857a-098cb5a8bae2","DeceasedStatus":"NO","CurrentEmployer":"","HasPostMatricQual":"UNKNOWN","WhatQual":"UNKNOWN","DateOfBirth":"29/08/1993"},"ContactInformation":{"FaxNumber":"","WorkTelephoneNumber":"","HomeTelephoneNumber":"","MobileNumber":"0833813505","EmailAddress":""},"FinancialInformation":{"EverInsolvent":"UNKNOWN","IncomeBracket":"UNKNOWN"},"AddressInformation":{"ResidentialAddress":{"FirstReportedDate":"2017-04-10","AddCert":"Y","AddressID":"12819810292","TypeDescription":"RESIDENTIAL","TypeCode":"R","Line1":"30 COLLETT STREET","Line2":"","Line3":"RACEVIEW","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"30 COLLETT STREET, RACEVIEW, ALBERTON, 1449","LastUpdatedDate":"2021-04-19"},"PostalAddress":{"AddressID":"25067940852","TypeDescription":"POSTAL","TypeCode":"P","Line1":"PO BOX 17030","Line2":"","Line3":"RANDHART","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"PO BOX 17030, RANDHART, ALBERTON, 1449","LastUpdatedDate":"2021-04-19"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21D19B55237B5725118 A21D19B55237B572511 14 1848","DocumentId":"cd31a4b8-7ea4-4e10-8d23-78e33b348a6a"},"isHANISCertificateStoredInEcm":true,"HANISCertECMdetails":{"AddStatus":"OK","Pid":"92 3 ICM7 UGOLSDB13 Ent_ProofOfId59 26 A1001001A21D19B55209E5724518 A21D19B55209E572451 14 1854","DocumentId":"e073a54a-2f7a-4e8a-a104-5887bb461ba2"},"WasHANISAttestationSelected":true,"HANISAttestationValue":"YY","OverrideResponse":null,"OtpAuthenticationResponse":null,"OverallVerificationResult":true}';
		string result = ASPDeviceDocumentScanningController.GetDocumentScanningRequestMetadata(account.Id, documentUptakeProcess, customerVerification, false);
		System.assert(result != null, 'Received a response');
	}

	/**
	 * @description createTestAccount
	 * @return Account
	 */
	public static Account createTestAccount() {
		Account acc = new Account();

		acc.FirstName = 'Test';
		acc.LastName = 'DEAAccount';
		acc.PersonEmail = 'test@account.com';
		acc.PersonMobilePhone = '0123456789';
		acc.ID_Number__pc = '8412117626084';
		acc.PersonBirthdate = Date.valueOf('1984-12-11');
		acc.Titles__pc = 'Mr';
		acc.CIF__c = 'DEACUST001';
		acc.Next_of_Kin_Cellphone_Number__pc = '0123456789';
		acc.Next_of_Kin_Telephone_Number__pc = '0123456789';
		acc.Initials__pc = 'JA';
		acc.ID_Type__pc = 'SA Identity Document';
		insert acc;
		return acc;
	}

	private static void createResidentialAddress(Id accountId) {
		Address__c residentialAddressMT = new Address__c(Account__c = accountId, Address_Type__c = 'Residential');

		residentialAddressMT.Shipping_Street__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('2601 DUTYWA MKOLWENI');
		residentialAddressMT.Shipping_Suburb__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('DUTYWA');
		residentialAddressMT.Shipping_City__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat('IDUTYWA');
		String Postalm = '5000';
		residentialAddressMT.Shipping_Zip_Postal_Code__c = Postalm.leftPad(4, '0');
		insert residentialAddressMT;
	}

	private static void createTestIncomeExpense(Id applicationId) {
		Application_Income_and_Expense__c result = new Application_Income_and_Expense__c();
		result.Application__c = applicationId;
		result.Applicant_Value__c = 1;
		result.Category__c = 'Monthly Income';
		result.Expense_Value__c = 'Bank Statements Consent';
		insert result;
	}

	private static void CreateBankStatementDEASalaryInfo(Id applicationId) {
		Application_Financial_Account__c result = new Application_Financial_Account__c();
		result.Application__c = applicationId;
		result.Account_Holder_Name__c = 'Lottering';
		result.Account_Number__c = 404567890;
		result.Account_Type__c = 'Cheque';
		result.Institution_Name__c = 'ABSA Bank Limited';
		result.Account_Purpose__c = 'Salary';
		insert result;
		BankInfo__c bankInfo = new BankInfo__c();
		bankInfo.Name = 'ABSA Bank Limited';
		bankInfo.Bank_short_name__c = 'ABSA';
		bankInfo.Branch_code__c = '632005';
		insert bankInfo;
	}

	private static Application__c createTestApplication(Id accountId) {
		Application__c app = new Application__c();
		app.Account__c = accountId;
		insert app;
		createTestIncomeExpense(app.Id);
		CreateBankStatementDEASalaryInfo(app.Id);
		return app;
	}

	@isTest
	public static void ValidateDEAFieldsTest() {
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
			Test.startTest();
			Account account = createTestAccount();
			createResidentialAddress(account.Id);
			Application__c app = createTestApplication(account.id);
			string documentUptakeProcess = 'IndividualOnboarding';
			string customerVerification = '{"WasHANISCancelled":false,"HANISCancelReason":null,"WasBioConsentGiven":false,"WasHANISServiceCallSuccessful":true,"HANISServiceResponse":{"ErrorCode":"0","errorDescription":null,"transactionID":null,"idNumber":"9308295015083","fpInd1":null,"finger1Result":"G","finger1Score":"0","fpInd2":null,"finger2Result":null,"finger2Score":"0","name":"PAUL JOHN","surname":"DU RANDT","maritalStatus":null,"image":"Y","dateIssued":"20180719","hasSmartCard":"Y","cert":"Y","sCallCentreNoField":null,"responseStatusDescription":null,"responseStatusCode":null,"sessionID":null},"WasCPBServiceCallSuccessful":true,"CPBServiceResponse":{"ErrorCode":null,"ErrorMessage":null,"SearchInformation":{"SearchUserName":"T_3000090001","Reference":"","SearchToken":"1fd9e183-dc7b-40e5-857a-098cb5a8bae2","SearchTypeDescription":"","SearchDescription":"9308295015083 DU RANDT","CallerModule":"BureauHouseAPI","SearchID":"1618840353.8586931","DataSupplier":"Consumer Profile Bureau","SearchType":"ProofOfResidence","ExtendedSections":"","ResponseType":"ProofOfResidence","ResponseObjectType":"Person"},"Person":{"PersonInformation":{"PersonID":"a58137f74f27718f37ec18e0eaf8bf2d","Title":"","Initials":"PJ","FirstName":"PAUL","Surname":"DU RANDT","IdNumber":"9308295015083","PassportNumber":"","MaritalStatus":"SINGLE","Gender":"Male","MiddleName1":"JOHN","MiddleName2":"","MiddleName3":"","Reference":"1fd9e183-dc7b-40e5-857a-098cb5a8bae2","DeceasedStatus":"NO","CurrentEmployer":"","HasPostMatricQual":"UNKNOWN","WhatQual":"UNKNOWN","DateOfBirth":"29/08/1993"},"ContactInformation":{"FaxNumber":"","WorkTelephoneNumber":"","HomeTelephoneNumber":"","MobileNumber":"0833813505","EmailAddress":""},"FinancialInformation":{"EverInsolvent":"UNKNOWN","IncomeBracket":"UNKNOWN"},"AddressInformation":{"ResidentialAddress":{"FirstReportedDate":"2017-04-10","AddCert":"Y","AddressID":"12819810292","TypeDescription":"RESIDENTIAL","TypeCode":"R","Line1":"30 COLLETT STREET","Line2":"","Line3":"RACEVIEW","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"30 COLLETT STREET, RACEVIEW, ALBERTON, 1449","LastUpdatedDate":"2021-04-19"},"PostalAddress":{"AddressID":"25067940852","TypeDescription":"POSTAL","TypeCode":"P","Line1":"PO BOX 17030","Line2":"","Line3":"RANDHART","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"PO BOX 17030, RANDHART, ALBERTON, 1449","LastUpdatedDate":"2021-04-19"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21D19B55237B5725118 A21D19B55237B572511 14 1848","DocumentId":"cd31a4b8-7ea4-4e10-8d23-78e33b348a6a"},"isHANISCertificateStoredInEcm":true,"HANISCertECMdetails":{"AddStatus":"OK","Pid":"92 3 ICM7 UGOLSDB13 Ent_ProofOfId59 26 A1001001A21D19B55209E5724518 A21D19B55209E572451 14 1854","DocumentId":"e073a54a-2f7a-4e8a-a104-5887bb461ba2"},"WasHANISAttestationSelected":true,"HANISAttestationValue":"YY","OverrideResponse":null,"OtpAuthenticationResponse":null,"OverallVerificationResult":true}';
			string result = ASPDeviceDocumentScanningController.GetDocumentScanningRequestMetadata(app.Id, documentUptakeProcess, customerVerification, false);

			System.assert(result != null, 'Received a response');
			Test.stopTest();
		}
	}

	@isTest
	public static void CPBNotFound() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestCVSServicesHelper' LIMIT 1];
		string documentUptakeProcess = 'IndividualOnboarding';
		string customerVerification = '{"WasHANISCancelled":false,"HANISCancelReason":null,"WasBioConsentGiven":false,"WasHANISServiceCallSuccessful":true,"HANISServiceResponse":{"ErrorCode":"0","errorDescription":null,"transactionID":null,"idNumber":"9308295015083","fpInd1":null,"finger1Result":"G","finger1Score":"0","fpInd2":null,"finger2Result":null,"finger2Score":"0","name":"PAUL JOHN","surname":"DU RANDT","maritalStatus":null,"image":"Y","dateIssued":"20180719","hasSmartCard":"Y","cert":"Y","sCallCentreNoField":null,"responseStatusDescription":null,"responseStatusCode":null,"sessionID":null},"WasCPBServiceCallSuccessful":true,"CPBServiceResponse":{"ErrorCode":null,"ErrorMessage":null,"SearchInformation":{"SearchUserName":"T_3000090001","Reference":"","SearchToken":"1fd9e183-dc7b-40e5-857a-098cb5a8bae2","SearchTypeDescription":"","SearchDescription":"9308295015083 DU RANDT","CallerModule":"BureauHouseAPI","SearchID":"1618840353.8586931","DataSupplier":"Consumer Profile Bureau","SearchType":"ProofOfResidence","ExtendedSections":"","ResponseType":"ProofOfResidence","ResponseObjectType":"Person"},"Person":{"PersonInformation":{"PersonID":"a58137f74f27718f37ec18e0eaf8bf2d","Title":"","Initials":"PJ","FirstName":"PAUL","Surname":"DU RANDT","IdNumber":"9308295015083","PassportNumber":"","MaritalStatus":"SINGLE","Gender":"Male","MiddleName1":"JOHN","MiddleName2":"","MiddleName3":"","Reference":"1fd9e183-dc7b-40e5-857a-098cb5a8bae2","DeceasedStatus":"NO","CurrentEmployer":"","HasPostMatricQual":"UNKNOWN","WhatQual":"UNKNOWN","DateOfBirth":"29/08/1993"},"ContactInformation":{"FaxNumber":"","WorkTelephoneNumber":"","HomeTelephoneNumber":"","MobileNumber":"0833813505","EmailAddress":""},"FinancialInformation":{"EverInsolvent":"UNKNOWN","IncomeBracket":"UNKNOWN"},"AddressInformation":{"ResidentialAddress":{"FirstReportedDate":"2017-04-10","AddCert":"Y","AddressID":"12819810292","TypeDescription":"RESIDENTIAL","TypeCode":"R","Line1":"30 COLLETT STREET","Line2":"","Line3":"RACEVIEW","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"30 COLLETT STREET, RACEVIEW, ALBERTON, 1449","LastUpdatedDate":"2021-04-19"},"PostalAddress":{"AddressID":"25067940852","TypeDescription":"POSTAL","TypeCode":"P","Line1":"PO BOX 17030","Line2":"","Line3":"RANDHART","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"PO BOX 17030, RANDHART, ALBERTON, 1449","LastUpdatedDate":"2021-04-19"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":false,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21D19B55237B5725118 A21D19B55237B572511 14 1848","DocumentId":"cd31a4b8-7ea4-4e10-8d23-78e33b348a6a"},"isHANISCertificateStoredInEcm":true,"HANISCertECMdetails":{"AddStatus":"OK","Pid":"92 3 ICM7 UGOLSDB13 Ent_ProofOfId59 26 A1001001A21D19B55209E5724518 A21D19B55209E572451 14 1854","DocumentId":"e073a54a-2f7a-4e8a-a104-5887bb461ba2"},"WasHANISAttestationSelected":true,"HANISAttestationValue":"NN","OverrideResponse":null,"OtpAuthenticationResponse":null,"OverallVerificationResult":true}';
		string result = ASPDeviceDocumentScanningController.GetDocumentScanningRequestMetadata(account.Id, documentUptakeProcess, customerVerification, false);
		System.assert(result != null, 'Received a response');
	}

	@isTest
	public static void GetAllDocs() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestCVSServicesHelperCPB' LIMIT 1];
		string documentUptakeProcess = 'IndividualOnboarding';
		string customerVerification = '{"WasHANISCancelled":false,"HANISCancelReason":null,"WasBioConsentGiven":false,"WasHANISServiceCallSuccessful":true,"HANISServiceResponse":{"ErrorCode":"0","errorDescription":null,"transactionID":null,"idNumber":"9308295015083","fpInd1":null,"finger1Result":"G","finger1Score":"0","fpInd2":null,"finger2Result":null,"finger2Score":"0","name":"PAUL JOHN","surname":"DU RANDT","maritalStatus":null,"image":"Y","dateIssued":"20180719","hasSmartCard":"Y","cert":"Y","sCallCentreNoField":null,"responseStatusDescription":null,"responseStatusCode":null,"sessionID":null},"WasCPBServiceCallSuccessful":true,"CPBServiceResponse":{"ErrorCode":null,"ErrorMessage":null,"SearchInformation":{"SearchUserName":"T_3000090001","Reference":"","SearchToken":"1fd9e183-dc7b-40e5-857a-098cb5a8bae2","SearchTypeDescription":"","SearchDescription":"9308295015083 DU RANDT","CallerModule":"BureauHouseAPI","SearchID":"1618840353.8586931","DataSupplier":"Consumer Profile Bureau","SearchType":"ProofOfResidence","ExtendedSections":"","ResponseType":"ProofOfResidence","ResponseObjectType":"Person"},"Person":{"PersonInformation":{"PersonID":"a58137f74f27718f37ec18e0eaf8bf2d","Title":"","Initials":"PJ","FirstName":"PAUL","Surname":"DU RANDT","IdNumber":"9308295015083","PassportNumber":"","MaritalStatus":"SINGLE","Gender":"Male","MiddleName1":"JOHN","MiddleName2":"","MiddleName3":"","Reference":"1fd9e183-dc7b-40e5-857a-098cb5a8bae2","DeceasedStatus":"NO","CurrentEmployer":"","HasPostMatricQual":"UNKNOWN","WhatQual":"UNKNOWN","DateOfBirth":"29/08/1993"},"ContactInformation":{"FaxNumber":"","WorkTelephoneNumber":"","HomeTelephoneNumber":"","MobileNumber":"0833813505","EmailAddress":""},"FinancialInformation":{"EverInsolvent":"UNKNOWN","IncomeBracket":"UNKNOWN"},"AddressInformation":{"ResidentialAddress":{"FirstReportedDate":"2017-04-10","AddCert":"Y","AddressID":"12819810292","TypeDescription":"RESIDENTIAL","TypeCode":"R","Line1":"30 COLLETT STREET","Line2":"","Line3":"RACEVIEW","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"30 COLLETT STREET, RACEVIEW, ALBERTON, 1449","LastUpdatedDate":"2021-04-19"},"PostalAddress":{"AddressID":"25067940852","TypeDescription":"POSTAL","TypeCode":"P","Line1":"PO BOX 17030","Line2":"","Line3":"RANDHART","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"PO BOX 17030, RANDHART, ALBERTON, 1449","LastUpdatedDate":"2021-04-19"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21D19B55237B5725118 A21D19B55237B572511 14 1848","DocumentId":"cd31a4b8-7ea4-4e10-8d23-78e33b348a6a"},"isHANISCertificateStoredInEcm":true,"HANISCertECMdetails":{"AddStatus":"OK","Pid":"92 3 ICM7 UGOLSDB13 Ent_ProofOfId59 26 A1001001A21D19B55209E5724518 A21D19B55209E572451 14 1854","DocumentId":"e073a54a-2f7a-4e8a-a104-5887bb461ba2"},"WasHANISAttestationSelected":true,"HANISAttestationValue":"YY","OverrideResponse":null,"OtpAuthenticationResponse":null,"OverallVerificationResult":true}';
		string result = ASPDeviceDocumentScanningController.GetDocumentScanningRequestMetadata(account.Id, documentUptakeProcess, customerVerification, false);
		System.assert(result != null, 'Received a response');
	}

	@isTest
	public static void GetAllDocsM() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'MTest' LIMIT 1];
		string documentUptakeProcess = 'IndividualOnboarding';
		string customerVerification = '{ "WasHANISCancelled": true, "HANISCancelReason": "Customer with no finger", "WasBioConsentGiven": true, "WasHANISServiceCallSuccessful": false, "HANISServiceResponse": null, "WasCPBServiceCallSuccessful": true, "CPBServiceResponse": { "ErrorCode": null, "ErrorMessage": null, "SearchInformation": { "SearchUserName": "T_3000090001", "Reference": "", "SearchToken": "c17f988f-d539-49d7-abe9-b0e42701ae75", "SearchTypeDescription": "", "SearchDescription": "9403076002085 MALASHE", "CallerModule": "BureauHouseAPI", "SearchID": "1619189842.0850627", "DataSupplier": "Consumer Profile Bureau", "SearchType": "ProofOfResidence", "ExtendedSections": "", "ResponseType": "ProofOfResidence", "ResponseObjectType": "Person" }, "Person": { "PersonInformation": { "PersonID": "7b18b91493d7c7dbf55137d014e6a8d7", "Title": "", "Initials": "S", "FirstName": "SIYAKUDUMISA", "Surname": "MALASHE", "IdNumber": "9403076002085", "PassportNumber": "", "MaritalStatus": "SINGLE", "Gender": "Male", "MiddleName1": "", "MiddleName2": "", "MiddleName3": "", "Reference": "c17f988f-d539-49d7-abe9-b0e42701ae75", "DeceasedStatus": "NO", "CurrentEmployer": "", "HasPostMatricQual": "UNKNOWN", "WhatQual": "UNKNOWN", "DateOfBirth": "07/03/1994" }, "ContactInformation": { "FaxNumber": "", "WorkTelephoneNumber": "", "HomeTelephoneNumber": "", "MobileNumber": "0780300654", "EmailAddress": "" }, "FinancialInformation": { "EverInsolvent": "UNKNOWN", "IncomeBracket": "UNKNOWN" }, "AddressInformation": { "ResidentialAddress": { "FirstReportedDate": "2019-04-26", "AddCert": "Y", "AddressID": "38885992913", "TypeDescription": "RESIDENTIAL", "TypeCode": "R", "Line1": "2601 DUTYWA MKOLWENI", "Line2": "", "Line3": "DUTYWA", "Line4": "IDUTYWA", "PostalCode": "5000", "FullAddress":"2601 DUTYWA MKOLWENI, DUTYWA, IDUTYWA, 5000","LastUpdatedDate":"2021-04-23"},"PostalAddress":{"AddressID":"0","TypeDescription":"POSTAL","TypeCode":"P","Line1":"","Line2":"","Line3":"","Line4":"","PostalCode":"","FullAddress":"","LastUpdatedDate":"2021-04-23"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21D23B65725J2162518 A21D23B65725J216251 14 1848","DocumentId":"497e9990-d45d-4bc2-b8e2-726c22d44d79"},"isHANISCertificateStoredInEcm":false,"HANISCertECMdetails":null,"WasHANISAttestationSelected":false,"HANISAttestationValue":null,"OverrideResponse":null,"OtpAuthenticationResponse":null,"OverallVerificationResult":false}';
		string result = ASPDeviceDocumentScanningController.GetDocumentScanningRequestMetadata(account.Id, documentUptakeProcess, customerVerification, false);
		System.assert(result != null, 'Received a response');
	}

	@isTest
	public static void GetAllDocsMNoneScored() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'MTest' LIMIT 1];
		string documentUptakeProcess = 'IndividualOnboarding';
		string customerVerification = '{ "WasHANISCancelled": true, "HANISCancelReason": "Customer with no finger", "WasBioConsentGiven": true, "WasHANISServiceCallSuccessful": false, "HANISServiceResponse": null, "WasCPBServiceCallSuccessful": true, "CPBServiceResponse": { "ErrorCode": null, "ErrorMessage": null, "SearchInformation": { "SearchUserName": "T_3000090001", "Reference": "", "SearchToken": "c17f988f-d539-49d7-abe9-b0e42701ae75", "SearchTypeDescription": "", "SearchDescription": "9403076002085 MALASHE", "CallerModule": "BureauHouseAPI", "SearchID": "1619189842.0850627", "DataSupplier": "Consumer Profile Bureau", "SearchType": "ProofOfResidence", "ExtendedSections": "", "ResponseType": "ProofOfResidence", "ResponseObjectType": "Person" }, "Person": { "PersonInformation": { "PersonID": "7b18b91493d7c7dbf55137d014e6a8d7", "Title": "", "Initials": "S", "FirstName": "SIYAKUDUMISA", "Surname": "MALASHE", "IdNumber": "9403076002085", "PassportNumber": "", "MaritalStatus": "SINGLE", "Gender": "Male", "MiddleName1": "", "MiddleName2": "", "MiddleName3": "", "Reference": "c17f988f-d539-49d7-abe9-b0e42701ae75", "DeceasedStatus": "NO", "CurrentEmployer": "", "HasPostMatricQual": "UNKNOWN", "WhatQual": "UNKNOWN", "DateOfBirth": "07/03/1994" }, "ContactInformation": { "FaxNumber": "", "WorkTelephoneNumber": "", "HomeTelephoneNumber": "", "MobileNumber": "0780300654", "EmailAddress": "" }, "FinancialInformation": { "EverInsolvent": "UNKNOWN", "IncomeBracket": "UNKNOWN" }, "AddressInformation": { "ResidentialAddress": { "FirstReportedDate": "2019-04-26", "AddCert": "Y", "AddressID": "38885992913", "TypeDescription": "RESIDENTIAL", "TypeCode": "R", "Line1": "2601 DUTYWA MKOLWENI", "Line2": "", "Line3": "DUTYWA", "Line4": "IDUTYWA", "PostalCode": "5000", "FullAddress":"2601 DUTYWA MKOLWENI, DUTYWA, IDUTYWA, 5000","LastUpdatedDate":"2021-04-23"},"PostalAddress":{"AddressID":"0","TypeDescription":"POSTAL","TypeCode":"P","Line1":"","Line2":"","Line3":"","Line4":"","PostalCode":"","FullAddress":"","LastUpdatedDate":"2021-04-23"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21D23B65725J2162518 A21D23B65725J216251 14 1848","DocumentId":"497e9990-d45d-4bc2-b8e2-726c22d44d79"},"isHANISCertificateStoredInEcm":false,"HANISCertECMdetails":null,"WasHANISAttestationSelected":false,"HANISAttestationValue":null,"OverrideResponse":null,"OtpAuthenticationResponse":null,"OverallVerificationResult":false}';
		string result = ASPDeviceDocumentScanningController.GetDocumentScanningRequestMetadata(account.Id, documentUptakeProcess, customerVerification, true);
		System.assert(result != null, 'Received a response');
	}

	@isTest
	public static void LowRiskCustomer() {
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestLowRisk' LIMIT 1];
		string documentUptakeProcess = 'IndividualOnboarding';
		string customerVerification = '{ "WasHANISCancelled": true, "HANISCancelReason": "Customer with no finger", "WasBioConsentGiven": true, "WasHANISServiceCallSuccessful": false, "HANISServiceResponse": null, "WasCPBServiceCallSuccessful": true, "CPBServiceResponse": { "ErrorCode": null, "ErrorMessage": null, "SearchInformation": { "SearchUserName": "T_3000090001", "Reference": "", "SearchToken": "c17f988f-d539-49d7-abe9-b0e42701ae75", "SearchTypeDescription": "", "SearchDescription": "9403076002085 MALASHE", "CallerModule": "BureauHouseAPI", "SearchID": "1619189842.0850627", "DataSupplier": "Consumer Profile Bureau", "SearchType": "ProofOfResidence", "ExtendedSections": "", "ResponseType": "ProofOfResidence", "ResponseObjectType": "Person" }, "Person": { "PersonInformation": { "PersonID": "7b18b91493d7c7dbf55137d014e6a8d7", "Title": "", "Initials": "S", "FirstName": "SIYAKUDUMISA", "Surname": "MALASHE", "IdNumber": "9403076002085", "PassportNumber": "", "MaritalStatus": "SINGLE", "Gender": "Male", "MiddleName1": "", "MiddleName2": "", "MiddleName3": "", "Reference": "c17f988f-d539-49d7-abe9-b0e42701ae75", "DeceasedStatus": "NO", "CurrentEmployer": "", "HasPostMatricQual": "UNKNOWN", "WhatQual": "UNKNOWN", "DateOfBirth": "07/03/1994" }, "ContactInformation": { "FaxNumber": "", "WorkTelephoneNumber": "", "HomeTelephoneNumber": "", "MobileNumber": "0780300654", "EmailAddress": "" }, "FinancialInformation": { "EverInsolvent": "UNKNOWN", "IncomeBracket": "UNKNOWN" }, "AddressInformation": { "ResidentialAddress": { "FirstReportedDate": "2019-04-26", "AddCert": "Y", "AddressID": "38885992913", "TypeDescription": "RESIDENTIAL", "TypeCode": "R", "Line1": "2601 DUTYWA MKOLWENI", "Line2": "", "Line3": "DUTYWA", "Line4": "IDUTYWA", "PostalCode": "5000", "FullAddress":"2601 DUTYWA MKOLWENI, DUTYWA, IDUTYWA, 5000","LastUpdatedDate":"2021-04-23"},"PostalAddress":{"AddressID":"0","TypeDescription":"POSTAL","TypeCode":"P","Line1":"","Line2":"","Line3":"","Line4":"","PostalCode":"","FullAddress":"","LastUpdatedDate":"2021-04-23"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21D23B65725J2162518 A21D23B65725J216251 14 1848","DocumentId":"497e9990-d45d-4bc2-b8e2-726c22d44d79"},"isHANISCertificateStoredInEcm":false,"HANISCertECMdetails":null,"WasHANISAttestationSelected":false,"HANISAttestationValue":null,"OverrideResponse":null,"OtpAuthenticationResponse":null,"OverallVerificationResult":false}';
		string result = ASPDeviceDocumentScanningController.GetDocumentScanningRequestMetadata(account.Id, documentUptakeProcess, customerVerification, true);
		System.assert(result != null, 'Received a response');
	}
}
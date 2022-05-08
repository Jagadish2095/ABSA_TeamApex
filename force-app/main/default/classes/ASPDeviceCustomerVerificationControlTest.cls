/**
 * @description       : ASPDeviceCustomerVerificationControlTest
 * @author            : PaulJohn.duRand@absa.africa
 * @created 2021-02-08
 * @last modified on  : 2021-07-02
 * @last modified by  : PaulJohn.duRand@absa.africa
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   2021-07-02   PaulJohn.duRand@absa.africa   Shipping_Street_2__c and PMD
 **/

@isTest
public class ASPDeviceCustomerVerificationControlTest {
	@testSetup
	static void dataCreation() {
		Date birthDate = Date.newInstance(2000, 3, 9);
		Account account = new Account();
		account.ID_Number__pc = '9308305015082';
		account.FirstName = 'TestDeviceUser';
		account.LastName = 'Tester';
		account.PersonBirthdate = birthDate;
		account.Gender__pc = 'Male';
		account.Date_Issued__pc = Date.today();
		account.Next_of_Kin_Last_Name__pc = 'Testing';
		account.Next_of_Kin_First_Name_s__pc = 'Testing';
		account.PersonOtherPhone = '0834527788';
		insert account;
	}

	@isTest
	public static void testDummyRequest() {
        Test.startTest();
		ASPDeviceCustomerVerificationRequest response = new ASPDeviceCustomerVerificationRequest();
		response.DummyRequest();
        System.assert(response != null, 'Test Working');
        Test.stopTest();
	}

	@isTest
	public static void testDummyResponse() {
        Test.startTest();
		ASPDeviceCustomerVerificationResponse response = new ASPDeviceCustomerVerificationResponse();
		response.Dummyresponse();
        System.assert(response != null, 'Test Working');
        Test.stopTest();
	}

	@isTest
	public static void GetCustomerVerificationRequestMetadata() {
		Test.startTest();
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestDeviceUser' LIMIT 1];
		string result = ASPDeviceCustomerVerificationController.GetCustomerVerificationRequestMetadata((String) account.Id, '', '', '', '');
        System.assert(result != null, 'Test Working');
		Test.stopTest();
	}

	@isTest
	public static void GetCustomerVerificationResponseMetadata() {
		Test.startTest();
		String Response = '{"HANISAttestationValue":"YY","WasHANISCancelled":false,"HANISCancelReason":null,"WasBioConsentGiven":false,"WasHANISServiceCallSuccessful":true,"HANISServiceResponse":{"ErrorCode":"0","errorDescription":null,"transactionID":null,"idNumber":"9308295015083","fpInd1":null,"finger1Result":"G","finger1Score":"0","fpInd2":null,"finger2Result":null,"finger2Score":"0","name":"PAUL JOHN","surname":"DU RANDT","maritalStatus":null,"image":"Y","dateIssued":"20180719","hasSmartCard":"Y","cert":"Y","sCallCentreNoField":null,"responseStatusDescription":null,"responseStatusCode":null,"sessionID":null},"WasCPBServiceCallSuccessful":true,"CPBServiceResponse":{"ErrorCode":null,"ErrorMessage":null,"SearchInformation":{"SearchUserName":"T_3000090001","Reference":"","SearchToken":"db955b43-a5fa-4826-afc3-76b7c58a662b","SearchTypeDescription":"","SearchDescription":"9308295015083 DU RANDT","CallerModule":"BureauHouseAPI","SearchID":"1612301057.7554283","DataSupplier":"Consumer Profile Bureau","SearchType":"ProofOfResidence","ExtendedSections":"","ResponseType":"ProofOfResidence","ResponseObjectType":"Person"},"Person":{"PersonInformation":{"PersonID":"a58137f74f27718f37ec18e0eaf8bf2d","Title":"MR","Initials":"PJ","FirstName":"PAUL","Surname":"DU RANDT","IdNumber":"9308295015083","PassportNumber":"","MaritalStatus":"SINGLE","Gender":"Male","MiddleName1":"JOHN","MiddleName2":"","MiddleName3":"","Reference":"db955b43-a5fa-4826-afc3-76b7c58a662b","DeceasedStatus":"NO","CurrentEmployer":"","HasPostMatricQual":"UNKNOWN","WhatQual":"UNKNOWN","DateOfBirth":"29/08/1993"},"ContactInformation":{"FaxNumber":"","WorkTelephoneNumber":"","HomeTelephoneNumber":"","MobileNumber":"","EmailAddress":""},"FinancialInformation":{"EverInsolvent":"UNKNOWN","IncomeBracket":"UNKNOWN"},"AddressInformation":{"ResidentialAddress":{"FirstReportedDate":"2017-04-10","AddCert":"Y","AddressID":"12819810292","TypeDescription":"RESIDENTIAL","TypeCode":"R","Line1":"30 COLLETT STREET","Line2":"","Line3":"RACEVIEW","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"30 COLLETT STREET, RACEVIEW, ALBERTON, 1449","LastUpdatedDate":"2021-02-02"},"PostalAddress":{"AddressID":"19213901812","TypeDescription":"POSTAL","TypeCode":"P","Line1":"PO BOX 17030","Line2":"","Line3":"RANDHART","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"PO BOX 17030, RANDHART, ALBERTON, 1449","LastUpdatedDate":"2021-02-02"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21B02C32423F7165218 A21B02C32423F716521 14 1848","DocumentId":"8bf7076e-3213-48bf-a508-05803b8ec804"},"isHANISCertificateStoredInEcm":true,"HANISCertECMdetails":{"AddStatus":"OK","Pid":"92 3 ICM7 UGOLSDB13 Ent_ProofOfId59 26 A1001001A21B02C32405E7162818 A21B02C32405E716281 14 1854","DocumentId":"b70cebe9-9bb4-4ba5-b3b1-18c752d5b711"},"WasHANISAttestationSelected":true}';
		ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse = ASPDeviceCustomerVerificationController.GetCustomerVerificationResponseMetadata(
			Response
		);
		deviceCustomerVerificationResponse = ASPDeviceCustomerVerificationController.GetCustomerVerificationResponseMetadata(Response);
		deviceCustomerVerificationResponse.WasHANISCancelled = true;
        System.assert(deviceCustomerVerificationResponse != null, 'Test Working');
		Test.stopTest();
	}

	@isTest
	public static void TestSetDataFromDHACPBa() {
		Test.startTest();
		String Response = '{"HANISAttestationValue":"YY","WasHANISCancelled":false,"HANISCancelReason":null,"WasBioConsentGiven":false,"WasHANISServiceCallSuccessful":true,"HANISServiceResponse":{"ErrorCode":"0","errorDescription":null,"transactionID":null,"idNumber":"9308295015083","fpInd1":null,"finger1Result":"G","finger1Score":"0","fpInd2":null,"finger2Result":null,"finger2Score":"0","name":"PAUL JOHN","surname":"DU RANDT","maritalStatus":null,"image":"Y","dateIssued":"20180719","hasSmartCard":"Y","cert":"Y","sCallCentreNoField":null,"responseStatusDescription":null,"responseStatusCode":null,"sessionID":null},"WasCPBServiceCallSuccessful":true,"CPBServiceResponse":{"ErrorCode":null,"ErrorMessage":null,"SearchInformation":{"SearchUserName":"T_3000090001","Reference":"","SearchToken":"db955b43-a5fa-4826-afc3-76b7c58a662b","SearchTypeDescription":"","SearchDescription":"9308295015083 DU RANDT","CallerModule":"BureauHouseAPI","SearchID":"1612301057.7554283","DataSupplier":"Consumer Profile Bureau","SearchType":"ProofOfResidence","ExtendedSections":"","ResponseType":"ProofOfResidence","ResponseObjectType":"Person"},"Person":{"PersonInformation":{"PersonID":"a58137f74f27718f37ec18e0eaf8bf2d","Title":"MR","Initials":"PJ","FirstName":"PAUL","Surname":"DU RANDT","IdNumber":"9308295015083","PassportNumber":"","MaritalStatus":"SINGLE","Gender":"Male","MiddleName1":"JOHN","MiddleName2":"","MiddleName3":"","Reference":"db955b43-a5fa-4826-afc3-76b7c58a662b","DeceasedStatus":"NO","CurrentEmployer":"","HasPostMatricQual":"UNKNOWN","WhatQual":"UNKNOWN","DateOfBirth":"29/08/1993"},"ContactInformation":{"FaxNumber":"","WorkTelephoneNumber":"","HomeTelephoneNumber":"","MobileNumber":"","EmailAddress":""},"FinancialInformation":{"EverInsolvent":"UNKNOWN","IncomeBracket":"UNKNOWN"},"AddressInformation":{"ResidentialAddress":{"FirstReportedDate":"2017-04-10","AddCert":"Y","AddressID":"12819810292","TypeDescription":"RESIDENTIAL","TypeCode":"R","Line1":"30 COLLETT STREET","Line2":"","Line3":"RACEVIEW","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"30 COLLETT STREET, RACEVIEW, ALBERTON, 1449","LastUpdatedDate":"2021-02-02"},"PostalAddress":{"AddressID":"19213901812","TypeDescription":"POSTAL","TypeCode":"P","Line1":"PO BOX 17030","Line2":"","Line3":"RANDHART","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"PO BOX 17030, RANDHART, ALBERTON, 1449","LastUpdatedDate":"2021-02-02"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"OK","Pid":"97 3 ICM7 UGOLSDB18 Ent_ProofOfAddress59 26 A1001001A21B02C32423F7165218 A21B02C32423F716521 14 1848","DocumentId":"8bf7076e-3213-48bf-a508-05803b8ec804"},"isHANISCertificateStoredInEcm":true,"HANISCertECMdetails":{"AddStatus":"OK","Pid":"92 3 ICM7 UGOLSDB13 Ent_ProofOfId59 26 A1001001A21B02C32405E7162818 A21B02C32405E716281 14 1854","DocumentId":"b70cebe9-9bb4-4ba5-b3b1-18c752d5b711"},"WasHANISAttestationSelected":true}';
		Account account = [SELECT Id FROM Account WHERE FirstName = 'TestDeviceUser' LIMIT 1];
		Boolean b = ASPDeviceCustomerVerificationController.SetDataFromDHACPB(String.valueOf(account.id), Response);
        System.assert(b == true, 'Test Working');
		Test.stopTest();
	}
}
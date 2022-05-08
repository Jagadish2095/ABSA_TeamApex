/*
 * Test Integration Handler for CPBValidate Service
 * @author Prashant Jain
 * @created 2020-02-06
 */
@isTest
public class CPBValidate_IH_v1_Test {
	@isTest
	static void validateCPBValidatePositive() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CPB_VALIDATE });

		Test.startTest();

		Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate('7707077777087', 'Burger');
		// Get first key from the map
		CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(200, responseBean.statusCode);

		Test.stopTest();
	}

	@isTest
	static void validateCPBValidateNegative() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CPB_VALIDATE });

		Test.startTest();

		Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate('7707077777087', 'Burger');
		// Get first key from the map
		CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void validateCPBValidateNoIntegrationSettings() {
		// This causes a fake response to be sent from the class that implements HttpCalloutMock.
		Test.startTest();

		Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate('7707077777087', 'Burger');
		// Get first key from the map
		CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];

		Test.stopTest();
		system.assert(responseBean.statusCode != 200, responseBean.statusCode);
	}

	@isTest
	static void validateCPBValidateException() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CPB_VALIDATE });

		Test.startTest();

		Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate('7707077777087', 'Burger');
		// Get first key from the map
		CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);

		Test.stopTest();
	}

	@isTest
	static void validateCPBRequest() {
		Test.startTest();
		CPBValidate_Req_IB_v1 requestBean = CPBValidate_Req_IB_v1.createDummyRequest();

		Test.stopTest();
		System.assertEquals('CPB_VALIDATE', requestBean.serviceID, 'Asset Failed');
	}

	@isTest
	static void validateCPBValidate_Resp_IB_v1() {
		CPBValidate_Resp_IB_v1 testResp = new CPBValidate_Resp_IB_v1();
		testResp.status = 'test';
		testResp.statusCode = 1;
		testResp.message = 'test';

		CPBValidate_Resp_IB_v1.SearchInformation testSearchInformation = new CPBValidate_Resp_IB_v1.SearchInformation();
		testSearchInformation.SearchUserName = 'test';
		testSearchInformation.ReportDate = 'test';
		testSearchInformation.Reference = 'test';
		testSearchInformation.SearchToken = 'test';
		testSearchInformation.SearchTypeDescription = 'test';
		testSearchInformation.SearchDescription = 'test';
		testSearchInformation.CallerModule = 'test';
		testSearchInformation.SearchID = 'test';
		testSearchInformation.DataSupplier = 'test';
		testSearchInformation.SearchType = 'test';
		testSearchInformation.ExtendedSections = 'test';
		testSearchInformation.ResponseType = 'test';
		testSearchInformation.ResponseObjectType = 'test';

		CPBValidate_Resp_IB_v1.Person testPerson = new CPBValidate_Resp_IB_v1.Person();
		CPBValidate_Resp_IB_v1.PersonInformation testPersonInformation = new CPBValidate_Resp_IB_v1.PersonInformation();
		testPersonInformation.PersonID = 'test';
		testPersonInformation.Title = 'test';
		testPersonInformation.DateOfBirth = 'test';
		testPersonInformation.Initials = 'test';
		testPersonInformation.FirstName = 'test';
		testPersonInformation.Surname = 'test';
		testPersonInformation.IDNumber = 'test';
		testPersonInformation.PassportNumber = 'test';
		testPersonInformation.MaritalStatus = 'test';
		testPersonInformation.Gender = 'test';
		testPersonInformation.MiddleName1 = 'test';
		testPersonInformation.MiddleName2 = 'test';
		testPersonInformation.MiddleName3 = 'test';
		testPersonInformation.Reference = 'test';
		testPersonInformation.DeceasedStatus = 'test';
		testPersonInformation.DeceasedDate = 'test';
		testPersonInformation.CurrentEmployer = 'test';
		testPersonInformation.HasPostMatricQual = 'test';
		testPersonInformation.WhatQual = 'test';

		CPBValidate_Resp_IB_v1.ContactInformation testContactInformation = new CPBValidate_Resp_IB_v1.ContactInformation();
		testContactInformation.EmailAddress = 'test';
		testContactInformation.MobileNumber = 'test';
		testContactInformation.HomeTelephoneNumber = 'test';
		testContactInformation.WorkTelephoneNumber = 'test';
		testContactInformation.FaxNumber = 'test';

		CPBValidate_Resp_IB_v1.FinancialInformation testFinancialInformation = new CPBValidate_Resp_IB_v1.FinancialInformation();
		testFinancialInformation.EverInsolvent = 'test';
		testFinancialInformation.IncomeBracket = 'test';

		CPBValidate_Resp_IB_v1.AddressInformation testAddress = new CPBValidate_Resp_IB_v1.AddressInformation();
		CPBValidate_Resp_IB_v1.ResidentialAddress testResidentialAddress = new CPBValidate_Resp_IB_v1.ResidentialAddress();
		testResidentialAddress.FirstReportedDate = 'test';
		testResidentialAddress.AddCert = 'test';
		testResidentialAddress.AddressID = 'test';
		testResidentialAddress.TypeDescription = 'test';
		testResidentialAddress.TypeCode = 'test';
		testResidentialAddress.Line1 = 'test';
		testResidentialAddress.Line2 = 'test';
		testResidentialAddress.Line3 = 'test';
		testResidentialAddress.Line4 = 'test';
		testResidentialAddress.PostalCode = 'test';
		testResidentialAddress.FullAddress = 'test';
		testResidentialAddress.LastUpdatedDate = 'test';

		CPBValidate_Resp_IB_v1.PostalAddress testPostalAddress = new CPBValidate_Resp_IB_v1.PostalAddress();
		testPostalAddress.AddressID = 'test';
		testPostalAddress.TypeDescription = 'test';
		testPostalAddress.TypeCode = 'test';
		testPostalAddress.Line1 = 'test';
		testPostalAddress.Line2 = 'test';
		testPostalAddress.Line3 = 'test';
		testPostalAddress.Line4 = 'test';
		testPostalAddress.PostalCode = 'test';
		testPostalAddress.FullAddress = 'test';
		testPostalAddress.LastUpdatedDate = 'test';
		System.assertEquals('test', testPostalAddress.AddressID, 'Asset Failed');
	}
}
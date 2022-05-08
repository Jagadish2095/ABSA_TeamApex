/**
 * @description This is the Lookup Controller test class
 *
 * @author   Nelson Chisoko (Dariel)
 * @since    2019/03/11
 */

@IsTest
private class LookupControllerTest {
	static Profile testProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Standard User (Custom)'];

	@isTest
	private static void testFetchLookUpValues() {
		List<SObject> result = LookupController.fetchLookUpValues('a1234', 'Employee__c', null);

		System.assert(result != null);

		Service_Type__c serviceType = new Service_Type__c(
			Name = 'TestType',
			Case_Record_Type__c = 'Service Request',
			Subtype__c = 'SubtypeTest',
			Type__c = 'TestType'
		);
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'TestGroup',
			Assign_Record_Type__c = 'Service Request',
			Response_Email_Address__c = 'testclass@test.com',
			Queue__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '8'
		);
		insert serviceGr;
		List<String> serviceGroupList = new List<String>();
		serviceGroupList.add(serviceGr.Name);

		Service_Level__c serviceLevel = new Service_Level__c(
			Name = 'TestServiceLevel',
			External_SLA_Time_Measure__c = 'Hour(s)',
			External_SLA_Units__c = '8',
			Default_Service_Level__c = true
		);
		insert serviceLevel;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
			Service_Type__c = serviceType.Id,
			Service_Group__c = serviceGr.Id,
			Service_Level__c = serviceLevel.Id,
			Auto_Case_Creation__c = true
		);
		insert serviceGrType;

		List<SObject> result1 = LookupController.fetchLookUpValues(serviceType.Name, 'Service_Group_Type__c', serviceGroupList);

		System.assert(result1 != null);

		//Employee__c based testing

		/*
Method params: String firstName, String middleName, String lastName, String initials, String idNumber, String idType,
String email, String mobile, String employeeNumber, String BRID, String abNumber, String adviserCode
*/
		WillsTestDataFactory.createEmployee(
			'Test',
			null,
			'User',
			'T',
			'9206146218096',
			'SA Identity Document',
			'test@test.com',
			'0123456789',
			'E00001',
			'B00001',
			'AB00001',
			'A12345'
		);

		result = LookupController.fetchLookUpValues('A1234', 'Employee__c', null);

		System.assert(result != null);

		//Service_Type__c based testing : Added against W-002766 dated 31/08/2019 by chandra

		/*
Method params: String name, String type, String subtype
*/
		WillsTestDataFactory.createServiceType('Dispute Debit Order', 'Query', 'Debit Order');

		result = LookupController.fetchLookUpValues('Dispute Debit', 'Service_Type__c', null);

		System.assert(result != null);
	}

	@isTest
	private static void testFetchSiteValues() {
		Site__c testSite;
		List<SObject> result;

		//Employee_Site__c based testing
		Employee__c testEmployee;
		Employee_Site__c testEmployeeSite;

		/*
Method params: String firstName, String middleName, String lastName, String initials, String idNumber, String idType,
String email, String mobile, String employeeNumber, String BRID, String abNumber, String adviserCode
*/
		testEmployee = WillsTestDataFactory.createEmployee(
			'Test',
			null,
			'User',
			'T',
			'9206146218096',
			'SA Identity Document',
			'test@test.com',
			'0123456789',
			'E00001',
			'B00001',
			'AB00001',
			'A12345'
		);

		testSite = WillsTestDataFactory.createSite('Test Site', '80001');

		testEmployeeSite = WillsTestDataFactory.createEmployeeSite(testEmployee.Id, testSite.Id);

		Service_Type__c serviceType = new Service_Type__c(
			Name = 'onboard client',
			Case_Record_Type__c = 'Service Request',
			Subtype__c = 'SubtypeTest',
			Type__c = 'TestType'
		);
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'TestGroup',
			Assign_Record_Type__c = 'Service Request',
			Response_Email_Address__c = 'testclass@test.com',
			Queue__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '8'
		);
		insert serviceGr;
		List<String> serviceGroupList = new List<String>();
		serviceGroupList.add(serviceGr.Name);

		Service_Level__c serviceLevel = new Service_Level__c(
			Name = 'TestServiceLevel',
			External_SLA_Time_Measure__c = 'Hour(s)',
			External_SLA_Units__c = '8',
			Default_Service_Level__c = true
		);
		insert serviceLevel;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
			Service_Type__c = serviceType.Id,
			Service_Group__c = serviceGr.Id,
			Service_Level__c = serviceLevel.Id,
			Auto_Case_Creation__c = true
		);
		insert serviceGrType;

		result = LookupController.fetchSiteValues('Test', 'Site__c');
		System.assert(result != null);
		LookupController.fetchLookUpFinProductValues('a1343', 'Financial_Product__c');
		LookupController.fetchLookUpProductValues('a1343', 'Product2');
		LookupController.fetchLookUpValuesforOnboarding(serviceType.Name, 'Service_Group_Type__c', serviceGroupList);
	}

	//test method to test FetchBranchSiteCodeValues() of LookupController dated 05/11/2019 by chandra
	@isTest
	private static void testFetchBranchSiteCodeValues() {
		List<SObject> result;

		result = LookupController.fetchBranchSiteCodeValues('MAURITIUS');
		System.assert(result != null);
		LookupController.fetchSiteValues('Test', 'Employee__c');
	}

	//test method to test getUserServiceGroups() of LookupController dated 16/09/2020 by Humbe
	@isTest
	private static void testgetUserServiceGroups() {
		Service_Type__c serviceType = new Service_Type__c(
			Name = 'onboard client',
			Case_Record_Type__c = 'Service Request',
			Subtype__c = 'SubtypeTest',
			Type__c = 'TestType'
		);
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'TestGroup',
			Assign_Record_Type__c = 'Service Request',
			Response_Email_Address__c = 'testclass@test.com',
			Queue__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '8'
		);
		insert serviceGr;

		List<String> serviceGroupList = new List<String>();
		serviceGroupList.add(serviceGr.Name);

		Service_Level__c serviceLevel = new Service_Level__c(
			Name = 'TestServiceLevel',
			External_SLA_Time_Measure__c = 'Hour(s)',
			External_SLA_Units__c = '8',
			Default_Service_Level__c = true
		);
		insert serviceLevel;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
			Service_Type__c = serviceType.Id,
			Service_Group__c = serviceGr.Id,
			Service_Level__c = serviceLevel.Id,
			Auto_Case_Creation__c = true
		);
		insert serviceGrType;

		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		String uid = h.SubString(0, 8);
		User testUser = new User(
			Alias = uid,
			Email = uid + '@myorg.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Testing',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = p.Id,
			TimeZoneSidKey = 'America/New_York',
			UserName = uid + '@myorg.com'
		);
		insert testUser;

		Service_Group_User_Entry__c userEntry = new Service_Group_User_Entry__c();
		userEntry.User__c = testUser.id;
		userEntry.Service_Group__c = serviceGr.id;

		List<string> result;
		System.runAs(testUser) {
			result = LookupController.getUserServiceGroups();
			System.assert(result != null);
		}

	}

	//test method to test getUserSalesGroups() of LookupController dated 22/06/2021 by Chandra against W-012959
	@isTest
	private static void testgetUserSalesGroups() {
		Sales_Group__c salesGr = new Sales_Group__c(Name = 'TestGroup');
		insert salesGr;

		List<String> salesGroupList = new List<String>();
		salesGroupList.add(salesGr.Name);

		Sales_Group_User_Entry__c userEntry = new Sales_Group_User_Entry__c();
		userEntry.User__c = UserInfo.getUserId();
		userEntry.Sales_Group__c = salesGr.id;

		List<string> result = LookupController.getUserSalesGroups();
		System.assert(result != null);
	}

	//test method to test fetchLookUpValuesforSales() of LookupController dated 22/06/2021 by Chandra against W-012959
	@isTest
	private static void testfetchLookUpValuesforSales() {
		Sales_Group__c salesGroup = new Sales_Group__c();
		salesGroup.Name = 'Test Group';
		insert salesGroup;

		Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c();
		salesProcessType.Name = 'Test Sales Type';
		salesProcessType.Opportunity_Record_Type__c = 'Credit Onboarding';
		salesProcessType.Request_Name__c = 'Service Request';
		insert salesProcessType;

		Sales_Group_Process_Type__c salesGroupProcessType = new Sales_Group_Process_Type__c();
		salesGroupProcessType.Name = 'Test';
		salesGroupProcessType.Sales_Group__c = salesGroup.Id;
		salesGroupProcessType.Sales_Process_Type__c = salesProcessType.Id;
		insert salesGroupProcessType;

		Sales_Group_User_Entry__c salesGroupUserEntry = new Sales_Group_User_Entry__c();
		salesGroupUserEntry.Sales_Group__c = salesGroup.Id;
		salesGroupUserEntry.User__c = UserInfo.getUserId();
		insert salesGroupUserEntry;

		List<String> salesGroups = new List<String>();
		salesGroups.add(salesGroup.Name);

		List<Sales_Group_Process_Type__c> lstOfSalesGroupProcessType = LookupController.fetchLookUpValuesforSales('Test', salesGroups);
		system.assertEquals(1, lstOfSalesGroupProcessType.size());
	}
	
}
/**
 * @description Test Class for VAPSInsuranceCancellationController
 * @Author Jason Quevauvilliers
 * @Created Date : 16/11/2020
 * @modified 202104-19 by Jason Quevauvilliers (W-011270)
 */
@isTest
public class VAPSInsuranceCancellationControllerTest {
	public static final String SERVICE_GROUP_NAME = 'AVAF Account Maintenance';
	public static final String SERVICE_TYPE_NAME = 'Insurance Cancellation';

	/*
	 * Purpose : Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		//Create Case data
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Account account = new Account(Name = 'Test Account');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id);
		insert contact;

		Case caseRec = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			Account = account,
			Email__c = 'test@test.com',
			recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			Incident_Date__c = date.today()
		);
		insert caseRec;

		//Create Service data
		Service_Group__c serviceGroupRecord = new Service_Group__c(
			Name = SERVICE_GROUP_NAME,
			Queue__c = 'Queue',
			Active__c = true,
			Assign_Record_Type__c = 'Complaint'
		);
		insert serviceGroupRecord;
		Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true);
		insert sl;
		Service_Type__c st = new Service_Type__c(Name = SERVICE_TYPE_NAME, Type__c = 'Type', Subtype__c = 'Subtype');
		insert st;
		Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c = serviceGroupRecord.Id, Service_Level__c = sl.id, Service_Type__c = st.Id);
		insert sgt;

		//Create Integration Service Records
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AvafVapsGetList_IH_v1.INTEGRATION_SERVICE_NAME, AvafVapsCancel_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@IsTest
	static void testAvafVapsGetList() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AvafVapsGetList_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		AvafVapsGetList_Resp_IB_v1 responseBean = VAPSInsuranceCancellationController.getVAPSInsuranceList('00073556860');
		Test.stopTest();

		System.assertEquals(200, responseBean.statusCode);
	}

	@IsTest
	static void testAvafVapsCancelInsurance() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AvafVapsCancel_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		AvafVapsCancel_Req_IB_v1 requestBean = AvafVapsCancel_Req_IB_v1.createDummyRequest();
		String selectedVAPS = JSON.serialize(requestBean.BAPI_SF_VAPS_CANCEL[0]);

		Test.startTest();
		AvafVapsCancel_Resp_IB_v1 responseBean = VAPSInsuranceCancellationController.cancelVAPSInsurance(selectedVAPS, true);
		Test.stopTest();

		System.assertEquals(200, responseBean.statusCode);
	}

	@IsTest
	static void testTransferCase() {
		Case caseRec = [SELECT Id, Transfer_Reason__c FROM Case LIMIT 1];
		caseRec.BusinessHoursId = [SELECT Id FROM BusinessHours WHERE isActive = TRUE LIMIT 1].Id;
		update caseRec;

		Test.startTest();
		VAPSInsuranceCancellationController.transferCase(SERVICE_GROUP_NAME, SERVICE_TYPE_NAME, caseRec.Id);
		Test.stopTest();

		Case caseAfter = [SELECT Id, sd_Service_Group__c FROM Case LIMIT 1];
		System.assertEquals(caseAfter.sd_Service_Group__c, SERVICE_GROUP_NAME);
	}
}
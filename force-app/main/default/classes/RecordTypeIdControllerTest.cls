/**
 * @description Test class for cmpChooseTask component
 * @author Chandra Bhushan Singh
 * @created 27/08/2019
 */
@IsTest
public class RecordTypeIdControllerTest {
	@isTest
	static void testGetRecordTypeId() {
		Test.startTest();
		String recordTypeId = RecordTypeIdController.getRecordTypeId('ATM', 'Case');
		Test.stopTest();
		System.assert(String.isNotBlank(recordTypeId), 'Assert Failed');
	}

	@isTest
	static void testGetRecordTypeIdFromServiceType() {
		Test.startTest();
		String recordTypeId = RecordTypeIdController.getRecordTypeIdFromServiceType('ATM', 'Case');
		Test.stopTest();
		System.assert(String.isNotBlank(recordTypeId), 'Assert Failed');
	}

	@isTest
	static void testGetRecordTypeName() {
		Test.startTest();
		String recordTypeName = RecordTypeIdController.getRecordTypeName('ATM', 'Case');
		Test.stopTest();
		System.assert(String.isNotBlank(recordTypeName), 'Assert Failed');
	}

	@isTest
	static void testCreateNewOpportunity() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;
		//Setting Up sales Process Type
        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'New Credit Product (Business Banking)',
            Sales_Process__c = 'Credit Onboarding',
            Opportunity_Record_Type__c = 'Credit Onboarding',
            Request_Name__c = 'New Credit Product (Business Banking)');
        insert salesProcessType;

		Test.startTest();
		String onboardOpportunityId = RecordTypeIdController.createNewOpportunity(testDataFactory.testAccount.id, 'Credit_Onboarding');
		Test.stopTest();
		System.assert(String.isNotBlank(onboardOpportunityId), 'Assert Failed');
	}

	@isTest
	static void testGetUCIDValueFromSessionCache() {
		String jsonString = '{"agentId":"7072","authenticationType":["ID_V","E_PIN"],"cifCode":"ESTATEA001","identified":true,"verified":true,"ucId":"00025173891614972755"}';
		ClientIDnVPollingApex.ClientIDnVSessionObject sessionObj = (ClientIDnVPollingApex.ClientIDnVSessionObject) JSON.deserialize(
			jsonString,
			ClientIDnVPollingApex.ClientIDnVSessionObject.class
		);
		Cache.Session.put('local.Customer1Cache.clientIDnVSessionObject', sessionObj);
		Test.startTest();
		String ucid = RecordTypeIdController.getUCIDValueFromSessionCache();
		Test.stopTest();
		System.assert(String.isNotBlank(ucid), 'Assert Failed');
	}
}
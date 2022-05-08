/**
 * @description This is the ImpressionRequestsSelector test class
 *
 * @author Vladimir Panajic
 * @created 2019-10-21
 */
@IsTest
public class ImpressionRequestsSelectorTest{
    @isTest
    public static void getSObjectType(){
		Schema.SObjectType newSchema = new ImpressionRequestsSelector().getSObjectType();
        system.assertNotEquals(null, newSchema);
	}

    @isTest
    public static void getSObjectFieldList(){
		List<Schema.SObjectField> fieldsList = new ImpressionRequestsSelector().getSObjectFieldList();
        system.assertNotEquals(null, fieldsList);
	}

    @isTest
    public static void selectRequestsByOpptyId(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectRequestsByOpptyId(testDataFactory.testOpportunity.id);
        system.assertNotEquals(null, impressionRequests);
	}

    @isTest
    public static void selectInProgressRequestsByOpptyIdDocId(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();
		ImpressionRequest__c req = new ImpressionRequest__c(RequestId__c = '12345', completed__c = false, Document__c = testDataFactory.testDocument.id);
		insert req;
		SignatureRequest__c src = new SignatureRequest__c(impressionRequestID__C = '12345', step__c = 1, signatureId__c = '12345', Processed__c = false);
		insert src;
		Set<Id> ids = new Set<Id>();
		ids.add(src.id);
		List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectInProgressRequestsByOpptyIdDocId(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id, 'In Progress');
		List<ImpressionRequest__c> selAll = new ImpressionRequestsSelector().selectAllRequests();
		ImpressionRequest__c req2 = new ImpressionRequestsSelector().selectByRequestId(src.impressionRequestID__C);
		ImpressionRequest__c req3 = new ImpressionRequestsSelector().selectById(req.Id);
		system.assertNotEquals(null, req2);
		test.stopTest();
	}
}
@isTest
public class SignatureRequestSelectorTest {
    private static testmethod void testAll2() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        test.startTest();
        ImpressionRequest__c req = new ImpressionRequest__c(RequestId__c='12345', completed__c=false, Document__c=testDataFactory.testDocument.id);
        insert req;
        SignatureRequest__c src = new SignatureRequest__c(impressionRequestID__C='12345', step__c=1,signatureId__c='12345', Processed__c=false);
        insert src;
        Set<Id> ids = new Set<Id>();
        ids.add(src.id);
        new SignatureRequestSelector().getSObjectType();
        new SignatureRequestSelector().selectById(ids);
        new SignatureRequestSelector().getSObjectFieldList();
        SignatureRequest__c req2 = new SignatureRequestSelector().selectbyRequestId('12345');
        System.assertNotEquals(null, req2);
        test.stopTest();
    }
}
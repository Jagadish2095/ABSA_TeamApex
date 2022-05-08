/**
* Test Class for DocumentAuditsSelector
*
* @author Vladimir Panajic
* @since 2019-10-21
*
**/
@isTest
public class DocumentAuditsSelectorTest {
    
    static testMethod void getSObjectType() {
        Schema.SObjectType newSchema = new DocumentAuditsSelector().getSObjectType();
    }
    
    static testMethod void getSObjectFieldList() {
        List<Schema.SObjectField> fieldsList = new DocumentAuditsSelector().getSObjectFieldList();
    }
	
    static testMethod void selectDocumentsShare() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<Document_Audit__c> documentAudits = new DocumentAuditsSelector().selectDocumentsShare(testDataFactory.testOpportunity.id);
    }
}
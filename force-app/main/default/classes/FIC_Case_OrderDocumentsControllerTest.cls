/**
 * @description       :
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-12-07
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@IsTest
public with sharing class FIC_Case_OrderDocumentsControllerTest {
    @testSetup
    static void methodName() {
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest(StringConstants.POSITIVE_STRING));
        Group queue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName ='Unassigned'];
        Account acc = new Account();
        acc.Name = 'Test';
        acc.CIF__c = 'Test 003';
        insert acc;
        Case caseInTest = new Case(Status = 'New', FIC_PreviousQueue__c = queue.Id);
        insert caseInTest;
        Document__c doc = new Document__c(Name = 'test1', Is_Fic_Document_Consent__c = true, Reference__c = 'test',
                                            Case__c = caseInTest.Id, Type__c = 'Proof of Address',
                                            Fic_Document_no_consent_reason__c='Guardian ID unclear');
        insert doc;
    }
    @isTest
    static void getCaseWhenAccountApplicationInOrderIsTrue() {
        Case cas = [SELECT Id, Status FROM Case LIMIT 1];
        Test.startTest();
        FIC_Case_OrderDocumentsController.getCase(cas.Id);
        Test.stopTest();
        System.assertEquals('New', cas.Status, 'old');
    }

    @isTest
    static void getDocumentWhenAccountApplicationInOrderIsTrue() {
        Case cas = [SELECT Id, Status FROM Case LIMIT 1];
        List<Document__c> listOfDocuments = new List<Document__c>();
        Test.startTest();
        listOfDocuments = FIC_Case_OrderDocumentsController.getDocuments(cas.Id);
        Test.stopTest();
        System.assertEquals('Proof of Address', listOfDocuments[0].Type__c, 'old');
    }
    @isTest
    static void updateInOrderCaseWhenAccountApplicationInOrderIsTrue() {
        Case cas = [SELECT Id FROM Case LIMIT 1];
        Test.startTest();
        FIC_Case_OrderDocumentsController.updateInOrder(cas.Id, 'Proof of address', false);
        Test.stopTest();
        Document__c doc = [SELECT Is_Fic_Document_Consent__c FROM Document__c];
        System.assertEquals(false, doc.Is_Fic_Document_Consent__c, true);
    }

    @isTest
    static void updateDocument() {
        Document__c doc = [SELECT Id ,Fic_Document_No_Consent_Reason__c , Type__c , Is_Fic_Document_Consent__c FROM Document__c LIMIT 1];

        Test.startTest();
        FIC_Case_OrderDocumentsController.updateDocument(doc.Id, 'Smart card id 1 side attached', true, 'Signing instructions');
        Test.stopTest();
        Document__c doc2 = [SELECT Id ,Fic_Document_No_Consent_Reason__c , Type__c , Is_Fic_Document_Consent__c FROM Document__c WHERE Id =: doc.Id LIMIT 1];
        System.assertEquals('Signing instructions', doc2.Type__c);
        System.assertEquals('Smart card id 1 side attached', doc2.Fic_Document_No_Consent_Reason__c);
        System.assertEquals(true, doc2.Is_Fic_Document_Consent__c);
    }

    @isTest
    static void checkPicklistValue() {
        List<String> pickListValues = new List<String>();
        Test.startTest();
        pickListValues = FIC_Case_OrderDocumentsController.getPickListValuesIntoList('');
        pickListValues = FIC_Case_OrderDocumentsController.getPickListValuesIntoList('Credit card quotation');
        pickListValues = FIC_Case_OrderDocumentsController.getPickListValuesIntoList('Proof of income (latest 3 months)');
        Test.stopTest();
        System.assert(pickListValues.size()>0, false);
    }
    @isTest
    static void isUnassignedQueue() {
        Boolean isUnassignedQueue;
        Case cas = [SELECT Id FROM Case LIMIT 1];
        Test.startTest();
        isUnassignedQueue = FIC_Case_OrderDocumentsController.isUnassignedQueue(cas.Id);
        Test.stopTest();
        System.assertEquals(true, isUnassignedQueue);
    }
}
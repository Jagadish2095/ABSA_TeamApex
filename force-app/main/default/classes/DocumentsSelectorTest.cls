/**
 * @description       : Adding Test Class
 * @author            : Sandeep Golla
 * @last modified on  : 2021-11-24
 * @last modified by  : luluwitney.rankwe@absa.africa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-05-27   Sandeep Golla   Initial Version
 * 
**/

@isTest
public class DocumentsSelectorTest {

    @isTest
    public static void shouldSelectDocuments() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity opp = testDataFactory.testOpportunity;
        Contact testContact = testDataFactory.testContact;
        Document__c doc = testDataFactory.testQuoteDocument;
        doc.Case__c = testDataFactory.testCase.id;
        Account acct = testDataFactory.testAccount;
        update doc;

        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(opp.Id);
        
        test.startTest();
        System.assertNotEquals(null,new DocumentsSelector().getSObjectType());
        System.assertNotEquals(null,new DocumentsSelector().getSObjectFieldList());
        System.assertNotEquals(null,new DocumentsSelector().getDocuments(opp.Id, 'Asset', 10));
        System.assertNotEquals(null,new DocumentsSelector().selectById(doc.Id));
        System.assertNotEquals(null,new DocumentsSelector().selectByDocsId(doc.Id));
        System.assertNotEquals(null,new DocumentsSelector().selectByAccountId(acct.Id));
      //  System.assertNotEquals(null,new DocumentsSelector().selectDocumentsByOppId(opp.Id));
        System.assertNotEquals(null,new DocumentsSelector().selectByDocId(doc.Id));
        System.assertNotEquals(null,new DocumentsSelector().selectByContactId(testContact.Id));
        System.assertNotEquals(null,new DocumentsSelector().selectByTypeAndOppId(opp.Id, 'Quote'));
        System.assertNotEquals(null,new DocumentsSelector().selectByStatusTypeAndOppId(opp.Id, new Set<String>{'Quote'}, new Set<String>{'Accepted'}));
        System.assertNotEquals(null,new DocumentsSelector().selectByCaseId(testDataFactory.testCase.id));
        new DocumentsSelector().selectCerts(opp.AccountId, new Set<String>{'Hanis Certificate'});
       new DocumentsSelector().selectCertRelatedParty(accIdSet, new Set<String>{'Hanis Certificate'});
        new DocumentsSelector().getOppDocuments(opp.Id, opp.AccountId);
       // new DocumentsSelector().getDocsRelatedToOpp(opp.Id); 

        new DocumentsSelector().selectDocumentBycaseId(testDataFactory.testCase.id);
        new DocumentsSelector().getDocsRelatedToCase(testDataFactory.testCase.id);
        new DocumentsSelector().selectByCaseIds( new Set<id>{testDataFactory.testCase.id});
        new DocumentsSelector().selectDocumentListBycaseId(testDataFactory.testCase.id);
        new DocumentsSelector().getActiveDocumentBycaseId(testDataFactory.testCase.id);
        new DocumentsSelector().selectByDocId(new set<string>{doc.Id});
        //new DocumentsSelector().selectDocumentsByOppId(opp.Id);
       // new DocumentsSelector().getDocsRelatedToOpp(opp.Id);
        set<Id> contId=new set<id>();
        contId.add(testContact.Id);
        new DocumentsSelector().selectByContactId(contId);
        Set<Id> caseIdSet = new Set<Id>();
        caseIdSet.add(testDataFactory.testCase.id);
        new DocumentsSelector().selectByCaseIds(caseIdSet);  // Added by Prashanth boeni
        new DocumentsSelector().getDocsRelatedToOpp(opp.Id);
        new DocumentsSelector().selectDocumentsByOppId(opp.Id);
        test.stopTest();
    }
}
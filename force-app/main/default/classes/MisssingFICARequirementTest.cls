/**
 * @description       : Test Class For MissingFICARequirement
 * @author            : Mohammed Junaid U
 * @group             :
 * @last modified on  : 2021-09-27
 * @last modified by  : Mohammed Junaid U
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-09-27   Mohammed Junaid U   Initial Version
 **/

@isTest
public class MisssingFICARequirementTest {

    @isTest
    public static void testmethod1() {
        Account testAccount = FICTestDataFactory.getAccount('Individual','Individual','Individual_Client');
        List<String> missingDocs = new List<String>();
        List<String> missingfields = new List<String>();
        List<String> refreshableDocs= new List<String>();
        missingDocs.add('ProofOfId');
        missingfields.add('occupation');
        refreshableDocs.add('ProofOfAddress');
        MisssingFICARequirement.documentData data = new MisssingFICARequirement.documentData();
        data.missingDocuments = missingDocs;
        data.refreshableDocuments = refreshableDocs;
        data.missingFields = missingfields;
        String jSONString = JSON.serialize(data);
        testAccount.FICA_Requirements__c = jSONString;
        update testAccount;
        Test.startTest();
        //PageReference pageRef = Page.success;
        //Test.setCurrentPage(pageRef);
        MisssingFICARequirement obj = new MisssingFICARequirement();
        obj.accountId = testAccount.Id;
        obj.missingFICADocuments = data;
        obj.missingFICADocuments = obj.missingFICADocuments;
        system.assertNotEquals(testAccount.FICA_Requirements__c, Null);
        Test.stopTest();
    }
}
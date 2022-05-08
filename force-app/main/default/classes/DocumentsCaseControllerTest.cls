/**
*@description Test class for DocumentsCaseController class
* @author  Himani Joshi
* @version v1.0
* @since   2020-12-08

*/
@isTest
public class DocumentsCaseControllerTest {
    @testSetup static void createData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;
        Contact testContact = new Contact();
        testContact.FirstName = 'Test Contact';
        testContact.LastName = '1';
        insert testContact;
        Case caseRecord=new Case();
        caseRecord.Status='New';
        caseRecord.Opportunity__c=opp.Id;
        caseRecord.ContactId=testContact.Id;
        insert caseRecord;

        String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = DocumentUploaderBlockCtrl.saveChunk(opp.Id, 'Test.txt', chunk1, 'txt', '', false, 'Will', true, '');

        Document__c doc1 = new Document__c ();
          doc1.Opportunity__c = opp.Id;
          doc1.File_Id__c = fileId;
          doc1.Reference__c = 'xxxxyyyyzzz';
          doc1.Type__c ='Will';
         insert doc1;
        Document__c doc2 = new Document__c ();
          doc2.case__c = caseRecord.Id;
          doc2.File_Id__c = fileId;
          doc2.Reference__c = 'xxxxyyyyzzz';
          doc2.Type__c ='Will';
         insert doc2;
    }
    @isTest
   public static void getAllDocumentsTest() {     
        Case cse=[select Id from Case];
        test.startTest();
    List<Document__c> docList=DocumentsCaseController.getAllDocuments(cse.Id);
    DocumentsCaseController.restrictSystemDocs(docList.get(0).Id);
    DocumentsCaseController.deleteDocument(docList.get(0).Id);
    System.assertNotEquals(null,docList);
    test.stopTest();
        
    }

     @istest
    public static void getRecordTypeName() {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Service_Request').getRecordTypeId();
        Case caseRec = new Case(RecordTypeId = caseRecordTypeId);
        insert caseRec;
        
        Test.startTest();
        Boolean results =DocumentsCaseController.getRecordTypeName(caseRec.Id);
        System.assert(results != null);
        Test.stopTest();
        
    }


}
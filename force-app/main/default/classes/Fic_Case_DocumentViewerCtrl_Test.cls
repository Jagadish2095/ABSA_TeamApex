/**
*
* @author  updated by Nikolay Kibalov
* @since   2021-05-10
* @description : Fic_Case_DocumentViewerCtrl
**/
@IsTest
private class Fic_Case_DocumentViewerCtrl_Test {
    @TestSetup
    static void setupMethod() {
        Case caseInTest = new Case(

        );
        insert caseInTest;
    }
    @IsTest
    static void getEntries() {
        Case cas = [SELECT Id FROM Case LIMIT 1];

        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test 1';
        cv.VersionData = Blob.valueOf('Test1');
        cv.PathOnClient = 'Test 1';
        insert cv;

        ContentVersion testCV = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = cas.Id;
        cdl.ContentDocumentId = testCV.ContentDocumentId;
        cdl.ShareType = 'V';
        insert cdl;
        
        Document__c doc = new Document__c(name='Test',Case__c=cas.id,Type__c='Proof of Id',Reference__c='test PID',File_Id__c=cdl.ContentDocumentId);
        insert doc;
        
        Test.startTest();
        Fic_Case_DocumentViewerCtrl.isAOL(doc.id);
       // Fic_Case_DocumentViewerCtrl.getDocumentContent(doc.id);
        System.assertNotEquals(null, Fic_Case_DocumentViewerCtrl.specificDoc(doc.id), true);
        System.assertNotEquals(null, Fic_Case_DocumentViewerCtrl.getdocumentS(cas.id),true);
        System.assertNotEquals(null, Fic_Case_DocumentViewerCtrl.getContents('Test 1.DHAcert'),true);
        Test.stopTest();
    }
}
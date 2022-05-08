/**
* Apex Test class for the class CaseFilesViewCtrl.
* @author  Chenna
* @since   2020-09-16
*
**/
@isTest
public class CaseFilesViewCtrlTest {
    public static testMethod void CaseFilesViewCtrlTest()
    {
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'TestCon';
        insert con;
        
        Case csObj = new Case();
        csobj.AccountId = acc.Id;
        csobj.ContactId = con.Id;
        insert csObj;
                
        ContentVersion cVObj = new ContentVersion();
        cVObj.Title = 'Test Document';
        cVObj.PathOnClient = 'TestDocument.pdf';
        cVObj.VersionData = Blob.valueOf('Test Content');
        cVObj.IsMajorVersion = true;
        Insert cVObj;
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVObj.Id].ContentDocumentId;
 
        ContentDocumentLink conDoc = New ContentDocumentLink();
        conDoc.LinkedEntityId = acc.Id;
        conDoc.ContentDocumentId = conDocId;
        conDoc.shareType = 'V'; 
        conDoc.LinkedEntityId = csObj.Id;
        Insert conDoc;  
        
        Test.startTest();
        CaseFilesViewCtrl.fetchContentDocument(csObj.Id);
        CaseFilesViewCtrl.fetchCaseNo(csObj.Id);
        CaseFilesViewCtrl.saveCurrentRec(cVObj);
        CaseFilesViewCtrl.deleteDocument(conDocId);
        
        List<ContentVersion> conVList = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVObj.Id];
        System.assert(conVList.size()==0);
        Test.stopTest();
    }
}
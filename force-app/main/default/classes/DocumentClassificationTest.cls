/**
* Test Class for Classification
* @description       : Document Classification Test Class mock
* @author            : Sandeep Ch
* @since             : 06/10/2021
*
**/
 
@isTest
public  class DocumentClassificationTest {
/**
     * @description : Test Method.
 
     **/ 
    /*
    @isTest
    public static void testCdocClassify(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
 
        testDataFactory.testAccount.Client_group__c = 'Individual';
        update testDataFactory.testAccount;
 
        case cs = new case();
        cs.AccountId = testDataFactory.testAccount.Id;
        cs.status = 'New';
        insert cs;
 
        string basedata = 'sadkfjhalskdjhfaskdjflajsdlkfjhasuwlkjfhaslkuhvlkjwnlkjwheraksjdfblkajshdflkjhasdf';
        Attachment attache = new Attachment();
        //oAttachment.parentId = parentId;
        attache.Body = EncodingUtil.base64Decode(basedata);
        attache.Name = 'test';
        attache.ParentId = cs.Id;
        attache.ContentType = 'application/pdf';
        insert attache;
 
        Attachment a = [SELECT Id, Name, Body FROM Attachment WHERE Id = :attache.Id];
        string filname = a.Name;
        string docdata = EncodingUtil.base64Encode(a.Body);
        Test.setMock(HttpCalloutMock.class, new documentClassificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Document Classification'});
        Test.startTest();
        DocumentClassification.getclassify(filname,docdata);
        DocuClassInfo_Resp_Parse docPackResponse = DocuClassifyInfo_IH_v1.getDocuInfo(filname,docdata);
        //DocumentClassification.classifyAndUploadToCISService(attache.Id);
        system.assertEquals(docPackResponse.statusCode, docPackResponse.statusCode, '500');
        Test.stopTest();
 
    } */
 
    /**
     * @description : Test Method
     **/
    /*
    @isTest
     public static void testCdocClassify1(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
 
        testDataFactory.testAccount.Client_group__c = 'Individual';
        update testDataFactory.testAccount;
 
        case cs = new case();
        cs.AccountId = testDataFactory.testAccount.Id;
        cs.status = 'New';
        insert cs;
 
        string basedata = 'sadkfjhalskdjhfaskdjflajsdlkfjhasuwlkjfhaslkuhvlkjwnlkjwheraksjdfblkajshdflkjhasdf';
        Attachment attache = new Attachment();
        //oAttachment.parentId = parentId;
        attache.Body = EncodingUtil.base64Decode(basedata);
        attache.Name = 'test';
        attache.ParentId = cs.Id;
        attache.ContentType = 'application/pdf';
        insert attache;
 
        Attachment a = [SELECT Id, Name, Body FROM Attachment WHERE Id = :attache.Id];
        string filname = a.Name;
        string docdata = EncodingUtil.base64Encode(a.Body);
        Test.setMock(HttpCalloutMock.class, new documentClassificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Document Classification'});
        Test.startTest();
        DocumentClassification.getclassify(filname,docdata);
        DocuClassInfo_Resp_Parse docPackResponse = DocuClassifyInfo_IH_v1.getDocuInfo('','');
        //DocumentClassification.classifyAndUploadToCISService(attache.Id);
        system.assertEquals(docPackResponse.statusCode, docPackResponse.statusCode, '200');
        Test.stopTest();
 
    } */
    
    @isTest
    public static void uploaddocuemttest(){
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest(StringConstants.POSITIVE_STRING));

         String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='6211275132089';
        accountList[0].AccountNumber ='6211275132089';
        accountList[0].Country_of_Citizenship__c =  'South Africa';
        accountList[0].PersonBirthdate = Date.valueOf('1962-11-27');
        accountList[0].Gender__pc = 'Male';
        insert accountList;
        list<case> testcase=TestDataFactory.getCases('FIC_Case',1);
        testcase[0].RecordtypeId=caserecordTypeId;
        testcase[0].AccountId=accountList[0].id;
        insert testcase[0];
        ContentVersion contVerFile = new ContentVersion();
        contVerFile.VersionData = Blob.valueOf('testsjdaru893pdf'); 
        contVerFile.VersionData =EncodingUtil.base64Decode('testkdsjfkdaji84pdf');
        contVerFile.Title = 'DHACert'; 
        contVerFile.PathOnClient = 'DHA.pdf';
        contVerFile.ContentLocation= 's';
        Test.startTest(); 
        insert contVerFile;
        System.assert(contVerFile.id!= null,false);
        //Get Content Documents
        Id conDoc; 
        if(contVerFile!=null){
            conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contVerFile.Id].ContentDocumentId;
        }
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = testcase[0].id;
        cDe.ShareType = 'I';
        cDe.Visibility = 'AllUsers';
        
        insert cDe;
        System.assert(cDe.id!= null,false);

        Test.stopTest(); 
        
        map<id,id> docIdAttachmentMap=new map<id,id>();
        docIdAttachmentMap.put(conDoc,testcase[0].id);
        DocumentClassification.classifyAndUploadToCISService(docIdAttachmentMap,'');
    }
}
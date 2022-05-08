/**
 * @description       : Test Classes
 * @author            : Mohammed Junaid
 * @group             :
 * @last modified on  : 2021-12-07
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log
 * Ver   Date         Author            Modification
 * 1.0   05-25-2021   Mohammed Junaid   Initial Version
**/
@isTest
public class CIS_IH_v1Test {

    @isTest
    public static void testComplianceView(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest(StringConstants.POSITIVE_STRING));
       // IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Add'});
       // string fileName, string documentType, attachment attach, account acc
        String documentType = 'ProofOfId';
        String fileName = 'Mohammed Junaid U.pdf';
        Attachment attach=new Attachment();
    	attach.Name='Mohammed Junaid U.pdf';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=testDataFactory.testAccount.id;
        attach.ContentType = 'ProofOfId';
        insert attach;
        Test.startTest();
        CIS_IH_v1.uploadDocument(fileName,documentType,attach,testDataFactory.testAccount,'SA ID Card','false','','');
        system.assertEquals(attach.ContentType, 'ProofOfId');
        Test.stopTest();
    }

    @isTest
    public static void testComplianceView2(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Get'});
        Test.setMock(HttpCalloutMock.class, new CIS_GetDocMock_ApiRest(StringConstants.POSITIVE_STRING));
        string pid = 'CISBISON_SIT Ent_ProofOfId B5C40FB9383D40059B45BD6C4F48DE74';
        Test.startTest();
        CIS_IH_v1.downloadDocument(pid);
        CIS_IH_v1.verifyDocument(pid , true);
        system.assertEquals(pid, 'CISBISON_SIT Ent_ProofOfId B5C40FB9383D40059B45BD6C4F48DE74');
        Test.stopTest();
    }

    @isTest
    public static void testPositive() {
       IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Document Classification'});
       Test.setMock(HttpCalloutMock.class, new documentClassificationMock_ApiRest(StringConstants.POSITIVE_STRING));
       DocuClassInfo_Resp_Parse requestBean = DocuClassifyInfo_IH_v1.getDocuInfo('Test','testkdsjfkdaji84pdf');
       System.assertNotEquals(requestBean, null,'Doc classification should not be empty');
    }

}
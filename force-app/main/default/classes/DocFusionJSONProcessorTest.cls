/**
* @description
* @author  Taras Kuliievych
* @since 2021-07-14
**/
@isTest
public with sharing class DocFusionJSONProcessorTest {
    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CC_ContentService_IH_v1.GENERATE_CONTENT_PATH});
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void createDocumenByJSONTest() {
        Document_Template__c documentTemplate = new Document_Template__c();
        documentTemplate.Template_Id__c = '12345';
        documentTemplate.Name = 'test';
        documentTemplate.Document_Type__c = 'test';
        insert documentTemplate;

        String reportData = 'testtttt';

        CC_GenerateContentResponse dummyResponse = CC_GenerateContentResponse.getExample();

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, JSON.serialize(dummyResponse)));

        Test.startTest();

        DocFusionJSONProcessor docFusionJSONProcessor = new DocFusionJSONProcessor();
        CC_GenerateContentResponse testResponse = DocFusionJSONProcessor.generateEnquiryReport(documentTemplate, reportData, new Map<String, String>{'test' => 'test'});

        Test.stopTest();

        System.assertEquals('1872197291728912', testResponse.contentStoreToken, 'createDocumenByJSON');
    }
}
/**
* @description
* @author  Taras Kuliievych
* @since 2021-07-14
**/
@isTest
public with sharing class Enquiry_PDFReportControllerTest {
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
    static void procesChargeEnquiryDetailTest() {
        Document_Template__c documentTemplate = new Document_Template__c();
        documentTemplate.Template_Id__c = '12345';
        documentTemplate.Name = 'CBP Charge Enquiry Detail';
        documentTemplate.Document_Type__c = 'CBP Charge Enquiry Detail';
        insert documentTemplate;

        Account testAccount = new Account();
        testAccount.firstName = 'ICM';
        testAccount.lastName = 'ICM';
        testAccount.Active_Email__c = 'ICM@asd.com';
        testAccount.lastName = 'ICM';
        testAccount.CurrencyIsoCode = 'ZAR';
        testAccount.CIF__c = 'PRETOK 002';
        Insert testAccount;

        String reportData = '{\"enquiryType\":\"CBP_Charge_Enquiry\",\"CIF\":\"PRETOK 002\",\"customerName\":\"Mabali Balisto\",\"accountName\":\"Mabali Balisto\",\"clientType\":\"Individual Client\",\"caseId\":\"test\",\"belowDetails\":\"detail\",\"dateFrom\":\"2021-08-29\",\"dateTo\":\"2021-09-01\"}';

        CC_GenerateContentResponse dummyResponse = CC_GenerateContentResponse.getExample();
        dummyResponse.transformedData = '123';

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, JSON.serialize(dummyResponse)));

        Test.startTest();

        EnquiryReportProcessor enquiryReportProcessor = new EnquiryReportProcessor();
        String testResponse = Enquiry_PDFReportController.getEnquiryReport(reportData);

        Test.stopTest();

        System.assertEquals('123', testResponse, 'createDocumenByJSON');
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void closeCaseTest() {
        Account testAccount = new Account();
        testAccount.firstName = 'ICM';
        testAccount.lastName = 'ICM';
        testAccount.Active_Email__c = 'ICM@asd.com';
        testAccount.lastName = 'ICM';
        Insert testAccount;

        Case testCase = new Case();
        testCase.Type = 'ICM';
        testCase.Accountid = testAccount.Id;
        testCase.Origin = 'SHIP';
        testCase.Status = 'New';
        testCase.Type = 'ICM';
        testCase.Type__c = 'Service Request';
        Insert testCase;

        Test.startTest();

        Enquiry_PDFReportController.closeCase(testCase.Id);

        Test.stopTest();

        System.assertEquals('Closed', [SELECT Status FROM Case WHERE id = :testCase.Id].Status, 'closeCaseTest');
    }
}
/**
* @description
* @author  Taras Kuliievych
* @since 2021-07-14
**/
@isTest
public with sharing class EnquiryReportProcessorTest {
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

        String reportData = '{\"enquiryType\":\"CBP_Charge_Enquiry\",\"accountType\":\"Test\",\"CIF\":\"PRETOK 002\",\"customerName\":\"Mabali Balisto\",\"accountName\":\"Mabali Balisto\",\"clientType\":\"Individual Client\",\"caseId\":\"test\",\"belowDetails\":\"detail\",\"dateFrom\":\"2021-08-29\",\"dateTo\":\"2021-09-01\"}';

        CC_GenerateContentResponse dummyResponse = CC_GenerateContentResponse.getExample();
        dummyResponse.transformedData = '123';

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, JSON.serialize(dummyResponse)));

        Test.startTest();

        EnquiryReportProcessor enquiryReportProcessor = new EnquiryReportProcessor();
        String testResponse = EnquiryReportProcessor.generateEnquiryReport(reportData);

        Test.stopTest();

        System.assertEquals('123', testResponse, 'createDocumenByJSON');
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void procesChargeEnquirySummaryTest() {
        Document_Template__c documentTemplate = new Document_Template__c();
        documentTemplate.Template_Id__c = '12345';
        documentTemplate.Name = 'CBP Charge Enquiry Summary';
        documentTemplate.Document_Type__c = 'CBP Charge Enquiry Summary';
        insert documentTemplate;

        Account testAccount = new Account();
        testAccount.firstName = 'ICM';
        testAccount.lastName = 'ICM';
        testAccount.Active_Email__c = 'ICM@asd.com';
        testAccount.lastName = 'ICM';
        testAccount.CurrencyIsoCode = 'ZAR';
        testAccount.CIF__c = 'PRETOK 002';
        Insert testAccount;

        String reportData = '{\"enquiryType\":\"CBP_Charge_Enquiry\",\"accountType\":\"Test\",\"CIF\":\"PRETOK 002\",\"customerName\":\"Mabali Balisto\",\"accountName\":\"Mabali Balisto\",\"clientType\":\"Individual Client\",\"caseId\":\"test\",\"belowDetails\":\"summary\",\"dateFrom\":\"2021-08-29\",\"dateTo\":\"2021-09-01\"}';

        CC_GenerateContentResponse dummyResponse = CC_GenerateContentResponse.getExample();
        dummyResponse.transformedData = '123';

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, JSON.serialize(dummyResponse)));

        Test.startTest();

        EnquiryReportProcessor enquiryReportProcessor = new EnquiryReportProcessor();
        String testResponse = EnquiryReportProcessor.generateEnquiryReport(reportData);

        Test.stopTest();

        System.assertEquals('123', testResponse, 'createDocumenByJSON');
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void procesChargeEnquirySummaryEmptyExternalTest() {
        Document_Template__c documentTemplate = new Document_Template__c();
        documentTemplate.Template_Id__c = '12345';
        documentTemplate.Name = 'CBP Charge Enquiry Summary';
        documentTemplate.Document_Type__c = 'CBP Charge Enquiry Summary';
        insert documentTemplate;

        Account testAccount = new Account();
        testAccount.firstName = 'ICM';
        testAccount.lastName = 'ICM';
        testAccount.Active_Email__c = 'ICM@asd.com';
        testAccount.lastName = 'ICM';
        testAccount.CurrencyIsoCode = 'ZAR';
        testAccount.CIF__c = 'PRETOK 002';
        Insert testAccount;

        String reportData = '{\"enquiryType\":\"CBP_Charge_Enquiry\",\"accountType\":\"Test\",\"CIF\":\"PRETOK 002\",\"customerName\":\"Mabali Balisto\",\"accountName\":\"Mabali Balisto\",\"clientType\":\"Individual Client\",\"caseId\":\"test\",\"belowDetails\":\"summary\",\"dateFrom\":\"2021-08-29\",\"dateTo\":\"2021-09-01\"}';

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, ''));

        Test.startTest();

        EnquiryReportProcessor enquiryReportProcessor = new EnquiryReportProcessor();

        try {
            String testResponse = EnquiryReportProcessor.generateEnquiryReport(reportData);
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }

        Test.stopTest();
    }



    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void notexistingEnquiryTest() {
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

        String reportData = '{\"enquiryType\":\"Test\",\"accountType\":\"Test\",\"CIF\":\"PRETOK 002\",\"customerName\":\"Mabali Balisto\",\"accountName\":\"Mabali Balisto\",\"clientType\":\"Individual Client\",\"caseId\":\"test\",\"belowDetails\":\"detail\",\"dateFrom\":\"2021-08-29\",\"dateTo\":\"2021-09-01\"}';

        CC_GenerateContentResponse dummyResponse = CC_GenerateContentResponse.getExample();
        dummyResponse.transformedData = '123';

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, JSON.serialize(dummyResponse)));

        Test.startTest();

        EnquiryReportProcessor enquiryReportProcessor = new EnquiryReportProcessor();

        try {
            String testResponse = EnquiryReportProcessor.generateEnquiryReport(reportData);
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }

        Test.stopTest();
    }
}
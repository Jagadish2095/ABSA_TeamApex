/**
* @description       : AccountEnquiryCntrTest
* @author            : Mradul Maheshwari
* @last modified on  : 29-10-2021
* @last modified by  : Mradul Maheshwari
* @Work Id           : W-013340
**/
@isTest
public class AccountEnquiryCntrTest {
    @TestSetup
    static void makeData() {
        Account account = new Account(Name = 'Test Account', CIF__c = 'ATRUST1375');
        insert account;
        
        Contact contact = new Contact(
            LastName = 'Test contact',
            AccountId = account.Id,
            Email = 'agents@support.co.za'
        );
        insert contact;
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
            .get('Service Request')
            .getRecordTypeId();
        
        Service_Group__c sGroup = new Service_Group__c(Name = 'Test');
        insert sGroup;
        
        Case caseRec = new Case(
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email_From_Address__c = 'test@ret.com',
            Email__c = 'test@ret.com',
            RecordTypeId = caseRecordTypeId,
            Subject = 'Test',
            Description = 'Test',
            Type__c = 'Test',
            sd_Service_Group_Id__c = sGroup.Id,
            sd_Service_Group__c = sGroup.Name,
            Out_Of_SLA_Reason__c = 'Feedback/Follow-Up',
            Out_Of_SLA_Comments__c = 'Test'
        );
        insert caseRec;
        Document_Template__c docTemp = new Document_Template__c(
            Name = 'Account Enquiry',
            Document_Type__c = 'Account Enquiry'
        );
        insert docTemp;
    }
    
    @IsTest
    static void doAccountEnquiry() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AccountEnquiry_IH_V1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                AccountEnquiry_IH_V1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        
        Test.startTest();
        String response = AccountEnquiryCntr.getAccountDetails('8053285542');
        System.assert(response.StartsWith('{'));
        Test.stopTest();
    }
    
    @IsTest
    static void doAccountEnquiryNegative1() {
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                AccountEnquiry_IH_V1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        
        Test.startTest();
        try{
            String response = AccountEnquiryCntr.getAccountDetails('');
        }catch(AuraHandledException E){
            System.assert(true);
        }
        Test.stopTest();
    }
    
    @IsTest
    static void doAccountEnquiryNegative2() {
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                AccountEnquiry_IH_V1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        
        Test.startTest();
        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'System Administrator (Custom)'
        ];
        
        User testUser = new User();
        testUser.Username = 'test.user@absa2.com';
        testUser.LastName = 'User';
        testUser.Email = 'test.user@absa2.com';
        testUser.Alias = 'testuser';
        testUser.TimeZoneSidKey = 'Africa/Johannesburg';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.ProfileId = p.Id;
        testUser.LanguageLocaleKey = 'en_US';
        insert testUser;
        System.runAs(testUser) {
            
            try{
                String response = AccountEnquiryCntr.getAccountDetails('1');
            }catch(AuraHandledException E){
                System.assert(true);
            }
        }
        Test.stopTest();
    }
    
    @IsTest
    static void doAccountEnquiryNegative3() {
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.NEGATIVE_STRING,
                AccountEnquiry_IH_V1_Test.STATIC_RESOURCE_NAME_MOCK_NEGATIVE
            )
        );
        
        Test.startTest();
        try{
            String response = AccountEnquiryCntr.getAccountDetails('1');
        }catch(AuraHandledException E){
            System.assert(true);
        }
        Test.stopTest();
        
    }
    
    @IsTest
    static void getDocumentData() {
        List<String> endpoints = new List<String>();
        endpoints.add('ECM Query Path');
        endpoints.add('ECM Authenication Path');
        endpoints.add('ECM Add Path');
        endpoints.add('ECM Logout Path');
        endpoints.add('ECM GetItemType Path');
        endpoints.add('ECM Get Path');
        endpoints.add('ECM GetItemTypes Path');
        endpoints.add(DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR);
        
        IntegrationTestDataFactory.insertIntegrationSettings(
            'Jitterbit2',
            endpoints
        );
        
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            endpoints
        );
        
        Test.startTest();
        // Since we cant have multiple mock calls with proper response we are passing the response value directly
        String response = '{"statusCode":null,"status":null,"message":null,"Fault":null,"statusCode":200,"status":"OK","NBSAPDPO":{"NBSAPLO":{"NBNAPLO_RETURN_CODE":0}},"MLB857O":{"MLB857O_OUTPUT_AREA":{"MLB857O_SEC_ACCT_DETAIL":[{"MLB857O_SE_OUTST_BAL":10.0,"MLB857O_SE_ACCT_NBR":12},{"MLB857O_SE_OUTST_BAL":10.0,"MLB857O_SE_ACCT_NBR":2},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0}],"MLB857O_PROPERTY_DETAIL":[{"MLB857O_UNIT_NBR":"1","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"test","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"2","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"3","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"4","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"5","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"6","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"7","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"8","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""}],"MLB857O_PRIM_ACCT_DETAIL":{"MLB857O_PR_TERM_OF_LOAN":240,"MLB857O_PR_REMAINING_TERM":237,"MLB857O_PR_OUTST_BAL":0.0,"MLB857O_PR_BOND_AMT":1000000,"MLB857O_PR_INST_DETAIL":{"MLB857O_PR_TOTAL_INST":154.01,"MLB857O_PR_PROV_HOC":0.0,"MLB857O_PR_PROV_HMP":0.0,"MLB857O_PR_PROV_ENDOWMENT":0.0,"MLB857O_PR_PROV_ADMIN_FEE":69.0,"MLB857O_PR_DUE_DAY":12,"MLB857O_PR_BASIC_INST":85.01},"MLB857O_PR_FLEXI_AMT_AVAIL":1000000.0,"MLB857O_PR_EFF_ACCT_RATE":6.0,"MLB857O_PR_BOND_REG_DATE":20010201,"MLB857O_PR_ACCT_NBR":8053285542}}},"message":null}'; //AccountEnquiryCntr.getAccountDetailsApex('8053285542');
        Account acc = [
            SELECT id, Trust_Number__c
            FROM Account
            WHERE name = 'Test Account'
            LIMIT 1
        ];
        Case caseRec = [SELECT id FROM Case WHERE Subject = 'Test' LIMIT 1];
        try{
            String pdfData = AccountEnquiryCntr.getDocumentData(
                response,
                acc.Id,
                caseRec.Id
            );
        }catch(AuraHandledException E){
            system.assert(true);
        }
        Test.stopTest();
    }
    
    @IsTest
    static void sendEmail() {
        List<String> endpoints = new List<String>();
        endpoints.add('ECM Query Path');
        endpoints.add('ECM Authenication Path');
        endpoints.add('ECM Add Path');
        endpoints.add('ECM Logout Path');
        endpoints.add('ECM GetItemType Path');
        endpoints.add('ECM Get Path');
        endpoints.add('ECM GetItemTypes Path');
        endpoints.add(DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR);
        
        IntegrationTestDataFactory.insertIntegrationSettings(
            'Jitterbit2',
            endpoints
        );
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            endpoints
        );
        
        // Since we cant have multiple mock calls with proper response we are passing the response value directly
        String response = '{"statusCode":null,"status":null,"message":null,"Fault":null,"statusCode":200,"status":"OK","NBSAPDPO":{"NBSAPLO":{"NBNAPLO_RETURN_CODE":0}},"MLB857O":{"MLB857O_OUTPUT_AREA":{"MLB857O_SEC_ACCT_DETAIL":[{"MLB857O_SE_OUTST_BAL":10.0,"MLB857O_SE_ACCT_NBR":12},{"MLB857O_SE_OUTST_BAL":10.0,"MLB857O_SE_ACCT_NBR":2},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0},{"MLB857O_SE_OUTST_BAL":0.0,"MLB857O_SE_ACCT_NBR":0}],"MLB857O_PROPERTY_DETAIL":[{"MLB857O_UNIT_NBR":"1","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"test","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"2","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"3","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"4","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"5","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"6","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"7","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"8","MLB857O_TOWNSHIP":"FOCHVILLE EXT 2","MLB857O_PROPERTY_DESCR":"SECTIONAL TITLE UNIT","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"1484","MLB857O_COMPLEX_NAME":"SS HENRIT","MLB857O_CITY":"POTCHEFSTROOM"},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""},{"MLB857O_UNIT_NBR":"","MLB857O_TOWNSHIP":"","MLB857O_PROPERTY_DESCR":"","MLB857O_PORTION":"","MLB857O_HOC_ANIV_DATE":0,"MLB857O_ERF_NBR":"","MLB857O_COMPLEX_NAME":"","MLB857O_CITY":""}],"MLB857O_PRIM_ACCT_DETAIL":{"MLB857O_PR_TERM_OF_LOAN":240,"MLB857O_PR_REMAINING_TERM":237,"MLB857O_PR_OUTST_BAL":0.0,"MLB857O_PR_BOND_AMT":1000000,"MLB857O_PR_INST_DETAIL":{"MLB857O_PR_TOTAL_INST":154.01,"MLB857O_PR_PROV_HOC":0.0,"MLB857O_PR_PROV_HMP":0.0,"MLB857O_PR_PROV_ENDOWMENT":0.0,"MLB857O_PR_PROV_ADMIN_FEE":69.0,"MLB857O_PR_DUE_DAY":12,"MLB857O_PR_BASIC_INST":85.01},"MLB857O_PR_FLEXI_AMT_AVAIL":1000000.0,"MLB857O_PR_EFF_ACCT_RATE":6.0,"MLB857O_PR_BOND_REG_DATE":20010201,"MLB857O_PR_ACCT_NBR":8053285542}}},"message":null}';
        //AccountEnquiryCntr.getAccountDetails('8053285542');
        
        Test.startTest();
        Account acc = [SELECT id FROM Account WHERE name = 'Test Account' LIMIT 1];
        Case caseRec = [SELECT id FROM Case WHERE Subject = 'Test' LIMIT 1];
        
        EmailTemplate eTemp = [SELECT Id, DeveloperName FROM EmailTemplate LIMIT 1];
        String pdfData = 'demo';
        try{
            String emailResponse = AccountEnquiryCntr.sendEmailAttachment(
                pdfData,
                'test@test.com',
                (String) caseRec.Id,
                (String) acc.Id,
                response
            );
        }catch(AuraHandledException E){
            system.assert(true);
        }
        Test.stopTest();
    }
}
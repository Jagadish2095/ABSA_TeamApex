/**
* Switching Get Institutions Schedule Test
* @author André Pietersen
* @created 2020-10-15
*/
@isTest 
public class SwitchingGetInstitutionsScheduleTest {
    public static final String POSITIVE_RESPONSE_BODY_GET = '{ "x_embedded" : { "items" : [ { "createdBy" : "bdp_user", "lastModifiedBy" : "bdp_user", "creationDate" : "2020-07-02T12:28:47.118+0000", "lastModifiedDate" : "2020-07-02T12:28:47.118+0000", "name" : "ABSA ", "contactPerson" : null, "contactEmail" : null, "contactDepartment" : null, "debitOrderAutomatedEmail" : null, "salaryAutomatedEmail" : null, "regexPatterns" : null, "debitOrderAcknowledgeHoursSLA" : 0, "debitOrderResolveHoursSLA" : 0, "salaryAcknowledgeHoursSLA" : 0, "salaryResolveHoursSLA" : 0, "route" : "NON_PARTICIPATING", "categories" : null, "batchFileType" : null, "batchFormatterType" : null, "batchIntegrationType" : null, "connectionPrefix" : null, "template" : null, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518" }, "institution" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518" }, "history" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518/history" } } }, { "createdBy" : "admin", "lastModifiedBy" : "admin", "creationDate" : "2019-11-27T21:22:00.404+0000", "lastModifiedDate" : "2019-11-27T21:22:00.404+0000", "name" : "CHUBB SA", "contactPerson" : "", "contactEmail" : "Depolelo.Mathebula@absa.africa", "contactDepartment" : "Customer Service", "debitOrderAutomatedEmail" : "Depolelo.Mathebula@absa.africa", "salaryAutomatedEmail" : null, "regexPatterns" : null, "debitOrderAcknowledgeHoursSLA" : 4, "debitOrderResolveHoursSLA" : 4, "salaryAcknowledgeHoursSLA" : 0, "salaryResolveHoursSLA" : 0, "route" : "PARTICIPATING", "categories" : [ ], "batchFileType" : "EXCEL", "batchFormatterType" : null, "batchIntegrationType" : null, "connectionPrefix" : null, "template" : null, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235" }, "institution" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235" }, "history" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235/history" } } } ] }, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions" }, "profile" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/profile/institutions" }, "search" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/search" } } }'; 
    @TestSetup
    static void makeData(){
        
        List<String> endpoints = new List<String>();
        endpoints.add(SwitchingInstitutions_IH_v1.SwitchingInstitutions);
        endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH);
        endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH2);

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, endpoints);
    }
    
    @isTest static void switchingGetInstitutionsTest_Schedule() { 
        JitterbitAuthResponse res = JitterbitAuthResponse.getExample();
        RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();       

        mock.addResponse(JSON.serialize(res));
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET));
        SwitchingGetInstitutionsSchedule.processSwitchingSync();
        Test.stopTest();
    }
}
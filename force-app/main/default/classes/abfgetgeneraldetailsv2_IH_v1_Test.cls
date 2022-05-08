/*
* Test Integration Handler for abfgetgeneraldetailsv2_IH_v1 Service
* @author Srikanth N
* @created 2020-02-06
*/   

@isTest
public class abfgetgeneraldetailsv2_IH_v1_Test {
    
    @isTest 
    static void abfgetgeneraldetailsv2Positive() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new abfgetgeneraldetailsv2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.abfgetgeneraldetailsv2_STRING,'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.abfgetgeneraldetailsv2_STRING});
        Test.startTest();
        abfgetgeneraldetailsv2_IH_v1.getabfgetgeneraldetailsv2('04483850000284469',true);
        Test.stopTest();
    }
    
    @isTest 
    static void abfgetgeneraldetailsv2Negative1() {
        Test.startTest();
        abfgetgeneraldetailsv2_Req_IB_v1 dummyReq = new abfgetgeneraldetailsv2_Req_IB_v1();
        abfgetgeneraldetailsv2_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        abfgetgeneraldetailsv2_Resp_IB_v1 dummyResponseBean = abfgetgeneraldetailsv2_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new abfgetgeneraldetailsv2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.abfgetgeneraldetailsv2_STRING});
        
        abfgetgeneraldetailsv2_IH_v1.getabfgetgeneraldetailsv2('04483850000284469',true);
        Test.stopTest();
    }
    @isTest 
    static void abfgetgeneraldetailsv2Negative() {
        Test.startTest();
        abfgetgeneraldetailsv2_Req_IB_v1 dummyReq = new abfgetgeneraldetailsv2_Req_IB_v1();
        abfgetgeneraldetailsv2_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        abfgetgeneraldetailsv2_Resp_IB_v1 dummyResponseBean = abfgetgeneraldetailsv2_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new abfgetgeneraldetailsv2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.abfgetgeneraldetailsv2_STRING});
        abfgetgeneraldetailsv2_IH_v1.getabfgetgeneraldetailsv2('04483850000284469',true);
        Test.stopTest();
    }
    
}
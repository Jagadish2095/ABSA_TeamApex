/*
* Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
* @author Srikanth N
* @created 2020-02-06
*/   

@isTest
public class cclinkaccounttocombicardv3_IH_v1_Test {
    
    @isTest 
    static void cclinkaccounttocombicardv3Positive() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new cclinkaccounttocombicardv3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING,'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING});
        Test.startTest();
        cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3('04483850000284469','4048276744','COMBIK 002',true);
        Test.stopTest();
    }
    
    @isTest 
    static void cclinkaccounttocombicardv3Negative1() {
        Test.startTest();
        cclinkaccounttocombicardv3_Req_IB_v1 dummyReq = new cclinkaccounttocombicardv3_Req_IB_v1();
        cclinkaccounttocombicardv3_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        cclinkaccounttocombicardv3_Resp_IB_v1 dummyResponseBean = cclinkaccounttocombicardv3_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new cclinkaccounttocombicardv3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING});
        
        cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3('04483850000284469','4048276744','COMBIK 002',true);
        Test.stopTest();
    }
    @isTest 
    static void cclinkaccounttocombicardv3Negative() {
        Test.startTest();
        cclinkaccounttocombicardv3_Req_IB_v1 dummyReq = new cclinkaccounttocombicardv3_Req_IB_v1();
        cclinkaccounttocombicardv3_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        cclinkaccounttocombicardv3_Resp_IB_v1 dummyResponseBean = cclinkaccounttocombicardv3_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new cclinkaccounttocombicardv3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING});
        cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3('04483850000284469','4048276744','COMBIK 002',true);
        Test.stopTest();
    }
    
}
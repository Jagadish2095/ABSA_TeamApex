/*
* Test Integration Handler for cigetgeneralpowerofattorneyv4_IH_v1 Service
* @author Srikanth N
* @created 2020-02-06
*/   

@isTest
public class cigetgeneralpowerofattorneyv4_IH_v1_Test {
    
    @isTest 
    static void cigetgeneralpowerofattorneyv4Positive() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new cigetgeneralpowerofattorney_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cigetgeneralpowerofattorneyv4_STRING,'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.cigetgeneralpowerofattorneyv4_STRING});
        Test.startTest();
        cigetgeneralpowerofattorneyv4_IH_v1.getcigetgeneralpowerofattorneyv4('04483850000284469',true);
        Test.stopTest();
    }
    
    @isTest 
    static void cigetgeneralpowerofattorneyv4Negative1() {
        Test.startTest();
        cigetgeneralpowerofattorneyv4_Req_IB_v1 dummyReq = new cigetgeneralpowerofattorneyv4_Req_IB_v1();
        cigetgeneralpowerofattorneyv4_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        cigetgeneralpowerofattorneyv4_Resp_IB_v1 dummyResponseBean = cigetgeneralpowerofattorneyv4_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new cigetgeneralpowerofattorney_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.cigetgeneralpowerofattorneyv4_STRING});
        
        cigetgeneralpowerofattorneyv4_IH_v1.getcigetgeneralpowerofattorneyv4('04483850000284469',true);
        Test.stopTest();
    }
    @isTest 
    static void cigetgeneralpowerofattorneyv4Negative() {
        Test.startTest();
        cigetgeneralpowerofattorneyv4_Req_IB_v1 dummyReq = new cigetgeneralpowerofattorneyv4_Req_IB_v1();
        cigetgeneralpowerofattorneyv4_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        cigetgeneralpowerofattorneyv4_Resp_IB_v1 dummyResponseBean = cigetgeneralpowerofattorneyv4_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new cigetgeneralpowerofattorney_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.cigetgeneralpowerofattorneyv4_STRING});
        cigetgeneralpowerofattorneyv4_IH_v1.getcigetgeneralpowerofattorneyv4('04483850000284469',true);
        Test.stopTest();
    }
    
}
/*
* Test Integration Handler for mlviewcomprehensivedetailsv1_IH_v1 Service
* @author Srikanth N
* @created 2020-02-06
*/   

@isTest
public class mlviewcomprehensivedetailsv1_IH_v1_Test {
    
    @isTest 
    static void mlviewcomprehensivedetailsv1Positive() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new mlviewcomprehensivedetail_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.mlviewcomprehensivedetailsv1_STRING,'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.mlviewcomprehensivedetailsv1_STRING});
        Test.startTest();
        mlviewcomprehensivedetailsv1_IH_v1.getmlviewcomprehensivedetailsv1('04483850000284469',true);
        Test.stopTest();
    }
    
    @isTest 
    static void mlviewcomprehensivedetailsv1Negative1() {
        Test.startTest();
        mlviewcomprehensivedetailsv1_Req_IB_v1 dummyReq = new mlviewcomprehensivedetailsv1_Req_IB_v1();
        mlviewcomprehensivedetailsv1_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        mlviewcomprehensivedetailsv1_Resp_IB_v1 dummyResponseBean = mlviewcomprehensivedetailsv1_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new mlviewcomprehensivedetail_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.mlviewcomprehensivedetailsv1_STRING});
        
        mlviewcomprehensivedetailsv1_IH_v1.getmlviewcomprehensivedetailsv1('04483850000284469',true);
        Test.stopTest();
    }
    @isTest 
    static void mlviewcomprehensivedetailsv1Negative() {
        Test.startTest();
        mlviewcomprehensivedetailsv1_Req_IB_v1 dummyReq = new mlviewcomprehensivedetailsv1_Req_IB_v1();
        mlviewcomprehensivedetailsv1_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        mlviewcomprehensivedetailsv1_Resp_IB_v1 dummyResponseBean = mlviewcomprehensivedetailsv1_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new mlviewcomprehensivedetail_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.mlviewcomprehensivedetailsv1_STRING});
        mlviewcomprehensivedetailsv1_IH_v1.getmlviewcomprehensivedetailsv1('04483850000284469',true);
        Test.stopTest();
    }
    
}
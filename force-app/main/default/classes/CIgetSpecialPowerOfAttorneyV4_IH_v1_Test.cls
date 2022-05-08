/*
* Test Integration Handler for CIgetSpecialPowerOfAttorneyV4_IH_v1 Service
* @author Srikanth N
* @created 2020-02-06
*/   

@isTest
public class CIgetSpecialPowerOfAttorneyV4_IH_v1_Test {
    
    @isTest 
    static void CIgetSpecialPowerOfAttorneyV4Positive() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetSpecialPowerOfAttorney_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.CIgetSpecialPowerOfAttorneyV4_STRING,'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CIgetSpecialPowerOfAttorneyV4_STRING});
        Test.startTest();
        CIgetSpecialPowerOfAttorneyV4_IH_v1.getCIgetSpecialPowerOfAttorneyV4('04483850000284469',true);
        Test.stopTest();
    }
    
    @isTest 
    static void CIgetSpecialPowerOfAttorneyV4Negative1() {
        Test.startTest();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 dummyReq = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 dummyResponseBean = CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetSpecialPowerOfAttorney_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CIgetSpecialPowerOfAttorneyV4_STRING});
        
        CIgetSpecialPowerOfAttorneyV4_IH_v1.getCIgetSpecialPowerOfAttorneyV4('04483850000284469',true);
        Test.stopTest();
    }
    @isTest 
    static void CIgetSpecialPowerOfAttorneyV4Negative() {
        Test.startTest();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 dummyReq = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 dummyResponseBean = CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1.dummyResponse();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetSpecialPowerOfAttorney_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CIgetSpecialPowerOfAttorneyV4_STRING});
        CIgetSpecialPowerOfAttorneyV4_IH_v1.getCIgetSpecialPowerOfAttorneyV4('04483850000284469',true);
        Test.stopTest();
    }
    
}
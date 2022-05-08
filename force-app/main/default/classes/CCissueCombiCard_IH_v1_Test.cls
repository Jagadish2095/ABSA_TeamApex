@isTest
public class CCissueCombiCard_IH_v1_Test {
    
    @isTest static void CCissueCombiCardPositive() {
        
        CCissueCombiCardV1_Req_IB_v1 dummyReq = new CCissueCombiCardV1_Req_IB_v1();
        CCissueCombiCardV1_Req_IB_v1 dummyReqBean = dummyReq.createDummyRequest();
        //CCissueCombiCardV1_Resp_IB_v1 dummyResponseBean = CCissueCombiCardV1_Resp_IB_v1.dummyResponse();
        
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CCissueCombiCard_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {CCissueCombiCard_IH_v1.INTEGRATION_SERVICE_NAME});
        
        Test.startTest();
        
        CCissueCombiCardV1_Resp_IB_v1 responseBean = CCissueCombiCard_IH_v1.issueCombiCard ('4053443100', '8013','N', '1565','Y','','','','','8013', '12','034','1389','H','BBBBDO 008','4053443100', '0', '04938050012744758', '04938050012744758');
         System.AssertEquals(200, responseBean.statusCode, 'Assert Failed');                                                       
        Test.stopTest();
    }
    
    @isTest static void CCissueCombiCardNegative1() {
        
        CCissueCombiCardV1_Req_IB_v1 dummyReq = new CCissueCombiCardV1_Req_IB_v1();
        CCissueCombiCardV1_Req_IB_v1 dummyReqBean = dummyReq.createDummyRequest();
        //CCissueCombiCardV1_Resp_IB_v1 dummyResponseBean = CCissueCombiCardV1_Resp_IB_v1.dummyResponse();
        
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CCissueCombiCard_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {CCissueCombiCard_IH_v1.INTEGRATION_SERVICE_NAME });
        
        Test.startTest();
        CCissueCombiCardV1_Resp_IB_v1 responseBean = CCissueCombiCard_IH_v1.issueCombiCard ('4053443100', '8013','N', '1565','Y','','','','','8013', '12','034','1389','H','BBBBDO 008','4053443100', '0', '04938050012744758', '04938050012744758');
        System.AssertNotEquals(200, responseBean.statusCode, 'Assert Failed'); 
        Test.stopTest();
    }
    
   @isTest static void CCissueCombiCardV1Negative() {
        Test.startTest();
        CCissueCombiCardV1_Req_IB_v1 dummyReq = new CCissueCombiCardV1_Req_IB_v1();
        CCissueCombiCardV1_Req_IB_v1 dummyReqBean = dummyReq.createDummyRequest();
        //CCissueCombiCardV1_Resp_IB_v1 dummyResponseBean = CCissueCombiCardV1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CCissueCombiCard_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        CCissueCombiCardV1_Resp_IB_v1 responseBean = CCissueCombiCard_IH_v1.issueCombiCard ('4053443100', '8013','N', '1565','Y','','','','','8013', '12','034','1389','H','BBBBDO 008','4053443100', '0', '04938050012744758', '04938050012744758');
        System.AssertNotEquals(200, responseBean.statusCode, 'Assert Failed'); 
        Test.stopTest();
    }
}
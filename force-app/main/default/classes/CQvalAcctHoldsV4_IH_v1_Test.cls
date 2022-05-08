@isTest
public class CQvalAcctHoldsV4_IH_v1_Test {
    
    
    @isTest static void CQvalAcctHoldsV4Positive() {
        
        CQvalAcctHoldsV4_Req_IB_v1 dummyReq = new CQvalAcctHoldsV4_Req_IB_v1();
        CQvalAcctHoldsV4_Req_IB_v1 dummyReqBean = dummyReq.createDummy();
        CQvalAcctHoldsV4_Resp_IB_v1 dummyResponseBean = CQvalAcctHoldsV4_Resp_IB_v1.dummyResponse();
        
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CQvalAcctHoldsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_VAL_ACCOUNT_HOLDS});
        
        Test.startTest();
       
        CQvalAcctHoldsV4_IH_v1.callTocqvalacctholdsv4('4047995828','N','Y','N','N','N','N','Y','N','N','N','N','N','N','N','N','N','0','N','N','N','N');
        
        Test.stopTest();
    }
    
    @isTest static void CQvalAcctHoldsV4Negative1() {
        Test.startTest();
        CQvalAcctHoldsV4_Req_IB_v1 dummyReq = new CQvalAcctHoldsV4_Req_IB_v1();
        CQvalAcctHoldsV4_Req_IB_v1 dummyReqBean = dummyReq.createDummy();
        CQvalAcctHoldsV4_Resp_IB_v1 dummyResponseBean = CQvalAcctHoldsV4_Resp_IB_v1.dummyResponse();
        
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CQvalAcctHoldsV4_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_VAL_ACCOUNT_HOLDS });
        CQvalAcctHoldsV4_IH_v1.callTocqvalacctholdsv4('4047995828','N','Y','N','N','N','N','Y','N','N','N','N','N','N','N','N','N','0','N','N','N','N');
        Test.stopTest();
    }
    
     @isTest static void CQgetAcctHoldsMaintV4Negative() {
                 Test.startTest();
        CQvalAcctHoldsV4_Req_IB_v1 dummyReq = new CQvalAcctHoldsV4_Req_IB_v1();
        CQvalAcctHoldsV4_Req_IB_v1 dummyReqBean = dummyReq.createDummy();
        CQvalAcctHoldsV4_Resp_IB_v1 dummyResponseBean = CQvalAcctHoldsV4_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CQvalAcctHoldsV4_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
         CQvalAcctHoldsV4_IH_v1.callTocqvalacctholdsv4('4047995828','N','Y','N','N','N','N','Y','N','N','N','N','N','N','N','N','N','0','N','N','N','N');
         Test.stopTest();
    }
}
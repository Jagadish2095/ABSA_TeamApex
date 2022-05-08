@isTest
public class NhlistAcctTransHistoryv5_IH_v1_Test {
    
    
     @isTest static void nhlistAcctTransactionHistoryv5Positive() {
          
         NhlistAcctTransactionHistoryv5_Req_IB_v1 dummyReq = new NhlistAcctTransactionHistoryv5_Req_IB_v1();
         NhlistAcctTransactionHistoryv5_Req_IB_v1 dummyReqBean = dummyReq.createDummy();
         NhlistAccTransactionHistoryv5_Resp_IB_v1 dummyResponseBean = NhlistAccTransactionHistoryv5_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new NhlistAcctTransHIstoryv5_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.GET_TRANSACTION_HISTORY });
        
        Test.startTest();
      
              NhlistAcctTransactionHistoryv5_IH_v1.callTonhlistaccttransactionhistoryv5('9050986380','20200225','20200228');
       
          Test.stopTest();
    }
    
     @isTest static void nhlistAcctTransactionHistoryv5Negative1() {
           Test.startTest();
         NhlistAcctTransactionHistoryv5_Req_IB_v1 dummyReq = new NhlistAcctTransactionHistoryv5_Req_IB_v1();
         NhlistAcctTransactionHistoryv5_Req_IB_v1 dummyReqBean = dummyReq.createDummy();
         NhlistAccTransactionHistoryv5_Resp_IB_v1 dummyResponseBean = NhlistAccTransactionHistoryv5_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
       Test.setMock(HttpCalloutMock.class, new NhlistAcctTransHIstoryv5_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.GET_TRANSACTION_HISTORY });
       
        NhlistAcctTransactionHistoryv5_IH_v1.callTonhlistaccttransactionhistoryv5('9050986380','20200225','20200228');

        NhlistAcctTransactionHistoryv5_IU_v1.mapFailedResponseFields('Success', 200, 'success');
      
       
          Test.stopTest();
    }

}
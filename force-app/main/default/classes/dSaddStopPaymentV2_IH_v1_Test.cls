/*
 * Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
 * @author Srikanth N
 * @created 2020-02-06
 */   

@isTest
public class dSaddStopPaymentV2_IH_v1_Test {


     @isTest static void dSaddStopPaymentV2Positive() {
          
         dSaddStopPaymentV2_Req_IB_v1 dummyReq = new dSaddStopPaymentV2_Req_IB_v1();
         dSaddStopPaymentV2_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         dSaddStopPaymentV2_Resp_IB_v1 dummyResponseBean = dSaddStopPaymentV2_Resp_IB_v1.dummyResponse();
        dSaddStopPaymentV2_IU_v1.mapRequestdFields(); 
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSaddStopPaymentV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.dSaddStopPaymentV2_STRING});
        Test.startTest();
         dSaddStopPaymentV2_IH_v1.callTodSaddStopPaymentV2(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  dSaddStopPaymentV2_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
    
    @isTest static void dSaddStopPaymentV2Negative1() {
           Test.startTest();
         dSaddStopPaymentV2_Req_IB_v1 dummyReq = new dSaddStopPaymentV2_Req_IB_v1();
         dSaddStopPaymentV2_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         dSaddStopPaymentV2_Resp_IB_v1 dummyResponseBean = dSaddStopPaymentV2_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSaddStopPaymentV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.dSaddStopPaymentV2_STRING});
       
         dSaddStopPaymentV2_IH_v1.callTodSaddStopPaymentV2(dummyReqBean);//'4047433399','20191001' );//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  dSaddStopPaymentV2_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
 @isTest static void dSaddStopPaymentV2Negative() {
          Test.startTest();
         dSaddStopPaymentV2_Req_IB_v1 dummyReq = new dSaddStopPaymentV2_Req_IB_v1();
         dSaddStopPaymentV2_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         dSaddStopPaymentV2_Resp_IB_v1 dummyResponseBean = dSaddStopPaymentV2_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSaddStopPaymentV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.dSaddStopPaymentV2_STRING});
         dSaddStopPaymentV2_IH_v1.callTodSaddStopPaymentV2(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
           Test.stopTest();
    }

}
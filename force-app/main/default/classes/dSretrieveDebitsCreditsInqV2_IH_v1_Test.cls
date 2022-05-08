/*
 * Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
 * @author Srikanth N
 * @created 2020-02-06
 */   

@isTest
public class dSretrieveDebitsCreditsInqV2_IH_v1_Test {


     @isTest static void dSretrieveDebitsCreditsInqV2Positive() {
          
         dSretrieveDebitsCreditsInqV2_Req_IB_v1 dummyReq = new dSretrieveDebitsCreditsInqV2_Req_IB_v1();
         dSretrieveDebitsCreditsInqV2_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         dSretrieveDebitsCreditsInqV2_Resp_IB_v1 dummyResponseBean = dSretrieveDebitsCreditsInqV2_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.dSretrieveDebitsCreditsInqV2_STRING});
        Test.startTest();
         dSretrieveDebitsCreditsInqV2_IH_v1.callTodSretrieveDebitsCreditsInqV2('4047433399','20191001' );//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  dSretrieveDebitsCreditsInqV2_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
    
     @isTest static void dSretrieveDebitsCreditsInqV2Negative1() {
           Test.startTest();
         dSretrieveDebitsCreditsInqV2_Req_IB_v1 dummyReq = new dSretrieveDebitsCreditsInqV2_Req_IB_v1();
         dSretrieveDebitsCreditsInqV2_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         dSretrieveDebitsCreditsInqV2_Resp_IB_v1 dummyResponseBean = dSretrieveDebitsCreditsInqV2_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.dSretrieveDebitsCreditsInqV2_STRING});
       
         dSretrieveDebitsCreditsInqV2_IH_v1.callTodSretrieveDebitsCreditsInqV2('4047433399','20191001' );//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  dSretrieveDebitsCreditsInqV2_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
 @isTest static void dSretrieveDebitsCreditsInqV2Negative() {
                 Test.startTest();
         dSretrieveDebitsCreditsInqV2_Req_IB_v1 dummyReq = new dSretrieveDebitsCreditsInqV2_Req_IB_v1();
         dSretrieveDebitsCreditsInqV2_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         dSretrieveDebitsCreditsInqV2_Resp_IB_v1 dummyResponseBean = dSretrieveDebitsCreditsInqV2_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
       // IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.dSretrieveDebitsCreditsInqV2_STRING});
       
         dSretrieveDebitsCreditsInqV2_IH_v1.callTodSretrieveDebitsCreditsInqV2('4047433399','20191001' );//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
           Test.stopTest();
    }

}
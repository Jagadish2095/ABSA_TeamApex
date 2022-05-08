/*
 * Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
 * @author Srikanth N
 * @created 2020-02-06
 */   

@isTest
public class gPpaymReturnV1_IH_v1_Test {


     @isTest static void gPpaymReturnV1Positive() {
          
         gPpaymReturnV1_Req_IB_v1 dummyReq = new gPpaymReturnV1_Req_IB_v1();
         gPpaymReturnV1_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         gPpaymReturnV1_Resp_IB_v1 dummyResponseBean = gPpaymReturnV1_Resp_IB_v1.dummyResponse();
        gPpaymReturnV1_IU_v1.mapRequestdFields();
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new gPpaymReturnV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.gPpaymReturnV1_STRING});
        Test.startTest();
         gPpaymReturnV1_IH_v1.callTogPpaymReturnV1(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  gPpaymReturnV1_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
    
     @isTest static void gPpaymReturnV1Negative1() {
           Test.startTest();
         gPpaymReturnV1_Req_IB_v1 dummyReq = new gPpaymReturnV1_Req_IB_v1();
         gPpaymReturnV1_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         gPpaymReturnV1_Resp_IB_v1 dummyResponseBean = gPpaymReturnV1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new gPpaymReturnV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.gPpaymReturnV1_STRING});
       
         gPpaymReturnV1_IH_v1.callTogPpaymReturnV1(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  gPpaymReturnV1_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
 @isTest static void gPpaymReturnV1Negative() {
          Test.startTest();
         gPpaymReturnV1_Req_IB_v1 dummyReq = new gPpaymReturnV1_Req_IB_v1();
         gPpaymReturnV1_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
         gPpaymReturnV1_Resp_IB_v1 dummyResponseBean = gPpaymReturnV1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new gPpaymReturnV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.gPpaymReturnV1_STRING});
         gPpaymReturnV1_IH_v1.callTogPpaymReturnV1(dummyReqBean);
           Test.stopTest();
    }

}
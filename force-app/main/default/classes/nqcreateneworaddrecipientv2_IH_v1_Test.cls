/*
 * Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
 * @author Srikanth N
 * @created 2020-03-22
 */   

@isTest
public class nqcreateneworaddrecipientv2_IH_v1_Test {


     @isTest static void nqcreateneworaddrecipientv2Positive() {
          
         nqcreateneworaddrecipientv2_Req_IB_v1 dummyReq = new nqcreateneworaddrecipientv2_Req_IB_v1();
         nqcreateneworaddrecipientv2_Req_IB_v1 dummyReqBean = nqcreateneworaddrecipientv2_Req_IB_v1.createDummyBean();
         nqcreateneworaddrecipientv2_Resp_IB_v1 dummyResponseBean = nqcreateneworaddrecipientv2_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings('JitterbitDev', new list<String> {StringConstants.nqcreateneworaddrecipientv2_STRING});
        Test.startTest();
         nqcreateneworaddrecipientv2_IH_v1.callTonqcreateneworaddrecipientv2(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         nqcreateneworaddrecipientv2_IU_v1.mapRequestdFields();
        
      //  nqcreateneworaddrecipientv2_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
    
     @isTest static void nqcreateneworaddrecipientv2Negative1() {
           Test.startTest();
         nqcreateneworaddrecipientv2_Req_IB_v1 dummyReq = new nqcreateneworaddrecipientv2_Req_IB_v1();
         nqcreateneworaddrecipientv2_Req_IB_v1 dummyReqBean = nqcreateneworaddrecipientv2_Req_IB_v1.createDummyBean();
         nqcreateneworaddrecipientv2_Resp_IB_v1 dummyResponseBean = nqcreateneworaddrecipientv2_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.nqcreateneworaddrecipientv2_STRING});
       
         nqcreateneworaddrecipientv2_IH_v1.callTonqcreateneworaddrecipientv2(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  nqcreateneworaddrecipientv2_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
 @isTest static void nqcreateneworaddrecipientv2Negative() {
                 Test.startTest();
         nqcreateneworaddrecipientv2_Req_IB_v1 dummyReq = new nqcreateneworaddrecipientv2_Req_IB_v1();
         nqcreateneworaddrecipientv2_Req_IB_v1 dummyReqBean = nqcreateneworaddrecipientv2_Req_IB_v1.createDummyBean();
         nqcreateneworaddrecipientv2_Resp_IB_v1 dummyResponseBean = nqcreateneworaddrecipientv2_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
       // IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.nqcreateneworaddrecipientv2_STRING});
       
         nqcreateneworaddrecipientv2_IH_v1.callTonqcreateneworaddrecipientv2( dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
           Test.stopTest();
    }

}
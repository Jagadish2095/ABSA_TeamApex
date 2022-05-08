/*
 * Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
 * @author Srikanth N
 * @created 2020-03-22
 */   

@isTest
public class nqcancelacctnotificationv1_IH_v1_Test {


     @isTest static void nqcancelacctnotificationv1Positive() {
          
         nqcancelacctnotificationv1_Req_IB_v1 dummyReqBean = nqcancelacctnotificationv1_Req_IB_v1.createDummyBean();
         nqcancelacctnotificationv1_Resp_IB_v1 dummyResponseBean = nqcancelacctnotificationv1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings('JitterbitDev', new list<String> {StringConstants.nqcancelacctnotificationv1_STRING});
        Test.startTest();
         nqcancelacctnotificationv1_IH_v1.callTonqcancelacctnotificationv1(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         nqcancelacctnotificationv1_IU_v1.mapRequestdFields();
        
      //  nqcancelacctnotificationv1_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
    
     @isTest static void nqcancelacctnotificationv1Negative1() {
           Test.startTest();
         
         nqcancelacctnotificationv1_Req_IB_v1 dummyReqBean = nqcancelacctnotificationv1_Req_IB_v1.createDummyBean();
         nqcancelacctnotificationv1_Resp_IB_v1 dummyResponseBean = nqcancelacctnotificationv1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.nqcancelacctnotificationv1_STRING});
       
         nqcancelacctnotificationv1_IH_v1.callTonqcancelacctnotificationv1(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  nqcancelacctnotificationv1_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
 @isTest static void nqcancelacctnotificationv1Negative() {
                 Test.startTest();
      
         nqcancelacctnotificationv1_Req_IB_v1 dummyReqBean = nqcancelacctnotificationv1_Req_IB_v1.createDummyBean();
         nqcancelacctnotificationv1_Resp_IB_v1 dummyResponseBean = nqcancelacctnotificationv1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
       // IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.nqcancelacctnotificationv1_STRING});
       
         nqcancelacctnotificationv1_IH_v1.callTonqcancelacctnotificationv1( dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
           Test.stopTest();
    }

}
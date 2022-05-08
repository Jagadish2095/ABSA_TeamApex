/*
 * Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
 * @author Srikanth N
 * @created 2020-03-22
 */   

@isTest
public class nqupdatenotificationsv1_IH_v1_Test {


     @isTest static void nqupdatenotificationsv1Positive() {
          
         nqupdatenotificationsv1_Req_IB_v1 dummyReqBean = nqupdatenotificationsv1_Req_IB_v1.createDummyBean();
         nqupdatenotificationsv1_Resp_IB_v1 dummyResponseBean = nqupdatenotificationsv1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings('JitterbitDev', new list<String> {StringConstants.nqupdatenotificationsv1_STRING});
        Test.startTest();
         nqupdatenotificationsv1_IH_v1.callTonqupdatenotificationsv1(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        nqupdatenotificationsv1_IU_v1.mapRequestdFields();
      //  nqupdatenotificationsv1_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
    
     @isTest static void nqupdatenotificationsv1Negative1() {
           Test.startTest();
         
         nqupdatenotificationsv1_Req_IB_v1 dummyReqBean = nqupdatenotificationsv1_Req_IB_v1.createDummyBean();
         nqupdatenotificationsv1_Resp_IB_v1 dummyResponseBean = nqupdatenotificationsv1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.nqupdatenotificationsv1_STRING});
       
         nqupdatenotificationsv1_IH_v1.callTonqupdatenotificationsv1(dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
         
        
      //  nqupdatenotificationsv1_IU_v1.mapRequestdFields(dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
       
          Test.stopTest();
    }
 @isTest static void nqupdatenotificationsv1Negative() {
                 Test.startTest();
      
         nqupdatenotificationsv1_Req_IB_v1 dummyReqBean = nqupdatenotificationsv1_Req_IB_v1.createDummyBean();
         nqupdatenotificationsv1_Resp_IB_v1 dummyResponseBean = nqupdatenotificationsv1_Resp_IB_v1.dummyResponse();
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
       // IntegrationTestDataFactory.insertIntegrationSettings('JitterbitTest', new list<String> {StringConstants.nqupdatenotificationsv1_STRING});
       
         nqupdatenotificationsv1_IH_v1.callTonqupdatenotificationsv1( dummyReqBean);//dummyReqBean.dsp973i.acno ,dummyReqBean.dsp973i.effFromDate);
           Test.stopTest();
    }

}
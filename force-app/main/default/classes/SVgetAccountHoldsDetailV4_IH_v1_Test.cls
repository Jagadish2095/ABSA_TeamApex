/* Lightning cmp controller for View and remove holds(Savings and cheques)
 * Author: Lulu Rankwe
 * Date :  12/06/2020 
 */
@isTest
public class SVgetAccountHoldsDetailV4_IH_v1_Test {
    
    
    @isTest static void SVgetAccountHoldsDetailV4Positive() {
        
        SVgetAccountHoldsDetailV4_Req_IB_v1 dummyReq = new SVgetAccountHoldsDetailV4_Req_IB_v1();
        SVgetAccountHoldsDetailV4_Req_IB_v1 dummyReqBean = dummyReq.createDummy();
        SVgetAccountHoldsDetailV4_Resp_IB_v1 dummyResponseBean = SVgetAccountHoldsDetailV4_Resp_IB_v1.dummyResponse();

           // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SVgetAccountHoldsDetailV4_MockApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.SV_GET_ACCOUNT_HOLDS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
 
        
        Test.startTest();
        Map<SVgetAccountHoldsDetailV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVgetAccountHoldsDetailV4_IH_v1.callTosvgetaccountholdsdetailv4('9050986380','25698','8089','25699');        
        SVgetAccountHoldsDetailV4_Resp_IB_v1 responseBean = (new List<SVgetAccountHoldsDetailV4_Resp_IB_v1>(responseMap.keySet()))[0];  
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();   
        
    }
    
   @isTest static void SVgetAccountHoldsDetailV4Negative1() {

        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SVgetAccountHoldsDetailV4_MockApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.SV_GET_ACCOUNT_HOLDS });
        
        Test.startTest();
        Map<SVgetAccountHoldsDetailV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVgetAccountHoldsDetailV4_IH_v1.callTosvgetaccountholdsdetailv4('','','','');        
        SVgetAccountHoldsDetailV4_Resp_IB_v1 responseBean = (new List<SVgetAccountHoldsDetailV4_Resp_IB_v1>(responseMap.keySet()))[0];
        system.assertNotEquals(200, responseBean.statusCode);
        Test.stopTest();   
        
    }
    
      @isTest static void SVgetAccountHoldsDetailV4V1Exception() {

           SVgetAccountHoldsDetailV4_Req_IB_v1 dummyReq = new SVgetAccountHoldsDetailV4_Req_IB_v1();
       SVgetAccountHoldsDetailV4_Req_IB_v1 dummyReqBean = dummyReq.createDummy();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nHgetSentProductNtfV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NHGETSENTPRODUCTNOTIFICATIONV1_STRING
        });

        Test.startTest();        
        Map<SVgetAccountHoldsDetailV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVgetAccountHoldsDetailV4_IH_v1.callTosvgetaccountholdsdetailv4('','','','');   
		SVgetAccountHoldsDetailV4_Resp_IB_v1 responseBean = (new List<SVgetAccountHoldsDetailV4_Resp_IB_v1>(responseMap.keySet()))[0];        
        System.assertEquals(500, responseBean.statusCode);        
        Test.stopTest();
    }

    
}
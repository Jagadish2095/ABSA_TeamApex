/*
*Test Integration Handler for BCancelServicev1 Service
* @author Lulu Rankwe
* @created 05/05/2020
*/
@isTest
public class IBCancelServicev1_IH_v1_Test {
   
    
    @isTest static void testCreateInstructionPositive(){
        
        IBCancelServicev1_Req_IB_v1 dummyBean = new IBCancelServicev1_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        IBCancelServicev1_Res_IB_v1 dummyResponseBean = new IBCancelServicev1_Res_IB_v1();
        dummyResponseBean.dummyResponse();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IBCancelServicev1Mock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.IBCANCELSERVICE});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        // Call the method to test
        IBCancelServicev1_Res_IB_v1 responseBean = IBCancelService_IH_v1.cancelService('4048276744','4','Testing','N','N','N','N','N','N','Y','8089','11012','25699');
       
        System.debug('  Code responseBean positive: '+ responseBean);
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();   
    }
 
    
  @isTest static void IBCancelServicev1Negative()
    {               
        Test.setMock(HttpCalloutMock.class, new IBCancelServicev1Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        IBCancelServicev1_Res_IB_v1 responseBean = IBCancelService_IH_v1.cancelService('','','','','','','','','','','','','');
        System.assertEquals(null,responseBean);
        
        Test.stopTest();
    }

}
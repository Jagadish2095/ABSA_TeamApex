/*
*Test Integration Handlerfor CCcloseV2 Service
* @author Lulu Rankwe
* @created 2020-03-19
*/
@isTest
public class CCcloseV2_IH_v1_Test {
    
    @isTest static void closeCombiCardPositive() 
    {        
        CCcloseV2_Req_IB_v1 dummyBean = new CCcloseV2_Req_IB_v1();
        dummyBean.createDummy();
        
        CCcloseV2_Resp_IB_v1 dummyResponseBean = CCcloseV2_Resp_IB_v1.dummyResponse();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CCcloseV2Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CCCLOSE});
		
        Test.startTest();
              
        CCcloseV2_IH_v1.closeCombiCard('05010111072983622','Customer Request','Others');       
   		//System.assertEquals(200, singleresponse.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void closeCombiCardNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CCcloseV2Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CCCLOSE});
        
        Test.startTest();
        
        CCcloseV2_IH_v1.closeCombiCard('05010111072983622','Customer Request','Others');
        
        Test.stopTest();
    }
    
     @isTest static void CCcloseV2Negative2() {
                 Test.startTest();
        CCcloseV2_Req_IB_v1 dummyBean = new CCcloseV2_Req_IB_v1();
        dummyBean.createDummy();
        
        CCcloseV2_Resp_IB_v1 dummyResponseBean = CCcloseV2_Resp_IB_v1.dummyResponse();
        
        
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CCcloseV2Mock_ApiRest(StringConstants.POSITIVE_STRING));
        CCcloseV2_IH_v1.closeCombiCard('05010111072983622','Customer Request','Others'); 
         Test.stopTest();
    }
    

}
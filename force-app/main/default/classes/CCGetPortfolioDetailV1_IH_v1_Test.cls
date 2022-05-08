/*
 * Test Integration Handler for CCGetPortfolioDetailV1 Service
 * @author Prashant Jain
 * @created 2020-03-16
 */

@isTest
public class CCGetPortfolioDetailV1_IH_v1_Test {
     @isTest static void validateCCGetPortfolioDetailV1Positive() {
        CCGetPortfolioDetailV1_Req_IB_v1 dummyBeanParent = CCGetPortfolioDetailV1_Req_IB_v1.createDummyRequest();
        CCGetPortfolioDetailV1_Req_IB_v1.Ccp301i dummyBean = dummyBeanParent.CCgetPortfolioDetailV1.ccp301i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCGetPortfolioDetailV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.CC_GET_PORTFOLIO_DETAIL_V1
        });

        Test.startTest();
        
        Map<CCGetPortfolioDetailV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCGetPortfolioDetailV1_IH_v1.CCGetPortfolioDetailV1(dummyBean.combiNbr);
		// Get first key from the map
		CCGetPortfolioDetailV1_Resp_IB_v1 responseBean = (new List<CCGetPortfolioDetailV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateCCGetPortfolioDetailV1Negative() {
        CCGetPortfolioDetailV1_Req_IB_v1 dummyBeanParent = CCGetPortfolioDetailV1_Req_IB_v1.createDummyRequest();
        CCGetPortfolioDetailV1_Req_IB_v1.Ccp301i dummyBean = dummyBeanParent.CCgetPortfolioDetailV1.ccp301i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCGetPortfolioDetailV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.CC_GET_PORTFOLIO_DETAIL_V1
        });

        Test.startTest();

        Map<CCGetPortfolioDetailV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCGetPortfolioDetailV1_IH_v1.CCGetPortfolioDetailV1(dummyBean.combiNbr);
		// Get first key from the map
		CCGetPortfolioDetailV1_Resp_IB_v1 responseBean = (new List<CCGetPortfolioDetailV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateCCGetPortfolioDetailV1NoIntegrationSettings() {
        CCGetPortfolioDetailV1_Req_IB_v1 dummyBeanParent = CCGetPortfolioDetailV1_Req_IB_v1.createDummyRequest();
        CCGetPortfolioDetailV1_Req_IB_v1.Ccp301i dummyBean = dummyBeanParent.CCgetPortfolioDetailV1.ccp301i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<CCGetPortfolioDetailV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCGetPortfolioDetailV1_IH_v1.CCGetPortfolioDetailV1(dummyBean.combiNbr);
		// Get first key from the map
		CCGetPortfolioDetailV1_Resp_IB_v1 responseBean = (new List<CCGetPortfolioDetailV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateCCGetPortfolioDetailV1Exception() {
        CCGetPortfolioDetailV1_Req_IB_v1 dummyBeanParent = CCGetPortfolioDetailV1_Req_IB_v1.createDummyRequest();
        CCGetPortfolioDetailV1_Req_IB_v1.Ccp301i dummyBean = dummyBeanParent.CCgetPortfolioDetailV1.ccp301i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCGetPortfolioDetailV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.CC_GET_PORTFOLIO_DETAIL_V1
        });

        Test.startTest();
        
        Map<CCGetPortfolioDetailV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCGetPortfolioDetailV1_IH_v1.CCGetPortfolioDetailV1(dummyBean.combiNbr);
		// Get first key from the map
		CCGetPortfolioDetailV1_Resp_IB_v1 responseBean = (new List<CCGetPortfolioDetailV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
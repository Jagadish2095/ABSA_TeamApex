/*
 * Test Integration Handler for CCgetDailyLimits Service
 * @author Prashant Jain
 * @created 2019-09-11
 */

 @ isTest
public class CCgetDailyLimits_IH_v1_Test {
     @ isTest static void validateCCgetDailyLimitsPositive() {
        CCgetDailyLimits_Req_IB_v1 dummyBean = CCgetDailyLimits_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCgetDailyLimits_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CC_GET_DAILY_LIMITS
        });

        Test.startTest();

        Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCgetDailyLimits_IH_v1.CCgetDailyLimits(dummyBean.combiNbr);
		// Get first key from the map
		CCgetDailyLimits_Resp_IB_v1 responseBean = (new List<CCgetDailyLimits_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

     @ isTest static void validateCCgetDailyLimitsNegative() {
        CCgetDailyLimits_Req_IB_v1 dummyBean = CCgetDailyLimits_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCgetDailyLimits_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CC_GET_DAILY_LIMITS
        });

        Test.startTest();

        Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCgetDailyLimits_IH_v1.CCgetDailyLimits(dummyBean.combiNbr);
		// Get first key from the map
		CCgetDailyLimits_Resp_IB_v1 responseBean = (new List<CCgetDailyLimits_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @ isTest static void validateCCgetDailyLimitsNoIntegrationSettings() {
        CCgetDailyLimits_Req_IB_v1 dummyBean = CCgetDailyLimits_Req_IB_v1.createDummyRequest();

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCgetDailyLimits_IH_v1.CCgetDailyLimits(dummyBean.combiNbr);
		// Get first key from the map
		CCgetDailyLimits_Resp_IB_v1 responseBean = (new List<CCgetDailyLimits_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @ isTest static void validateCCgetDailyLimitsException() {
        CCgetDailyLimits_Req_IB_v1 dummyBean = CCgetDailyLimits_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCgetDailyLimits_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CC_GET_DAILY_LIMITS
        });

        Test.startTest();
        
        Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCgetDailyLimits_IH_v1.CCgetDailyLimits(dummyBean.combiNbr);
		// Get first key from the map
		CCgetDailyLimits_Resp_IB_v1 responseBean = (new List<CCgetDailyLimits_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
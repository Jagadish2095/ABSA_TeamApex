/*
 * Test Integration Handler for CCupdDailyTransactionLimitsV2 Service
 * @author Muvhuso Nekhubvi
 * @created 2019-10-10
 */
@isTest
public class CCupdDailyTransactionLimitsV2_IH_v1_Test {
    
    @ isTest static void validateCCupdDailyTransactionLimitsV2Positive() {
        CCupdDailyTransactionLimitsV2_Req_IB_v1 dummyBean = CCupdDailyTransactionLimitsV2_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCupdDailyTransLimitsV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CC_UPDATE_DAILY_LIMITS
        });

        Test.startTest();

        Map<CCupdDailyTransactionLimitsV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCupdDailyTransactionLimitsV2_IH_v1.CCupdateDailyLimits(dummyBean.tellerCode, dummyBean.workStation, dummyBean.supervisor, dummyBean.branchCode, dummyBean.combiNbr, dummyBean.cardCshLim, dummyBean.cardTrfLim, dummyBean.cardPosLim, dummyBean.cardCntLim, dummyBean.cheqNomAcc, dummyBean.cheqApplNo, dummyBean.cheqCshLim, dummyBean.cheqTrfLim, dummyBean.cheqPosLim, dummyBean.savsNomAcc, dummyBean.savsApplNo, dummyBean.savsCshLim, dummyBean.savsTrfLim, dummyBean.savsPosLim);
		// Get first key from the map
		CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBean = (new List<CCupdDailyTransactionLimitsV2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

     @ isTest static void validateCCupdateDailyLimitsNegative() {
        CCupdDailyTransactionLimitsV2_Req_IB_v1 dummyBean = CCupdDailyTransactionLimitsV2_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCupdDailyTransLimitsV2_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CC_UPDATE_DAILY_LIMITS
        });

        Test.startTest();

       Map<CCupdDailyTransactionLimitsV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCupdDailyTransactionLimitsV2_IH_v1.CCupdateDailyLimits(dummyBean.tellerCode, dummyBean.workStation, dummyBean.supervisor, dummyBean.branchCode, dummyBean.combiNbr, dummyBean.cardCshLim, dummyBean.cardTrfLim, dummyBean.cardPosLim, dummyBean.cardCntLim, dummyBean.cheqNomAcc, dummyBean.cheqApplNo, dummyBean.cheqCshLim, dummyBean.cheqTrfLim, dummyBean.cheqPosLim, dummyBean.savsNomAcc, dummyBean.savsApplNo, dummyBean.savsCshLim, dummyBean.savsTrfLim, dummyBean.savsPosLim);
		// Get first key from the map
		CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBean = (new List<CCupdDailyTransactionLimitsV2_Resp_IB_v1>(responseMap.keySet()))[0];
        
		
        Test.stopTest();
    }

     @ isTest static void validateCCupdateDailyLimitsNoIntegrationSettings() {
        CCupdDailyTransactionLimitsV2_Req_IB_v1 dummyBean = CCupdDailyTransactionLimitsV2_Req_IB_v1.createDummyRequest();

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
         Map<CCupdDailyTransactionLimitsV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCupdDailyTransactionLimitsV2_IH_v1.CCupdateDailyLimits(dummyBean.tellerCode, dummyBean.workStation, dummyBean.supervisor, dummyBean.branchCode, dummyBean.combiNbr, dummyBean.cardCshLim, dummyBean.cardTrfLim, dummyBean.cardPosLim, dummyBean.cardCntLim, dummyBean.cheqNomAcc, dummyBean.cheqApplNo, dummyBean.cheqCshLim, dummyBean.cheqTrfLim, dummyBean.cheqPosLim, dummyBean.savsNomAcc, dummyBean.savsApplNo, dummyBean.savsCshLim, dummyBean.savsTrfLim, dummyBean.savsPosLim);
		// Get first key from the map
		CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBean = (new List<CCupdDailyTransactionLimitsV2_Resp_IB_v1>(responseMap.keySet()))[0];
        
		
        Test.stopTest();
    }

     @ isTest static void validateCCupdateDailyLimitsException() {
        CCupdDailyTransactionLimitsV2_Req_IB_v1 dummyBean = CCupdDailyTransactionLimitsV2_Req_IB_v1.createDummyRequest();

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
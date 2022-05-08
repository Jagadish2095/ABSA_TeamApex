/*
 * Test Integration Handler for DSretrieveDebitsCreditsInq Service
 * @author Prasanna Patwardhan
 * @created 2019-10-30
 */
@ isTest
public class DSretrieveDebitsCreditsInqV1_IH_v1_Test {
     @ isTest static void validateDSretrieveDebitsCreditsInqPositive() {
        DSretrieveDebitsCreditsInqV1_Req_IB_v1 dummyBean = DSretrieveDebitsCreditsInqV1_Req_IB_v1.createDummyRequest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new DSretrieveDebitsCredInqV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.DEBIT_RETRI_DETAILS_CARD_V1
        });

        Test.startTest();
        Map<DSretrieveDebitsCreditsInqV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = DSretrieveDebitsCreditsInqV1_IH_v1.DSretrieveDebitsCreditsInqV1Details(dummyBean.acno, dummyBean.effFromDate);
		// Get first key from the map
		DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean = (new List<DSretrieveDebitsCreditsInqV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
         DSretrieveDebitsCreditsInqV1_Resp_IB_v1.dummyResponse();
    }

     @ isTest static void validateDSretrieveDebitsCreditsInqNegative() {
        DSretrieveDebitsCreditsInqV1_Req_IB_v1 dummyBean = DSretrieveDebitsCreditsInqV1_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new DSretrieveDebitsCredInqV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.DEBIT_RETRI_DETAILS_CARD_V1
        });

        Test.startTest();

        Map<DSretrieveDebitsCreditsInqV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = DSretrieveDebitsCreditsInqV1_IH_v1.DSretrieveDebitsCreditsInqV1Details(dummyBean.acno, dummyBean.effFromDate);
		// Get first key from the map
		DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean = (new List<DSretrieveDebitsCreditsInqV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
         DSretrieveDebitsCreditsInqV1_Resp_IB_v1.dummyResponse();
    }

     @ isTest static void validateDSretrieveDebitsCreditsInqNoIntegrationSettings() {
        DSretrieveDebitsCreditsInqV1_Req_IB_v1 dummyBean = DSretrieveDebitsCreditsInqV1_Req_IB_v1.createDummyRequest();

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<DSretrieveDebitsCreditsInqV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = DSretrieveDebitsCreditsInqV1_IH_v1.DSretrieveDebitsCreditsInqV1Details(dummyBean.acno, dummyBean.effFromDate);
		// Get first key from the map
		DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean = (new List<DSretrieveDebitsCreditsInqV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
         DSretrieveDebitsCreditsInqV1_Resp_IB_v1.dummyResponse();
    }

     @ isTest static void validateDSretrieveDebitsCreditsInqException() {
        DSretrieveDebitsCreditsInqV1_Req_IB_v1 dummyBean = DSretrieveDebitsCreditsInqV1_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new DSretrieveDebitsCredInqV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.DEBIT_RETRI_DETAILS_CARD_V1
        });

        Test.startTest();
        
        Map<DSretrieveDebitsCreditsInqV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = DSretrieveDebitsCreditsInqV1_IH_v1.DSretrieveDebitsCreditsInqV1Details(dummyBean.acno, dummyBean.effFromDate);
		// Get first key from the map
		DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean = (new List<DSretrieveDebitsCreditsInqV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
         DSretrieveDebitsCreditsInqV1_Resp_IB_v1.dummyResponse();
    }

}
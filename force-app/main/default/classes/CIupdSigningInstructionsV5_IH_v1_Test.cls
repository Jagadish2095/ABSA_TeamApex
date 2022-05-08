/*
 * Test Integration Handler for CIupdSigningInstructionsV5 Service
 * @author Prashant Jain
 * @created 2020-02-25
 */

@isTest
public class CIupdSigningInstructionsV5_IH_v1_Test {
     @isTest static void validateCIupdSigningInstructionsV5Positive() {
        CIupdSigningInstructionsV5_Req_IB_v1 dummyBean = CIupdSigningInstructionsV5_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIupdSigningInstructionsV5_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CI_UPD_SIGNING_INSTRUCTIONS_V5
        });

        Test.startTest();
        
        Map<CIupdSigningInstructionsV5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIupdSigningInstructionsV5_IH_v1.CIupdSigningInstructionsV5(dummyBean);
		// Get first key from the map
		CIupdSigningInstructionsV5_Resp_IB_v1 responseBean = (new List<CIupdSigningInstructionsV5_Resp_IB_v1>(responseMap.keySet()))[0];
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateCIupdSigningInstructionsV5Negative() {
        CIupdSigningInstructionsV5_Req_IB_v1 dummyBean = CIupdSigningInstructionsV5_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIupdSigningInstructionsV5_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CI_UPD_SIGNING_INSTRUCTIONS_V5
        });

        Test.startTest();

        Map<CIupdSigningInstructionsV5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIupdSigningInstructionsV5_IH_v1.CIupdSigningInstructionsV5(dummyBean);
		// Get first key from the map
		CIupdSigningInstructionsV5_Resp_IB_v1 responseBean = (new List<CIupdSigningInstructionsV5_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateCIupdSigningInstructionsV5NoIntegrationSettings() {
        CIupdSigningInstructionsV5_Req_IB_v1 dummyBean = CIupdSigningInstructionsV5_Req_IB_v1.createDummyRequest();

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<CIupdSigningInstructionsV5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIupdSigningInstructionsV5_IH_v1.CIupdSigningInstructionsV5(dummyBean);
		// Get first key from the map
		CIupdSigningInstructionsV5_Resp_IB_v1 responseBean = (new List<CIupdSigningInstructionsV5_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateCIupdSigningInstructionsV5Exception() {
        CIupdSigningInstructionsV5_Req_IB_v1 dummyBean = CIupdSigningInstructionsV5_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIupdSigningInstructionsV5_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CI_UPD_SIGNING_INSTRUCTIONS_V5
        });

        Test.startTest();
        
        Map<CIupdSigningInstructionsV5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIupdSigningInstructionsV5_IH_v1.CIupdSigningInstructionsV5(dummyBean);
		// Get first key from the map
		CIupdSigningInstructionsV5_Resp_IB_v1 responseBean = (new List<CIupdSigningInstructionsV5_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
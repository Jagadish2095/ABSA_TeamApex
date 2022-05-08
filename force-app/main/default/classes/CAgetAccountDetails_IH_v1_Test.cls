/*
 * Test Integration Handler for CAgetAccountDetails Service
 * @author Prashant Jain
 * @created 2019-09-27
 */

 @ isTest
public class CAgetAccountDetails_IH_v1_Test {
     @ isTest static void validateCAgetAccountDetailsPositive() {
        CAgetAccountDetails_Req_IB_v1 dummyBean = CAgetAccountDetails_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CAgetAccountDetails_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CA_GET_ACCOUNT_DETAILS
        });

        Test.startTest();
        
        Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CAgetAccountDetails_IH_v1.CAgetAccountDetails(dummyBean.accountNumber);
		// Get first key from the map
		CAgetAccountDetails_Resp_IB_v1 responseBean = (new List<CAgetAccountDetails_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @ isTest static void validateCAgetAccountDetailsNegative() {
        CAgetAccountDetails_Req_IB_v1 dummyBean = CAgetAccountDetails_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CAgetAccountDetails_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CA_GET_ACCOUNT_DETAILS
        });

        Test.startTest();

        Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CAgetAccountDetails_IH_v1.CAgetAccountDetails(dummyBean.accountNumber);
		// Get first key from the map
		CAgetAccountDetails_Resp_IB_v1 responseBean = (new List<CAgetAccountDetails_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @ isTest static void validateCAgetAccountDetailsNoIntegrationSettings() {
        CAgetAccountDetails_Req_IB_v1 dummyBean = CAgetAccountDetails_Req_IB_v1.createDummyRequest();

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CAgetAccountDetails_IH_v1.CAgetAccountDetails(dummyBean.accountNumber);
		// Get first key from the map
		CAgetAccountDetails_Resp_IB_v1 responseBean = (new List<CAgetAccountDetails_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @ isTest static void validateCAgetAccountDetailsException() {
        CAgetAccountDetails_Req_IB_v1 dummyBean = CAgetAccountDetails_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CAgetAccountDetails_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CA_GET_ACCOUNT_DETAILS
        });

        Test.startTest();
        
        Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CAgetAccountDetails_IH_v1.CAgetAccountDetails(dummyBean.accountNumber);
		// Get first key from the map
		CAgetAccountDetails_Resp_IB_v1 responseBean = (new List<CAgetAccountDetails_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
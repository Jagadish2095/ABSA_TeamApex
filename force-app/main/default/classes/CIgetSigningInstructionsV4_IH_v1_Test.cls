/*
 * Test Integration Handler for CIgetSigningInstructionsV4 Service
 * @author Prashant Jain
 * @created 2020-03-05
 */

@isTest
public class CIgetSigningInstructionsV4_IH_v1_Test {
     @isTest static void validateCIgetSigningInstructionsV4Positive() {
        CIgetSigningInstructionsV4_Req_IB_v1 dummyBeanParent = CIgetSigningInstructionsV4_Req_IB_v1.createDummyRequest();
        CIgetSigningInstructionsV4_Req_IB_v1.Cip082di dummyBean = dummyBeanParent.CIgetSigningInstructionsV4.cip082di;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetSigningInstructionsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4
        });

        Test.startTest();
        
        Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4(dummyBean.accountNumber, dummyBean.siteCode, dummyBean.maxRetrieve);
		// Get first key from the map
		CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = (new List<CIgetSigningInstructionsV4_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateCIgetSigningInstructionsV4Negative() {
        CIgetSigningInstructionsV4_Req_IB_v1 dummyBeanParent = CIgetSigningInstructionsV4_Req_IB_v1.createDummyRequest();
        CIgetSigningInstructionsV4_Req_IB_v1.Cip082di dummyBean = dummyBeanParent.CIgetSigningInstructionsV4.cip082di;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetSigningInstructionsV4_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4
        });

        Test.startTest();
        System.assertEquals('success', 'success');
        Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4(dummyBean.accountNumber, dummyBean.siteCode, dummyBean.maxRetrieve);
		// Get first key from the map
		CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = (new List<CIgetSigningInstructionsV4_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateCIgetSigningInstructionsV4NoIntegrationSettings() {
        CIgetSigningInstructionsV4_Req_IB_v1 dummyBeanParent = CIgetSigningInstructionsV4_Req_IB_v1.createDummyRequest();
        CIgetSigningInstructionsV4_Req_IB_v1.Cip082di dummyBean = dummyBeanParent.CIgetSigningInstructionsV4.cip082di;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4(dummyBean.accountNumber, dummyBean.siteCode, dummyBean.maxRetrieve);
		// Get first key from the map
		CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = (new List<CIgetSigningInstructionsV4_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals('success', 'success');
        Test.stopTest();
    }

     @isTest static void validateCIgetSigningInstructionsV4Exception() {
        CIgetSigningInstructionsV4_Req_IB_v1 dummyBeanParent = CIgetSigningInstructionsV4_Req_IB_v1.createDummyRequest();
        CIgetSigningInstructionsV4_Req_IB_v1.Cip082di dummyBean = dummyBeanParent.CIgetSigningInstructionsV4.cip082di;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetSigningInstructionsV4_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4
        });

        Test.startTest();
        
        Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4(dummyBean.accountNumber, dummyBean.siteCode, dummyBean.maxRetrieve);
		// Get first key from the map
		CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = (new List<CIgetSigningInstructionsV4_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
    
     @isTest static void CIgetALLSigningInstructionsV4() {
        CIgetSigningInstructionsV4_Req_IB_v1 dummyBeanParent = CIgetSigningInstructionsV4_Req_IB_v1.createDummyRequest();
        CIgetSigningInstructionsV4_Req_IB_v1.Cip082di dummyBean = dummyBeanParent.CIgetSigningInstructionsV4.cip082di;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetSigningInstructionsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4
        });

        Test.startTest();
        
       CIgetSigningInstructionsV4_Resp_IB_v2 responseBean = CIgetSigningInstructionsV4_IH_v1.CIgetAllSigningInstructionsV4(dummyBean.accountNumber, dummyBean.siteCode, dummyBean.maxRetrieve);
		// Get first key from the map
	
        System.assertnotEquals(null, responseBean.statusCode);
        
        Test.stopTest();
    }
}
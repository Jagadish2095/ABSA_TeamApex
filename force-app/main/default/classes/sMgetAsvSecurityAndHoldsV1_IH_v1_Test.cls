/*
 * Test Integration Handler for sMgetAsvSecurityAndHoldsV1 Service
 * @author Prashant Jain
 * @created 2020-03-10
 */

@isTest
public class sMgetAsvSecurityAndHoldsV1_IH_v1_Test {
     @isTest static void validatesMgetAsvSecurityAndHoldsV1Positive() {
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1 dummyBeanParent = sMgetAsvSecurityAndHoldsV1_Req_IB_v1.createDummyRequest();
         
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Smp155ei dummyBean = dummyBeanParent.SMgetASVOutstandingSecurityAndHoldsV1.smp155ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSecurityAndHoldsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SECURITY_AND_HOLDS_V1
        });

        Test.startTest();
        
        Map<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSecurityAndHoldsV1_IH_v1.sMgetAsvSecurityAndHoldsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvSecurityAndHoldsV1Negative() {
       sMgetAsvSecurityAndHoldsV1_Req_IB_v1 dummyBeanParent = sMgetAsvSecurityAndHoldsV1_Req_IB_v1.createDummyRequest();
         
       sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Smp155ei dummyBean = dummyBeanParent.SMgetASVOutstandingSecurityAndHoldsV1.smp155ei;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSecurityAndHoldsV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SECURITY_AND_HOLDS_V1
        });

        Test.startTest();

        Map<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSecurityAndHoldsV1_IH_v1.sMgetAsvSecurityAndHoldsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvSecurityAndHoldsV1NoIntegrationSettings() {
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1 dummyBeanParent = sMgetAsvSecurityAndHoldsV1_Req_IB_v1.createDummyRequest();
         
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Smp155ei dummyBean = dummyBeanParent.SMgetASVOutstandingSecurityAndHoldsV1.smp155ei;
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSecurityAndHoldsV1_IH_v1.sMgetAsvSecurityAndHoldsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvSecurityAndHoldsV1Exception() {
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1 dummyBeanParent = sMgetAsvSecurityAndHoldsV1_Req_IB_v1.createDummyRequest();
         
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Smp155ei dummyBean = dummyBeanParent.SMgetASVOutstandingSecurityAndHoldsV1.smp155ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSecurityAndHoldsV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SECURITY_AND_HOLDS_V1
        });

        Test.startTest();
        
        Map<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSecurityAndHoldsV1_IH_v1.sMgetAsvSecurityAndHoldsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
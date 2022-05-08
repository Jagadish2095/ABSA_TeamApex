/*
 * Test Integration Handler for sMgetAsvCessionOfLPLinkedV1 Service
 * @author Prashant Jain
 * @created 2020-03-05
 */

@isTest
public class sMgetAsvCessionOfLPLinkedV1_IH_v1_Test { 
     @isTest static void validatesMgetAsvCessionOfLPLinkedV1Positive() {
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.Smp332ei dummyBean = dummyBeanParent.SMgetASVCessionOfLifePoliciesLinkedV1.smp332ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPLinkedV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_LINKED_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPLinkedV1_IH_v1.sMgetAsvCessionOfLPLinkedV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfLPLinkedV1Negative() {
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.Smp332ei dummyBean = dummyBeanParent.SMgetASVCessionOfLifePoliciesLinkedV1.smp332ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPLinkedV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_LINKED_V1
        });

        Test.startTest();

        Map<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPLinkedV1_IH_v1.sMgetAsvCessionOfLPLinkedV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfLPLinkedV1NoIntegrationSettings() {
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.Smp332ei dummyBean = dummyBeanParent.SMgetASVCessionOfLifePoliciesLinkedV1.smp332ei;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPLinkedV1_IH_v1.sMgetAsvCessionOfLPLinkedV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfLPLinkedV1Exception() {
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.Smp332ei dummyBean = dummyBeanParent.SMgetASVCessionOfLifePoliciesLinkedV1.smp332ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPLinkedV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_LINKED_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPLinkedV1_IH_v1.sMgetAsvCessionOfLPLinkedV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
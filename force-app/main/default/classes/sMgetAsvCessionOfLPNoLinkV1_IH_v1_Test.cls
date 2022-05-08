/*
 * Test Integration Handler for sMgetAsvCessionOfLPNoLinkV1 Service
 * @author Prashant Jain
 * @created 2020-03-05
 */

@isTest
public class sMgetAsvCessionOfLPNoLinkV1_IH_v1_Test {
     @isTest static void validatesMgetAsvCessionOfLPNoLinkV1Positive() {
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei dummyBean = dummyBeanParent.SMgetASVCessionOfLifePoliciesNonLinkV1.smp232ei;
         
        //sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei dummyBean = dummyBeanParent.smp232ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPNoLinkV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_NO_LINK_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPNoLinkV1_IH_v1.sMgetAsvCessionOfLPNoLinkV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfLPNoLinkV1Negative() {
         sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei dummyBean = dummyBeanParent.SMgetASVCessionOfLifePoliciesNonLinkV1.smp232ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPNoLinkV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_NO_LINK_V1
        });

        Test.startTest();

        Map<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPNoLinkV1_IH_v1.sMgetAsvCessionOfLPNoLinkV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfLPNoLinkV1NoIntegrationSettings() {
         sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei dummyBean = dummyBeanParent.SMgetASVCessionOfLifePoliciesNonLinkV1.smp232ei;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPNoLinkV1_IH_v1.sMgetAsvCessionOfLPNoLinkV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfLPNoLinkV1Exception() {
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei dummyBean = dummyBeanParent.SMgetASVCessionOfLifePoliciesNonLinkV1.smp232ei;


        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPNoLinkV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_NO_LINK_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPNoLinkV1_IH_v1.sMgetAsvCessionOfLPNoLinkV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
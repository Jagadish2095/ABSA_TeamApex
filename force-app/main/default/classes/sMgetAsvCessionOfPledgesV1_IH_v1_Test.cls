/*
 * Test Integration Handler for sMgetAsvCessionOfPledgesV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

@isTest
public class sMgetAsvCessionOfPledgesV1_IH_v1_Test {
     @isTest static void validatesMgetAsvCessionOfPledgesV1Positive() {
        sMgetAsvCessionOfPledgesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfPledgesV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei dummyBean = dummyBeanParent.SMgetASVCessionOfGeneralPledgesV1.Smp149ei;
        //sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei dummyBean = dummyBeanParent.smp149ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfPledgesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_PLEDGES_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfPledgesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfPledgesV1_IH_v1.sMgetAsvCessionOfPledgesV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfPledgesV1Negative() {
        sMgetAsvCessionOfPledgesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfPledgesV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei dummyBean = dummyBeanParent.SMgetASVCessionOfGeneralPledgesV1.Smp149ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfPledgesV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_PLEDGES_V1
        });

        Test.startTest();

        Map<sMgetAsvCessionOfPledgesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfPledgesV1_IH_v1.sMgetAsvCessionOfPledgesV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfPledgesV1NoIntegrationSettings() {
        sMgetAsvCessionOfPledgesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfPledgesV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei dummyBean = dummyBeanParent.SMgetASVCessionOfGeneralPledgesV1.Smp149ei;
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvCessionOfPledgesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfPledgesV1_IH_v1.sMgetAsvCessionOfPledgesV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfPledgesV1Exception() {
        sMgetAsvCessionOfPledgesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfPledgesV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei dummyBean = dummyBeanParent.SMgetASVCessionOfGeneralPledgesV1.Smp149ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfPledgesV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_PLEDGES_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfPledgesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfPledgesV1_IH_v1.sMgetAsvCessionOfPledgesV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
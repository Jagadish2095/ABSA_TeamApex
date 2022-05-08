/*
 * Test Integration Handler for sMgetAsvCessionOfSchemesV1 Service
 * @author Prashant Jain
 * @created 2020-03-05
 */

@isTest
public class sMgetAsvCessionOfSchemesV1_IH_v1_Test {
     @isTest static void validatesMgetAsvCessionOfSchemesV1Positive() {
        sMgetAsvCessionOfSchemesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfSchemesV1_Req_IB_v1.createDummyRequest();
       
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Smp135ei dummyBean = dummyBeanParent.SMgetASVCessionOfSchemesV1.smp135ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSchemesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SCHEMES_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSchemesV1_IH_v1.sMgetAsvCessionOfSchemesV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSchemesV1Negative() {
       sMgetAsvCessionOfSchemesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfSchemesV1_Req_IB_v1.createDummyRequest();
       
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Smp135ei dummyBean = dummyBeanParent.SMgetASVCessionOfSchemesV1.smp135ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSchemesV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SCHEMES_V1
        });

        Test.startTest();

        Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSchemesV1_IH_v1.sMgetAsvCessionOfSchemesV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSchemesV1NoIntegrationSettings() {
        sMgetAsvCessionOfSchemesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfSchemesV1_Req_IB_v1.createDummyRequest();
       
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Smp135ei dummyBean = dummyBeanParent.SMgetASVCessionOfSchemesV1.smp135ei;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSchemesV1_IH_v1.sMgetAsvCessionOfSchemesV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSchemesV1Exception() {
       sMgetAsvCessionOfSchemesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfSchemesV1_Req_IB_v1.createDummyRequest();
       
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Smp135ei dummyBean = dummyBeanParent.SMgetASVCessionOfSchemesV1.smp135ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSchemesV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SCHEMES_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSchemesV1_IH_v1.sMgetAsvCessionOfSchemesV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
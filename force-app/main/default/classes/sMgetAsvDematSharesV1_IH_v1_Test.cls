/*
 * Test Integration Handler for sMgetAsvDematSharesV1 Service
 * @author Prashant Jain
 * @created 2020-03-09
 */

@isTest
public class sMgetAsvDematSharesV1_IH_v1_Test {
     @isTest static void validatesMgetAsvDematSharesV1Positive() {
        sMgetAsvDematSharesV1_Req_IB_v1 dummyBeanParent = sMgetAsvDematSharesV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvDematSharesV1_Req_IB_v1.Smn336i dummyBean = dummyBeanParent.SMgetASVDematerializedSharesV1.smn336i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvDematSharesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_DEMAT_SHARES_V1
        });

        Test.startTest();
        
        Map<sMgetAsvDematSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvDematSharesV1_IH_v1.sMgetAsvDematSharesV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvDematSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvDematSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvDematSharesV1Negative() {
       sMgetAsvDematSharesV1_Req_IB_v1 dummyBeanParent = sMgetAsvDematSharesV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvDematSharesV1_Req_IB_v1.Smn336i dummyBean = dummyBeanParent.SMgetASVDematerializedSharesV1.smn336i;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvDematSharesV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_DEMAT_SHARES_V1
        });

        Test.startTest();

        Map<sMgetAsvDematSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvDematSharesV1_IH_v1.sMgetAsvDematSharesV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvDematSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvDematSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvDematSharesV1NoIntegrationSettings() {
        sMgetAsvDematSharesV1_Req_IB_v1 dummyBeanParent = sMgetAsvDematSharesV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvDematSharesV1_Req_IB_v1.Smn336i dummyBean = dummyBeanParent.SMgetASVDematerializedSharesV1.smn336i;
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvDematSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvDematSharesV1_IH_v1.sMgetAsvDematSharesV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvDematSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvDematSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvDematSharesV1Exception() {
        sMgetAsvDematSharesV1_Req_IB_v1 dummyBeanParent = sMgetAsvDematSharesV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvDematSharesV1_Req_IB_v1.Smn336i dummyBean = dummyBeanParent.SMgetASVDematerializedSharesV1.smn336i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvDematSharesV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_DEMAT_SHARES_V1
        });

        Test.startTest();
        
        Map<sMgetAsvDematSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvDematSharesV1_IH_v1.sMgetAsvDematSharesV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvDematSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvDematSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
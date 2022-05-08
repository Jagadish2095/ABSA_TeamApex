/*
 * Test Integration Handler for sMgetAsvCessionOfInvstmntV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

@isTest
public class sMgetAsvCessionOfInvstmntV1_IH_v1_Test {  
     @isTest static void validatesMgetAsvCessionOfInvstmntV1Positive() {
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfInvstmntV1_Req_IB_v1.createDummyRequest();
         
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Smn146i dummyBean = dummyBeanParent.SMgetASVCessionOfInternalInvestmentsV1.Smn146i;
         
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfInvstmntV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_INVSTMNT_V1
        });    

        Test.startTest();
        
        Map<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfInvstmntV1_IH_v1.sMgetAsvCessionOfInvstmntV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfInvstmntV1Negative() {
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfInvstmntV1_Req_IB_v1.createDummyRequest();
         
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Smn146i dummyBean = dummyBeanParent.SMgetASVCessionOfInternalInvestmentsV1.Smn146i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfInvstmntV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_INVSTMNT_V1
        });

        Test.startTest();

        Map<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfInvstmntV1_IH_v1.sMgetAsvCessionOfInvstmntV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfInvstmntV1NoIntegrationSettings() {
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfInvstmntV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Smn146i dummyBean = dummyBeanParent.SMgetASVCessionOfInternalInvestmentsV1.Smn146i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfInvstmntV1_IH_v1.sMgetAsvCessionOfInvstmntV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfInvstmntV1Exception() {
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfInvstmntV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Smn146i dummyBean = dummyBeanParent.SMgetASVCessionOfInternalInvestmentsV1.Smn146i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfInvstmntV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_INVSTMNT_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfInvstmntV1_IH_v1.sMgetAsvCessionOfInvstmntV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
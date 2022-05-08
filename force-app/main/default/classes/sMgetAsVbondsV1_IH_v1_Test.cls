/*
 * Test Integration Handler for sMgetAsVbondsV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

@isTest
public class sMgetAsVbondsV1_IH_v1_Test {
     @isTest static void validatesMgetAsVbondsV1Positive() {
        sMgetAsVbondsV1_Req_IB_v1 dummyBeanParent = sMgetAsVbondsV1_Req_IB_v1.createDummyRequest();
        sMgetAsVbondsV1_Req_IB_v1.Smn145i dummyBean = dummyBeanParent.SMgetASVbondsV1.Smn145i;
        //sMgetASVbondsV1.smn145i dummyBean = dummyBeanParent.smn145i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_BONDS_V1
        });

        Test.startTest();
        
        Map<sMgetAsVbondsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsVbondsV1_IH_v1.sMgetAsVbondsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsVbondsV1_Resp_IB_v1 responseBean = (new List<sMgetAsVbondsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsVbondsV1Negative() {
        sMgetAsVbondsV1_Req_IB_v1 dummyBeanParent = sMgetAsVbondsV1_Req_IB_v1.createDummyRequest();
        sMgetAsVbondsV1_Req_IB_v1.Smn145i dummyBean = dummyBeanParent.SMgetASVbondsV1.Smn145i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_BONDS_V1
        });

        Test.startTest();

        Map<sMgetAsVbondsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsVbondsV1_IH_v1.sMgetAsVbondsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsVbondsV1_Resp_IB_v1 responseBean = (new List<sMgetAsVbondsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsVbondsV1NoIntegrationSettings() {
        sMgetAsVbondsV1_Req_IB_v1 dummyBeanParent = sMgetAsVbondsV1_Req_IB_v1.createDummyRequest();
        sMgetAsVbondsV1_Req_IB_v1.Smn145i dummyBean = dummyBeanParent.SMgetASVbondsV1.Smn145i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsVbondsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsVbondsV1_IH_v1.sMgetAsVbondsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsVbondsV1_Resp_IB_v1 responseBean = (new List<sMgetAsVbondsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsVbondsV1Exception() {
        sMgetAsVbondsV1_Req_IB_v1 dummyBeanParent = sMgetAsVbondsV1_Req_IB_v1.createDummyRequest();
        sMgetAsVbondsV1_Req_IB_v1.Smn145i dummyBean = dummyBeanParent.SMgetASVbondsV1.Smn145i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_BONDS_V1
        });

        Test.startTest();
        
        Map<sMgetAsVbondsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsVbondsV1_IH_v1.sMgetAsVbondsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsVbondsV1_Resp_IB_v1 responseBean = (new List<sMgetAsVbondsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
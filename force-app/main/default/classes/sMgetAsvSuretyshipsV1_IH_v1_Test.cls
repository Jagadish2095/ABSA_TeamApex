/*
 * Test Integration Handler for sMgetAsvSuretyshipsV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

@isTest
public class sMgetAsvSuretyshipsV1_IH_v1_Test {
     @isTest static void validatesMgetAsvSuretyshipsV1Positive() {
        sMgetAsvSuretyshipsV1_Req_IB_v1 dummyBeanParent = sMgetAsvSuretyshipsV1_Req_IB_v1.createDummyRequest();
        sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i dummyBean = dummyBeanParent.SMgetASVSuretyshipsV1.Smn152i;
        //sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i dummyBean = dummyBeanParent.smn152i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSuretyshipsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SURETYSHIPS_V1
        });

        Test.startTest();
        
        Map<sMgetAsvSuretyshipsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSuretyshipsV1_IH_v1.sMgetAsvSuretyshipsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSuretyshipsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvSuretyshipsV1Negative() {
        sMgetAsvSuretyshipsV1_Req_IB_v1 dummyBeanParent = sMgetAsvSuretyshipsV1_Req_IB_v1.createDummyRequest();
        sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i dummyBean = dummyBeanParent.SMgetASVSuretyshipsV1.Smn152i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSuretyshipsV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SURETYSHIPS_V1
        });

        Test.startTest();

        Map<sMgetAsvSuretyshipsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSuretyshipsV1_IH_v1.sMgetAsvSuretyshipsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSuretyshipsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvSuretyshipsV1NoIntegrationSettings() {
        sMgetAsvSuretyshipsV1_Req_IB_v1 dummyBeanParent = sMgetAsvSuretyshipsV1_Req_IB_v1.createDummyRequest();
        sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i dummyBean = dummyBeanParent.SMgetASVSuretyshipsV1.Smn152i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvSuretyshipsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSuretyshipsV1_IH_v1.sMgetAsvSuretyshipsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSuretyshipsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvSuretyshipsV1Exception() {
        sMgetAsvSuretyshipsV1_Req_IB_v1 dummyBeanParent = sMgetAsvSuretyshipsV1_Req_IB_v1.createDummyRequest();
        sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i dummyBean = dummyBeanParent.SMgetASVSuretyshipsV1.Smn152i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSuretyshipsV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SURETYSHIPS_V1
        });

        Test.startTest();
        
        Map<sMgetAsvSuretyshipsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSuretyshipsV1_IH_v1.sMgetAsvSuretyshipsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSuretyshipsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
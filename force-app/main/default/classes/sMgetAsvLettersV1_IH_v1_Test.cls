/*
 * Test Integration Handler for sMgetAsvLettersV1 Service
 * @author Prashant Jain
 * @created 2020-03-09
 */

@isTest
public class sMgetAsvLettersV1_IH_v1_Test {
     @isTest static void validatesMgetAsvLettersV1Positive() {
        sMgetAsvLettersV1_Req_IB_v1 dummyBeanParent = sMgetAsvLettersV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvLettersV1_Req_IB_v1.Smn140i dummyBean = dummyBeanParent.SMgetASVLettersV1.smn140i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvLettersV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_LETTERS_V1
        });

        Test.startTest();
        
        Map<sMgetAsvLettersV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvLettersV1_IH_v1.sMgetAsvLettersV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvLettersV1_Resp_IB_v1 responseBean = (new List<sMgetAsvLettersV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvLettersV1Negative() {
        sMgetAsvLettersV1_Req_IB_v1 dummyBeanParent = sMgetAsvLettersV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvLettersV1_Req_IB_v1.Smn140i dummyBean = dummyBeanParent.SMgetASVLettersV1.smn140i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvLettersV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_LETTERS_V1
        });

        Test.startTest();

        Map<sMgetAsvLettersV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvLettersV1_IH_v1.sMgetAsvLettersV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvLettersV1_Resp_IB_v1 responseBean = (new List<sMgetAsvLettersV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvLettersV1NoIntegrationSettings() {
        sMgetAsvLettersV1_Req_IB_v1 dummyBeanParent = sMgetAsvLettersV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvLettersV1_Req_IB_v1.Smn140i dummyBean = dummyBeanParent.SMgetASVLettersV1.smn140i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvLettersV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvLettersV1_IH_v1.sMgetAsvLettersV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvLettersV1_Resp_IB_v1 responseBean = (new List<sMgetAsvLettersV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvLettersV1Exception() {
        sMgetAsvLettersV1_Req_IB_v1 dummyBeanParent = sMgetAsvLettersV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvLettersV1_Req_IB_v1.Smn140i dummyBean = dummyBeanParent.SMgetASVLettersV1.smn140i;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvLettersV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_LETTERS_V1
        });

        Test.startTest();
        
        Map<sMgetAsvLettersV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvLettersV1_IH_v1.sMgetAsvLettersV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvLettersV1_Resp_IB_v1 responseBean = (new List<sMgetAsvLettersV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
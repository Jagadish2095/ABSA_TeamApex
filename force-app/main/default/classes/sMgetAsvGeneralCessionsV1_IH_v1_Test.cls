/*
 * Test Integration Handler for sMgetAsvGeneralCessionsV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-03-09
 */

@isTest
public class sMgetAsvGeneralCessionsV1_IH_v1_Test {
	@isTest static void validatesMgetAsvGeneralCessionsV1Positive() {
        sMgetAsvGeneralCessionsV1_Req_IB_v1 dummyBeanParent = sMgetAsvGeneralCessionsV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Sms148i dummyBean = dummyBeanParent.SMgetASVGeneralCessionsV1.Sms148i;
        

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvGeneralCessionsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_GENERAL_SESSION_V1
        });

        Test.startTest();
        
        Map<sMgetAsvGeneralCessionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvGeneralCessionsV1_IH_v1.sMgetAsvGeneralCessionsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvGeneralCessionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvGeneralCessionsV1Negative() {
        sMgetAsvGeneralCessionsV1_Req_IB_v1 dummyBeanParent = sMgetAsvGeneralCessionsV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Sms148i dummyBean = dummyBeanParent.SMgetASVGeneralCessionsV1.Sms148i;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvLettersV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_GENERAL_SESSION_V1
        });

        Test.startTest();
        
        Map<sMgetAsvGeneralCessionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvGeneralCessionsV1_IH_v1.sMgetAsvGeneralCessionsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvGeneralCessionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvGeneralCessionsV1NoIntegrationSettings() {
        sMgetAsvGeneralCessionsV1_Req_IB_v1 dummyBeanParent = sMgetAsvGeneralCessionsV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Sms148i dummyBean = dummyBeanParent.SMgetASVGeneralCessionsV1.Sms148i;
        Test.startTest();
        
        Map<sMgetAsvGeneralCessionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvGeneralCessionsV1_IH_v1.sMgetAsvGeneralCessionsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvGeneralCessionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMGeneralCessionsV1Exception() {
        sMgetAsvGeneralCessionsV1_Req_IB_v1 dummyBeanParent = sMgetAsvGeneralCessionsV1_Req_IB_v1.createDummyRequest();
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Sms148i dummyBean = dummyBeanParent.SMgetASVGeneralCessionsV1.Sms148i;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvLettersV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_GENERAL_SESSION_V1
        });
        Test.startTest();
        Map<sMgetAsvGeneralCessionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvGeneralCessionsV1_IH_v1.sMgetAsvGeneralCessionsV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvGeneralCessionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
}
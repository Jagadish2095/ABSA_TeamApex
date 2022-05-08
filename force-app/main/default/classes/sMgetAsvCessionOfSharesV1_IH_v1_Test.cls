/*
 * Test Integration Handler for sMgetAsvCessionOfSharesV1 Service
 * @author Prashant Jain
 * @created 2020-03-06
 */

@isTest
public class sMgetAsvCessionOfSharesV1_IH_v1_Test {
     @isTest static void validatesMgetAsvCessionOfSharesV1Positive() {
        sMgetAsvCessionOfSharesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfSharesV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i dummyBean = dummyBeanParent.SMgetASVCessionOfSharesV1.Sms136i;
       

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSharesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SHARES_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSharesV1_IH_v1.sMgetAsvCessionOfSharesV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSharesV1Negative() {
        sMgetAsvCessionOfSharesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfSharesV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i dummyBean = dummyBeanParent.SMgetASVCessionOfSharesV1.Sms136i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSharesV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SHARES_V1
        });

        Test.startTest();

        Map<sMgetAsvCessionOfSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSharesV1_IH_v1.sMgetAsvCessionOfSharesV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSharesV1NoIntegrationSettings() {
        sMgetAsvCessionOfSharesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfSharesV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i dummyBean = dummyBeanParent.SMgetASVCessionOfSharesV1.Sms136i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvCessionOfSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSharesV1_IH_v1.sMgetAsvCessionOfSharesV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSharesV1Exception() {
        sMgetAsvCessionOfSharesV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfSharesV1_Req_IB_v1.createDummyRequest();
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i dummyBean = dummyBeanParent.SMgetASVCessionOfSharesV1.Sms136i;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSharesV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SHARES_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSharesV1_IH_v1.sMgetAsvCessionOfSharesV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
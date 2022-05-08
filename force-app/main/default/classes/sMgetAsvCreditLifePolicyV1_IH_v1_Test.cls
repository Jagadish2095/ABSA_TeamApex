/*
 * Test Integration Handler for sMgetAsvCreditLifePolicyV1 Service
 * @author Prashant Jain
 * @created 2020-03-06
 */

@isTest
public class sMgetAsvCreditLifePolicyV1_IH_v1_Test {
     @isTest static void validatesMgetAsvCreditLifePolicyV1Positive() {
        sMgetAsvCreditLifePolicyV1_Req_IB_v1 dummyBeanParent = sMgetAsvCreditLifePolicyV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Smn151i dummyBean = dummyBeanParent.SMgetASVcreditLifePoliciesV1.Smn151i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCreditLifePolicyV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CREDIT_LIFE_POLICY_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCreditLifePolicyV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCreditLifePolicyV1_IH_v1.sMgetAsvCreditLifePolicyV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCreditLifePolicyV1Negative() {
        sMgetAsvCreditLifePolicyV1_Req_IB_v1 dummyBeanParent = sMgetAsvCreditLifePolicyV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Smn151i dummyBean = dummyBeanParent.SMgetASVcreditLifePoliciesV1.Smn151i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCreditLifePolicyV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CREDIT_LIFE_POLICY_V1
        });

        Test.startTest();

        Map<sMgetAsvCreditLifePolicyV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCreditLifePolicyV1_IH_v1.sMgetAsvCreditLifePolicyV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCreditLifePolicyV1NoIntegrationSettings() {
        sMgetAsvCreditLifePolicyV1_Req_IB_v1 dummyBeanParent = sMgetAsvCreditLifePolicyV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Smn151i dummyBean = dummyBeanParent.SMgetASVcreditLifePoliciesV1.Smn151i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvCreditLifePolicyV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCreditLifePolicyV1_IH_v1.sMgetAsvCreditLifePolicyV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCreditLifePolicyV1Exception() {
        sMgetAsvCreditLifePolicyV1_Req_IB_v1 dummyBeanParent = sMgetAsvCreditLifePolicyV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Smn151i dummyBean = dummyBeanParent.SMgetASVcreditLifePoliciesV1.Smn151i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCreditLifePolicyV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CREDIT_LIFE_POLICY_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCreditLifePolicyV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCreditLifePolicyV1_IH_v1.sMgetAsvCreditLifePolicyV1(dummyBean.clcd);
		// Get first key from the map
		sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
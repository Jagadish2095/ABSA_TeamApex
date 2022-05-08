/*
 * Test Integration Handler for sMgetAsvCessionOfDebtorsV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

@isTest
public class sMgetAsvCessionOfDebtorsV1_IH_v1_Test {
     @isTest static void validatesMgetAsvCessionOfDebtorsV1Positive() {
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfDebtorsV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Smp170ei dummyBean = dummyBeanParent.SMgetASVCessionOfDebtorsV1.Smp170ei;
        

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfDebtorsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_DEBTORS_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfDebtorsV1_IH_v1.sMgetAsvCessionOfDebtorsV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfDebtorsV1Negative() {
       sMgetAsvCessionOfDebtorsV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfDebtorsV1_Req_IB_v1.createDummyRequest();
       sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Smp170ei dummyBean = dummyBeanParent.SMgetASVCessionOfDebtorsV1.Smp170ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfDebtorsV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_DEBTORS_V1
        });

        Test.startTest();

        Map<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfDebtorsV1_IH_v1.sMgetAsvCessionOfDebtorsV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfDebtorsV1NoIntegrationSettings() {
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfDebtorsV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Smp170ei dummyBean = dummyBeanParent.SMgetASVCessionOfDebtorsV1.Smp170ei;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfDebtorsV1_IH_v1.sMgetAsvCessionOfDebtorsV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfDebtorsV1Exception() {
       sMgetAsvCessionOfDebtorsV1_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfDebtorsV1_Req_IB_v1.createDummyRequest();
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Smp170ei dummyBean = dummyBeanParent.SMgetASVCessionOfDebtorsV1.Smp170ei;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfDebtorsV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_DEBTORS_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfDebtorsV1_IH_v1.sMgetAsvCessionOfDebtorsV1(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
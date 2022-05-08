/*
 * Test Integration Handler for SMgetASVCessionOfExternalInvestmentsV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-03-09
 */

@isTest
public class sMgetAsvCessionOfExtInv_IH_v1_Test {
	@isTest static void validatesMgetAsvExternalInvestmentsV1Positive() {
        sMgetAsvCessionOfExtInv_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfExtInv_Req_IB_v1.createDummyRequest();
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Smp147ei dummyBean = dummyBeanParent.SMgetASVCessionOfExternalInvestmentsV1.Smp147ei;
        

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfExtInv_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfExtInv_IH_v1.getAsvCessionOfExtInvestment(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfExtInv_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvExternalInvestmentsV1Negative() {
        sMgetAsvCessionOfExtInv_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfExtInv_Req_IB_v1.createDummyRequest();
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Smp147ei dummyBean = dummyBeanParent.SMgetASVCessionOfExternalInvestmentsV1.Smp147ei;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfExtInv_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1
        });

        Test.startTest();
        
        Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfExtInv_IH_v1.getAsvCessionOfExtInvestment(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfExtInv_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvExternalInvestmentsV1NoIntegrationSettings() {
        sMgetAsvCessionOfExtInv_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfExtInv_Req_IB_v1.createDummyRequest();
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Smp147ei dummyBean = dummyBeanParent.SMgetASVCessionOfExternalInvestmentsV1.Smp147ei;
        // Set mock callout class
        Test.startTest();
        
        Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfExtInv_IH_v1.getAsvCessionOfExtInvestment(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfExtInv_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesExternalInvestmentsV1Exception() {
         sMgetAsvCessionOfExtInv_Req_IB_v1 dummyBeanParent = sMgetAsvCessionOfExtInv_Req_IB_v1.createDummyRequest();
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Smp147ei dummyBean = dummyBeanParent.SMgetASVCessionOfExternalInvestmentsV1.Smp147ei;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfExtInv_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1
        });
        Test.startTest();
        Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfExtInv_IH_v1.getAsvCessionOfExtInvestment(dummyBean.clcdData);
		// Get first key from the map
		sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfExtInv_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
}
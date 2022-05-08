/*
 * Test Integration Handler for SMgetASVCessionOfFireShortTermInsuranceV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-03-09
 */

@isTest
public class SMgetASVCessionOfFireShortV1_IH_v1_Test {
	@isTest static void validateSMgetASVCessionOfFireShortTermInsuranceV1Positive() {
       SMgetASVCessionOfFireShortV1_Req_IB_v1 dummyBeanParent = SMgetASVCessionOfFireShortV1_Req_IB_v1.createDummyRequest();
        
       SMgetASVCessionOfFireShortV1_Req_IB_v1.Smp132ei dummyBean = dummyBeanParent.SMgetASVCessionOfFireShortTermInsuranceV1.Smp132ei;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SMgetASVCessionOfFireSrtV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_FIRESHORT_TERMINSURANCE_SESSION_V1
        });

        Test.startTest();
        
        Map<SMgetASVCessionOfFireShortV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfFireShortV1_IH_v1.getASVCessionOfFireShortV1(dummyBean.clcdData);
		// Get first key from the map
		SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfFireShortV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateSMgetASVCessionOfFireShortTermInsuranceV1Negative() {
       SMgetASVCessionOfFireShortV1_Req_IB_v1 dummyBeanParent = SMgetASVCessionOfFireShortV1_Req_IB_v1.createDummyRequest();
        
       SMgetASVCessionOfFireShortV1_Req_IB_v1.Smp132ei dummyBean = dummyBeanParent.SMgetASVCessionOfFireShortTermInsuranceV1.Smp132ei;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SMgetASVCessionOfFireSrtV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_FIRESHORT_TERMINSURANCE_SESSION_V1
        });
        
        Test.startTest();
        
        Map<SMgetASVCessionOfFireShortV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfFireShortV1_IH_v1.getASVCessionOfFireShortV1(dummyBean.clcdData);
		// Get first key from the map
		SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfFireShortV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateSMgetASVCessionOfFireShortTermInsuranceV11NoIntegrationSettings() {
        SMgetASVCessionOfFireShortV1_Req_IB_v1 dummyBeanParent = SMgetASVCessionOfFireShortV1_Req_IB_v1.createDummyRequest();
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.Smp132ei dummyBean = dummyBeanParent.SMgetASVCessionOfFireShortTermInsuranceV1.Smp132ei;
         Test.startTest();
        
        Map<SMgetASVCessionOfFireShortV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfFireShortV1_IH_v1.getASVCessionOfFireShortV1(dummyBean.clcdData);
		// Get first key from the map
		SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfFireShortV1_Resp_IB_v1>(responseMap.keySet()))[0];
        
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesSMgetASVCessionOfFireShortTermInsuranceV1Exception() {
        SMgetASVCessionOfFireShortV1_Req_IB_v1 dummyBeanParent = SMgetASVCessionOfFireShortV1_Req_IB_v1.createDummyRequest();
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.Smp132ei dummyBean = dummyBeanParent.SMgetASVCessionOfFireShortTermInsuranceV1.Smp132ei;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SMgetASVCessionOfFireSrtV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_FIRESHORT_TERMINSURANCE_SESSION_V1
        });
        
        Test.startTest();
        
        Map<SMgetASVCessionOfFireShortV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfFireShortV1_IH_v1.getASVCessionOfFireShortV1(dummyBean.clcdData);
		// Get first key from the map
		SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfFireShortV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
}
/*
 * Test Integration Handler for MBListSourceInstructionsV1 Service
 * @author Rudolf Niehaus
 * @created 2020-05-12
 */

@isTest
public class MBListSourceInstructionsV1_IH_v1_Test {
     @isTest static void validateMBListSourceInstructionsV1Positive() {

        MBListSourceInstructionsV1_Req_IB_v1 dummyBeanParent = MBListSourceInstructionsV1_Req_IB_v1.createDummyRequest();
        MBListSourceInstructionsV1_Req_IB_v1.Mbs305i dummyBean = dummyBeanParent.MBListSourceInstructionsV1.mbs305i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBListSourceInstructionsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1
        });

        Test.startTest();
        
        Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBListSourceInstructionsV1_IH_v1.MBListSourceInstructionsV1(dummyBean.cifKey,dummyBean.srcAcc);
		// Get first key from the map
		MBListSourceInstructionsV1_Resp_IB_v1 responseBean = (new List<MBListSourceInstructionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateMBListSourceInstructionsV1Negative() {

        MBListSourceInstructionsV1_Req_IB_v1 dummyBeanParent = MBListSourceInstructionsV1_Req_IB_v1.createDummyRequest();
        MBListSourceInstructionsV1_Req_IB_v1.Mbs305i dummyBean = dummyBeanParent.MBListSourceInstructionsV1.mbs305i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBListSourceInstructionsV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1
        });

        Test.startTest();

        Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBListSourceInstructionsV1_IH_v1.MBListSourceInstructionsV1(dummyBean.cifKey,dummyBean.srcAcc);
		// Get first key from the map
		MBListSourceInstructionsV1_Resp_IB_v1 responseBean = (new List<MBListSourceInstructionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateMBListSourceInstructionsV1NoIntegrationSettings() {

        MBListSourceInstructionsV1_Req_IB_v1 dummyBeanParent = MBListSourceInstructionsV1_Req_IB_v1.createDummyRequest();
        MBListSourceInstructionsV1_Req_IB_v1.Mbs305i dummyBean = dummyBeanParent.MBListSourceInstructionsV1.mbs305i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBListSourceInstructionsV1_IH_v1.MBListSourceInstructionsV1(dummyBean.cifKey,dummyBean.srcAcc);
		// Get first key from the map
		MBListSourceInstructionsV1_Resp_IB_v1 responseBean = (new List<MBListSourceInstructionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateMBListSourceInstructionsV1Exception() {

        MBListSourceInstructionsV1_Req_IB_v1 dummyBeanParent = MBListSourceInstructionsV1_Req_IB_v1.createDummyRequest();
        MBListSourceInstructionsV1_Req_IB_v1.Mbs305i dummyBean = dummyBeanParent.MBListSourceInstructionsV1.mbs305i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBListSourceInstructionsV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1
        });

        Test.startTest();
        
        Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBListSourceInstructionsV1_IH_v1.MBListSourceInstructionsV1(dummyBean.cifKey,dummyBean.srcAcc);
		// Get first key from the map
		MBListSourceInstructionsV1_Resp_IB_v1 responseBean = (new List<MBListSourceInstructionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
         
        responseMap = MBListSourceInstructionsV1_IH_v1.mbListSourceInstructions(dummyBean.cifKey,dummyBean.srcAcc); 
        
        Test.stopTest();
    }
}
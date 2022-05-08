/*
 * Test Integration Handler for MBdeleteInstructionV2 Service
 * @author Rudolf Niehaus
 * @created 2020-03-21
 */

@isTest
public class MBdeleteInstructionV2_IH_v1_Test {
     @isTest static void validateMBdeleteInstructionV2Positive() {

        MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
        MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {

            StringConstants.MB_DELETE_BENEFICIARIES_V2
            
        });

        Test.startTest();
        
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2(dummyBean.cifKey,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell,
                                                                                                                                           	dummyBean.tieb);
		// Get first key from the map
		MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateMBdeleteInstructionV2Negative() {

        MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
        MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_DELETE_BENEFICIARIES_V2
        });

        Test.startTest();

        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2(dummyBean.cifKey,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell,
                                                                                                                                           	dummyBean.tieb);
		// Get first key from the map
		MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateMBdeleteInstructionV2NoIntegrationSettings() {

        MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
        MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2(dummyBean.cifKey,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell,
                                                                                                                                           	dummyBean.tieb);
		// Get first key from the map
		MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateMBdeleteInstructionV2Exception() {

        MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
        MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_DELETE_BENEFICIARIES_V2
        });

        Test.startTest();
        
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2(dummyBean.cifKey,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell,
                                                                                                                                           	dummyBean.tieb);
		// Get first key from the map
		MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    
    @isTest static void validateMBdeleteInstructionPaymentV2Positive() {

        MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
        MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {

            StringConstants.MB_DELETE_BENEFICIARIES_V2
            
        });

        Test.startTest();
        
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2Forpayment(dummyBean.cifKey,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell);
		// Get first key from the map
		MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateMBdeleteInstructionPaymentV2Negative() {

        MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
        MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_DELETE_BENEFICIARIES_V2
        });

        Test.startTest();

        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2Forpayment(dummyBean.cifKey,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell);
		// Get first key from the map
		MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }
    
    @isTest static void validateMBdeleteInstructionIVRV2Positive() {

        MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
        MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {

            StringConstants.MB_DELETE_BENEFICIARIES_V2
            
        });

        Test.startTest();
        
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionForIVR(dummyBean.cifKey,dummyBean.tieb,dummybean.instrNo);
                                                                                                                                          
		// Get first key from the map
		MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validateMBdeleteInstructionStop() {

        MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
        MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {

            StringConstants.MB_DELETE_BENEFICIARIES_V2
            
        });

        Test.startTest();
        
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2ForStopOrder(dummyBean.cifKey,dummyBean.instrNo,dummybean.lastMaintBrnch,dummyBean.lastMaintTell);
                                                                                                                                          
		// Get first key from the map                                                                                                                  
		MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

}
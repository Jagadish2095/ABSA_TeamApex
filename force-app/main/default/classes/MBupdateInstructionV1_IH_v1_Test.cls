/*
 * Test Integration Handler for MBupdateInstructionV1 Service
 * @author Rudolf Niehaus
 * @created 2020-03-20
 */

@isTest
public class MBupdateInstructionV1_IH_v1_Test {
     @isTest static void validateMBupdateInstructionV1Positive() {

        MBupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBupdateInstructionV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
        });

        Test.startTest();
        
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.MBupdateInstructionV1(dummyBean.cifKey,
                                                                                                                                            dummyBean.tieb,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.instrRefName,
                                                                                                                                            dummyBean.srcAcc,
                                                                                                                                            dummyBean.srcAccType,
                                                                                                                                            dummyBean.srcClrCode,
                                                                                                                                            dummyBean.srcStmtRef,
                                                                                                                                            dummyBean.trgAcc,
                                                                                                                                            dummyBean.trgAccType,
                                                                                                                                            dummyBean.trgClrCode,
                                                                                                                                            dummyBean.trgStmtRef,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell);
		// Get first key from the map
		MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateMBupdateInstructionV1Negative() {

        MBupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBupdateInstructionV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
        });

        Test.startTest();

        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.MBupdateInstructionV1(dummyBean.cifKey,
                                                                                                                                            dummyBean.tieb,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.instrRefName,
                                                                                                                                            dummyBean.srcAcc,
                                                                                                                                            dummyBean.srcAccType,
                                                                                                                                            dummyBean.srcClrCode,
                                                                                                                                            dummyBean.srcStmtRef,
                                                                                                                                            dummyBean.trgAcc,
                                                                                                                                            dummyBean.trgAccType,
                                                                                                                                            dummyBean.trgClrCode,
                                                                                                                                            dummyBean.trgStmtRef,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell);
		// Get first key from the map
		MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateMBupdateInstructionV1NoIntegrationSettings() {

        MBupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.MBupdateInstructionV1(dummyBean.cifKey,
                                                                                                                                            dummyBean.tieb,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.instrRefName,
                                                                                                                                            dummyBean.srcAcc,
                                                                                                                                            dummyBean.srcAccType,
                                                                                                                                            dummyBean.srcClrCode,
                                                                                                                                            dummyBean.srcStmtRef,
                                                                                                                                            dummyBean.trgAcc,
                                                                                                                                            dummyBean.trgAccType,
                                                                                                                                            dummyBean.trgClrCode,
                                                                                                                                            dummyBean.trgStmtRef,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell);
		// Get first key from the map
		MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateMBupdateInstructionV1Exception() {

        MBupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBupdateInstructionV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
        });

        Test.startTest();
        
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.MBupdateInstructionV1(dummyBean.cifKey,
                                                                                                                                            dummyBean.tieb,
                                                                                                                                            dummyBean.instrNo,
                                                                                                                                            dummyBean.instrRefName,
                                                                                                                                            dummyBean.srcAcc,
                                                                                                                                            dummyBean.srcAccType,
                                                                                                                                            dummyBean.srcClrCode,
                                                                                                                                            dummyBean.srcStmtRef,
                                                                                                                                            dummyBean.trgAcc,
                                                                                                                                            dummyBean.trgAccType,
                                                                                                                                            dummyBean.trgClrCode,
                                                                                                                                            dummyBean.trgStmtRef,
                                                                                                                                            dummyBean.lastMaintBrnch,
                                                                                                                                            dummyBean.lastMaintTell);
		// Get first key from the map
		MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void updateInstructionInstructionV1Positive() {
        MBupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBupdateInstructionV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
                });
        
        Test.startTest();
        
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap =  MBupdateInstructionV1_IH_v1.updateInstruction('BBBBDO 008','1','1','don','1021871806','02','632005','don','62001847237','02','250655','ton','8089','11332','20200110');
        
        // Get first key from the map
        MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    @isTest static void updateInstructionInstructionV1Negativetive() {
        MBupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBupdateInstructionV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
                });
        
        Test.startTest();
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap =  MBupdateInstructionV1_IH_v1.updateInstruction('','1','1','don','1021871806','02','632005','don','62001847237','02','250655','ton','8089','11332','20200111');
        
        // Get first key from the map
        MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertNotEquals(200, responseBean.statusCode);      
        Test.stopTest();
    }
        @isTest static void updateIVRbeneficiaryInstructionV1Negative() {
        MBupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBupdateInstructionV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
                });
        
        Test.startTest();
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap =  MBupdateInstructionV1_IH_v1.updateIVRbeneficiary('Mashudu','62001847237','02', '250655','2','ZUMAD  001','4048017641','4','32', '02','Shudu','Shudu');
        //String beneficiaryName,String trgAccNumber,String trgAccType, String trgBranchCode,String ivrCustNo, String cif, String srcAcc,String tieb,String instrNo, String srcAccType
        // Get first key from the map
        MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertNotEquals(200, responseBean.statusCode);      
        Test.stopTest();
    }
    
    
    
    
}
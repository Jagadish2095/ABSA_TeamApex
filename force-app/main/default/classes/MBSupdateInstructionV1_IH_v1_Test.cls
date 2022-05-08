/*
 * Test Integration Handler for MBupdateInstructionV1 Service
 * @author Rudolf Niehaus
 * @created 2020-05-16
 */

@isTest
public class MBSupdateInstructionV1_IH_v1_Test {
     @isTest static void validateMBupdateInstructionV1Positive() {

        MBSupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBSupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBSupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBSupdateInstructionV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
        });

        Test.startTest();
        
        Map<MBSupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBSupdateInstructionV1_IH_v1.MBupdateInstructionV1(dummyBean.cifKey,
                                                                                                                                                dummyBean.instrNo,
                                                                                                                                                dummyBean.instrRefName,
                                                                                                                                                dummyBean.trigDate,
                                                                                                                                                dummyBean.endDate,
                                                                                                                                                dummyBean.payDay,
                                                                                                                                                dummyBean.freq,
                                                                                                                                                dummyBean.amount,
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
		MBSupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBSupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateMBupdateInstructionV1Negative() {

        MBSupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBSupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBSupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBSupdateInstructionV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
        });

        Test.startTest();

        Map<MBSupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBSupdateInstructionV1_IH_v1.MBupdateInstructionV1(dummyBean.cifKey,
                                                                                                                                                dummyBean.instrNo,
                                                                                                                                                dummyBean.instrRefName,
                                                                                                                                                dummyBean.trigDate,
                                                                                                                                                dummyBean.endDate,
                                                                                                                                                dummyBean.payDay,
                                                                                                                                                dummyBean.freq,
                                                                                                                                                dummyBean.amount,
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
		MBSupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBSupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateMBupdateInstructionV1NoIntegrationSettings() {

        MBSupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBSupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBSupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<MBSupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBSupdateInstructionV1_IH_v1.MBupdateInstructionV1(dummyBean.cifKey,
                                                                                                                                                dummyBean.instrNo,
                                                                                                                                                dummyBean.instrRefName,
                                                                                                                                                dummyBean.trigDate,
                                                                                                                                                dummyBean.endDate,
                                                                                                                                                dummyBean.payDay,
                                                                                                                                                dummyBean.freq,
                                                                                                                                                dummyBean.amount,
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
		MBSupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBSupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateMBupdateInstructionV1Exception() {

        MBSupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBSupdateInstructionV1_Req_IB_v1.createDummyRequest();
        MBSupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MBSupdateInstructionV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.MB_UPDATE_BENEFICIARIES_V1
        });

        Test.startTest();
        
        Map<MBSupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBSupdateInstructionV1_IH_v1.MBupdateInstructionV1(dummyBean.cifKey,
                                                                                                                                                dummyBean.instrNo,
                                                                                                                                                dummyBean.instrRefName,
                                                                                                                                                dummyBean.trigDate,
                                                                                                                                                dummyBean.endDate,
                                                                                                                                                dummyBean.payDay,
                                                                                                                                                dummyBean.freq,
                                                                                                                                                dummyBean.amount,
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
		MBSupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBSupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}
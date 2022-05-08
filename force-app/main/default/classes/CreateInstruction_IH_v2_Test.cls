/*
 * Test Integration Handler for CreateInstruction v2 Service
 * @author Rudolf Niehaus
 * @created 2020-05-17
 */
@isTest
public class CreateInstruction_IH_v2_Test {
    
    @isTest static void testCreateInstructionPositive(){

        CreateInstruction_Req_IB_v2 dummyBean = CreateInstruction_Req_IB_v2.createDummy();

        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v2 responseBean = CreateInstruction_IH_v2.createInstruction(dummyBean.accessAcc, dummyBean.instrRefName, dummyBean.actDate, dummyBean.endDate,
                                                                                                dummyBean.payDay, dummyBean.freq, dummyBean.amount, 
                                                                                                dummyBean.srcAcc, dummyBean.srcAccType, dummyBean.srcClrCode,
                                                                                                dummyBean.srcStmtRef, dummyBean.trgAcc, dummyBean.trgAccType,
                                                                                                dummyBean.trgClrCode, dummyBean.trgStmtRef, dummyBean.lastMaintBrnch,
                                                                                                dummyBean.lastMaintTell);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateInstructionnNegative(){

        CreateInstruction_Req_IB_v2 dummyBean = CreateInstruction_Req_IB_v2.createDummy();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest_v2(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v2 responseBean = CreateInstruction_IH_v2.createInstruction(dummyBean.accessAcc, dummyBean.instrRefName, dummyBean.actDate, dummyBean.endDate,
                                                                                                dummyBean.payDay, dummyBean.freq, dummyBean.amount, 
                                                                                                dummyBean.srcAcc, dummyBean.srcAccType, dummyBean.srcClrCode,
                                                                                                dummyBean.srcStmtRef, dummyBean.trgAcc, dummyBean.trgAccType,
                                                                                                dummyBean.trgClrCode, dummyBean.trgStmtRef, dummyBean.lastMaintBrnch,
                                                                                                dummyBean.lastMaintTell);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateInstructionNoIntegrationSettings(){

        CreateInstruction_Req_IB_v2 dummyBean = CreateInstruction_Req_IB_v2.createDummy();
        
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest_v2(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v2 responseBean = CreateInstruction_IH_v2.createInstruction(dummyBean.accessAcc, dummyBean.instrRefName, dummyBean.actDate, dummyBean.endDate,
                                                                                                dummyBean.payDay, dummyBean.freq, dummyBean.amount, 
                                                                                                dummyBean.srcAcc, dummyBean.srcAccType, dummyBean.srcClrCode,
                                                                                                dummyBean.srcStmtRef, dummyBean.trgAcc, dummyBean.trgAccType,
                                                                                                dummyBean.trgClrCode, dummyBean.trgStmtRef, dummyBean.lastMaintBrnch,
                                                                                                dummyBean.lastMaintTell);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateInstructionNoMock(){

        CreateInstruction_Req_IB_v2 dummyBean = CreateInstruction_Req_IB_v2.createDummy();
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v2 responseBean = CreateInstruction_IH_v2.createInstruction(dummyBean.accessAcc, dummyBean.instrRefName, dummyBean.actDate, dummyBean.endDate,
                                                                                                dummyBean.payDay, dummyBean.freq, dummyBean.amount, 
                                                                                                dummyBean.srcAcc, dummyBean.srcAccType, dummyBean.srcClrCode,
                                                                                                dummyBean.srcStmtRef, dummyBean.trgAcc, dummyBean.trgAccType,
                                                                                                dummyBean.trgClrCode, dummyBean.trgStmtRef, dummyBean.lastMaintBrnch,
                                                                                                dummyBean.lastMaintTell);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateInstructionNoIntegrationTranslations(){

        CreateInstruction_Req_IB_v2 dummyBean = CreateInstruction_Req_IB_v2.createDummy();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v2 responseBean = CreateInstruction_IH_v2.createInstruction(dummyBean.accessAcc, dummyBean.instrRefName, dummyBean.actDate, dummyBean.endDate,
                                                                                                dummyBean.payDay, dummyBean.freq, dummyBean.amount, 
                                                                                                dummyBean.srcAcc, dummyBean.srcAccType, dummyBean.srcClrCode,
                                                                                                dummyBean.srcStmtRef, dummyBean.trgAcc, dummyBean.trgAccType,
                                                                                                dummyBean.trgClrCode, dummyBean.trgStmtRef, dummyBean.lastMaintBrnch,
                                                                                                dummyBean.lastMaintTell);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateInstructionCreaetDummy(){
        CreateInstruction_Req_IB_v2 requestBean = CreateInstruction_Req_IB_v2.createDummy();
    }
    
}
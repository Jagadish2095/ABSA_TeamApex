/*
 * Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
 * @author Srikanth N
 * @created 2020-02-06
 * @Modified Lulu Rankwe
 * @created 2020-05-27
 */   

@isTest
public class MBinitiatePaymentV10_IH_v1_Test {
    
    @isTest static void MBinitiatePaymentV10Positive() {   

        MBinitiatePaymentV10_Req_IB_v1 dummyBean = MBinitiatePaymentV10_Req_IB_v1.createDummyRequest();
        MBinitiatePaymentV10_Resp_IB_v1 dummyResponseBean = MBinitiatePaymentV10_Resp_IB_v1.dummyResponse();

        //Insert Integration Settings
        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});
        
        Test.startTest();
        // Call the method to test  
        MBinitiatePaymentV10_IU_v1.mapRequestdFields();
        HttpResponse httpresp = new HttpResponse();
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBinitiatePaymentV10_IH_v1.callToMBinitiatePaymentV10(dummyBean);        
        MBinitiatePaymentV10_Resp_IB_v1 responseBean = (new List<MBinitiatePaymentV10_Resp_IB_v1>(responseMap.keySet()))[0];
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();   
    }
    
        @isTest static void MBinitiatePaymentV10Negative() {   

        MBinitiatePaymentV10_Req_IB_v1 dummyBean = MBinitiatePaymentV10_Req_IB_v1.createDummyRequest();
        MBinitiatePaymentV10_Resp_IB_v1 dummyResponseBean = MBinitiatePaymentV10_Resp_IB_v1.dummyResponse();

        //Insert Integration Settings
        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});
        
        Test.startTest();
        // Call the method to test  
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBinitiatePaymentV10_IH_v1.callToMBinitiatePaymentV10(dummyBean);        
        MBinitiatePaymentV10_Resp_IB_v1 responseBean = (new List<MBinitiatePaymentV10_Resp_IB_v1>(responseMap.keySet()))[0];
        Test.stopTest();   
    }
    


    @isTest static void testcallMBinitiatePaymentPositive(){
        
        MBinitiatePaymentV10_Req_IB_v1 dummyBean = MBinitiatePaymentV10_Req_IB_v1.createDummyRequest();   
        MBinitiatePaymentV10_Resp_IB_v1 dummyResponseBean = MBinitiatePaymentV10_Resp_IB_v1.dummyResponse();
        
        //Insert Integration Settings
        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});
        
        Test.startTest();
        // Call the method to test   
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBinitiatePaymentV10_IH_v1.callMBinitiatePayment(dummyBean.paymTime,dummyBean.actDate,dummyBean.amount,dummyBean.srcAcc,dummyBean.srcAccType,dummyBean.srcStmtRef,dummyBean.trgAcc,dummyBean.trgClrCode,dummyBean.trgAccType,dummyBean.trgStmtRef,dummyBean.paymIipInd,dummyBean.instrRefName,dummyBean.tieb);         
        MBinitiatePaymentV10_Resp_IB_v1 responseBean = (new List<MBinitiatePaymentV10_Resp_IB_v1>(responseMap.keySet()))[0];
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();   
        
    }
    
    @isTest static void testcallMBinitiatePaymentNegetave(){
        
        MBinitiatePaymentV10_Req_IB_v1 dummyBean = MBinitiatePaymentV10_Req_IB_v1.createDummyRequest();   
        MBinitiatePaymentV10_Resp_IB_v1 dummyResponseBean = MBinitiatePaymentV10_Resp_IB_v1.dummyResponse();
        
        //Insert Integration Settings
        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});
        
        Test.startTest();
        // Call the method to test   
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBinitiatePaymentV10_IH_v1.callMBinitiatePayment('','','','','','','','','','','','','');         
        
        MBinitiatePaymentV10_Resp_IB_v1 responseBean = (new List<MBinitiatePaymentV10_Resp_IB_v1>(responseMap.keySet()))[0];
        system.assertNotEquals(200, responseBean.statusCode);
        Test.stopTest();   
        
    }

    @isTest static void testPayBeneficiaryPositive(){
        
        MBinitiatePaymentV10_Req_IB_v1 dummyBean = MBinitiatePaymentV10_Req_IB_v1.createPayBeneficiaryDummy();   
        MBinitiatePaymentV10_Resp_IB_v1 dummyResponseBean = MBinitiatePaymentV10_Resp_IB_v1.dummyResponse();

        //Insert Integration Settings
        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});

        Test.startTest();
        // Call the method to test   
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBinitiatePaymentV10_IH_v1.payBeneficiary(dummyBean.paymTime,dummyBean.accessAcc,dummyBean.cifKey,dummyBean.instrRefName,dummyBean.actDate,dummyBean.amount,dummyBean.instrNo,dummyBean.srcAcc,dummyBean.srcAccType,dummyBean.srcStmtRef,dummyBean.trgAcc,dummyBean.trgClrCode,dummyBean.trgAccType,dummyBean.trgStmtRef,dummyBean.paymIipInd,dummyBean.tieb);
        MBinitiatePaymentV10_Resp_IB_v1 responseBean = (new List<MBinitiatePaymentV10_Resp_IB_v1>(responseMap.keySet()))[0];
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();   
        
    }
    
    @isTest static void testPayBeneficiaryNegetave(){
        
        MBinitiatePaymentV10_Req_IB_v1 dummyBean = MBinitiatePaymentV10_Req_IB_v1.createPayBeneficiaryDummy();   
        MBinitiatePaymentV10_Resp_IB_v1 dummyResponseBean = MBinitiatePaymentV10_Resp_IB_v1.dummyResponse();
        
        //Insert Integration Settings
        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});
        
        Test.startTest();
        // Call the method to test   
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBinitiatePaymentV10_IH_v1.payBeneficiary('','','','','','','','','','','','','','','','');
        MBinitiatePaymentV10_Resp_IB_v1 responseBean = (new List<MBinitiatePaymentV10_Resp_IB_v1>(responseMap.keySet()))[0];
        system.assertNotEquals(200, responseBean.statusCode);
        Test.stopTest();   
        
    }
    


}
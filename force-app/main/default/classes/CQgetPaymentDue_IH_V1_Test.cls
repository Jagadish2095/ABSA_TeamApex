/*
 * Test Integration Handler for CQGetPaymentDue Service
 * @author Haritha Police
 * @created 2019-09-14
 */

@isTest
Global class CQgetPaymentDue_IH_V1_Test {
 @isTest static void CQgetPaymentDuePositive() {
         CQgetPaymentDue_Req_IB_V1 dummyBean = CQgetPaymentDue_Req_IB_V1.createDummyRequest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CQgetPaymentDueMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CQ_PaymentDueV1});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Map<CQgetPaymentDue_Resp_IB_V1, List<Sys_Log_Integration__c>>  responseBean = CQgetPaymentDue_IH_V1.getCQPaymentDueResponseDetails('BDP','BDP','Y','E','STD','4046048717','034','034','1234','1');
        Test.stopTest();
        CQgetPaymentDue_Resp_IB_V1.dummyResponse();
    }
    
    //Test with no Mock
    @isTest static void CQgetPaymentDueNoMock() {
        CQgetPaymentDue_Req_IB_V1 dummyBean = CQgetPaymentDue_Req_IB_V1.createDummyRequest();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CQ_PaymentDueV1});
         CQgetPaymentDue_Resp_IB_V1.dummyResponse();
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Map<CQgetPaymentDue_Resp_IB_V1, List<Sys_Log_Integration__c>> responseBean = CQgetPaymentDue_IH_V1.getCQPaymentDueResponseDetails('BDP','BDP','Y','E','STD','4046048717','034','034','1234','1');
        Test.stopTest();
    }
    
    @isTest static void CQgetPaymentDueNoIntegrationSettings() {
        CQgetPaymentDue_Req_IB_V1 dummyBean = CQgetPaymentDue_Req_IB_V1.createDummyRequest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CQgetPaymentDueMock_ApiRest(StringConstants.POSITIVE_STRING)); 
         CQgetPaymentDue_Resp_IB_V1.dummyResponse();
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Map<CQgetPaymentDue_Resp_IB_V1, List<Sys_Log_Integration__c>> responseBean = CQgetPaymentDue_IH_V1.getCQPaymentDueResponseDetails('BDP','BDP','Y','E','STD','4046048717','034','034','1234','1');
        Test.stopTest();
    }
    
    @isTest static void CQgetPaymentDueNegative() {
        CQgetPaymentDue_Req_IB_V1 dummyBean = CQgetPaymentDue_Req_IB_V1.createDummyRequest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CQgetPaymentDueMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CQ_PaymentDueV1});
         CQgetPaymentDue_Resp_IB_V1.dummyResponse();
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
       Map<CQgetPaymentDue_Resp_IB_V1, List<Sys_Log_Integration__c>> responseBean = CQgetPaymentDue_IH_V1.getCQPaymentDueResponseDetails('BDP','BDP','Y','E','STD','4046048717','034','034','1234','1');
        Test.stopTest();
    }
}
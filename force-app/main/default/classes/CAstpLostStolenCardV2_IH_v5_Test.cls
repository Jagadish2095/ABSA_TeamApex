/*
* Test Integration Handler for CAstpLostStolenCardV2 Service
* @author Madhava Palla
* @created 2019-09-17
*/
@isTest
Global class CAstpLostStolenCardV2_IH_v5_Test {
    
    @isTest static void CAstpLostStolenCardV2Positive() {
        CAstpLostStolenCardV2_Req_IB_v5 dummyBean = CAstpLostStolenCardV2_Req_IB_v5.createDummyRequest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CAstpLostStolenCardV2Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CA_STP_LOSTSTOLENCARD_V2});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>> responseBean = CAstpLostStolenCardV2_IH_v5.CAstpLostStolenCardResponseDetails('Test');
        Test.stopTest();
    }
    
    //Test with no Mock
    @isTest static void CAstpLostStolenCardV2NoMock() {
        CAstpLostStolenCardV2_Req_IB_v5 dummyBean = CAstpLostStolenCardV2_Req_IB_v5.createDummyRequest();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CA_STP_LOSTSTOLENCARD_V2});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>> responseBean = CAstpLostStolenCardV2_IH_v5.CAstpLostStolenCardResponseDetails('Test');
        Test.stopTest();
    }
    
    @isTest static void CAstpLostStolenCardV2NoIntegrationSettings() {
        CAstpLostStolenCardV2_Req_IB_v5 dummyBean = CAstpLostStolenCardV2_Req_IB_v5.createDummyRequest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CAstpLostStolenCardV2Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>> responseBean = CAstpLostStolenCardV2_IH_v5.CAstpLostStolenCardResponseDetails('Test');
        Test.stopTest();
    }
    
    @isTest static void CAstpLostStolenCardV2Negative() {
        CAstpLostStolenCardV2_Req_IB_v5 dummyBean = CAstpLostStolenCardV2_Req_IB_v5.createDummyRequest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CAstpLostStolenCardV2Mock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CA_STP_LOSTSTOLENCARD_V2});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>> responseBean = CAstpLostStolenCardV2_IH_v5.CAstpLostStolenCardResponseDetails('Test');
        Test.stopTest();
    }
}
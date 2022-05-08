@isTest
public class GetClientDetailsCIF_IH_v1_Test {
    
    @isTest static void getClientDetailsPositive() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsCIFMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_DETAILS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetClientDetailsCIF_Resp_IB_v1 responseBean = GetClientDetailsCIF_IH_v1.getClientDetails('SLABBHP001', '0', '009970');
        Test.stopTest();
    }
    
    //Test with no Mock
    @isTest static void getClientDetailsNoMock() {
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_DETAILS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetClientDetailsCIF_Resp_IB_v1 responseBean = GetClientDetailsCIF_IH_v1.getClientDetails('SLABBHP001', '0', '009970');
        Test.stopTest();
    }
    
    @isTest static void getClientDetailsNoIntegrationSettings() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsCIFMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetClientDetailsCIF_Resp_IB_v1 responseBean = GetClientDetailsCIF_IH_v1.getClientDetails('SLABBHP001', '0', '009970');
        Test.stopTest();
    }
    
    @isTest static void getClientDetailsNegative() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsCIFMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_DETAILS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetClientDetailsCIF_Resp_IB_v1 responseBean = GetClientDetailsCIF_IH_v1.getClientDetails('SLABBHP001', '0', '009970');
        Test.stopTest();
    }
}
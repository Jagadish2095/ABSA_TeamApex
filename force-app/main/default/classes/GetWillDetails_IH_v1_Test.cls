@isTest
public class GetWillDetails_IH_v1_Test {
    
    @isTest static void getWillDetails() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetWillDetailsMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_WILL_DETAILS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetWillDetails_Resp_IB_v1 responseBean = GetWillDetails_IH_v1.getWillDetails('41000006932');
        Test.stopTest();
    }
    
    @isTest static void getWillDetailsNegative() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetWillDetailsMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_WILL_DETAILS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetWillDetails_Resp_IB_v1 responseBean = GetWillDetails_IH_v1.getWillDetails('41000006932');
        Test.stopTest();
    }
}
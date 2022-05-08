@isTest
public class GetAssetsLiabilities_IH_v1_Test 
{    
    @isTest static void getAssetsLiabilitiesPositive() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetAssetsLiabilitiesMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_ASSETS_LIABILITIES});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetAssetsLiabilities_Resp_IB_v1 responseBean = GetAssetsLiabilities_IH_v1.getAssetsLiabilities('41000003908');
        Test.stopTest();
    }
    
    @isTest static void getAssetsLiabilitiesNoIntegrationSettings() 
    {        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetAssetsLiabilities_Resp_IB_v1 responseBean = GetAssetsLiabilities_IH_v1.getAssetsLiabilities('41000003908');
        Test.stopTest();
    }
    
    @isTest static void getAssetsLiabilitiesNegative() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetAssetsLiabilitiesMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_ASSETS_LIABILITIES});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetAssetsLiabilities_Resp_IB_v1 responseBean = GetAssetsLiabilities_IH_v1.getAssetsLiabilities(null);
        Test.stopTest();
    }
    
    @isTest static void getAssetsLiabilitiesException() 
    {       
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_ASSETS_LIABILITIES});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetAssetsLiabilities_Resp_IB_v1 responseBean = GetAssetsLiabilities_IH_v1.getAssetsLiabilities('41000003908');
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
}
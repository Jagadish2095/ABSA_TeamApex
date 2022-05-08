@isTest
public class GetFilingAddress_IH_v1_Test 
{
	@isTest static void getFilingAddressPositive() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetFilingAddressMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_FILING_ADDRESS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetFilingAddress_Resp_IB_v1 responseBean = GetFilingAddress_IH_v1.getFilingAddress('41000014420');
        Test.stopTest();
    }
    
    @isTest static void getFilingAddressNoIntegrationSettings() 
    {        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetFilingAddress_Resp_IB_v1 responseBean = GetFilingAddress_IH_v1.getFilingAddress('41000014420');
        Test.stopTest();
    }
    
    @isTest static void getFilingAddressNegative() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetFilingAddressMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_FILING_ADDRESS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetFilingAddress_Resp_IB_v1 responseBean = GetFilingAddress_IH_v1.getFilingAddress(null);
        Test.stopTest();
    }
    
    @isTest static void getFilingAddressException() 
    {        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_FILING_ADDRESS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetFilingAddress_Resp_IB_v1 responseBean = GetFilingAddress_IH_v1.getFilingAddress('41000014420');
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
}
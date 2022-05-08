@isTest
public class CreateAssetsLiabilities_IH_v1_Test 
{
	@isTest static void createAssetsLiabilitiesPositive() 
    {        
        CreateAssetsLiabilities_Req_IB_v1 dummyBean = new CreateAssetsLiabilities_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateAssetsLiabilitiesMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_ASSETS_LIABILITIES});

        Test.startTest();
              
		CreateAssetsLiabilities_Resp_IB_v1 responseBean = CreateAssetsLiabilities_IH_v1.createAssetsLiability(dummyBean.createDummyRequest());       
        System.debug('Create Assets Liabilities responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void createAssetsLiabilitiesNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateAssetsLiabilitiesMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_ASSETS_LIABILITIES});

        Test.startTest();
        
        CreateAssetsLiabilities_Req_IB_v1 reqBean = new CreateAssetsLiabilities_Req_IB_v1();
    	reqBean.Operation = 'WRITE ASS';
        reqBean.WillNo = '41000003908';
        reqBean.Assets = 'Y';
        reqBean.FarmingTestator = '250';
        
        CreateAssetsLiabilities_Resp_IB_v1 responseBean = CreateAssetsLiabilities_IH_v1.createAssetsLiability(reqBean);
        System.debug('Create Assets Liabilities responseBean negative: '+ responseBean);
        Test.stopTest();
    }
        
    @isTest static void createAssetsLiabilitiesNoIntegrationSettings() 
    {        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        CreateAssetsLiabilities_Req_IB_v1 reqBean = new CreateAssetsLiabilities_Req_IB_v1();
        CreateAssetsLiabilities_Resp_IB_v1 responseBean = CreateAssetsLiabilities_IH_v1.createAssetsLiability(reqBean); 
        Test.stopTest();
    }
    
    @isTest static void createAssetsLiabilitiesException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateAssetsLiabilitiesMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_ASSETS_LIABILITIES});

        Test.startTest();
        
        CreateAssetsLiabilities_Req_IB_v1 reqBean = new CreateAssetsLiabilities_Req_IB_v1();
        CreateAssetsLiabilities_Resp_IB_v1 responseBean = CreateAssetsLiabilities_IH_v1.createAssetsLiability(reqBean);  
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }    
}
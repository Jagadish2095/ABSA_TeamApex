@isTest
public class GetXmlWillDraft_IH_v1_Test 
{
    @isTest static void getXmlWillDraftPositive() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetXmlWillDraftMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_XML_WILL_DRAFT});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetXmlWillDraft_Resp_IB_v1 responseBean = GetXmlWillDraft_IH_v1.getXmlWillDraft('41005576899');
        Test.stopTest();
    }
    
    @isTest static void getXmlWillDraftNoIntegrationSettings() 
    {        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetXmlWillDraft_Resp_IB_v1 responseBean = GetXmlWillDraft_IH_v1.getXmlWillDraft('41005576899');
        Test.stopTest();
    }
    
    @isTest static void getXmlWillDraftNegative() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetXmlWillDraftMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_XML_WILL_DRAFT});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetXmlWillDraft_Resp_IB_v1 responseBean = GetXmlWillDraft_IH_v1.getXmlWillDraft(null);
        Test.stopTest();
    }
    
    @isTest static void getXmlWillDraftException() 
    {        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_XML_WILL_DRAFT});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetXmlWillDraft_Resp_IB_v1 responseBean = GetXmlWillDraft_IH_v1.getXmlWillDraft('41005576899');
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
}
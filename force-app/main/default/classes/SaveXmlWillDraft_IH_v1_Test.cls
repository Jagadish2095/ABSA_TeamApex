@isTest
public class SaveXmlWillDraft_IH_v1_Test 
{	
	@isTest static void SaveXmlWillDraftPositive() 
    {        
     	SaveXmlWillDraft_Req_IB_v1 dummyBean = new SaveXmlWillDraft_Req_IB_v1();
                
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SaveXmlWillDraftMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.SAVE_XML_WILL_DRAFT});

        Test.startTest();
              
		SaveXmlWillDraft_Resp_IB_v1 responseBean = SaveXmlWillDraft_IH_v1.saveXmlWillDraft(dummyBean.createDummyRequest());   
        System.debug('Save Xml Will Draft responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void SaveXmlWillDraftNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SaveXmlWillDraftMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.SAVE_XML_WILL_DRAFT});

        Test.startTest();
        
        SaveXmlWillDraft_Req_IB_v1 draft1 = new SaveXmlWillDraft_Req_IB_v1();
        draft1.key = 'willNo';
        draft1.value = '41005576899';
        
        List<SaveXmlWillDraft_Req_IB_v1> reqBean = new List<SaveXmlWillDraft_Req_IB_v1>();
        reqBean.add(draft1);
        
        SaveXmlWillDraft_Resp_IB_v1 responseBean = SaveXmlWillDraft_IH_v1.saveXmlWillDraft(reqBean);
        System.debug('Save Xml Will Draft responseBean negative: '+ responseBean);
        Test.stopTest();
    }
        
    @isTest static void SaveXmlWillDraftNoIntegrationSettings() 
    {        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        List<SaveXmlWillDraft_Req_IB_v1> reqBean = new List<SaveXmlWillDraft_Req_IB_v1>();
        SaveXmlWillDraft_Resp_IB_v1 responseBean = SaveXmlWillDraft_IH_v1.saveXmlWillDraft(reqBean); 
        Test.stopTest();
    }
    
    @isTest static void SaveXmlWillDraftException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new  SaveXmlWillDraftMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.SAVE_XML_WILL_DRAFT});

        Test.startTest();
        
        List<SaveXmlWillDraft_Req_IB_v1> reqBean = new List<SaveXmlWillDraft_Req_IB_v1>();
        SaveXmlWillDraft_Resp_IB_v1 responseBean = SaveXmlWillDraft_IH_v1.saveXmlWillDraft(reqBean);  
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }        
}
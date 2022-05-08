@isTest
public class RetrieveTrackerStatus_IH_v1_Test
{           
    @isTest static void getRetrieveTrackerStatusPositive() 
    {        
        RetrieveTrackerStatus_Req_IB_v1 dummyBean = new RetrieveTrackerStatus_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RetrieveTrackerStatus_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.LIST_TRACKER_HISTORY});

        Test.startTest();
              
		RetrieveTrackerStatus_Resp_IB_v1 responseBean = RetrieveTrackerStatus_IH_v1.getRetrieveTrackerStatus('WILLS', 'WILLS', 'N', 'E', 'STD', '41000014420');       
        System.debug('Retrieve Tracker Status responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void getRetrieveTrackerStatusNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RetrieveTrackerStatus_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.LIST_TRACKER_HISTORY});

        Test.startTest();  
        
        RetrieveTrackerStatus_Resp_IB_v1 responseBean = RetrieveTrackerStatus_IH_v1.getRetrieveTrackerStatus('WINS', 'WINS', 'Y', 'Y', 'DTS', '5211115531');
        System.debug('Retrieve Tracker Statust responseBean negative: '+ responseBean);
        Test.stopTest();
    }
    
    @isTest static void getRetrieveTrackerStatusException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RetrieveTrackerStatus_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.LIST_TRACKER_HISTORY});

        Test.startTest();
        
        RetrieveTrackerStatus_Resp_IB_v1 responseBean = RetrieveTrackerStatus_IH_v1.getRetrieveTrackerStatus('','','','','','');  
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
}
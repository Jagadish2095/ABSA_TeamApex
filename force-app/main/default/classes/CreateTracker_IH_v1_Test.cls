@isTest
public class CreateTracker_IH_v1_Test {      
	     
    @isTest 
    public static void createTrackerPositive() {        
        CreateTracker_Req_IB_v1 dummyBean = new CreateTracker_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateTrackerMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_TRACKER_RECORD});

        Test.startTest();
              
		CreateTracker_Resp_IB_v1 responseBean = CreateTracker_IH_v1.createTracker('WILLS','WILLS','Y','41000014420','D','20190128','1524','usr112','ARKCD','ARKCDxiqbsMyglenFtph','location','usr333','FILED','testing','3232');       
		System.assert(responseBean != null);   
        Test.stopTest();
    }
    
    @isTest 
    public static void createTrackerNegative() {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateTrackerMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_TRACKER_RECORD});
        Test.startTest();      
        CreateTracker_Resp_IB_v1 responseBean = CreateTracker_IH_v1.createTracker('WILLS','WILLS','Y','4100001442','D','20190128','1524','usx112','ARKCD','ARKCDxiqbsMyglenFtph','location','usx333','FILED','testing','3322');
        System.assert(responseBean != null); 
        System.assert(responseBean.statusCode == 400); //check response code was set on the response
        Test.stopTest();
    }
}
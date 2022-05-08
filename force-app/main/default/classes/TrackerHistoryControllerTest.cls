/**
* Test Class for Refresh Tracker History
* Calling RetreiveTracker service 
* @author  Himanshu Nimje (Mphatek)
* @created 2019-03-13
*/


@isTest
public class TrackerHistoryControllerTest {
    
    private static Map <String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    private static Map <String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    
    @isTest static void RefreshTrackerHistoryPositive(){
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.LIST_TRACKER_HISTORY});
        
        Test.setMock(HttpCalloutMock.class, new TrackerHistoryControllerMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
        TrackerHistoryController.refreshTrackerHistoryRecords(testDataFactory.testOpportunity.Id);
        Test.stopTest();
        
    }
    
    
}
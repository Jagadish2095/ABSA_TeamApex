@isTest
private class CreateWillRecord_IH_v1_Test 
{
    @isTest static void createWillRecordPositive() 
    {        
        CreateWillRecord_Req_IB_v1 dummyBean = new CreateWillRecord_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateWillRecordMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_WILL_RECORD});
        
        Test.startTest();
        
        CreateWillRecord_Resp_IB_v1 responseBean = CreateWillRecord_IH_v1.createRecord('41000003904','WILLM 0778',3232,'ABS',3232,0,20190128);       
        System.debug('Create Will Record responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void createWillRecordNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateWillRecordMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        
        CreateWillRecord_Resp_IB_v1 responseBean = CreateWillRecord_IH_v1.createRecord('41000003','WILLM 0778',3232,'ABS',0,0,20190128);
        System.debug('Create Will Record responseBean negative: '+ responseBean);
        Test.stopTest();
    }
    
    @isTest static void createWillRecordException() 
    {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_WILL_RECORD});        
        
        Test.startTest();
        
        CreateWillRecord_Req_IB_v1 reqBean = new CreateWillRecord_Req_IB_v1();
        CreateWillRecord_Resp_IB_v1 responseBean = CreateWillRecord_IH_v1.createRecord('41000003904','WILLM 0778',0,'',0,0,0);  
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }    
}
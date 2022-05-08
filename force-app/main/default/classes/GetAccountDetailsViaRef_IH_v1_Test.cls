@isTest
public class GetAccountDetailsViaRef_IH_v1_Test
{           
    @isTest static void GetAccountDetailsViaRefPositive() 
    {        
        GetAccountDetailsViaRef_Req_IB_v1 dummyBean = new GetAccountDetailsViaRef_Req_IB_v1();
        dummyBean.createDummyRequest();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_ACCOUNT_DETAILS_VIA_REFERENCE});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetAccountDetailsViaRefMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
              
		GetAccountDetailsViaRef_Resp_IB_v1 responseBean = GetAccountDetailsViaRef_IH_v1.getAccountDetailsViaRef('SALESFORCE','WILLS','Y','AVSR004000', '1749288A5B', 20170411, 15150000, 0);       
        System.debug('Get Account Details Via Reference responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void GetAccountDetailsViaRefNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetAccountDetailsViaRefMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_ACCOUNT_DETAILS_VIA_REFERENCE});
        
        Test.startTest();  
        
        GetAccountDetailsViaRef_Resp_IB_v1 responseBean = GetAccountDetailsViaRef_IH_v1.getAccountDetailsViaRef('SALESFORCE','WILLS','Y','AVSR004000', '1749288A5B', 20170411, 15150000, 0);
        System.debug('Get Account Details Via Reference responseBean negative: '+ responseBean);
        Test.stopTest();
    }
    
    @isTest static void GetAccountDetailsViaRefException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetAccountDetailsViaRefMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_ACCOUNT_DETAILS_VIA_REFERENCE});
        
        Test.startTest();
        
        GetAccountDetailsViaRef_Resp_IB_v1 responseBean = GetAccountDetailsViaRef_IH_v1.getAccountDetailsViaRef('', '', '', '', '', 0, 0, 0);  
        System.debug('Get Account Details Via Reference responseBean positive: '+ responseBean);
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
    
    @isTest static void GetAccountDetailsViaRefNoIntegrationSettings() 
    {               
        // Set mock callout class         
        Test.startTest();
		GetAccountDetailsViaRef_Resp_IB_v1 responseBean = GetAccountDetailsViaRef_IH_v1.getAccountDetailsViaRef('SALESFORCE','WILLS','Y','AVSR004000', '1749288A5B', 20170411, 15150000, 0);       
        Test.stopTest();
    }
}
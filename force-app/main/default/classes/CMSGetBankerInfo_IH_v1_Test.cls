/*
* Test Integration Handler for CMSGetBankerInfo Service
* @author Diksha wasekar
* @created 2019-09-07
*/

@isTest
public class CMSGetBankerInfo_IH_v1_Test {
    
	@isTest static void validateBankerInfoPositive() 
    {        
        CMSGetBankerInfo_Req_IB_V1 dummyBeanCms = new CMSGetBankerInfo_Req_IB_V1();
        dummyBeanCms.creatDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CMSServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CMS_GET_ACCOUNTDEATILS});

        Test.startTest();
              
        Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CMSGetBankerInfo_IH_v1.getBankerDeatils('BDP', 'DFARIML001');
		CMSGetBankerInfo_Resp_IB_v1 responseBean = (new List<CMSGetBankerInfo_Resp_IB_v1>(responseMap.keySet()))[0];
        System.debug('CMS get AccountInfo responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validateBankerInfoNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CMSServiceMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CMS_GET_ACCOUNTDEATILS});

        Test.startTest();
        
        Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CMSGetBankerInfo_IH_v1.getBankerDeatils('', '');
		CMSGetBankerInfo_Resp_IB_v1 responseBean = (new List<CMSGetBankerInfo_Resp_IB_v1>(responseMap.keySet()))[0];
        System.debug('CMS get AccountInfo responseBean negative: '+ responseBean);
        Test.stopTest();
    }
    
    @isTest static void validateBankerInfoNoIntegrationSettings() 
    {  
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Test.startTest();
        Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CMSGetBankerInfo_IH_v1.getBankerDeatils('BDP', 'DFARIML001');
		CMSGetBankerInfo_Resp_IB_v1 responseBean = (new List<CMSGetBankerInfo_Resp_IB_v1>(responseMap.keySet()))[0];
        Test.stopTest();
    }
    
    @isTest static void validateBankerInfoException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CMS_GET_ACCOUNTDEATILS});

        Test.startTest();
        Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CMSGetBankerInfo_IH_v1.getBankerDeatils('BDP', 'DFARIML001'); 
		CMSGetBankerInfo_Resp_IB_v1 responseBean = (new List<CMSGetBankerInfo_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

}
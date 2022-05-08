/*
* Test Integration Handler for CASAScreenRelatedParty Service
* @author Pitso Sekhu
* @created 2019-03-13
*/

@isTest
public class CASAScreenRelatedParty_IH_v2_Test  {    
    
    @isTest static void screenRelatedPartyPositive() {        
        CASAScreenRelatedParty_Req_IB_v2 dummyBean = new CASAScreenRelatedParty_Req_IB_v2();
        dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedPartyMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
        
        Test.startTest();
        
        CASAScreenRelatedParty_Resp_IB_v2 responseBean = CASAScreenRelatedParty_IH_v2.screenRelatedParty('SALESFORCE','WILLS','N','Test25102017105243','Last25102017105243', '1', '9710256796082','I','19971025','SOU01','ZWIDE','SO003','SO003','120001185','125346','3456','ABLMAZB','WILLS');       
        System.debug('CASA Screen Related Party responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyNegative() {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedPartyMock_ApiRest_v2(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
        
        Test.startTest();  
        
        CASAScreenRelatedParty_Resp_IB_v2 responseBean = CASAScreenRelatedParty_IH_v2.screenRelatedParty('SALESFORCE','WILLS','N','4363','5353', '1', '9710256796666','K','19991025','XOU04','ZWIDE','XO003','XO003','120005678','125346','8789','ABLMABA','BILLS');
        System.debug('CASA Screen Related Party responseBean negative: '+ responseBean);
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyException() {        
        // Set mock callout class 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
        
        Test.startTest();
        
        CASAScreenRelatedParty_Resp_IB_v2 responseBean = CASAScreenRelatedParty_IH_v2.screenRelatedParty('','','','','','','','','','','','','','','','','','');  
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyNoIntegrationSettingFound() {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedPartyMock_ApiRest_v2(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        
        CASAScreenRelatedParty_Resp_IB_v2 responseBean = CASAScreenRelatedParty_IH_v2.screenRelatedParty('','','','','','','','','','','','','','','','','','');  
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyJointAccPositive() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedPartyMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        List<User> userList = [Select AB_Number__c From User Where AB_Number__c != null];
        
        Test.startTest();
        
        Map<CASAScreenRelatedParty_Resp_IB_v2, Sys_Log_Integration__c> screenRelatedPartyMap = CASAScreenRelatedParty_IH_v2.screenRelatedPartyMap(testDataFactory.testProspectAccount, 'South Africa', 'South Africa', 'South Africa', 'SA Identity Document', userList[0], '123', 'South Africa');
        System.debug('CASA Screen Related Party responseBean positive: '+ screenRelatedPartyMap);
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyJointAccNoIntegrationSettings() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedPartyMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        List<User> userList = [Select AB_Number__c From User Where AB_Number__c != null];
        
        Test.startTest();
        
        Map<CASAScreenRelatedParty_Resp_IB_v2, Sys_Log_Integration__c> screenRelatedPartyMap = CASAScreenRelatedParty_IH_v2.screenRelatedPartyMap(testDataFactory.testProspectAccount, 'South Africa', 'South Africa', 'South Africa', 'SA Identity Document', userList[0], '123', 'South Africa');
        System.debug('CASA Screen Related Party responseBean positive: '+ screenRelatedPartyMap);
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyJointAccNoMock() {
        
        // Set mock callout class 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        List<User> userList = [Select AB_Number__c From User Where AB_Number__c != null];
        
        Test.startTest();
        
        Map<CASAScreenRelatedParty_Resp_IB_v2, Sys_Log_Integration__c> screenRelatedPartyMap = CASAScreenRelatedParty_IH_v2.screenRelatedPartyMap(testDataFactory.testProspectAccount, 'South Africa', 'South Africa', 'South Africa', 'SA Identity Document', userList[0], '123', 'South Africa');
        System.debug('CASA Screen Related Party responseBean positive: '+ screenRelatedPartyMap);
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
}
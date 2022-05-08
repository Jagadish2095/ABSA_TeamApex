/**
* @description Test class for ContactsSelector
* @since 2019-04-29
**/
@isTest
public with sharing class IntegrationServicesSelectorTest {

    // PJAIN: 20200708
    @TestSetup
    static void testDataSetup(){
        Integration_API__c api = new Integration_API__c();
        api.Name = 'iTouchxx';
        api.Environment__c = 'Development';
        api.Base_URL__c = 'https://testme/';
        api.Client_ID__c = '89797897987';
        api.Client_Secret__c = '789798';
        insert api;

        Integration_Service__c integrationService = new Integration_Service__c();
        integrationService.Integration_API_ID__c = api.Id;
        integrationService.Name = 'iTouch For PBB';
        integrationService.Method__c = 'POST';
        integrationService.URL_Extension__c = '/itouch/test';
        integrationService.Username__c = 'abc';
        integrationService.Password__c = 'zyx';
        integrationService.Content_Type__c = 'application/json';
        insert integrationService;
    }

    static testMethod void runIntegrationServicesSelectorTest(){
        Test.startTest();
        Set<Id> ids = new Set<Id>();
        String servId = [Select Id From Integration_Service__c Where Name = 'iTouch For PBB'].Id;
        ids.add(servId);
        List<Integration_Service__c> isList = new IntegrationServicesSelector().selectById(ids);
        Test.stopTest();
    }

    // PJAIN: 20200708
    static testMethod void testSelectByNameAndEnvironment(){
        Test.startTest();
        List<Integration_Service__c> integrationServices = new IntegrationServicesSelector().selectByNameAndEnvironment('iTouch For PBB', 'Development');
        Test.stopTest();
        System.assertEquals(1, integrationServices.size());
    }
}
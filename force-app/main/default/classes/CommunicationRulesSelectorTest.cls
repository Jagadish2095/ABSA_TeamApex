/**
* @description Test class for BusinessHoursSelector
* @since 2019-04-29
**/
@isTest
public with sharing class CommunicationRulesSelectorTest {
     static testMethod void runCommunicationRulesSelectorTest(){
         Integration_API__c api = new Integration_API__c();
        api.Name = 'iTouchxx';
        api.Environment__c = 'Development';
        api.Base_URL__c = 'https://testme/';
        api.Client_ID__c = '89797897987';
        api.Client_Secret__c = '789798';
        insert api;

        Integration_Service__c intsrv = new Integration_Service__c();
        intsrv.Integration_API_ID__c = api.Id;
        intsrv.Name = 'iTouch For PBB';
        intsrv.Method__c = 'POST';
        intsrv.URL_Extension__c = 'iTouch';
        intsrv.Username__c = 'abc';
        intsrv.Password__c = 'zyx';
        intsrv.Content_Type__c = 'application/json';
        insert intsrv;

        sd_Communication_Plan__c commPlan = new sd_Communication_Plan__c();
        commPlan.Name = 'Test Plan';
        insert commPlan;

        sd_Communication_Rule__c commRule = new sd_Communication_Rule__c();
        commRule.sd_Communication_Plan__c = commPlan.Id;
        commRule.sd_Integration_Service__c = intsrv.Id;
        commRule.sd_Rule_Description__c = 'New Case Creation Email Notification';
        commRule.sd_Action__c = 'Email';
        commRule.sd_Before_After__c = 'Before';
        commRule.sd_Quantity__c = 0;
        commRule.sd_Email_Field__c = 'Email';
        commRule.sd_Object__c = 'Case';
        commRule.sd_Email_Template__c = [Select Name From EmailTemplate limit 1].Name;
        commRule.sd_Trigger_Condition__c = 'Case Created in a Queue';
        commRule.sd_Trigger_Date_Field__c = 'Created Date';
        commRule.sd_Units__c = 'Hour(s)';
        commRule.sd_When_to_Trigger__c = 'Immediate';
        insert commRule;

        Set<Id> ids = new Set<Id>();
        ids.add(commRule.Id);

        Test.startTest();
            List<sd_Communication_Rule__c> ruleList = new CommunicationRulesSelector().selectById(ids);
            ruleList = new CommunicationRulesSelector().selectByRuleIdAndObjectType(ids, 'Case');
            ids.clear();
            ids.add(commPlan.Id);
            ruleList = new CommunicationRulesSelector().selectByParentId(ids, 1);
        Test.stopTest();
     }
}
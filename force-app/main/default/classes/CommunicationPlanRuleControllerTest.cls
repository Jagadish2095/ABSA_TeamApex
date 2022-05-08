/**
* @description Test class for CommunicationPlanRuleController
* @since 2019-07-15
**/
@isTest
public with sharing class CommunicationPlanRuleControllerTest {
    
    
    static testMethod void runCommunicationPlansSelectorTest(){

        //Test data
        User runningUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        
        EmailTemplate e = new EmailTemplate();
        
		System.runAs ( runningUser ) {
            
            e.developerName = 'test';
            e.TemplateType= 'Text';
            e.Name = 'test'; 
            e.isActive = true;
            e.FolderId = UserInfo.getUserId();
            insert e;
		}
        
        
        sd_Communication_Plan__c plan = new sd_Communication_Plan__c();
        plan.Name = 'Test Plan';
        
        insert plan;

        sd_Communication_Rule__c newrule = new sd_Communication_Rule__c();
        newrule.sd_Communication_Plan__c = plan.Id;
        newrule.sd_Action__c = 'Email';
        newrule.sd_Before_After__c = 'Before';
        newrule.sd_Rule_Description__c = 'Test Rule';
        newrule.sd_When_to_Trigger__c = 'Immediate';
        newrule.sd_Email_Template_Id__c = e.Id;
		newrule.sd_Email_Template_Id_AFR__c = e.Id;
		newrule.sd_SMS_Template_Id__c = e.Id;
		newrule.sd_SMS_Template_Id_AFR__c = e.Id;

        insert newrule;

        Test.startTest();
        sd_Communication_Rule__c rule = CommunicationPlanRuleController.getRule(newrule.Id);
        CommunicationPlanRuleController.upsertRule(rule);
        //Neg test, pass invalid ID
        CommunicationPlanRuleController.getRule(plan.Id);
        Test.stopTest();

    }
}
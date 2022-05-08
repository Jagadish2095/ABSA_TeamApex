/**
* @description Test class for EmailTemplatesSelector
* @since 2019-04-27
**/

@isTest
public with sharing class EmailTemplatesSelectorTest {

    static testMethod void testSelectById(){
        Test.startTest();
            Id templateId = [Select Id From EmailTemplate LIMIT 1].Id;
            Set<Id> ids = new Set<Id>();
            ids.add(templateId);
            List<EmailTemplate> bhr = new EmailTemplatesSelector().selectById(ids);
        	List<EmailTemplate> ets = new EmailTemplatesSelector().selectByName('name');
            List<EmailTemplate> sbdn = new EmailTemplatesSelector().selectByDeveloperName('names');
        Test.stopTest();
    }
}
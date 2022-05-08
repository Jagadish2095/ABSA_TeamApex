/**
* Test Class for CommunicationRuleTriggerHandler
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2019-07-20
*
**/
@isTest 
public class CommunicationRuleTriggerHandlerTest {
    
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
        commPlan.Name = 'Test Update Rule Plan';
        insert commPlan;

        sd_Communication_Rule__c commRule = new sd_Communication_Rule__c();
        commRule.sd_Communication_Plan__c = commPlan.Id;
        commRule.sd_Integration_Service__c = intsrv.Id;
        commRule.sd_Rule_Description__c = 'zzz';
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
		
        Financial_Product__c testFinancialProduct = new Financial_Product__c();
        testFinancialProduct.Name = 'Estate Provider Plan';
        testFinancialProduct.Type__c = 'Borrow';
        testFinancialProduct.Description__c = 'Test Product';
        testFinancialProduct.Business_Unit__c = 'Business Banking';
        testFinancialProduct.Product_Type__c = 'Bank';
        insert testFinancialProduct;
        
        Lead leadTest = new Lead();
        leadTest.FirstName = 'Test Rule Lead';
        leadTest.LastName = '1';
        leadTest.Company = 'Test Lead 1';
        leadTest.Financial_Product__c = testFinancialProduct.Id;
        leadTest.Business_Unit__c = 'Business Banking';
        leadTest.MobilePhone = '0987654321';
        leadTest.Phone = '0987654321';
        insert leadTest;
        
 		Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
		Task t = new Task();
        t.Priority = 'Normal';
        t.Status = 'Scheduled';
        t.Type = 'Notification';          
        t.RecordTypeId = taskRecordTypeMap.get('Communication Plan Tasks').RecordTypeId;
        t.Subject = commRule.sd_Rule_Description__c;
        t.Communication_Rule_Id__c = commRule.Id;
        t.WhoId = leadTest.Id;
        t.Communication_Task_Unique_Key__c = leadTest.Id + '' + commRule.Id;
		insert t;
        
        Test.startTest();
        
        sd_Communication_Rule__c rule = [Select Id, sd_Before_After__c from sd_Communication_Rule__c Where sd_Rule_Description__c = 'zzz'];
        rule.sd_Before_After__c = 'After';
        try{
            update rule;
        }catch(Exception e){
            
        }
        
        try{
             delete rule;

        }catch(Exception e){
            
        }
               	
        Test.stopTest();
     }

}
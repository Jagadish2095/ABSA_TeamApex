/**  
* @Purpose      : Test Class for DecisionHistoriesSelector
* @Author       : Jaco de Lange		 
* @Created Date : 2020-01-07
*/
@isTest
public class DecisionHistoriesSelectorTest {
    
/*
* Purpose : Method to create test data
*/
    @testSetup
    static void dataCreation(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email', 
                                Status = 'New', 
                                Origin = 'Email',
                                Account = account ,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('CAF_Application').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
        
        
        Decision_History__c testDH =  new Decision_History__c(case__c = caseRec.id,
                                                             Process_Name__c = 'Securities Validator',
                                                             Decision__c = 'Approved');
        insert testDH;
    }
    
    
    //Method to test
    static testMethod void DecisionHistoriesSelectorTest(){
        test.startTest();
        Case caseRec = [SELECT Id, AccountId FROM Case LIMIT 1];
        DecisionHistoriesSelector dh = new DecisionHistoriesSelector();
        dh.getSObjectType();
        dh.getSObjectFieldList();
        dh.selectById(new Set<Id>{caseRec.Id});
       // dh.selectByCaseProcessName(caseRec.Id, 'Test'); //added by Bhanumurty
        dh.selectByCaseDecision(caseRec.id, 'Approved');
        dh.selectByCaseProcessName(caseRec.id, 'Securities Validator');
        test.stopTest();
    }
 
}
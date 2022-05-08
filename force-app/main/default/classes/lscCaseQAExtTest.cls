/**
* Lightning conversion from classic quick action
* @Author : Koketso Mpshane
* @Date :   2019-08-07
* @Desc : Test Class for the lightning quick action Aura bundle lscCaseQA
*
**/
@isTest
public class lscCaseQAExtTest {
    
    @isTest
    static void lscCaseQAExt_test() { 
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
		insert con;
        Case testCase = new Case();
        //testCase.Queue__c = 'EBSH - Absa Electronic Banking';
        testCase.Subject = 'Support test ';
        testCase.Origin = 'Email';
        testCase.Status = 'New';
        testCase.Priority = 'High';  
        testcase.Department__c = 'EBSH';
        testCase.Full_Department__c = 'Absa Electronic Banking Helpdesk';
        
        insert testCase;
        
        Group testq = new Group();
        testq.Name = 'testq';
        testq.Type = 'Queue'; 
        insert testq;      
        
        Case_Checklist_Template__c testTemplate = new Case_Checklist_Template__c(Business_Area__c = 'RSCS', Checklist_Name__c = 'test');
        insert testTemplate;
        
        Case_Checklist__c testChecklist = new Case_Checklist__c();
        testChecklist.Case_Checklist_Template__c =testTemplate.id;
        testChecklist.Related_Case__c = testCase.id;
        testChecklist.Submitted_By__c =  UserInfo.getUserId();
        testChecklist.Saved_Results__c = 'test|test';
                
        insert testChecklist;
                
        lscCaseQAExt.getChecklistTemplateRecord();
        lscCaseQAExt.getQAtemplateRecord();
        lscCaseQAExt.getCaseChecklistRecords(testCase.id,testTemplate.id,'');
        
        
        String CaseID =String.valueOf(testCase.id);
        String TemplateID =String.valueOf(testTemplate.id);
        String SavedResults =String.valueOf(testChecklist.id);
        
        lscCaseQAExt.updateCaseChecklistRecord(CaseID, TemplateID, SavedResults, CaseID);
        //lscCaseQAExtFormSelection();
    }
    
    @IsTest
    static void lscCaseQAExt_test_Negitve(){
        
        lscCaseQAExt.getChecklistTemplateRecord();
        lscCaseQAExt.getQAtemplateRecord();
        lscCaseQAExt.getCaseChecklistRecords(null,null,'');
        lscCaseQAExt.updateCaseChecklistRecord(null,null, null, null);
        
    }
    
    @IsTest
    static void lscCaseQAExt_test_Postive(){
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
		insert con;
        Case testCase = new Case();
        //testCase.Queue__c = 'EBSH - Absa Electronic Banking';
        testCase.Subject = 'Support test ';
        testCase.Origin = 'Email';
        testCase.Status = 'New';
        testCase.Priority = 'High';  
        testcase.Department__c = 'EBSH';
        testCase.Full_Department__c = 'Absa Electronic Banking Helpdesk';
        
        insert testCase;
        
        Group testq = new Group();
        testq.Name = 'testq';
        testq.Type = 'Queue'; 
        insert testq;
        
        //Added this
        String question,questionId = '';
                
        Case_Checklist_Template__c testTemplate = new Case_Checklist_Template__c(Business_Area__c = 'RSCS', Checklist_Name__c = 'test');
        insert testTemplate;
        
        Case_Checklist_Question__c testQuestion = new Case_Checklist_Question__c(Checklist_Template__c = testTemplate.id, Heading__c = 'Test', Question__c= 'What is the test?');
        insert testQuestion;
        
        Case_Checklist__c testChecklist = new Case_Checklist__c(Case_Checklist_Template__c =testTemplate.id, Related_Case__c = testCase.id,Submitted_By__c =  UserInfo.getUserId());
        
        insert testChecklist;
                
        lscCaseQAExt.getChecklistTemplateRecord();
        lscCaseQAExt.getQAtemplateRecord();
        lscCaseQAExt.getCaseChecklistRecords(testCase.id,testTemplate.id,'');
        
        String CaseID =String.valueOf(testCase.id);
        String TemplateID =String.valueOf(testTemplate.id);
        String SavedResults =String.valueOf(testChecklist.id);
                
        //Added this
        lscCaseQAExt.FormSelection fs = new lscCaseQAExt.FormSelection(question, questionId, 'Yes');
        
        fs = new lscCaseQAExt.FormSelection(question, questionId, 'No');
        fs = new lscCaseQAExt.FormSelection(question, questionId, 'NA');
              
        lscCaseQAExt.updateCaseChecklistRecord(CaseID, TemplateID, SavedResults, CaseID);        
    }   
}
@isTest
public class LscCaseQaFormControllerTest {
    
  @isTest
    static void LscCaseQaFormController_Postive_test() { 
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
		insert con;
        case testCase = new case();
        
        //testCase.Queue__c = 'EBSH - Absa Electronic Banking';
        testCase.Subject = 'Support test ';
        testCase.Origin = 'Email';
        testCase.Status = 'New';
        testCase.Priority = 'High';  
        testCase.Department__c = 'EBSH';
        testCase.Full_Department__c = 'Absa Electronic Banking Helpdesk';
        
        insert testCase;
        
        Group testq = new Group();
        testq.Name = 'testq';
        testq.Type = 'Queue'; 
        insert testq;
        
        Case_QA_Template__c QATemplate = new Case_QA_Template__c(QA_Name__c ='EBSH', Business_Area__c ='EBSH');
                  
        insert QATemplate;
                
        Case_QA_Question__c CaseQA = new Case_QA_Question__c();
        CaseQA.QA_Template__c = QATemplate.id;
        CaseQA.Heading__c = 'Test';
        CaseQA.Question__c = 'Test';
        CaseQA.Weighting__c = 12;
        insert CaseQA;
        
        Case_QA__c TestQustions = new Case_QA__c();
        TestQustions.Related_Case__c= testCase.id;
        TestQustions.Submitted_By__c = UserInfo.getUserId();
        TestQustions.QA_Template__c = QATemplate.id;
        TestQustions.Saved_Results__c = 'test|test';
        insert TestQustions;
        
        LscCaseQaFormController.updateCaseChecklistRecord(TestQustions) ;
        
        LscCaseQaFormController.updateCaseChecklistRecord(null) ;
        
        system.debug(QATemplate.id+' Test 11111111111111111111111111111111111111111111111111111111111111111111111111111111111');
        
         LscCaseQaFormController.getCaseQaRecords(testCase.id,QATemplate.id,'');
         LscCaseQaFormController.fetchAgentRecords('test', 'Account');
        
        LscCaseQaFormController.FormSelection formS = new LscCaseQaFormController.FormSelection(CaseQA, CaseQA.id, 'No', True);
       
        formS = new LscCaseQaFormController.FormSelection(CaseQA, CaseQA.id, 'NA', True);
    }
}
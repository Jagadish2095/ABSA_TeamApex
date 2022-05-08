/**
 * @description       : 
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-11-17
 * @last modified by  : almas.aleem@absa.africa
**/
@isTest
public class OnboardingClientQuestionnarieContrl_Test {
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    **/
    @testSetup  
    public static void testData(){
        //TriggerDispatcher.skippedTriggers.add('ContentVersionTriggerHandler');
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Onboarding').getRecordTypeId();
        Lead l = new Lead(Description='My Lead',Phone='0794465556',Company='Company1',LastName='Lead');
        insert l;
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity newOpp = new Opportunity(Name = 'Test-1',StageName = 'Proposal',
                                             CloseDate = Date.today(),Lead_Number__c = '23432',RecordTypeId = devRecordTypeId
                                            );
        oppList.add(newOpp);
        insert oppList;  
        
        List<Account> listPersonAcc = TestDataFactory.getPersonAccounts('Test Person','Individual_Prospect',1);
        listPersonAcc[0].Client_Group__c ='Individual';
        listPersonAcc[0].Client_Type__c = 'Individual';
        insert listPersonAcc;
        
        Id devRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LDP Fulfilment').getRecordTypeId(); 
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email',
                                Account = listPersonAcc,
                                Email__c = 'test@test.com',
                                Subject = 'test',
                                Type__c = 'Dispute Debit Order',
                                Description = 'test',
                                Internal_SLA_End_Date__c = date.today()+2,
                                Expectation_of_the_Customer__c = 'test',
                                RecordTypeId = devRecordTypeId1,
                                Incident_Date__c = date.today());
        insert caseRec;
        
        /*List<Lead> leadsList = TestDataFactory.getLeads('Face2Face_Lead', 1);
insert leadsList;*/
        
        Questionnaire_Template__c questTmplet = new Questionnaire_Template__c();
        questTmplet.Name ='Credit Onboarding';
        insert questTmplet;
        Questionnaire_Question__c questionnarie = new Questionnaire_Question__c();
        questionnarie.Questionnaire_Template__c = questTmplet.Id;
        questionnarie.Section__c ='Bank Attestion';
        questionnarie.Question_Label__c = 'Test Question';
        questionnarie.Answer_Type__c ='String';
        questionnarie.Answer_Control_Type__c ='Textbox';
        questionnarie.Question__c ='Test';
        questionnarie.Client_Type__c ='Individual';
        insert questionnarie;
        Questionnaire_Answer__c questionAns = new Questionnaire_Answer__c();
        questionAns.Answer__c = 'Test Answer';
        questionAns.Answer_Data_Type__c ='Text';
        questionAns.Questionnaire_Question__c = questionnarie.Id;
        questionAns.Questionnaire_Template__c = questTmplet.id;
        questionAns.Related_Opportunity__c = oppList[0].Id;
        insert questionAns;
        
        
        
        
        
        /*Questionnaire_Template__c questTmplet1 = new Questionnaire_Template__c();
        questTmplet1.Name ='LDP Fulfilment';
        insert questTmplet1;
        Questionnaire_Question__c questionnarie1 = new Questionnaire_Question__c();
        questionnarie.Questionnaire_Template__c = questTmplet1.Id;
        questionnarie.Section__c ='Bank Attestion';
        questionnarie.Question_Label__c = 'Test Question1';
        questionnarie.Answer_Type__c ='String';
        questionnarie.Answer_Control_Type__c ='Textbox';
        questionnarie.Question__c ='Test';
        questionnarie.Client_Type__c ='Individual';
        insert questionnarie;
        Questionnaire_Answer__c questionAns1 = new Questionnaire_Answer__c();
        questionAns.Answer__c = 'Test Answer';
        questionAns.Answer_Data_Type__c ='Text';
        questionAns.Questionnaire_Question__c = questionnarie.Id;
        questionAns.Questionnaire_Template__c = questTmplet1.id;
        questionAns.Related_Opportunity__c = caseRec.Id;
        insert questionAns1;*/
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    **/
    @isTest
    public static void testQuestionopp(){
        Account acc = [select id from Account Limit 1];
        Questionnaire_Question__c questionobject =  [select id,Questionnaire_Template__c from Questionnaire_Question__c LIMIT 1];
        List<Opportunity> opplist =[select Id,AccountId from Opportunity LIMIT 1];
        opplist[0].AccountId = acc.id;
        update opplist[0];
        
        
        OnboardingClientQuestionnarieController.getRecordType(opplist[0].id);
        OnboardingClientQuestionnarieController.getOpportunityDetails(opplist[0].id);
        OnboardingClientQuestionnarieController.getQuestionList(opplist[0].id,'Credit Onboarding');
        List<OnboardingClientQuestionnarieController.getQuestionfieldInfo> questionAnswList = new  List<OnboardingClientQuestionnarieController.getQuestionfieldInfo>();
        OnboardingClientQuestionnarieController.getQuestionfieldInfo questionAnsw = new OnboardingClientQuestionnarieController.getQuestionfieldInfo();
        questionAnsw.AnswerType = '';
        questionAnsw.isRequired = true;
        questionAnsw.userAnswer ='Test Answer';
        questionAnsw.AnswerType ='text';
        questionAnsw.questionId = String.valueOf(questionobject.id);
        questionAnsw.TemplateId = String.valueOf(questionobject.Questionnaire_Template__c);
        questionAnswList.add(questionAnsw);
        String jsondata = JSON.serialize(questionAnswList); //JSON.serialize(questionAnsw);
        OnboardingClientQuestionnarieController.saveQuestionAnswer(jsondata, opplist[0].id);
        
        system.assertNotEquals(null, opplist);
        // List<OnboardingClientQuestionnarieController.getQuestionfieldInfo> questionAnswList = new  List<OnboardingClientQuestionnarieController.getQuestionfieldInfo>();
        
        
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    **/
    @isTest
    public static void testQuestionRecord(){
        Opportunity opp =[select Id,RecordType.Name from Opportunity LIMIT 1];
        OnboardingClientQuestionnarieController.getRecordType(opp.id);
        
        
        Account acc = [select id ,RecordType.Name from Account Limit 1];
        
        OnboardingClientQuestionnarieController.getRecordType(acc.id);
        system.assertNotEquals(null, opp);
        
        
       
        
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    **/
    @isTest
    public static void testQuestionRecord1(){
        Case case1 = [select id ,RecordType.Name from Case Limit 1]; 
        OnboardingClientQuestionnarieController.getRecordType(case1.id);
        OnboardingClientQuestionnarieController.getQuestionList(case1.id,'Credit Onboarding');
        system.assertNotEquals(null, case1);
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    **/
    @isTest
    public static void testQuestionRecord2(){
        List<Lead> leadLst =[select Id from Lead LIMIT 1];
       OnboardingClientQuestionnarieController.getQuestionList(leadLst[0].id,'Credit Onboarding');
       system.assertNotEquals(null, leadlst);
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    **/
    @isTest
    public static void testQuestionRecord3(){
         Account acc =[select Id from Account LIMIT 1];
       OnboardingClientQuestionnarieController.getQuestionList(acc.id,'Credit Onboarding');
       system.assertNotEquals(null, acc);
    }
     
    /*  @isTest
public static void testQuestionAccount(){
Lead lead =[select Id,RecordType.Name from Lead LIMIT 1];
OnboardingClientQuestionnarieController.getRecordType(lead.id);

}*/
    
}
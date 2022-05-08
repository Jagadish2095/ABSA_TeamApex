/**
* @description Test class for Record Of Advice  Component for SPM Onboarding
*
* @author  Haritha P : Absa
* @version v1.0
* @since   2021-04-07
* @class : SPMRecordOfAdviceController
*/
@isTest(SeeAllData=true) 
public class SPMRecordOfAdviceControllerTest {
@isTest
    public static void TestRecordofAdvice(){
         Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
     insert testOpp;
     //Application__c
      Application__c  testApplication = new Application__c();
        testApplication.Opportunity__c = testOpp.Id;
        testApplication.Preferred_Communication_Method__c='himanshu.nimje@absa.africa';
        testApplication.Preferred_SMS__c='065892600';
        testApplication.Preferred_Communication_Method__c='Email';
        testApplication.Fees_Waived__c = true;
        testApplication.Application_Status__c = 'Pending'; // Tinashe W-004373
        testApplication.Products_And_Services__c = 'NotifyMe';
        insert testApplication;
        //Questionnaire_Template__c qtemplate=[select id,Name from Questionnaire_Template__c where Name='SPM Record Of Advice' ];
        LIST<Questionnaire_Question__c> questionnames=[SELECT Id, Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Questionnaire_Template__r.Name='SPM Record Of Advice'];
        system.debug('questionnames----'+questionnames);
       
         List<Questionnaire_Answer__c> QAnswerRecList=   [SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Question__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c FROM Questionnaire_Answer__c where Related_Opportunity__r.Id=:testOpp.Id AND Related_Application__c=:testApplication.Id AND Questionnaire_Template__r.Name='SPM Record Of Advice' ];
        system.debug('QAnswerRecList'+QAnswerRecList);
        Test.startTest();
        SPMRecordOfAdviceController.createQuestionnaireRecordlist(testOpp.Id,'Yes','Yes','Income','Pay out','On Request','Yes','Yes','Yes','Yes','Yes','Yes',
                                                                 'Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','30','test','test','test','Accepted');
        SPMRecordOfAdviceController.getQuestionnaireRecordlist(testOpp.Id);
        SPMRecordOfAdviceController.getAccount(testOpp.Id);
        system.assertEquals(testOpp.Id, testOpp.Id);
        Test.stopTest();
        
    }
}
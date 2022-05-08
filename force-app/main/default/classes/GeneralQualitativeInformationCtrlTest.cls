/**
 * @description       : Test Class for GeneralQualitativeInformationController
 * @author            : englarmerdge.mongwe@absa.africa
 * @last modified on  : 2021-07-12
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2020-07-31   englarmerdge.mongwe@absa.africa   Initial Version
**/
@IsTest
public class GeneralQualitativeInformationCtrlTest {
    /**
     * @description test setup method
     * @author englarmerdge.mongwe@absa.africa | 2020-07-31
    **/
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    @IsTest
 	public static void testGetQuestionsAndAnswers() {

        Test.startTest();

        Opportunity opportnity = [SELECT Id, Name FROM Opportunity WHERE Name = 'Cheque Credit Onboarding' LIMIT 1];
        List<Map<String,Object>> qAndAList = GeneralQualitativeInformationController.getQuestionsAndAnswers(opportnity.Id, 'General Qualitative Information');

        System.assert((qAndAList != null));

        Test.stopTest();
    }

    @IsTest
 	public static void testSaveGeneralQualitativeInformation() {

        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Cheque Credit Onboarding' LIMIT 1];
        Application__c app = [SELECT Id, Name FROM Application__c WHERE SurnameSignature__c = 'Rob Van Wyk' LIMIT 1];
        Questionnaire_Template__c qTemp = [SELECT Id, Name FROM Questionnaire_Template__c LIMIT 1];
        Questionnaire_Question__c qQues = [SELECT Id, Name, Questionnaire_Template__c FROM Questionnaire_Question__c LIMIT 1];

        Questionnaire_Answer__c qAnsw = new Questionnaire_Answer__c();
        qAnsw.Answer__c = 'Ola, how you doing?';
        qAnsw.Answer_Data_Type__c = 'String';
        qAnsw.Comment__c = 'Mxm, you do me like that huh?';
        qAnsw.Questionnaire_Question__c = qQues.Id;
        qAnsw.Questionnaire_Template__c = qQues.Questionnaire_Template__c;
        qAnsw.Related_Application__c = app.Id;
        qAnsw.Related_Opportunity__c = opp.id;
        insert qAnsw;

        Test.startTest();

        String qqQAndAObj = '[{"Id":"' + qQues.Id + '","TemplateId":"' + qTemp.Id + '","Question":"Number Of Employees","QuestionLabel":"Number Of Employees","IncludeComment":true,"Section":"Info about General Qualitative Information","AnswerType":"Integer","AnswerControlType":"Textbox","Answer":"12345","Comment": "meow"}]';
        String result = GeneralQualitativeInformationController.saveGeneralQualitativeInformation(opp.Id, qqQAndAObj);
        GeneralQualitativeInformationController.getQuestionsAndAnswers(opp.Id, 'General Qualitative Information');
        System.assert(result.contains('Successfully'));

        Test.stopTest();
    }

    @IsTest
    public static void testSaveGeneralQualitativeInformationNoAnswer() {

        Opportunity opportnity = [SELECT Id, Name FROM Opportunity WHERE Name = 'Cheque Credit Onboarding' LIMIT 1];
        Questionnaire_Template__c qTemp = [SELECT Id, Name FROM Questionnaire_Template__c LIMIT 1];
        Questionnaire_Question__c qQues = [SELECT Id, Name FROM Questionnaire_Question__c LIMIT 1];

        Test.startTest();

        String qqQAndAObj = '[{"Id":"' + qQues.Id + '","TemplateId":"' + qTemp.Id + '","Question":"Number Of Employees","QuestionLabel":"Number Of Employees","IncludeComment":true,"Section":"Info about General Qualitative Information","AnswerType":"Integer","AnswerControlType":"Textbox","Answer":"12345","Comment": "meow"}]';
        String result = GeneralQualitativeInformationController.saveGeneralQualitativeInformation(opportnity.Id, qqQAndAObj);
        System.assert(result.contains('Successfully'));

        Test.stopTest();
    }
}
/**
 * Test Class for the Selector layer for Questionnaire_Answer__c objects
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-11-24
 **/
@IsTest
public class QuestionnaireAnswerSelectorTest {

    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    static testMethod void testGetSObjectType() {
        System.assert(new QuestionnaireAnswerSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {
        System.assert(new QuestionnaireAnswerSelector().getSObjectFieldList() != null);
    }

    static testMethod void testSelectByApplicationId() {
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

        Set<Id> tstSet = new Set<Id>();
        tstSet.add(qAnsw.Id);

        System.assert(new QuestionnaireAnswerSelector().selectById(tstSet) != null);
        System.assert(new QuestionnaireAnswerSelector().selectByApplicationId(app.Id) != null);
    }
}
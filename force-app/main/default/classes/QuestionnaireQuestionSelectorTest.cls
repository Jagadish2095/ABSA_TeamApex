/**
 * Test Class for the Selector layer for Questionnaire_Question__c objects
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-11-24
 **/
@IsTest
public class QuestionnaireQuestionSelectorTest {

    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    static testMethod void testGetSObjectType() {
        System.assert(new QuestionnaireQuestionSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {
        System.assert(new QuestionnaireQuestionSelector().getSObjectFieldList() != null);
    }

    static testMethod void testSelectByApplicationId() {
        Questionnaire_Template__c qTemp = [SELECT Id, Name From Questionnaire_Template__c LIMIT 1];
        Questionnaire_Question__c qQues = [SELECT Id, Name From Questionnaire_Question__c LIMIT 1];

        Set<Id> tstSet = new Set<Id>();
        tstSet.add(qQues.Id);

        System.assert(new QuestionnaireQuestionSelector().selectById(tstSet) != null);
        System.assert(new QuestionnaireQuestionSelector().selectByTemplateId(qTemp.Id) != null);
    }
}
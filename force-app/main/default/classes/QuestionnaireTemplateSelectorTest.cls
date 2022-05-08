/**
 * Test Class for the Selector layer for Questionnaire_Template__c objects
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-11-24
 **/
@IsTest
public class QuestionnaireTemplateSelectorTest {

    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    static testMethod void testGetSObjectType() {
        System.assert(new QuestionnaireTemplateSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {
        System.assert(new QuestionnaireTemplateSelector().getSObjectFieldList() != null);
    }

    static testMethod void testSelectByApplicationId() {
        Questionnaire_Template__c qQues = [SELECT Id, Name From Questionnaire_Template__c LIMIT 1];

        Set<Id> tstSet = new Set<Id>();
        tstSet.add(qQues.Id);

        System.assert(new QuestionnaireTemplateSelector().selectById(tstSet) != null);
        System.assert(new QuestionnaireTemplateSelector().selectByName('General Qualitative Information') != null);
    }
}
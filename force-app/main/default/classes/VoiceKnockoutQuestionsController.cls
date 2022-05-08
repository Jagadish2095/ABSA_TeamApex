/**
 * @description       : Voice Knockout questions that read from the Questionnaire Questions & not Knockout Questions. W-015253
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2022-02-16
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
public class VoiceKnockoutQuestionsController {


    /**
    * @description Get KO questions
    * @author Lehlohonolo.Matsoso@absa.africa | 2022-02-10 
    * @param templateName 
    * @return string 
    **/
	@AuraEnabled
    public static string fetchKnockoutQuestions(string templateName) {
        string result = '<ul>';
        QuestionnaireQuestionSelector selector = new QuestionnaireQuestionSelector();
        List<Questionnaire_Question__c> questions = selector.selectByTemplateName(templateName);

        for (Questionnaire_Question__c q: questions) {
            result = result + '<li>' + q.Question_Label__c + '</li>';
        }
        result = result + '</ul>';

        return result;
    }

    /**
    * @description Submits KO answers to Questionnaire Answers
    * @author Lehlohonolo.Matsoso@absa.africa | 2022-02-11 
    * @param templateName 
    * @param opportunityId 
    * @param hasClientAgreed 
    **/
    @AuraEnabled
    public static void submitKnockoutQuestions(string templateName, String opportunityId, Boolean hasClientAgreed) {
        QuestionnaireQuestionSelector selector = new QuestionnaireQuestionSelector();
        List<Questionnaire_Question__c> questions = selector.selectByTemplateName(templateName);
        List<Questionnaire_Answer__c>  answers = new List<Questionnaire_Answer__c>();
        Questionnaire_Answer__c  answer;
        for(Questionnaire_Question__c q:questions){
            answer = new Questionnaire_Answer__c();
            answer.Answer_Data_Type__c = 'String';
            answer.Answer__c = String.valueOf(hasClientAgreed);
            answer.Related_Opportunity__c = opportunityId;
            answer.Questionnaire_Question__c = q.Id;
            answer.Questionnaire_Template__c = q.Questionnaire_Template__c;
            answers.add(answer);
        }

        insert answers;

    }
}
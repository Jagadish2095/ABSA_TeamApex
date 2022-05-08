/**
 * Selector Class for QuestionnaireQuestion Object
 * @author  Englarmerdge Mongwe
 * @since   2020-10-16
**/
public class QuestionnaireQuestionSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Questionnaire_Question__c.sObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet> {
            SObjectType.Questionnaire_Question__c.FieldSets.Questionnaire_Question_Compact_View
        };
    }

    public List<Questionnaire_Question__c> selectById(Set<ID> idSet) {
        return (List<Questionnaire_Question__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy() {
        return 'CreatedDate ASC';
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Questionnaire_Question__c.Id,
            Questionnaire_Question__c.Question__c,
            Questionnaire_Question__c.Question_Label__c,
            Questionnaire_Question__c.Include_Comment__c,
            Questionnaire_Question__c.Section__c,
            Questionnaire_Question__c.Default_Answer__c,
            Questionnaire_Question__c.Answer_Options__c,
            Questionnaire_Question__c.Answer_Type__c,
            Questionnaire_Question__c.Answer_Control_Type__c,
            Questionnaire_Question__c.Questionnaire_Template__c
        };
    }

    /**
     * Return Questionnaire Question by template Id
     *
     * @param String TemplateID from Questionnaire Template
     * @return List<Questionnaire_Question__c>
    **/
    public List<Questionnaire_Question__c> selectByTemplateId(String templateId) {
        return (List<Questionnaire_Question__c>) Database.query(
            newQueryFactory().
            setCondition('Questionnaire_Template__c =:templateId').
            toSOQL()
        );
    }

    /**
     * Return Questionnaire Question by template name
     *
     * @param String Template Name from Questionnaire Template
     * @return List<Questionnaire_Question__c>
    **/
    public List<Questionnaire_Question__c> selectByTemplateName(String templateName) {
        QuestionnaireTemplateSelector selector = new QuestionnaireTemplateSelector();
        Questionnaire_Template__c template = selector.selectByName(templateName);
        return this.selectByTemplateId(template.Id);
    }
}
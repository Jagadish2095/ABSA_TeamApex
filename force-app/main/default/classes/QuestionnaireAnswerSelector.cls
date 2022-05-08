/**
 * Selector Class for QuestionnaireAnswer Object
 * @author  Englarmerdge Mongwe
 * @since   2020-10-16
**/
public class QuestionnaireAnswerSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Questionnaire_Answer__c.sObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet> {
            SObjectType.Questionnaire_Answer__c.FieldSets.Questionnaire_Answer_Compact_View
        };
    }

    public List<Questionnaire_Answer__c> selectById(Set<ID> idSet) {
        return (List<Questionnaire_Answer__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy() {
        return 'CreatedDate ASC';
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Questionnaire_Answer__c.Id,
            Questionnaire_Answer__c.Answer__c,
            Questionnaire_Answer__c.Answer_Data_Type__c,
            Questionnaire_Answer__c.Name,
            Questionnaire_Answer__c.Comment__c,
            Questionnaire_Answer__c.Question__c,
            Questionnaire_Answer__c.Questionnaire_Question__c,
            Questionnaire_Answer__c.Questionnaire_Template__c,
            Questionnaire_Answer__c.Related_Application__c,
            Questionnaire_Answer__c.Related_Opportunity__c
        };
    }

    /**
     * Return Questionnaire Answers by ApplicationId
     *
     * @param String appId from Application
     * @return List<Questionnaire_Answer__c>
    **/
    public List<Questionnaire_Answer__c> selectByApplicationId(String appId) {
        return (List<Questionnaire_Answer__c>) Database.query(
            newQueryFactory().
            selectField('Questionnaire_Question__r.Question__c').
            setCondition('Related_Application__c = :appId').
            toSOQL()
        );
    }
}
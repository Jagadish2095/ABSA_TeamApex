/**
* Selector Class for QuestionnaireTemplate Object
* @author  Englarmerdge Mongwe
* @since   2020-10-16
**/
public class QuestionnaireTemplateSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Questionnaire_Template__c.sObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet> { 
            //SObjectType.Questionnaire_Template__c.FieldSets.Application_Financial_Info_Compact_View 
        };
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Questionnaire_Template__c.Id,
            Questionnaire_Template__c.Name
        };
    }

    public List<Questionnaire_Template__c> selectById(Set<ID> idSet) {
        return (List<Questionnaire_Template__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy() {
        return 'CreatedDate ASC';
    }

    /**
     * Return Questionnaire Template by template name
     *
     * @param String templateName
     * @return Questionnaire_Template__c
    **/
    public Questionnaire_Template__c selectByName(String templateName) {
        return (Questionnaire_Template__c) Database.query(
            newQueryFactory().
            setCondition('Name = :templateName').
            toSOQL()
        );
    }
}
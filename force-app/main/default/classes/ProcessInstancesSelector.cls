/**
* Apex Enterprise Design Patterns
* Selector Layer for ProcessInstance object
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2019-01-18
*/
public without sharing class ProcessInstancesSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return ProcessInstance.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ProcessInstance.Id,
            ProcessInstance.TargetObjectId,
            ProcessInstance.Status
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    //get records by id's
    public List<ProcessInstance> selectById(Set<Id> idSet) {
        return (List<ProcessInstance>) selectSObjectsById(idSet);
    }

    //INHERIT FROM BASE CLASS - END

    //CUSTOM SELECTORS - START

    /*
* Return ProcessInstanceSteps by ProcessInstance
* WITH related active ProcessInstanceSteps
* Custom selector USING the Base class queryFactory
*
* @param ProcessInstanceId Set
* @return List<Case>
*/
    public List<ProcessInstance> selectByIdWithProcessInstanceSteps(Set<Id> processInstanceIds) {

        fflib_QueryFactory query = newQueryFactory(false).
            selectField('Id').
            selectField('TargetObjectId').
            setCondition('Id IN :processInstanceIds').
            addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true);

        //new ProcessInstanceStepsSelector().addQueryFactorySubselect(query,'Steps');

        fflib_QueryFactory oliQueryFactory = query.subselectQuery('Steps')
            .selectFields(new ProcessInstanceStepsSelector().getSobjectFieldList())
            .addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true)
            .setLimit(1);

        return (List<ProcessInstance>) Database.query(query.toSOQL() );

    }

    // PJAIN: 20200710: W-005081
    public List<ProcessInstance> selectByObjectIdAndProcessNames(Set<Id> objectIds, List<String> processNames) {

        // PJAIN: 20200801: Commenting out the below code and replacing it with SOQL query.
        // Had to do this because for some reason the addOrdering is not working.
        /* return Database.query(
            newQueryFactory().
            selectField('ProcessDefinition.Name').
            selectField('ProcessDefinition.DeveloperName').
            setCondition('TargetObjectId IN :objectIds AND ProcessDefinition.DeveloperName IN :processNames').
            addOrdering(ProcessInstance.LastModifiedDate, fflib_QueryFactory.SortOrder.DESCENDING).
            toSOQL()
        ); */

        return [SELECT Id, ProcessDefinition.DeveloperName, ProcessDefinition.Name, Status FROM ProcessInstance WHERE TargetObjectId IN :objectIds AND ProcessDefinition.DeveloperName IN :processNames ORDER BY LastModifiedDate DESC];
    }

    //CUSTOM SELECTORS - END
}
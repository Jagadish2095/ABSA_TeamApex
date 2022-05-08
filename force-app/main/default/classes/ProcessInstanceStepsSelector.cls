/**
* Apex Enterprise Design Patterns
* Selector Layer for ProcessInstanceStep object
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2019-01-18
*/
public class ProcessInstanceStepsSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return ProcessInstanceStep.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ProcessInstanceStep.Id,
                ProcessInstanceStep.ProcessInstanceId,
                ProcessInstanceStep.StepStatus,
                ProcessInstanceStep.Comments
                };
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<ProcessInstanceStep> selectById(Set<Id> idSet) {
        return (List<ProcessInstanceStep>) selectSObjectsById(idSet);
    }
    
    //INHERIT FROM BASE CLASS - END
    
    //CUSTOM SELECTORS - START
    
    //CUSTOM SELECTORS - END
}
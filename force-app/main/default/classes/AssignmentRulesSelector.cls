/**
* Apex Enterprise Design Patterns
* Selector Layer for Financial Product objects
*
* @author  Tracy de Bruin
* @since   2019-04-12
*/
public class AssignmentRulesSelector extends fflib_SObjectSelector {
    
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){  
        return Schema.AssignmentRule.getSObjectType();
    }

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                AssignmentRule.Id,
                AssignmentRule.SobjectType,
                AssignmentRule.Active
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get cases by id's
    public List<AssignmentRule> selectById(Set<Id> idSet) {
        return (List<AssignmentRule>) selectSObjectsById(idSet);
    }
	//Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name';
    }
    //CUSTOM SELECTORS - START
    
    /*
    * Return active AssignmentRules
    * Custom selector USING the 
    * Base class queryFactory
    * 
    * @param recordLimit Integer max records to return
    * @return List<AssignmentRule>
    */
    public List<AssignmentRule> selectByActiveSoBjectType(String sObjectTypeName, Integer recordLimit) { 
        
        return (List<AssignmentRule>) Database.query(
            newQueryFactory().   
            setCondition('Active = true'). 
            setCondition('SobjectType = :sObjectTypeName'). 
            setLimit(recordLimit).
            toSOQL()
        );
    } 

    //CUSTOM SELECTORS - END
}
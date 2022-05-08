/**
* Apex Enterprise Design Patterns
* Selector Layer for ActionPlanTemplateItemVersion objects
*
* @author  Ephetehe - Tetrad
* @since   2019-07-16
*/
public class ActionPlanTemplateVersionSelector extends fflib_SObjectSelector {
	
    //MANDATORY ABSTRACT METHODS - START
    
    public Schema.SObjectType getSObjectType(){
        return ActionPlanTemplateVersion.sObjectType;
    } 
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ActionPlanTemplateVersion.Id,
            ActionPlanTemplateVersion.Name,
            ActionPlanTemplateVersion.ActionPlanTemplateId
        };
    }
    
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    
    //get ActionPlanTemplateVersion by id's 
    public List<ActionPlanTemplateVersion> selectById(Set<Id> idSet) {
        return (List<ActionPlanTemplateVersion>) selectSObjectsById(idSet);
    }
    
    //INHERIT FROM BASE CLASS - END
    
    //CUSTOM SELECTORS - START
    
    /*EM - Tetrad IT
    * Return Id for set of Ids
    * 
    * @param idSet Set<Id>
    * @return List<ActionPlanTemplateVersion>
    */
    public List<ActionPlanTemplateVersion> selectByActionPlanTemplateId(Set<Id> idSet) { 
        return [SELECT ID,Name FROM ACTIONPLANTEMPLATEVERSION WHERE ActionPlanTemplateId In: idSet];
    }
    
    
    /*EM - Tetrad IT
    * Return Id for set of Ids - Not using conventional method with newQueryFactory() because it kept returning a permissions error
    * 
    * @param idSet Set<Id>
    * @return List<ActionPlanTemplateVersion>
    */
    public List<ActionPlanTemplateVersion> selectByActionPlanTemplateName(String actionPlanTemplateVersionName) { 
        return [SELECT ID,Name FROM ACTIONPLANTEMPLATEVERSION WHERE Name =: actionPlanTemplateVersionName AND Status = 'Final' LIMIT 1];
    }
    
        /**
     * Method that gets a List of ActionPlanTemplateVersion based on Template Name
     *
     * @return List<ActionPlanTemplateVersion> 
     */
    public List<ActionPlanTemplateVersion> selectByTemplateName(Set<String> actionPlanNames) {
        /*return Database.query(
                newQueryFactory().
                        setCondition('Name IN :actionPlanNames AND ' + 
                                    'Status = Final').
                        toSOQL()
        );*/
        
        return [SELECT ID,Name, ActionPlanTemplateId FROM ACTIONPLANTEMPLATEVERSION WHERE Name IN : actionPlanNames AND Status = 'Final'];

    }
    //CUSTOM SELECTORS - END
}
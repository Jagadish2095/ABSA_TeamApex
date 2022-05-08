/**
* Apex Enterprise Design Patterns
* @description Selector Layer for PermissionSetAssignment
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2019-03-18
*/
public class PermissionSetAssignmentsSelector extends fflib_SObjectSelector {
    
     //MANDATORY ABSTRACT METHODS - START
     /**
      * @description getSObjectFieldList description
      *
      * @return Return List<Schema.SObjectField>: Return description
      */
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            PermissionSetAssignment.PermissionSetId,
                PermissionSetAssignment.Id,
                PermissionSetAssignment.AssigneeId

        };
    }
    /**
     * @description getSObjectType description
     *
     * @return Return Schema.SObjectType: Return description
     */
    public Schema.SObjectType getSObjectType() {
        return PermissionSetAssignment.sObjectType;
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    /**
     * @description selectById description
     *
     * @param idSet (Set<Id>): idSet
     * @return Return List<PermissionSetAssignment>: Return description
     */
    public List<PermissionSetAssignment > selectById( Set<Id> idSet ) {
        return (List<PermissionSetAssignment >) selectSObjectsById(idSet);
    }
    //Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'permissionSet.name';
    }
    //INHERIT FROM BASE CLASS - STOP
    //CUSTOM SELECTORS - START
    
   /**
    * @description selectByNameAndUserId description
    *
    * @param permissionSetName (String): permissionSetName
    * @param userId (Id): userId
    * @return Return List<PermissionSetAssignment>: Return description
    */
   public List<PermissionSetAssignment> selectByNameAndUserId(String permissionSetName, Id userId)
   {
       return selectByNameAndUserId(new Set<String> {permissionSetName}, userId);
   }
    
  /**
   * @description selectByNameAndUserId description
   *
   * @param permissionSetNames (Set<String>): permissionSetNames
   * @param userId (Id): userId
   * @return Return List<PermissionSetAssignment>: Return description
   */
   public List<PermissionSetAssignment> selectByNameAndUserId(Set<String> permissionSetNames, Id userId)
   {
		 return Database.query(
      		newQueryFactory(true).
            selectField('PermissionSet.Name').
            selectField('PermissionSetId').
            setCondition('PermissionSet.Name IN :permissionSetNames AND AssigneeId = :userId').
            toSOQL()
   		);
   }
   /**
    * @description selectByUserId description
    *
    * @param userId (Id): userId
    * @return Return List<PermissionSetAssignment>: Return description
    */
   public List<PermissionSetAssignment> selectByUserId(Id userId)
   {
		 return Database.query(
      		newQueryFactory(true).
            selectField('PermissionSet.Name').
            selectField('Id').
            selectField('AssigneeId').
            selectField('Assignee.Name').
            selectField('PermissionSetId').
            setCondition('AssigneeId = :userId').
            toSOQL()
   		);
   }
      
            
   //CUSTOM SELECTORS - END
}
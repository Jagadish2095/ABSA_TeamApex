/**
* @description Apex Enterprise Design Patterns
* Selector Layer for BusinessHours objects
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2018-10-17
*/
public class BusinessHoursSelector extends fflib_SObjectSelector {
    
     //MANDATORY ABSTRACT METHODS - START

    /**
    * @description 
    * @author 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            BusinessHours.Id,
            BusinessHours.IsDefault
        };
    }
    /**
    * @description 
    * @author 
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType() {
        return BusinessHours.sObjectType;
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START

    /**
    * @description 
    * @author 
    * @param idSet 
    * @return List<BusinessHours> 
    **/
    public List<BusinessHours> selectById( Set<Id> idSet ) {
        return (List<BusinessHours>) selectSObjectsById(idSet);
    }
    //Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name';
    }
    //INHERIT FROM BASE CLASS - STOP
    //CUSTOM SELECTORS - START
      
     /**
    * @description Return Default BusinessHours 
    * 
    * 
    * @return List<BusinessHours>
    */
   public List<BusinessHours> selectDefault() { 
       
       return Database.query(
      		newQueryFactory(true).
            setCondition('IsDefault = true').
            setLimit(1).
            toSOQL()
   		);
   }
     /**
    *@description Return BusinessHours for sanctioning 
    * 
    * @param 
    * @return List<BusinessHours>
*/ 
    
   public List<BusinessHours> selectSanctioningBusinessHours() { 
       
       return Database.query(
      		newQueryFactory(true).
            setCondition('name =\'Monday to Friday (8h00 - 16h30) excluding public holidays\'').
            setLimit(1).
            toSOQL()
   		);
   }

   /**
   * @description 
   * @author m
   * @param name 
   * @param recordLimit 
   * @return List<BusinessHours> 
   **/
   public List<BusinessHours> selectByIdName(String name, Integer recordLimit) {
    return Database.query(
        newQueryFactory(false).
        selectField('Id').
        selectField('Name').
        setCondition('Name = :name').
        setLimit(recordLimit).
        toSOQL()

    );
}
   //CUSTOM SELECTORS - END
}
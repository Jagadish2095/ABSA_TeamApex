/**
* Apex Enterprise Design Patterns
* Selector Layer for Site__c objects
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2018-09-26
*/
public class SitesSelector extends fflib_SObjectSelector {
	
   //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType() {
      return Site__c.sObjectType;
   }
 
   public List<Schema.SObjectField> getSObjectFieldList() {
       
      return new List<Schema.SObjectField> {
                Site__c.Id,
                Site__c.Name,
                Site__c.Service_Group__c
                    
      };
   }
   //MANDATORY ABSTRACT METHODS - END
   
   //INHERIT FROM BASE CLASS - START
   //get Site__c by id's 
   public List<Site__c> selectById(Set<Id> idSet) {
        return (List<Site__c>) selectSObjectsById(idSet);
   }
   //INHERIT FROM BASE CLASS - END
   
    /**
     * Returns a single site based on a given Opportunity site field
     *
     * @param   siteId   The site Id
     *
     * @return  site     The site object record
     */
    public Site__c selectById(Id siteId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Unique_Site_Code__c').
            selectField('Site_Code__c').
            selectField('Zone__c').
            setCondition('Id = :siteId').
            toSOQL()
        );
    }
    
      /*
    * Return Site__c by Service Group
    * 
    * @param ServiceGroupId Id
    * @return List<Site__c> 
    */
   public List<Site__c> selectByServiceGroup(Set<Id> serviceGroupId) {

        return Database.query(
      		newQueryFactory(true).
            setCondition('Service_Group__c IN :serviceGroupId').
            toSOQL()
   		);
   }
	 /*
    * Return Site__c by Site Code
    * 
    * @param siteCode
    * @return List<Site__c> 
    * @author:Haritha
    */
    
     public List<Site__c> selectBySiteCode(string siteCode) {
         String branch = 'Branch Site';
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Unique_Site_Code__c').
            selectField('Site_Code__c').
            selectField('Zone__c').
            selectField('Street__c').
            selectField('Suburb__c').
            selectField('Postal_Code__c').
            selectField('City__c').
            selectField('State_Province__c').
            selectField('Country__c').
            selectField('Region__c'). // Added by Bhanumurty for refunds
            setCondition('Site_Code__c = :siteCode AND RecordType.Name = :branch').
            toSOQL()
        );
    }

    	 /*
    * Return Site__c by Zone
    * Refunds Process
    * @param Zone__c
    * @return List<Site__c> 
    * @author:Tinashe Shoko
    */
     public List<Site__c> selectByZone(string zone) {
         String branch = 'Branch Site';
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Unique_Site_Code__c').
            selectField('Site_Code__c').
            selectField('Zone__c').
            selectField('Region__c'). // Added by Bhanumurty for refunds
            setCondition('Zone__c = :zone AND RecordType.Name = :branch').
            toSOQL()
        );
    }
    
     /*
    * Return Site__c by Site Code
    * 
    * @param siteCode
    * @return List<Site__c> 
    * @author:Bhanumurty 
    */
    
     public List<Site__c> selectBySiteCodeRefund(string siteCode) {
         String branch = 'Branch Site';
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Unique_Site_Code__c').
            selectField('Site_Code__c').
            selectField('Zone__c').
            selectField('Street__c').
            selectField('Suburb__c').
            selectField('Postal_Code__c').
            selectField('City__c').
            selectField('State_Province__c').
            selectField('Country__c').
            selectField('Region__c'). // Added by Bhanumurty for refunds
            setCondition('Site_Code__c = :siteCode AND RecordType.Name = :branch AND Zone__c != NULL'  ).
            toSOQL()
        );
    }
    
    /*
     * 
     * 
	*/
}
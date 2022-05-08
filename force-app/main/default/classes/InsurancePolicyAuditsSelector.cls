/**
* Apex Enterprise Design Patterns
* Selector Layer for Insurance_Policy_Audit__c objects
*
* @author  Koketso Mpshane
* @since   2021-02-01
*/
public class InsurancePolicyAuditsSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType() {
      return Insurance_Policy_Audit__c.sObjectType;
   }
 
   public List<Schema.SObjectField> getSObjectFieldList() {
       
       return new List<Schema.SObjectField> {
               Insurance_Policy_Audit__c.Id,
               Insurance_Policy_Audit__c.Name,
               Insurance_Policy_Audit__c.Insurance_Policy_Number__c,
               Insurance_Policy_Audit__c.Product_Code__c,
               Insurance_Policy_Audit__c.Effective_From_Date__c,
               Insurance_Policy_Audit__c.Effective_To_Date__c,
               Insurance_Policy_Audit__c.Status__c,
               Insurance_Policy_Audit__c.Policy_Action__c,
               Insurance_Policy_Audit__c.Action__c,
               Insurance_Policy_Audit__c.Log_Date__c
       };
   }
    
   //MANDATORY ABSTRACT METHODS - END
   
   //INHERIT FROM BASE CLASS - START
   //get Insurance_Policy_Audit__c by id's 
   public List<Insurance_Policy_Audit__c> selectById(Set<Id> idSet) {
        return (List<Insurance_Policy_Audit__c>) selectSObjectsById(idSet);
   }
    
   /* Return All Insurance Policy Audits linked to an Insurance Policy by Insurance Policy ID
	* @param String insurancePolicyId
	* @return List<Insurance_Policy_Audit__c>
	*/
    public List<Insurance_Policy_Audit__c> selectByInsurancePolicyId(String insurancePolicyId) {
        return (List<Insurance_Policy_Audit__c>) Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Name')
            .selectField('Insurance_Policy_Number__c')
            .selectField('Product_Code__c')
            .selectField('Effective_From_Date__c')
            .selectField('Effective_To_Date__c')
            .selectField('Status__c')
            .selectField('Policy_Action__c')
            .selectField('Action__c')
            .selectField('Log_Date__c')
            .selectField('CreatedDate')
            .setCondition('Insurance_Policy__c =:InsurancePolicyId')
            .toSOQL()
        );
    } 
    
}
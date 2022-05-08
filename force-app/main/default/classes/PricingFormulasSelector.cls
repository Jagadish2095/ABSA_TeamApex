/**
* Apex Enterprise Design Patterns
* Selector Layer for Pricing_Formula__c objects
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2020-04-20
*/
public class PricingFormulasSelector extends fflib_SObjectSelector {
	 //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType(){
      return Pricing_Formula__c.sObjectType;
   }
 
   public List<Schema.SObjectField> getSObjectFieldList() {
      return new List<Schema.SObjectField> {
      			Pricing_Formula__c.Id,
                Pricing_Formula__c.Name,
                Pricing_Formula__c.Fee_Amount_Picklist_Values__c,
                Pricing_Formula__c.Pricing_Template__c
		};
   }
   //MANDATORY ABSTRACT METHODS - END
   
   //INHERIT FROM BASE CLASS - START
   //get Pricing_Formula__c by id's 
   public List<Pricing_Formula__c> selectById(Set<Id> idSet) {
        return (List<Pricing_Formula__c>) selectSObjectsById(idSet);
   }
   //INHERIT FROM BASE CLASS - END
}
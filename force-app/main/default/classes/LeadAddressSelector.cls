/**
	 *@description Method: description class for the Lead Address Selector
	 * @author: Monde Masiza(Absa)
	 * @created date: 17/02/2021
	 * */
public class LeadAddressSelector extends fflib_SObjectSelector{
    /**
     *@description Method : get Postal_Code__c object
     * @return Postal_Code__c
     */
    public Schema.SObjectType getSObjectType() {
        return Postal_Code__c.sObjectType;
    }
    /**
     * @description Method : fileds for postal code object
     * @return a list postal code description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            	Postal_Code__c.Id,
                Postal_Code__c.Name,
                Postal_Code__c.Box_Code__c,
                Postal_Code__c.Area__c,
                Postal_Code__c.Suburb__c
                };
    }
    
   
     /**
     *  @description Method: Postal_Code__c by id's
     *  @param idSet
     *  @return List of postal code id's
     */
   public List<Postal_Code__c> selectById(Set<Id> idSet) {
        return (List<Postal_Code__c>) selectSObjectsById(idSet);
   }
}
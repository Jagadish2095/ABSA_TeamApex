/**
* @description Apex Enterprise Design Patterns
* Selector Layer for Addresss objects
*
* @author  Madhava Palla
* @since   2020-02-06
*/
public class AddressesSelector extends fflib_SObjectSelector{

    
    /**
     * @description MANDATORY ABSTRACT METHODS - START
     * @return Schema.SObjectType
     */
    public Schema.SObjectType getSObjectType(){
        return Address__c.sObjectType;
    }
    /**
     * @description GetSObjectFieldList
     * @return List<Schema.SObjectField>
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Address__c.Id,
                Address__c.OwnerId,
                Address__c.Address_Type__c,
                Address__c.Client_Entity_Type__c,
                Address__c.Shipping_Street__c,
                Address__c.Shipping_Street_2__c,
                Address__c.Shipping_Suburb__c,
                Address__c.Shipping_City__c,
                Address__c.Shipping_State_Province__c,
                Address__c.Shipping_Country__c,
                Address__c.Shipping_Zip_Postal_Code__c,
                Address__c.Account__c,
                Address__c.Contact__c,
                Address__c.Address1__c,
                Address__c.Address2__c,
                Address__c.Address3__c,
                Address__c.Address4__c,
                Address__c.Address5__c
                };
                    }
    //MANDATORY ABSTRACT METHODS - END

    /**
     * @description INHERIT FROM BASE CLASS - START
     * override the sort method to sort by created date and accountId
     * @return List<Schema.SObjectField>
     */
    public override String getOrderBy() {
        return 'CreatedDate DESC, Account__c';
    }
    /**
     * @description get Addresses by id's
     * @param idSet
     * @return List<Address__c>
     */
    public List<Address__c> selectById(Set<Id> idSet) {
        return (List<Address__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END

    //CUSTOM SELECTORS - START

    /**
    * @description Return list of Address details for corresponding account
    * Custom selector USING the Base class queryFactory
    * @author : Madhava Palla
    * @date : 2020-02-06
    * @param accId
    * @return List<Address__c
    */
    public List<Address__c> addressesRelatedToAcc(String accId) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address_Type__c').
            selectField('Address1__c').
            selectField('Address2__c').
            selectField('Address3__c').
            selectField('Address4__c').
            selectField('Address5__c').
            selectField('Shipping_Street__c').
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c').
            selectField('Billing_Suburb__c').
            selectField('Shipping_City__c').
            selectField('Shipping_State_Province__c').
            selectField('Shipping_Country__c').
            selectField('Shipping_Zip_Postal_Code__c').
            selectField('Account__c').
            setCondition('Account__c = :accId').
            toSOQL()
        );

    }
    /**
    * @description Return list of Address details for corresponding account
    * Custom selector USING the Base class queryFactory
    * @author : Madhava Palla
    * @date : 2020-02-06
    * @param conId
    * @return List<Address__c>
    */
    public List<Address__c> addressesRelatedToContact(String conId) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address_Type__c').
            selectField('Address1__c').
            selectField('Address2__c').
            selectField('Address3__c').
            selectField('Address4__c').
            selectField('Address5__c').
            selectField('Shipping_Street__c').
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c').
            selectField('Shipping_City__c').
            selectField('Shipping_State_Province__c').
            selectField('Shipping_Country__c').
            selectField('Shipping_Zip_Postal_Code__c').
            selectField('Contact__c').
            selectField('Contact__r.ID_Number__c').
            setCondition('Contact__c = :conId').
            toSOQL()
        );

    }
    /**
    * @description Return list of Address details for corresponding Address Id
    * @author : Jason
    * @date : 2020-02-06
    * @param addressId
    * @return List<Address__c>
    */
    public List<Address__c> selectByAddressId(Id addressId) {

        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address1__c').
            selectField('Address2__c').
            selectField('Address3__c').
            selectField('Address4__c').
            selectField('Address5__c').
            selectField('Shipping_Street__c'). //D Booysen 27/06/2020
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c'). //D Booysen 27/06/2020
            selectField('Shipping_City__c'). //D Booysen 27/06/2020
            selectField('Shipping_State_Province__c'). //D Booysen 27/06/2020
            selectField('Shipping_Country__c'). //D Booysen 27/06/2020
            selectField('Shipping_Zip_Postal_Code__c'). //D Booysen 27/06/2020
            setCondition('Id = :addressId').
            toSOQL()
        );

    }
    /**
    * @description Return list of Address details for corresponding Address Id
    * @param accIds Set of accountId
    * @return List<Address__c> List of Address__c
    */
    public List<Address__c> selectByAccountIds(Set<String> accIds) {

        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address_Type__c').
            selectField('Address1__c').
            selectField('Address2__c').
            selectField('Address3__c').
            selectField('Address4__c').
            selectField('Address5__c').
            selectField('Billing_Suburb__c').
            selectField('Billing_City__c').
            selectField('Billing_Zip_Postal_Code__c').
            selectField('Shipping_Street__c').
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c').
            selectField('Shipping_City__c').
            selectField('Shipping_State_Province__c').
            selectField('Shipping_Country__c').
            selectField('Shipping_Zip_Postal_Code__c').
            selectField('Account__c').
            selectField('Client_Entity_Type__c').
            setCondition('Account__c IN :accIds').
            toSOQL()
        );
    }
    /**
    * @description Return list of Address details for corresponding Address Id
    * @param accId
    * @param addType
    * @return List<Address__c> List of Address__c
    */
    public List<Address__c> selectByAccountAndType(Id accId, String addType) {

        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address_Type__c').
            selectField('Address1__c').
            selectField('Address2__c').
            selectField('Address3__c').
            selectField('Address4__c').
            selectField('Address5__c').
            selectField('Billing_Suburb__c').
            selectField('Billing_City__c').
            selectField('Billing_Zip_Postal_Code__c').
            selectField('Shipping_Street__c').
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c').
            selectField('Shipping_City__c').
            selectField('Shipping_State_Province__c').
            selectField('Shipping_Country__c').
            selectField('Shipping_Zip_Postal_Code__c').
            selectField('Account__c').
            selectField('Client_Entity_Type__c').
            setCondition('Account__c = :accId AND Address_Type__c =: addType').
            toSOQL()
        );
    }
    /**
    * @description Return list of Address details for corresponding Address Id
    * @author Himani Joshi
    * @param accId
    * @param addressType
    * @return List<Address__c> List of Address__c
    */
     public List<Address__c> addressRelatedToAcc(String accId,String addressType) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address_Type__c').
            selectField('Address1__c').
            selectField('Address2__c').
            selectField('Address3__c').
            selectField('Address4__c').
            selectField('Address5__c').
            selectField('Billing_Suburb__c').
            selectField('Billing_City__c').
            selectField('Billing_Zip_Postal_Code__c').
            selectField('Shipping_Street__c').
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c').
            selectField('Shipping_City__c').
            selectField('Shipping_State_Province__c').
            selectField('Shipping_Country__c').
            selectField('Shipping_Zip_Postal_Code__c').
            selectField('Account__c').
            setCondition('Account__c = :accId AND Address_Type__c =:addressType').
            setLimit(1).
            toSOQL()
        );
     }
     /**
    * @description Return list of Address details for corresponding Address Id
    * @param accId
    * @param addressTypes
    * @param recordLimit
    * @return List<Address__c> List of Address__c
    */
     public List<Address__c> selectByAccountAndTypes(Id accId, Set<String> addressTypes, Integer recordLimit) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address_Type__c').
            selectField('Address1__c').
            selectField('Address2__c').
            selectField('Address3__c').
            selectField('Address4__c').
            selectField('Address5__c').
            selectField('Billing_Suburb__c').
            selectField('Billing_City__c').
            selectField('Billing_Zip_Postal_Code__c').
            selectField('Shipping_Street__c').
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c').
            selectField('Shipping_City__c').
            selectField('Shipping_State_Province__c').
            selectField('Shipping_Country__c').
            selectField('Shipping_Zip_Postal_Code__c').
            selectField('Account__c').
            selectField('Client_Entity_Type__c').
            setCondition('Account__c = :accId AND Address_Type__c IN :addressTypes').
            setLimit(recordLimit).
            toSOQL()
        );
    }

    /**
    * @description Return list of Address details for corresponding Address Id
    * @author : Srikanth
    * @date : 2020-10-15
    * @param policyId
    * @param addressTypes
    * @return List<Address__c>
    */
    public List<Address__c> selectByInsurancePolicyIdAndType(Id policyId, Set<String> addressTypes) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address_Type__c').
            selectField('Shipping_Street__c').
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c').
            selectField('Shipping_City__c').
            selectField('Shipping_State_Province__c').
            selectField('Shipping_Country__c').
            selectField('Shipping_Zip_Postal_Code__c').
            setCondition('Insurance_Policy__c = :policyId AND Address_Type__c IN :addressTypes').
            toSOQL()
        );
    }
    /**
    * @description return the list of addresses based on the list of account ids : added by short term insurance
    * @param accountIds
    * @return List<Address__c> List of Address__c
    */
    public List<Address__c> selectByAccountIdList(List<Id> accountIds) {

        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Address_Type__c').
            selectField('Address1__c').
            selectField('Address2__c').
            selectField('Address3__c').
            selectField('Address4__c').
            selectField('Address5__c').
            selectField('Billing_Suburb__c').
            selectField('Billing_City__c').
            selectField('Billing_Zip_Postal_Code__c').
            selectField('Shipping_Street__c').
            selectField('Shipping_Street_2__c').
            selectField('Shipping_Suburb__c').
            selectField('Shipping_City__c').
            selectField('Shipping_State_Province__c').
            selectField('Shipping_Country__c').
            selectField('Shipping_Zip_Postal_Code__c').
            selectField('Account__c').
            selectField('Client_Entity_Type__c').
            setCondition('Account__c IN :accountIds').
            toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}
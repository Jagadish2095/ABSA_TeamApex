/**
 * @description Branch Customer Address Helper
 * @author  Paul John du Randt : ABSA (IQ Business)
 * @created 2020-09-18
 */
public without sharing class BranchAddressController {
    /**
    * @description getFieldPickListValues
    * @return String
    * @param objObject
    * @param objField
    */
    @AuraEnabled
    public static List<String> getFieldPickListValues(sObject objObject, string objField)
    {
        return BranchFunctions.getFieldPickListValues(objObject, objField);
    }
    /**
    * @description getTranslationValues
    * @return Map<String,String>
    * @param systemName
    * @param valueType
    * @param direction
    * @param objObject
    * @param objField
    */
    @AuraEnabled
    public static Map<String,String> getTranslationValues(String systemName, String valueType, String direction, sObject objObject, string objField)
    {
        return BranchFunctions.getValidTranslations(systemName, valueType, direction, objObject, objField);
    }
    /**
    * @description getAddress
    * @return Map<String, String>
    * @param recordId
    * @param requestedAddressTypeList
    */
    @AuraEnabled
    public static Map<String, String> getAddress(String recordId, List<String> requestedAddressTypeList)
    {
        return getAddresses(recordId, requestedAddressTypeList);
    }
    /**
    * @description getAddresses
    * @return Map<String, String>
    * @param recordId
    * @param requestedAddressTypeList
    */
    public static Map<String, String> getAddresses(String recordId, List<String> requestedAddressTypeList)
    {
        Map<String, String> listofAddresses = getListofAddresses(recordId);
        Map<String, String> returnAddresses = new Map<String, String>();
        for(String addressType : requestedAddressTypeList )
        {
            if(ListofAddresses.containsKey(addressType))
            {
                returnAddresses.put(addressType, listofAddresses.get(addressType));
            } else {
                returnAddresses.put(addressType, addAddressRecord(recordId, addressType));
            }
        }
        return returnAddresses;
    }
    /**
    * @description getListofAddresses
    * @return Map<String, String>
    * @param recordId
    */
    public static Map<String,String> getListofAddresses(string recordId)
    {
        Account acc = [Select Id, (Select Id, Address_Type__c From Addresses__r) From Account Where Id = :recordId WITH SECURITY_ENFORCED];
        List<Address__c> adresses = acc.Addresses__r;
        Map<String, string> adresMp = new Map<String, string>();
        for(Address__c adr :adresses) {
            adresMp.put(adr.Address_Type__c, adr.Id);
        }
        return adresMp;
    }
    /**
    * @description addAddressRecord
    * @return String
    * @param recordId
    * @param addressType
    */
    public static string addAddressRecord(string recordId, String addressType)
    {
        Address__c newAddress = new Address__c(
            Account__c=recordId,
            Address_Type__c=addressType,
        	Shipping_Street__c='',
        	Shipping_Suburb__c='',
            Shipping_City__c='',
            Shipping_State_Province__c='',
            Shipping_Zip_Postal_Code__c=''
        );
        if (Address__c.sObjectType.getDescribe().isCreateable()) {
            insert newAddress;
        }
        return newAddress.Id;
    }
}
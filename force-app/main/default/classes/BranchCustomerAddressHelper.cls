/**
 * @description Branch Customer Address Helper
 * @author  Paul du Randt
 * @created 2020-09-19
 */
public without sharing class BranchCustomerAddressHelper {
    /**
    * @description getAddresses
    * @return Map<String,String>
    * @param recordId
    * @param requestedAddressTypeList
    */
    @AuraEnabled
    public static Map<String,String> getAddresses(String recordId, List<String> requestedAddressTypeList )
    {
        Map<String,String> listofAddresses = getListofAddresses(recordId);
        Map<String,String> returnAddresses = new Map<String,String>();

        for(String addressType : requestedAddressTypeList ) {
            if(ListofAddresses.containsKey(addressType)) {
                returnAddresses.put(addressType, listofAddresses.get(addressType));
            } else {
                returnAddresses.put(addressType, addAddressRecord(recordId,addressType));
            }
        }
        return returnAddresses;
    }
    /**
    * @description getListofAddresses
    * @return Map<String,String>
    * @param recordId
    */
    public static Map<String,String> getListofAddresses(string recordId)
    {
        Account acc = [Select Id, (Select Id, Address_Type__c From Addresses__r) From Account Where Id = :recordId WITH SECURITY_ENFORCED];
        List<Address__c> adresses = acc.Addresses__r;
        Map<String, string> adresMp = new Map<String, string>();

        for(Address__c adr :adresses) {
            adresMp.put(adr.Address_Type__c,adr.Id);
        }
        return adresMp;
    }
    /**
    * @description addAddressRecord
    * @return string
    * @param recordId
    * @param addressType
    */
    public static string addAddressRecord(string recordId, String addressType)
    {
        Address__c address1 = new Address__c(
            Account__c=recordId,
            Address_Type__c=addressType);

        if (Address__c.sObjectType.getDescribe().isCreateable()) {
            insert address1;
        }
        return address1.Id;
    }
}
/*
* Extension Controller for AddressOverride Component
*
* @author  Tracy de Bruin
* @version v1.0
* @since   2020-06-019
*
*/

public class AddressOverrideController {
    
    /* Input parameter : String (record id)
     * Descreption : Get Client Type 
     * Return Type : String
     * */
    @AuraEnabled
    public static String getClientType(Id recordId){
        
        String clientType = null;
        
        if(recordId != null){
            String sObjName = recordId.getSObjectType().getDescribe().getName();

            if(sObjName == 'Account') {
                clientType = new AccountsSelector().selectAllById(recordId).Client_Type__c;
            } else if (sObjName == 'Contact') {
                clientType = new ContactsSelector().selectByPersonId(recordId, 1).Account.Client_Type__c;
            }

        }
        return clientType;
    }
    
     /* Input parameter : String (record id)
     * Descreption : Get Address details 
     * Return Type : Address__c
     * */
    @AuraEnabled
    public static Address__c getAddressDetails(Id addressRecId){
        
        List<Address__c> addrLst = new List<Address__c>();
        Address__c addrRecord = new Address__c();
        Set<Id> addIds = new Set<Id>();

        if(addressRecId != null){
            addIds.add(addressRecId);
            addrLst = new AddressesSelector().selectById(addIds);
            
            if(addrLst != null && addrLst.size() > 0) {
                addrRecord = addrLst[0];
            }
            
        }
        System.debug('addrRecord : ' + addrRecord);
        return addrRecord;
    }
    
     @AuraEnabled
    public static Address__c createNewAddress(Id parentRecId, Address__c newAddress, Address__c existingAddress ){
        Try{ 
            
            Address__c addressRecord;
            
            if(existingAddress != null) {  
                update existingAddress; 
                addressRecord = existingAddress;
            } 
            
            if(newAddress != null) {
                //Check if ParentId is a Account or Contact and link to Address
                if(parentRecId != null){
                    system.debug('parentRecId : ' + parentRecId);
                    String sObjName = parentRecId.getSObjectType().getDescribe().getName();
                    
                    if(sObjName == 'Account') {
                        newAddress.Account__c = parentRecId;
                        
                        //Get personContactId to link Address to Contact as well - Only for Person Accounts
                        String AccountPersonContactId = new AccountsSelector().selectAllById(parentRecId).PersonContactId;
                        if(AccountPersonContactId != null) {
                            newAddress.Contact__c = AccountPersonContactId;
                        }
                        
                    } else if (sObjName == 'Contact') {
                        newAddress.Contact__c = parentRecId;
                    }
                    
                }
                
                upsert newAddress;
                addressRecord = newAddress;
            }
            
            return addressRecord;
            
        }
        catch (Exception e) {
            throw new AuraHandledException('Exception : '+ e.getMessage());
        }
        
    }
}
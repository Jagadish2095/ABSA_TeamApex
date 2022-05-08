/*
* Extension Controller for OnboardingClientBusAddController Component
*
* @author  Anka Ganta : Absa
* @version v1.0
* @since   2020-01-31
*
*/
public class OnboardingClientBusAddController {
    
    /* Input parameter : String (account record id)
     * Descreption : It will fetch all the address records related to particular acount
     * Return Type : List of address records
     * */
    @AuraEnabled
    public static List<Address__c> displayAddresses(String accRecId){
         List<Address__c> allAddressRelatedToAcc = new List<Address__c>();
        If(accRecId != null){
            allAddressRelatedToAcc = new AddressesSelector().addressesRelatedToAcc(accRecId); 
        }
        return allAddressRelatedToAcc;
    }
    
    /* Input parameter : List of address records 
     * Descreption : It will update all the address records related to particular acount
     * Return Type : List of address records
     * */
   @AuraEnabled
    public static List<Address__c> updateAddress(List<Address__c> add ){
        Try{     
                update add;
                return add;
           }
        catch (Exception e) {
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
           }

    }
    
     /* Input parameter : Address records 
     * Description : Create new Addresses and link to Account
     * Return Type : List of address records
     * */
    @AuraEnabled
    public static List<Address__c> createNewAddress(Address__c newAddressRecord,List<String> addressTypes ){
        Try{ 
            
            if(newAddressRecord != null) {  
                
                //Assign address fields to Shiiping Fields as well
                 newAddressRecord.Address1__c = newAddressRecord.Shipping_Street__c;
                newAddressRecord.Address2__c = newAddressRecord.Shipping_Street_2__c;
                newAddressRecord.Address3__c = newAddressRecord.Shipping_Suburb__c;
                newAddressRecord.Address4__c = newAddressRecord.Shipping_City__c;
                newAddressRecord.Address5__c = newAddressRecord.Shipping_Zip_Postal_Code__c;
                
                //Get personContactId to link Address to Contact as well - Only for Person Accounts
                if(newAddressRecord.Account__c != null) {
                    String AccountPersonContactId = new AccountsSelector().selectAllById(newAddressRecord.Account__c).PersonContactId;
                    if(AccountPersonContactId != null) {
                        newAddressRecord.Contact__c = AccountPersonContactId;
                    }  
                }
                
                insert newAddressRecord;
                
                //W-006581 - To Copy Addressses to other Address types - Manoj
                List<Address__c> allAddressRelatedToAcc = new AddressesSelector().addressesRelatedToAcc(newAddressRecord.Account__c); 
                List<Address__c> addressToUpdate = new List<Address__c>();
                List<Address__c> addressToInsert = new List<Address__c>();
                
                Map<String,Address__c> mapToAddressTypes = new Map<String, Address__c>();
                for(Address__c addressObj: allAddressRelatedToAcc){
                    mapToAddressTypes.put(addressObj.Address_Type__c,addressObj);
                }
                
                if(!allAddressRelatedToAcc.isEmpty()){
                    for(String addr: addressTypes){
                        if(mapToAddressTypes.get(addr) != null ){
                            if(addr==mapToAddressTypes.get(addr).Address_Type__c){
                            Address__c adds = new Address__c(Id = mapToAddressTypes.get(addr).Id);
                            adds.Address1__c = newAddressRecord.Shipping_Street__c;
                            adds.Address2__c = newAddressRecord.Shipping_Street_2__c;
                            adds.Address3__c = newAddressRecord.Shipping_Suburb__c;
                            adds.Address4__c = newAddressRecord.Shipping_City__c;
                            adds.Address5__c = newAddressRecord.Shipping_Zip_Postal_Code__c;
                            adds.Shipping_Street__c = newAddressRecord.Shipping_Street__c;
                            adds.Shipping_Street_2__c = newAddressRecord.Shipping_Street_2__c;
                            adds.Shipping_Suburb__c = newAddressRecord.Shipping_Suburb__c;
                            adds.Shipping_City__c = newAddressRecord.Shipping_City__c;
                            adds.Shipping_Zip_Postal_Code__c = newAddressRecord.Shipping_Zip_Postal_Code__c;
                            
                            addressToUpdate.add(adds);
                        } 
                        }
                        else{
                            Address__c adds = new Address__c();
                            adds.Account__c = newAddressRecord.Account__c;
                            adds.Address_Type__c = addr;
                            adds.Address1__c = newAddressRecord.Shipping_Street__c;
                            adds.Address2__c = newAddressRecord.Shipping_Street_2__c;
                            adds.Address3__c = newAddressRecord.Shipping_Suburb__c;
                            adds.Address4__c = newAddressRecord.Shipping_City__c;
                            adds.Address5__c = newAddressRecord.Shipping_Zip_Postal_Code__c;
                            adds.Shipping_Street__c = newAddressRecord.Shipping_Street__c;
                            adds.Shipping_Street_2__c = newAddressRecord.Shipping_Street_2__c;
                            adds.Shipping_Suburb__c = newAddressRecord.Shipping_Suburb__c;
                            adds.Shipping_City__c = newAddressRecord.Shipping_City__c;
                            adds.Shipping_Zip_Postal_Code__c = newAddressRecord.Shipping_Zip_Postal_Code__c;
                            addressToInsert.add(adds);
                            
                        }
                    }
                    if(!addressToUpdate.isEmpty()){
                    	update addressToUpdate;
                    }
                    if(!addressToInsert.isEmpty()){
                    	insert addressToInsert;
                    }
                }
                
                //Get alladdresses link
                return displayAddresses(newAddressRecord.Account__c);
                
            } else {
                return null;
            }
                
        }
        catch (Exception e) {
            throw new AuraHandledException('Exception : '+ e.getMessage());
        }
        
    }
    
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
    
       @AuraEnabled
    public static String fetchProcessType(String accId){
        System.debug('accId '+accId);
        Account accRec = new AccountsSelector().selectAllById(accId);
        String processTypeValue = accRec.Process_Type__c;
        return processTypeValue;
    }
    
    
    //Newly added by Rajesh for Dynamic address type
    @AuraEnabled
    public static List<String> fetchAddressTypes(String entityTypeValue){
        Map<String, List<String>> dataMap = getDependentPicklistValues(Address__c.Address_Type__c);
        
        List<String> depedentValues = new List<String>();
        depedentValues = dataMap.get(entityTypeValue);
        System.debug('depedentValues '+depedentValues);
        
        return depedentValues;
    }
    public static Map<String, List<String>> getDependentPicklistValues(Schema.sObjectField dependToken) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
        
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
        
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                    String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                        (controlEntries == null
                         ?   (Object) (index == 1)
                         :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                        );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        return dependentPicklistValues;
    }
}
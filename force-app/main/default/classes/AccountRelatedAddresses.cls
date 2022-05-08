/**
 * @description       : 
 * @author            : Monde Masiza
 * @last modified on  : 2021-07-14
 * @last modified by  : Monde Masiza
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-07-10   Monde Masiza   Initial Version
**/
public class AccountRelatedAddresses {
    
    private static final String PHYSICALADDRESS = 'Physical Address';
    private static final String POSTALADDRESS = 'Postal';
    private static final String EMPLOYERADDRESS = 'Employers';
    private static final String RESIDENTIALADDRESS = 'Residential';
    
    /**
    * @description created account related address
    * @author Monde Masiza
    * @param accountIds
    **/
    
    @InvocableMethod(label='Create Account Addresses')
    public static void createAccountRelatedAddresses(List<Id> accountIds){
        
        Set<Id> accIds = new Set<Id>(accountIds);
        List<Address__c> addressesToBeCreated = new List<Address__c>();
        List<Address__c> relatedAddresses = new AddressesSelector().selectByAccountIdList(accountIds);
        List<Account> accounts = new AccountsSelector().selectById(accIds);
        
        for(Account account : accounts){
            
            if(account.Occupation_Status__pc == 'Full Time Employed' 
               || account.Occupation_Status__pc == 'Self Employed Professional' 
               || account.Occupation_Status__pc == 'Self Employed-Non-Professional' 
               || account.Occupation_Status__pc == 'Temporary Employed'
               || account.Occupation_Status__pc == 'Part Time Employed'){
                   
                   //create Physical/Postal/Employer
                   addressesToBeCreated.add(createAddress(account,PHYSICALADDRESS));
                   addressesToBeCreated.add(createAddress(account,EMPLOYERADDRESS));
                   addressesToBeCreated.add(createPostalAddress(account));
               }else{
                   
                   //create physical/postal/residential
                   addressesToBeCreated.add(createAddress(account,PHYSICALADDRESS));
                   addressesToBeCreated.add(createAddress(account,RESIDENTIALADDRESS));
                   addressesToBeCreated.add(createPostalAddress(account));
               }
        }  
        
        system.debug('addressesToBeCreated : '+addressesToBeCreated);
        
        //purge the existing address records to create the new address as per the short term insurance occupation status rules.
        if(!relatedAddresses.isEmpty()){
            delete relatedAddresses;
        }
        
        insert addressesToBeCreated;
    }
    
 /**
    * @description create physical/employer/residential addresses
    * @author Monde Masiza
    * @param acc
    * @param addressType
    * @return Address__c
**/
    public static Address__c createAddress(Account acc, String addressType){
        //physical address
        Address__c createAddress = new Address__c(); 
        createAddress.Address_Type__c = addressType;
        createAddress.Shipping_Street__c = acc.Physical_Address_Line_1__c;
        createAddress.Shipping_Street_2__c = acc.Physical_address_line_2_c__c;
        createAddress.Shipping_Suburb__c = acc.Physical_Address_Suburb__c;
        createAddress.Shipping_City__c = acc.Physical_Address_City__c;
        createAddress.Shipping_Zip_Postal_Code__c = acc.Physical_Address_Physical_Code__c;
        createAddress.Shipping_Country__c = acc.Physical_Address_Country__c;
        createAddress.Client_Entity_Type__c = 'Individual';
        createAddress.Account__c = acc.Id;
        createAddress.Contact__c = acc.PersonContactId;
        return createAddress;
    }
    
/**
    * @description create postal address
    * @author Monde Masiza | 2021-07-10 
    * @param acc 
    * @return Address__c
    **/

    public static Address__c createPostalAddress(Account acc){
        
        //Post address
        Address__c createPostalAddress = new Address__c(); 
        createPostalAddress.Address_Type__c = POSTALADDRESS;
        createPostalAddress.Shipping_Street__c = acc.Postal_Address_Line__c;
        createPostalAddress.Shipping_Street_2__c = acc.billing_address_line_2__c;
        createPostalAddress.Shipping_Suburb__c = acc.Postal_Address_Suburb__c;
        createPostalAddress.Shipping_City__c = acc.Postal_Address_City__c;
        createPostalAddress.Shipping_Zip_Postal_Code__c = acc.Postal_Address_Postal_Code__c;
        createPostalAddress.Shipping_Country__c = acc.Postal_Address_Country__c;
        createPostalAddress.Client_Entity_Type__c = 'Individual';
        createPostalAddress.Account__c = acc.Id;
        createPostalAddress.Contact__c = acc.PersonContactId;
        return createPostalAddress;

    }
    
}
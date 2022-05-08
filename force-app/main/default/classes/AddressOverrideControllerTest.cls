@isTest
public class AddressOverrideControllerTest {

     @isTest 
    public static void addressOverrideTest(){
        
       // Insert account record
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        // Insert address records.
        
        List<Address__c> addListToBeinsert = new List<Address__c>();
        Address__c add1 = new Address__c();
        add1.Address1__c = 'Unit 171';
        add1.Address2__c = 'Silver Stream';
        add1.Address3__c = 'Leauxe road';
        add1.Address4__c = 'Midrand';
        add1.Address5__c = '5081';
        add1.Shipping_Street__c = 'Unit 171';
        add1.Shipping_Suburb__c = 'Silver Stream';
        add1.Shipping_City__c = 'Leauxe road';
        add1.Shipping_State_Province__c = 'Midrand';
        add1.Shipping_Zip_Postal_Code__c = '5081';
        add1.Account__c =accountList[0].id;
        add1.Address_Type__c ='Physical Address';
        addListToBeinsert.add(add1);
        
        Address__c add2 = new Address__c();
        add2.Address1__c = 'Unit 172';
        add2.Address2__c = 'Silver Stream';
        add2.Address3__c = 'Leauxe road';
        add2.Address4__c = 'Midrand';
        add2.Address5__c = '5081';
        add2.Shipping_Street__c = 'Unit 171';
        add2.Shipping_Suburb__c = 'Silver Stream';
        add2.Shipping_City__c = 'Leauxe road';
        add2.Shipping_State_Province__c = 'Midrand';
        add2.Shipping_Zip_Postal_Code__c = '5081';
        add2.Account__c =accountList[0].id;
        add2.Address_Type__c ='Physical Address';
        addListToBeinsert.add(add2);

        insert addListToBeinsert;
        
        try {
            AddressOverrideController.getClientType(accountList[0].id);
            AddressOverrideController.getAddressDetails(addListToBeinsert[0].id);
            AddressOverrideController.createNewAddress(accountList[0].id, addListToBeinsert[0], addListToBeinsert[1]);
            
        } catch (Exception ex) {
            System.debug(ex); 
        }

    }
}
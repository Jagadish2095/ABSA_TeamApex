/*
 Controller Test Class For XDS Controller class
*
* @author  Madhava Palla : Absa
* @version v1.0
* @since   2020-02-07
*/

@isTest
public class OnboardingClientBusAddControllerTest {
    @isTest 
    public static void testAddress(){
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
        
        Address__c add3 = new Address__c();
        add3.Address1__c = 'Unit 173';
        add3.Address2__c = 'Silver Stream';
        add3.Address3__c = 'Leauxe road';
        add3.Address4__c = 'Midrand';
        add3.Address5__c = '5081';
        add3.Shipping_Street__c = 'Unit 171';
        add3.Shipping_Suburb__c = 'Silver Stream';
        add3.Shipping_City__c = 'Leauxe road';
        add3.Shipping_State_Province__c = 'Midrand';
        add3.Shipping_Zip_Postal_Code__c = '5081';
        add3.Account__c =accountList[0].id;
        add3.Address_Type__c ='Postal';
        //addListToBeinsert.add(add3);
        
        insert addListToBeinsert;
        
        Test.startTest();
        List<Address__c> addList =OnboardingClientBusAddController.displayAddresses(accountList[0].id);
        //List<Address__c> addList2 = OnboardingClientBusAddController.createNewAddress(add3);
        List<Address__c> addList3 = OnboardingClientBusAddController.updateAddress(addListToBeinsert);
        OnboardingClientBusAddController.getClientType(accountList[0].id);
        system.assertNotEquals(0, addList.size());
        system.assertEquals(2, addList.size());
        Test.stopTest();
    }
    @isTest 
    public static void testcreateNewAddress(){
    	List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        Address__c add3 = new Address__c();
        add3.Address1__c = 'Unit 173';
        add3.Address2__c = 'Silver Stream';
        add3.Address3__c = 'Leauxe road';
        add3.Address4__c = 'Midrand';
        add3.Address5__c = '5081';
        add3.Shipping_Street__c = 'Unit 171';
        add3.Shipping_Suburb__c = 'Silver Stream';
        add3.Shipping_City__c = 'Leauxe road';
        add3.Shipping_State_Province__c = 'Midrand';
        add3.Shipping_Zip_Postal_Code__c = '5081';
        add3.Account__c =accountList[0].id;
        add3.Address_Type__c ='Postal';
        add3.Client_Entity_Type__c = 'Private Company';
        insert add3;
        
        Address__c add2 = new Address__c();
        add2.Address1__c = 'Unit 173';
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
        add2.Address_Type__c ='Business Address';
        add2.Client_Entity_Type__c = 'Private Company';
        OnboardingClientBusAddController.fetchAddressTypes('Private Company');
        List<String> addTypes = new List<String>{'Postal','Head Office'};
        List<Address__c> addList2 = OnboardingClientBusAddController.createNewAddress(add2,addTypes);
            
    }
}
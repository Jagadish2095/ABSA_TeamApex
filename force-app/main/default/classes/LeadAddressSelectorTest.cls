@isTest
public class LeadAddressSelectorTest {
    @isTest
     static void createleadAddress(){

        Postal_Code__c pc = new Postal_Code__c();
        pc.Name ='0122';
        pc.Area__c ='MAMELODI';
        pc.Box_Code__c =177;
        pc.Suburb__c ='LUSAKA EXT';
        insert pc;
         
         test.startTest();
         
         List<Postal_Code__c> getPostalCode = [select id, Name,Suburb__c from Postal_Code__c where Name='0122' ];
         system.debug('getPostalCode: ' + getPostalCode[0].Name);

        system.assertNotEquals('0122', getPostalCode[0].Suburb__c, 'Name does not match:' + getPostalCode[0].Suburb__c);

        
        List<Postal_Code__c> leadAddress = new LeadAddressSelector().selectById(new Set<Id>{pc.Id});
        test.stopTest();
    }
}
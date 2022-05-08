/**
 * @description AddressesSelectorTest Description
 *
 */
@isTest
private class AddressesSelectorTest {

    @isTest
    private static void addressesRelatedToAccTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
        List<Address__c> accs = new AddressesSelector().addressesRelatedToAcc(acc.Id);
        System.assertEquals(true, accs.size() > 0, 'Assert Failed');
        Test.stopTest();
    }

    

    @isTest
    private static void selectByAccountIdsTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Set<String> accIds = new Set<String>();
        accIds.add(acc.Id);
        Test.startTest();
        new AddressesSelector().getSObjectFieldList();
        List<Address__c> accountAddresses = new AddressesSelector().selectByAccountIds(accIds);
        Set<Id> Ids = new Set<Id>();
        Ids.add(accountAddresses.get(0).Id);
        new AddressesSelector().selectById(Ids);
        new AddressesSelector().selectByAccountAndType(testDataFactory.testAccount.Id, 'Postal') ;
        Test.stopTest();
        System.assertEquals(true, accountAddresses.size() > 0, 'Assert Failed');
    }

    @isTest
    private static void selectByAddressIdTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Address__c addr = [SELECT Id FROM Address__c LIMIT 1];
        Test.startTest();
        List<Address__c> accAddresses = new AddressesSelector().selectByAddressId(addr.Id);
        Test.stopTest();
        System.assertEquals(1, accAddresses.size(), 'Assert Failed');
    }

    @isTest
    private static void addressesRelatedToContactTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Test.startTest();
        List<Address__c> conAddresses = new AddressesSelector().addressesRelatedToContact(con.Id);
        Test.stopTest();
        System.assertEquals(false, conAddresses.size() > 0, 'Assert Failed');
    }
    
    @isTest
    private static void addressRelatedToAccTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        Address__c testAddress = new Address__c(Account__c = testDataFactory.testAccount.Id,
                                                Address_Type__c = 'Risk');
        insert testAddress;

        Test.startTest();
        List<Address__c> accAddresses = new AddressesSelector().addressRelatedToAcc(testDataFactory.testAccount.Id, 'Risk');
        Test.stopTest();
        System.assertEquals(true, accAddresses.size() > 0, 'Assert Failed');
    }
    
    @isTest
    private static void selectByAccountAndTypesTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        Address__c testAddress = new Address__c(Account__c = testDataFactory.testAccount.Id,
                                                Address_Type__c = 'Risk');
        insert testAddress;

        Test.startTest();
        List<Address__c> accAddresses = new AddressesSelector().selectByAccountAndTypes(testDataFactory.testAccount.Id, new Set<String>{'Risk'}, 2);
        Test.stopTest();
        System.assertEquals(true, accAddresses.size() > 0, 'Assert Failed');
    }

    //Danie Booysen, Paula Kreutzfeldt
    //2020-11-03
    //W-005966
    @isTest
    private static void selectByInsurancePolicyIdAndTypeTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        InsurancePolicy policy = new InsurancePolicy(Name = 'TestPolicy1',
                                                     NameInsuredId = testDataFactory.testAccount.Id);
        insert policy;

        Address__c testAddress = new Address__c(Insurance_Policy__c = policy.Id,
                                                Address_Type__c = 'Risk');
        insert testAddress;

        Test.startTest();
        List<Address__c> policyAddresses = new AddressesSelector().selectByInsurancePolicyIdAndType(policy.Id, new Set<String>{'Risk'});
        Test.stopTest();
        System.assertEquals(true, policyAddresses.size() > 0, 'Assert Failed');
        
    }
}
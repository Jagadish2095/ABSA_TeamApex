/**
* @description This is the AccountContactRelationSelectorTest class
*
* @author Vladimir Panajic
* @created  2019-05-24
*/
@isTest
public class AccountContactRelationSelectorTest {

    @isTest
    private static void testSelectById() {

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        testDataFactory.testContact.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testContact;

        Test.startTest();

        AccountContactRelation testACR = new AccountContactRelation();
        testACR.AccountId = testDataFactory.testAccount.Id;
        testACR.ContactId = testDataFactory.testContact.Id;
        insert testACR;

        AccountContactRelationSelector acs = new AccountContactRelationSelector();
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(testACR.Id);
        System.assert(acs.selectById(tstSet) != null);
        System.assert(acs.selectRelationByAccountId(testACR.AccountId) != null);
        System.assert(acs.selectRelationById(testACR.id) != null);
        System.assert(acs.selectRelationByAcctIdAndRoles(testACR.AccountId, 'Managing Director') != null);
        Test.stopTest();
    }

    @isTest
    private static void testSelectListByAccId() {

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        testDataFactory.testContact.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testContact;

        Test.startTest();

        AccountContactRelation testACR = new AccountContactRelation();
        testACR.AccountId = testDataFactory.testAccount.Id;
        testACR.ContactId = testDataFactory.testContact.Id;
        insert testACR;

        AccountContactRelationSelector acs = new AccountContactRelationSelector();
        List<Account> acrs = acs.selectListByAccId(testDataFactory.testAccount.Id);
        List<Contact> contacts = new AccountContactRelationSelector().selectContactListByAccId(testDataFactory.testJointAccount.Id);
        new AccountContactRelationSelector().selectbyAccount(testDataFactory.testAccount.Id);
        new AccountContactRelationSelector().selectbyAccountContactRelationId(testACR.Id);
        new AccountContactRelationSelector().selectbyPrimaryEntityIdAndContactId(testDataFactory.testAccount.Id, testDataFactory.testContact.Id);
        System.assert(new AccountContactRelationSelector().selectbyaccConRelId(testACR.Id) != null);
        Test.stopTest();
    }

    @isTest
    private static void testselectbyRoles() {

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Set<id> ids = new Set<id>();
        ids.add(testDataFactory.testAccount.PersonContactId);

        Test.startTest();

        AccountContactRelationSelector acs = new AccountContactRelationSelector();
        List<AccountContactRelation> acrs = acs.selectbyRoles(testDataFactory.testAccount.Id, ids, 'Director');
        System.assert(acs.selectRelationByAccountIdSet(ids)!= null);

        Test.stopTest();
    }

    @isTest
    private static void testselectbyAccountIdAndRoles() {

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        Test.startTest();
        AccountContactRelationSelector acs = new AccountContactRelationSelector();
        List<AccountContactRelation> acrs = acs.selectbyAccountIdAndRoles(testDataFactory.testAccount.Id, 'Director');
        System.assertNotEquals(null, acrs.size());
        Test.stopTest();
    }

    //Test Data Creation
    //@author: Chandra
    //@Date: 25/07/2020

    @testSetup
    static void dataCreation(){
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 

        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'test';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        insert sysAdminUser; 

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Advisor'];
        insert new PermissionSetAssignment(AssigneeId = sysAdminUser.id, PermissionSetId = ps.Id);

        PermissionSet fsps = [SELECT Id FROM PermissionSet WHERE Name = 'FinancialServicesCloudStandard'];
        insert new PermissionSetAssignment(AssigneeId = sysAdminUser.id, PermissionSetId = fsps.Id);
    }

    //Test Method to test selectbyPrimaryEntityIdAndContactId method
    //@author: Masechaba Maseli
    //@Date: 25/07/2020
    @isTest
    private static void testselectUBOContacts() {
        User sysUser = [Select Id,FirstName from User where LastName = 'last_test'];

        System.runAs(sysUser) {
            WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
            Test.startTest();
            AccountContactRelationSelector acs = new AccountContactRelationSelector();
            System.assert(acs.selectUBOContacts(testDataFactory.testAccount.Id, testDataFactory.testAccount.Id) != null);
            Test.stopTest();
        }
    }
    @isTest
    private static void selectListByAccIdAndPrimaryEntityIdTest() {
          User sysUser = [Select Id,FirstName from User where LastName = 'last_test'];

        System.runAs(sysUser) {
            WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
            Set<Id> primaryEntityIds = new Set<Id>();
            primaryEntityIds.add(testDataFactory.testAccount.Id);
            Test.startTest();
            AccountContactRelationSelector acs = new AccountContactRelationSelector();
            System.assert(acs.selectListByAccIdAndPrimaryEntityId(testDataFactory.testAccount.Id, primaryEntityIds) != null);
            Test.stopTest();
        }
    }
    @isTest
    private static void parentInTest() {
          User sysUser = [Select Id,FirstName from User where LastName = 'last_test'];

        System.runAs(sysUser) {
            WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
            List<Id> primaryEntityIds = new List<Id>();
            primaryEntityIds.add(testDataFactory.testAccount.Id);
            Test.startTest();
            AccountContactRelationSelector acs = new AccountContactRelationSelector();
            System.assert(acs.parentIn(primaryEntityIds)!= null);
            Test.stopTest();
        }
    }
    @isTest
    private static void selectUBOTest() {
          User sysUser = [Select Id,FirstName from User where LastName = 'last_test'];

        System.runAs(sysUser) {
            WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
            List<Id> primaryEntityIds = new List<Id>();
            primaryEntityIds.add(testDataFactory.testAccount.Id);
            Test.startTest();
            AccountContactRelationSelector acs = new AccountContactRelationSelector();
            System.assert(acs.selectUBO(testDataFactory.testAccount.Id,'Yes')!=null);
            Test.stopTest();
        }
    }

    @isTest
    private static void selectbyPrimaryEntityIdTest() {
          User sysUser = [Select Id,FirstName from User where LastName = 'last_test'];

        System.runAs(sysUser) {
            WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
            List<Id> primaryEntityIds = new List<Id>();
            primaryEntityIds.add(testDataFactory.testAccount.Id);
            Test.startTest();
            AccountContactRelationSelector acs = new AccountContactRelationSelector();
            System.assert(acs.selectbyPrimaryEntityId(testDataFactory.testAccount.Id) != null);
            Test.stopTest();
        }
    }
    @isTest
    private static void selectbyActiveDirectorsTest() {
          User sysUser = [Select Id,FirstName from User where LastName = 'last_test'];

        System.runAs(sysUser) {
            WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
            List<Id> primaryEntityIds = new List<Id>();
            primaryEntityIds.add(testDataFactory.testAccount.Id);
            Test.startTest();
            AccountContactRelationSelector acs = new AccountContactRelationSelector();
            acs.selectbyActiveDirectors(testDataFactory.testAccount.Id,'Director');
            System.assert(acs.selectbyIdNumber('1234567890', testDataFactory.testAccount.Id) != null);
            Test.stopTest();
        }
    }
    @isTest
    private static void selectbyUboPrimaryIdsTest() {
          User sysUser = [Select Id,FirstName from User where LastName = 'last_test'];
        System.runAs(sysUser) {
            WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
            Set<Id> primaryEntityIds = new Set<Id>();
            primaryEntityIds.add(testDataFactory.testAccount.Id);
            Test.startTest();
            AccountContactRelationSelector acs = new AccountContactRelationSelector();
            System.assert(acs.selectbyUboPrimaryIds(testDataFactory.testAccount.Id, primaryEntityIds, 'Yes')!= null);
            System.assert(acs.selectByRelatedPartySection(testDataFactory.testAccount.Id)!= null);
            
            Test.stopTest();
        }
    }
}
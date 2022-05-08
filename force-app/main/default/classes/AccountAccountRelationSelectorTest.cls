/**
* @description Apex Enterprise Design Patterns
* Selector Layer Test class for AccountAccountRelation objects
*
* @author       Chandra (ABSA)
* @since        2020-07-26
*/
@isTest
public class AccountAccountRelationSelectorTest {

    @testSetup
    static void dataCreation(){
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'actest';
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

    @isTest
    static void createAccountAccountRelation(){
        test.startTest();
        User sysUser = [Select Id,FirstName from User where FirstName='actest'];

        System.runAs(sysUser) {
            Account acct = new Account();
            acct.Name = 'Absa';
            insert acct;
            system.assertNotEquals(null, acct.id);
            Account accRecord2 = new account();
            accRecord2.Name = 'Test Acc2';
            insert accRecord2;
            system.assertNotEquals(null, accRecord2.id);
            Contact con = new Contact();
            con.AccountId = acct.id;
            con.lastname = 'testdata'; 
            con.firstname ='testdata1';
            insert con;
            system.assertNotEquals(null, con.id);
            AccountContactRelation acctcr = new AccountContactRelation();
            acctcr.AccountId = accRecord2.id;
            acctcr.ContactId = con.id;
            acctcr.Primary_Entity_Id__c = acct.id;
            acctcr.Share_Percentage__c = 10.0;
            insert acctcr;
            system.assertNotEquals(null, acctcr.id);
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            system.assertNotEquals(null, resRole.id);
            FinServ__AccountAccountRelation__c finservAccount = new FinServ__AccountAccountRelation__c();
            finservAccount.FinServ__Account__c = acct.id;
            finservAccount.FinServ__RelatedAccount__c = acctcr.AccountId;
            finservAccount.FinServ__Role__c = resRole.id;
            finservAccount.Primary_Entity_Id__c = acctcr.Primary_Entity_Id__c;
            finservAccount.Shareholding_Percentage__c = 2;
            insert finservAccount;
            system.assertNotEquals(null, finservAccount.id);
            List<String> accList = new List<String>();
            accList.add(acct.id);
            String inverseRelationship = 'Inverse Testing';
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount);

            AccountAccountRelationSelector accountaccountSelector = new AccountAccountRelationSelector();
            List<FinServ__AccountAccountRelation__c> aaTestList = accountaccountSelector.selectbyPrimaryEntityIdAndRelatedAccId(acct.Id,accRecord2.Id);
            FinServ__AccountAccountRelation__c aaTestList2 = accountaccountSelector.selectbyAccAccRelId(finservAccount.id);
            List<FinServ__AccountAccountRelation__c> aaTestList3 = accountaccountSelector.selectbyPrimaryEntityId(acct.Id);
            List<FinServ__AccountAccountRelation__c> aaTestList4 = accountaccountSelector.selectbyLevel0RelatedParty(acct.Id,acct.Id);
            List<FinServ__AccountAccountRelation__c> aaTestList5 = accountaccountSelector.selectbyPrimaryEntityIdFiltered(acct.Id,inverseRelationship);
            List<FinServ__AccountAccountRelation__c> aaTestList6 = accountaccountSelector.selectbyPrimaryEntityListFiltered(accList,inverseRelationship);
            FinServ__AccountAccountRelation__c aaTestList7 = accountaccountSelector.selectbyRelatedPrimaryEntity(acct.Id,acct.Id);
            List<FinServ__AccountAccountRelation__c> aaTestList8 = accountaccountSelector.getFirstLevel(acct.Id);
            List<FinServ__AccountAccountRelation__c> aaTestList9 = accountaccountSelector.searchByParent(acct.Id);
            List<FinServ__AccountAccountRelation__c> aaTestList10 = accountaccountSelector.searchByParentIn(accList);
            List<FinServ__AccountAccountRelation__c> aaTestList11 = accountaccountSelector.selectByPrimaryForRelationshipSection(acct.Id);
            List<FinServ__AccountAccountRelation__c> aaTestList12 = accountaccountSelector.selectByPrimaryForDocuments(acct.Id);
            List<FinServ__AccountAccountRelation__c> aaTestListById = accountaccountSelector.selectById(new Set<Id>{acct.Id});
             List<FinServ__AccountAccountRelation__c> aaTestListselectByByRelatedPartySection = accountaccountSelector.selectByByRelatedPartySection(accRecord2.Id);
             List<FinServ__AccountAccountRelation__c> aaTestListselectbyIdSet = accountaccountSelector.selectbyIdSet(new Set<Id>{acct.Id});
        }
        test.stopTest();
    }
}
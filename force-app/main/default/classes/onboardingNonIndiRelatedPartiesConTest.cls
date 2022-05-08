/**
* @description Controller Test Class For onboardingNonIndividualRelatedPartiesCon class
*
* @author  Diksha Wasekar : Absa
* @version v1.0
* @since   2020-07-25
*/

@isTest
public class onboardingNonIndiRelatedPartiesConTest {

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

    //Test Method to test calculate calculateControllingPercentageforAccAccRel method
    //@author: Chandra
    //@Date: 25/07/2020
    @isTest
    public static void calculateControllingPercentageforAccAccRel(){

        User sysUser = [Select Id,FirstName from User where FirstName='test'];

        System.runAs(sysUser) {
       Test.startTest();
            Account acct = new Account();
            acct.Name = 'Absa';
            insert acct;

            Account accRecord2 = new account();
            accRecord2.Name = 'Test Acc2';
            insert accRecord2;

            Contact con = new Contact();
            con.AccountId = acct.id;
            con.lastname = 'testdata';
            con.firstname ='testdata1';
            insert con;

            AccountContactRelation acctcr = new AccountContactRelation();
            acctcr.AccountId = accRecord2.id;
            acctcr.ContactId = con.id;
            acctcr.Primary_Entity_Id__c = acct.id;
            acctcr.Share_Percentage__c = 10.0;
            insert acctcr;

            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;

            FinServ__AccountAccountRelation__c finservAccount = new FinServ__AccountAccountRelation__c();
            finservAccount.FinServ__Account__c = acct.id;
            finservAccount.FinServ__RelatedAccount__c = acctcr.AccountId;
            finservAccount.FinServ__Role__c = resRole.id;
            finservAccount.Primary_Entity_Id__c = accRecord2.id;
            finservAccount.Shareholding_Percentage__c = 2;
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount);

            FinServ__AccountAccountRelation__c finservAccount2 = new FinServ__AccountAccountRelation__c();
            finservAccount2.FinServ__Account__c = acct.id;
            finservAccount2.FinServ__RelatedAccount__c = accRecord2.id;
            finservAccount2.FinServ__Role__c = resRole.id;
            finservAccount2.Primary_Entity_Id__c = acct.id;
            finservAccount2.Shareholding_Percentage__c = 2;
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount2);
            System.assert(finservAccount2.Shareholding_Percentage__c > 0);
            onboardingNonIndividualRelatedPartiesCon.calculateControllingPercentageforAccAccRel('Shareholder/Controller',2,acct.id,accRecord2.id,resRole.id,acct.id, '','Sole Trader');
            onboardingNonIndividualRelatedPartiesCon.updateComplexContact(acct.id,accRecord2.id);
            Test.stopTest();
        }
    }

    @isTest
    public static void callExperianService(){
        User sysUser = [Select Id,FirstName from User where FirstName='test'];

        System.runAs(sysUser) {

            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, ExperianBusinessDetailsGet_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
            IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String> {ExperianBusinessDetailsGet_IH_v1.INTEGRATION_SERVICE_NAME});
            Test.startTest();
            String respStr = onboardingNonIndividualRelatedPartiesCon.callExperianHandler('197101150307');
            System.assertNotEquals(null, respStr);
            onboardingNonIndividualRelatedPartiesCon.getAccountRecordTypeId('Prospect');

            Test.stopTest();
        }
    }
}
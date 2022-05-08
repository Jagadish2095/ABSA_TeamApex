/**
 * @description       : Test class for ApplicationProfileSelector class
 * @author            : Himani Joshi
 * @last modified on  : 2021-06-11
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   2021-06-08   Himani Joshi   Initial Version
**/

@IsTest
private class ApplicationProfileSelectorTest {
	
	@TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ApplicationExposureFacilities_IH_v1.INTEGRATION_SERVICE_NAME});
        ClientDetailsSectionCreditTest.dataCreation();
    }
    @isTest
    public static void testGetAppProfileBureauData(){
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        Application__c application = [SELECT Id FROM Application__c WHERE Opportunity__c =: opportunity.Id LIMIT 1];
        
        Application_Profile__c appProfile = new Application_Profile__c();
        appProfile.Client_CIF_Code__c = 'AABK   007';
        appProfile.Client_Name__c = 'Absa Bank';
        appProfile.Application__c = application.Id;
        appProfile.Applicant_Type__c = 'Main Applicant';
        insert appProfile;
        
        Test.startTest();
        List<Application_Profile__c> appProfiles = new ApplicationProfileSelector().getAppProfileBureauData(opportunity.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, appProfiles);
        System.assertNotEquals(0, appProfiles.size());
    }
    @isTest
    public static void testGetSObjectType() {
        test.startTest();
        System.assert(new ApplicationProfileSelector().getSObjectType() != null);
        test.stopTest();
    }
    @isTest
    public static void testGetSObjectFieldList() {
        test.startTest();
        System.assert(new ApplicationProfileSelector().getSObjectFieldList() != null);
        test.stopTest();
    }
    @isTest
    public static void testgetApplicationProfiles() {
        Account account = [SELECT Id,Registration_Number__c FROM Account LIMIT 1];
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE AccountId =: account.Id LIMIT 1];
        Application__c application = [SELECT Id FROM Application__c WHERE Opportunity__c =: opportunity.Id LIMIT 1];
        
        Application_Profile__c appProfile = new Application_Profile__c();
        appProfile.Client_CIF_Code__c = 'AABK   007';
        appProfile.Client_Name__c = 'Absa Bank';
        appProfile.Application__c = application.Id;
        appProfile.Applicant_Type__c = 'Main Applicant';
        appProfile.Related_to_Client_Id_Or_Reg_Number__c=account.Registration_Number__c;
        insert appProfile;
        Set<String>Ids=new Set<String>();
        Ids.add(appProfile.Related_to_Client_Id_Or_Reg_Number__c);
        Set<String> applicationIds=new Set<String>();
        applicationIds.add(application.Id);
        
        Application_Principal__c appPrincipal = new Application_Principal__c();
        appPrincipal.Principal_Shareholder_Name__c = 'HERMAN JOHANNES FOURIE';
        appPrincipal.cif__c = 'FOURIBM001';
        appPrincipal.Application__c = application.Id;
        appPrincipal.Id_Number__c = '7010075121089';
        insert appPrincipal;
        
        test.startTest();
        System.assert(new ApplicationProfileSelector().getApplicationProfiles(application.Id) != null);
        System.assert(new ApplicationProfileSelector().getApplicationProfilesByType(application.Id) != null);
        System.assert(new ApplicationProfileSelector().getApplicationProfilesByType(application.Id,'Main Applicant') != null);
        System.assert(new ApplicationProfileSelector().getApplicationProfilesByRelatedClientCode(account.Registration_Number__c,application.Id) != null);
        System.assert(new ApplicationProfileSelector().getLinkedPrincipals(Ids,appProfile.Applicant_Type__c,application.Id) != null);
        System.assert(new ApplicationProfileSelector().getLinkedPrincipals(appProfile.Related_to_Client_Id_Or_Reg_Number__c,appProfile.Applicant_Type__c,application.Id) != null);
        System.assert(new ApplicationProfileSelector().getApplicationProfilesByRelatedClientCode(appProfile.Related_to_Client_Id_Or_Reg_Number__c,application.Id) != null);
        System.assert(new ApplicationProfileSelector().getApplicationProfilesbyAppIdSet(applicationIds) != null);
        test.stopTest();
    }
}
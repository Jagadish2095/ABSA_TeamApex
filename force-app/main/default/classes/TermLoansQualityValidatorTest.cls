/**
* This is the Test Class for theTerm Loans Quality Validator (COVID 19) Controller
*
* @author  Himanshu Nimje
* @since   2020-11-30
*/

@isTest
public class TermLoansQualityValidatorTest {
    
    
    @testSetup
    public static void dataCreation() {
        insertUser();
        
        Account account = new Account();
        account.Name = 'Test Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;
        
        BusinessHours bh = [SELECT Id, Name FROM BusinessHours where Name = '24 Hours including Public Holidays'];
        User u = [SELECT Id, UserRoleId FROM User LIMIT 1];
        
        Case caseRec = new Case();
        caseRec.BusinessHoursId = bh.Id;
        caseRec.Subject = 'Test Case';
        caseRec.AccountId = account.Id;
        //caseRec.Collateral_Consultant__c = '';
        //caseRec.Collateral_Processing_Consultant__c = '';
        //caseRec.Collateral_Validator__c = '';
        caseRec.Banker_RE__c = u.UserRoleId;
        //caseRec.Fulfilment_Consultant__c = '';
        //insert caseRec;
        
        
        Opportunity oppCovid = new Opportunity();
        oppCovid.Name = 'Covid Onboarding';
        oppCovid.CloseDate = Date.today();
        oppCovid.StageName = 'New';
        oppCovid.AccountId = account.Id;
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Maintenance').getRecordTypeId();
        oppCovid.RecordTypeId = recordTypeId;
        insert oppCovid;
    }
    @future
    private static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Banker%' LIMIT 1];
        UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];
        
        User futureUser = new User(
            ProfileId = p.Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            SiteCode__c = '8198',
            SiteType__c = '034',
            Teller_Operator_Code__c = '12345',
            Supervisor__c = '0',
            Division__c = 'RBB',
            UserRoleId = r.Id
        );
        insert(futureUser);
    }
    
    
    public static testMethod void testfetchUser() {
        Test.startTest();
        System.assert((TermLoansQualityValidator.fetchUser())!= null);
        Test.stopTest();
    }
    
    public static testMethod void testSubmitDecision() {
        Test.startTest();
        System.assert((TermLoansQualityValidator.submitDecision(oppData().Id,'Accepted','' ,'Passed','testUser'))!= null);
        Test.stopTest();
    }
    
    public static testMethod void testSubmitDecisionExpection() {
        Test.startTest();
        System.assert((TermLoansQualityValidator.submitDecision(oppData().Id,'','' ,'',''))== null);
        Test.stopTest();
    }
    
    public static testMethod void testSubmitDecisionNegative() {
        Test.startTest();
        System.assert((TermLoansQualityValidator.submitDecision(oppData().Id,'Rejected','' ,'Passed','testUser'))!= null);
        Test.stopTest();
    }
    private static Opportunity oppData() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Covid Onboarding' LIMIT 1];
        return opp;
    }
}
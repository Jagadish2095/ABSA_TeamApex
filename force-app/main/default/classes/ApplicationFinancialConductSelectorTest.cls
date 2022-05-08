/**
 * This is the Test Class for the ApplicationFinancialConductSelector
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-26
*/
@IsTest
public class ApplicationFinancialConductSelectorTest {
    @testSetup
    public static void dataCreation() {
        Opportunity opp = new Opportunity();
        opp.Name = 'Cheque Credit Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        insert opp;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.id;
        app.Account_Access__c = 'Cellphone';
        app.Surplus_Cash__c = 'Fixed Deposits';
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'Dr';
        app.FirstNameSignature__c = 'Rob';
        app.SurnameSignature__c = 'Robbello';
        app.Signing_Date__c = System.today();
        insert app;

        ChequeAndOverdraftControllerTest.addConductData(app.Id);
    }

    static testMethod void testGetSObjectType() {
        System.assert(new ApplicationFinancialConductSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {
        System.assert(new ApplicationFinancialConductSelector().getSObjectFieldList() != null);
    }

    static testMethod void testAaSelectMethods() {
        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        Application_Financial_Conduct__c appFinCon = new ApplicationFinancialConductSelector().selectByApplicationId(app.Id).get(0);
        Set<ID> idSet = new Set<ID>();
        idSet.add(appFinCon.Id);

        System.assert(new ApplicationFinancialConductSelector().selectById(idSet) != null);
        System.assert(new ApplicationFinancialConductSelector().selectByApplicationId(app.Id) != null);
        System.assert(new ApplicationFinancialConductSelector().selectApplicationFinancialById(appFinCon.Id) != null);
        System.assert(new ApplicationFinancialConductSelector().selectApplicationFinancialByAccount(appFinCon.Application__c, new Set<String>{appFinCon.Account_Name_Number__c}) != null);
    }
}
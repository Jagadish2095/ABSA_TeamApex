/**
 * Test class for ApplicationFinancialInformationSelector class
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-09-20
**/
@IsTest
public class ApplicationFinancialInfoSelectorTest {
    @testSetup
    public static void dataCreation() {
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Maintenance').getRecordTypeId();

        Account account = new Account();
		account.Name = 'Test Account';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
        insert account;

        Opportunity opp5 = new Opportunity();
		opp5.Name = 'Cheque Credit Onboarding';
		opp5.CloseDate = Date.today();
		opp5.StageName = 'New';
		opp5.AccountId = account.Id;
		opp5.RecordTypeId = recordTypeId;
		opp5.Illustrative_Decision__c = false;
        insert opp5;

        Application__c app2 = new Application__c();
		app2.Opportunity__c = opp5.id;
		//app2.Transactional_Account__c = '11026 Absa Wealth Business';
		app2.Account_Access__c = 'Cellphone';
		//app2.Foreign_Services__c = 'Currency Swap (Hedging Instruments)';
		app2.Surplus_Cash__c = 'Fixed Deposits';
		app2.Borrowing_Requiment_General__c = 'Credit Card';
		//app2.Borrowing_requiment_Assest_Acquisition__c = 'Business /BACKED Property Finance';
		app2.Protection_Of_Services__c = 'Retirement';
		app2.Title__c = 'Dr';
		app2.FirstNameSignature__c = 'Rob';
		app2.SurnameSignature__c = 'Rob Van Wyk';
		app2.Signing_Date__c = System.today();
        insert app2;

        List<Application_Financial_Information__c> appFinInfoList = new List<Application_Financial_Information__c>();
		Application_Financial_Information__c appFinInfo = new Application_Financial_Information__c();
		appFinInfo.Application__c = app2.Id;
		appFinInfo.Client_Name__c = 'REBELLO';
		appFinInfo.Year_Selection__c = 'Forecast';
		appFinInfo.Financial_Statement_Type__c = 'Draft';
		appFinInfo.Statement_Date_Year_end__c = Date.today();
		appFinInfo.Auditor_s_Certificate_Date__c = Date.today();
		appFinInfo.Date_Financials_Signed_Client__c = Date.today();
		appFinInfo.Financial_Statement_Qualified_Issue__c = 'No';
		appFinInfo.Qualification_Comments__c = 'Comments';
		appFinInfo.No_of_Days__c = 365;
        appFinInfoList.add(appFinInfo);

		appFinInfo = new Application_Financial_Information__c();
		appFinInfo.Application__c = app2.Id;
		appFinInfo.Client_Name__c = 'REBELLO';
		appFinInfo.Year_Selection__c = 'Year1';
		appFinInfo.Financial_Statement_Type__c = 'Draft';
		appFinInfo.Statement_Date_Year_end__c = Date.today();
		appFinInfo.Auditor_s_Certificate_Date__c = Date.today();
		appFinInfo.Date_Financials_Signed_Client__c = Date.today();
		appFinInfo.Financial_Statement_Qualified_Issue__c = 'No';
		appFinInfo.Qualification_Comments__c = 'Comments';
		appFinInfo.No_of_Days__c = 365;
        appFinInfoList.add(appFinInfo);

		appFinInfo = new Application_Financial_Information__c();
		appFinInfo.Application__c = app2.Id;
		appFinInfo.Client_Name__c = 'REBELLO';
		appFinInfo.Year_Selection__c = 'Year2';
		appFinInfo.Financial_Statement_Type__c = 'Draft';
		appFinInfo.Statement_Date_Year_end__c = Date.today();
		appFinInfo.Auditor_s_Certificate_Date__c = Date.today();
		appFinInfo.Date_Financials_Signed_Client__c = Date.today();
		appFinInfo.Financial_Statement_Qualified_Issue__c = 'No';
		appFinInfo.Qualification_Comments__c = 'Comments';
		appFinInfo.No_of_Days__c = 365;
        appFinInfoList.add(appFinInfo);

		appFinInfo = new Application_Financial_Information__c();
		appFinInfo.Application__c = app2.Id;
		appFinInfo.Client_Name__c = 'REBELLO';
		appFinInfo.Year_Selection__c = 'Year3';
		appFinInfo.Financial_Statement_Type__c = 'Draft';
		appFinInfo.Statement_Date_Year_end__c = Date.today();
		appFinInfo.Auditor_s_Certificate_Date__c = Date.today();
		appFinInfo.Date_Financials_Signed_Client__c = Date.today();
		appFinInfo.Financial_Statement_Qualified_Issue__c = 'No';
		appFinInfo.Qualification_Comments__c = 'Comments';
		appFinInfo.No_of_Days__c = 365;
		appFinInfoList.add(appFinInfo);
        insert appFinInfoList;
    }

    static testMethod void testGetSObjectType() {

        System.assert(new ApplicationFinancialInformationSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {

        System.assert(new ApplicationFinancialInformationSelector().getSObjectFieldList() != null);
    }

    static testMethod void testSelectById() {
        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        Application_Financial_Information__c application = new ApplicationFinancialInformationSelector().selectByApplicationId(app.Id).get(0);
        Set<ID> idSet = new Set<ID>();
        idSet.add(application.Id);

        System.assert(new ApplicationFinancialInformationSelector().selectById(idSet) != null);
    }

    static testMethod void testSelectByApplicationId() {
        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        System.assert(new ApplicationFinancialInformationSelector().selectByApplicationId(app.Id) != null);
    }

    static testMethod void testSelectApplicationFinancialById() {
        Application_Financial_Information__c appFinInfo = [SELECT Id, Name FROM Application_Financial_Information__c LIMIT 1];
        Application_Financial_Information__c appFinInfo1 = new ApplicationFinancialInformationSelector().selectApplicationFinancialById(appFinInfo.Id);
    }
}
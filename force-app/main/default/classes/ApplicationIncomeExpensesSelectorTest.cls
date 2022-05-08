/**
 * @description       : Test class for ApplicationIncomeExpenseSelector class
 * @author            : englarmerdge.mongwe@absa.africa
 * @group             :
 * @last modified on  : 06-22-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   06-22-2021   englarmerdge.mongwe@absa.africa   Initial Version
**/
@IsTest
public class ApplicationIncomeExpensesSelectorTest {
   /**
   * @description       : Test data creation Method for ApplicationIncomeExpenseSelector class
   * @author            : englarmerdge.mongwe@absa.africa
   **/
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

        List<Application_Income_and_Expense__c> appIncoExpList = new List<Application_Income_and_Expense__c>();
        Application_Income_and_Expense__c appIncoExp = new Application_Income_and_Expense__c();
        appIncoExp.Accounts_Orchestration_JSON__c = '';
        appIncoExp.Applicant_Bureau_Value__c = 0.00;
        appIncoExp.Applicant_Type__c = 'Spouse';
        appIncoExp.Applicant_Value__c = 0.00;
        appIncoExp.Application__c = app2.Id;
        appIncoExp.Bureau_Value__c = 0.00;
        appIncoExp.Business_Value__c = 0.00;
        appIncoExp.Category__c = '';
        appIncoExp.Client_Code__c = 'SNIFFEL001';
        appIncoExp.Cost_of_Current_Faclity_Settlements__c = 0.00;
        appIncoExp.Cost_of_New_Facility__c = 0.00;
        appIncoExp.Credit_Cards__c = 0.00;
        appIncoExp.Expense_Value__c = '0.00';
        appIncoExp.Household_Value__c = 0.00;
        appIncoExp.Necessary_Expenses_Shortfall__c = 0.00;
        appIncoExp.Operation_Type__c = '';
        appIncoExp.Spouse_Bureau_Value__c = 0.00;
        appIncoExp.Spouse_Value__c = 0.00;
        appIncoExp.Stress_Allowance__c = 0.00;
        appIncoExp.Total_Absa_Instalments__c = 0.00;
        appIncoExp.Total_External_Instalments__c = 0.00;
        appIncoExp.Total_Living_Expense__c = 0.00;
        appIncoExp.Total_Maximum_Applicant__c = 0.00;
        appIncoExp.Total_Maximum_Spouse_Value__c = 0.00;
        appIncoExp.Total_MDI_Adjusted__c = 0.00;
        appIncoExp.Total_Monthly_Household_Income__c = 0.00;
        appIncoExpList.add(appIncoExp);

        appIncoExp = new Application_Income_and_Expense__c();
        appIncoExp.Accounts_Orchestration_JSON__c = '';
        appIncoExp.Applicant_Bureau_Value__c = 0.00;
        appIncoExp.Applicant_Type__c = 'Spouse';
        appIncoExp.Applicant_Value__c = 0.00;
        appIncoExp.Application__c = app2.Id;
        appIncoExp.Bureau_Value__c = 0.00;
        appIncoExp.Business_Value__c = 0.00;
        appIncoExp.Category__c = '';
        appIncoExp.Client_Code__c = 'SNIFFEL001';
        appIncoExp.Cost_of_Current_Faclity_Settlements__c = 0.00;
        appIncoExp.Cost_of_New_Facility__c = 0.00;
        appIncoExp.Credit_Cards__c = 0.00;
        appIncoExp.Expense_Value__c = '0.00';
        appIncoExp.Household_Value__c = 0.00;
        appIncoExp.Necessary_Expenses_Shortfall__c = 0.00;
        appIncoExp.Operation_Type__c = '';
        appIncoExp.Spouse_Bureau_Value__c = 0.00;
        appIncoExp.Spouse_Value__c = 0.00;
        appIncoExp.Stress_Allowance__c = 0.00;
        appIncoExp.Total_Absa_Instalments__c = 0.00;
        appIncoExp.Total_External_Instalments__c = 0.00;
        appIncoExp.Total_Living_Expense__c = 0.00;
        appIncoExp.Total_Maximum_Applicant__c = 0.00;
        appIncoExp.Total_Maximum_Spouse_Value__c = 0.00;
        appIncoExp.Total_MDI_Adjusted__c = 0.00;
        appIncoExp.Total_Monthly_Household_Income__c = 0.00;
        appIncoExpList.add(appIncoExp);
        insert appIncoExpList;
    }
    
    /**
   * @description       : Test Method for ApplicationIncomeExpenseSelector class
   * @author            : englarmerdge.mongwe@absa.africa
   **/
    @isTest
    public static void testGetSObjectType() {
        System.assert(new ApplicationIncomeExpensesSelector().getSObjectType() != null);
    }

     /**
   * @description       : Test Method for ApplicationIncomeExpenseSelector class
   * @author            : englarmerdge.mongwe@absa.africa
   **/
   @isTest
    public static void testGetSObjectFieldList() {
        System.assert(new ApplicationIncomeExpensesSelector().getSObjectFieldList() != null);
    }
    
     /**
   * @description       : Test Method for ApplicationIncomeExpenseSelector class
   * @author            : englarmerdge.mongwe@absa.africa
   **/
    @isTest
    public static void testSelectByAppType() {
        Application__c apps = [SELECT Id, Name FROM Application__c LIMIT 1];
        System.assert(new ApplicationIncomeExpensesSelector().selectByAppType(apps.Id) != null);
    }
     /**
   * @description       : Test Method for ApplicationIncomeExpenseSelector class
   * @author            : englarmerdge.mongwe@absa.africa
   **/
    @isTest
    public static void testSelectByExpenseType() {
        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        System.assert(new ApplicationIncomeExpensesSelector().selectByExpenseType(app.Id,'Applicant') != null);
    }
}
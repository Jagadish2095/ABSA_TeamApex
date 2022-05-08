/**
 * Test class for ApplicationFinancialInformation class
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-09-20
**/
@IsTest
public class ApplicationFinancialInformationTest {
    @testSetup
    public static void dataCreation() {
        FinancialInformationTriggerTest.FinancialInfoTriggertest();

        Account acc = [SELECT Id, Name FROM Account WHERE CIF__c = 'CLOSE  001' LIMIT 1];

        List<Financial_Information__c> finInfoList = new List<Financial_Information__c>();
		Financial_Information__c finInfo = new Financial_Information__c();
		finInfo.Account__c = acc.Id;
		finInfo.Client_Name__c = 'REBELLO';
		finInfo.Year_Selection__c = 'Forecast';
		finInfo.Financial_Statement_Type__c = 'Draft';
		finInfo.Statement_Date_Year_end__c = Date.today();
		finInfo.Auditor_s_Certificate_Date__c = Date.today();
		finInfo.Date_Financials_Signed_Client__c = Date.today();
		finInfo.Financial_Statement_Qualified_Issue__c = 'No';
		finInfo.Qualification_Comments__c = 'Comments';
		finInfo.No_of_Days__c = 365;
		finInfo.Intangible_Assets__c = 0.00;
		finInfo.Loans_from_Associates__c = 0.00;
		finInfo.Loans_from_Principals_Ceded__c = 0.00;
		finInfo.Loans_from_Principals_Non_Ceded__c = 0.00;
		finInfo.Loans_to_Principals_Associates__c = 0.00;
		finInfo.Other_Assets__c = 0.00;
		finInfo.Other_Current_Assets__c = 0.00;
		finInfo.Other_Current_Liabilities__c = 0.00;
		finInfo.Revaluation_Of_Assets__c = 0.00;
		finInfo.Total_Fixed_Investments_Cash_and_Market__c = 0.00;
		finInfo.Month_With_Highest_Debit_Balance__c = '12/2122';
		finInfo.Month_with_highest_shortfall__c = '01/2122';
		finInfo.Cash_Marketable_Securities__c = 100000;
		finInfo.Property_Plant_Equipment__c = 100000;
		finInfo.Shareholders_Funds_Capital_Account__c = 100000;
        finInfoList.add(finInfo);

		finInfo = new Financial_Information__c();
		finInfo.Account__c = acc.Id;
		finInfo.Client_Name__c = 'REBELLO';
		finInfo.Year_Selection__c = 'Year2';
		finInfo.Financial_Statement_Type__c = 'Draft';
		finInfo.Statement_Date_Year_end__c = Date.today();
		finInfo.Auditor_s_Certificate_Date__c = Date.today();
		finInfo.Date_Financials_Signed_Client__c = Date.today();
		finInfo.Financial_Statement_Qualified_Issue__c = 'No';
		finInfo.Qualification_Comments__c = 'Comments';
		finInfo.No_of_Days__c = 365;
		finInfo.Intangible_Assets__c = 0.00;
		finInfo.Loans_from_Associates__c = 0.00;
		finInfo.Loans_from_Principals_Ceded__c = 0.00;
		finInfo.Loans_from_Principals_Non_Ceded__c = 0.00;
		finInfo.Loans_to_Principals_Associates__c = 0.00;
		finInfo.Other_Assets__c = 0.00;
		finInfo.Other_Current_Assets__c = 0.00;
		finInfo.Other_Current_Liabilities__c = 0.00;
		finInfo.Revaluation_Of_Assets__c = 0.00;
		finInfo.Total_Fixed_Investments_Cash_and_Market__c = 0.00;
		finInfo.Month_With_Highest_Debit_Balance__c = '12/2122';
		finInfo.Month_with_highest_shortfall__c = '01/2122';
		finInfo.Cash_Marketable_Securities__c = 100000;
		finInfo.Property_Plant_Equipment__c = 100000;
		finInfo.Shareholders_Funds_Capital_Account__c = 100000;
        finInfoList.add(finInfo);

		finInfo = new Financial_Information__c();
		finInfo.Account__c = acc.Id;
		finInfo.Client_Name__c = 'REBELLO';
		finInfo.Year_Selection__c = 'Year3';
		finInfo.Financial_Statement_Type__c = 'Draft';
		finInfo.Statement_Date_Year_end__c = Date.today();
		finInfo.Auditor_s_Certificate_Date__c = Date.today();
		finInfo.Date_Financials_Signed_Client__c = Date.today();
		finInfo.Financial_Statement_Qualified_Issue__c = 'No';
		finInfo.Qualification_Comments__c = 'Comments';
		finInfo.No_of_Days__c = 365;
		finInfo.Intangible_Assets__c = 0.00;
		finInfo.Loans_from_Associates__c = 0.00;
		finInfo.Loans_from_Principals_Ceded__c = 0.00;
		finInfo.Loans_from_Principals_Non_Ceded__c = 0.00;
		finInfo.Loans_to_Principals_Associates__c = 0.00;
		finInfo.Other_Assets__c = 0.00;
		finInfo.Other_Current_Assets__c = 0.00;
		finInfo.Other_Current_Liabilities__c = 0.00;
		finInfo.Revaluation_Of_Assets__c = 0.00;
		finInfo.Total_Fixed_Investments_Cash_and_Market__c = 0.00;
		finInfo.Month_With_Highest_Debit_Balance__c = '12/2122';
		finInfo.Month_with_highest_shortfall__c = '01/2122';
		finInfo.Cash_Marketable_Securities__c = 100000;
		finInfo.Property_Plant_Equipment__c = 100000;
		finInfo.Shareholders_Funds_Capital_Account__c = 100000;
		finInfoList.add(finInfo);
        insert finInfoList;
    }

    public static testMethod void testAllGetMethods() {
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        Test.startTest();
        System.assertNotEquals(null, ApplicationFinancialInformation.getFinancialInformation(acc.Id));
        System.assertNotEquals(null, ApplicationFinancialInformation.getApplicationClientDetails(null,acc.Id));
        System.assertNotEquals(null, ApplicationFinancialInformation.getApplicationFinancialsDocuments(acc.Id));
        System.assertNotEquals(null, ApplicationFinancialInformation.getAccClientType(acc.Id));
		ApplicationFinancialInformation.createCaseforCreditSupportConsultant(acc.Id);
        System.assertNotEquals(null, ApplicationFinancialInformation.getFinancialByAccountId(acc.Id));
        Test.stopTest();
    }
}
/**
 * @description       : Controller for Financials, Income Statements & Balance Sheets
 * @author            : Englarmerge Mongwe
 * @last modified on  : 2021-06-18
 * @last modified by  : Saurabh
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-06-15   Englarmerge Mongwe   Initial Version
**/

 @IsTest
public class HistoricalFinancialDataControllerTest {
    /**
    * @description test setup method
    * @author Englarmerge Mongwe | 2021-06-15 
    **/
    @testSetup
    public static void dataCreation() {
        //FinancialInformationTriggerTest.FinancialInfoTriggertest();

        Account acc = new Account();
		acc.Name = 'Ndumiso';
		acc.CIF__c = 'BRINKJH060';
		acc.Client_Type__c = 'Private Individual';
		acc.Sic = '35790';
		acc.AccountNumber = '0';
		acc.Registration_Number__c = '1990/011515/23';
		insert acc;

		Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
		Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		Id onboardingrecId = rtMapByName.get('Credit Onboarding').getrecordtypeId();
		Opportunity opp = new Opportunity();
		opp.Name = 'Credit Onboarding';
		opp.StageName = 'Open';
		opp.CloseDate = System.today();
		opp.AccountId = acc.Id;
		opp.RecordTypeId = onboardingrecId;
		insert opp;

        IntegrationTestDataFactory.insertIntegrationSettings(GetBalanceSheet_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{GetBalanceSheet_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(GetIncomeStatement_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{GetIncomeStatement_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    @istest
    public static void testAllGetMethods() {
        GetBalanceSheet_IH_v1_Test.balSheetTestMock();
        GetIncomeStatement_IH_v1_Test.incStatementTestMock();

		Opportunity opp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        Test.startTest();
        HistoricalFinancialDataController.getHistoricalFianancialData(opp.Id);
		System.assertNotEquals(null, opp);
        Test.stopTest();
    }
}
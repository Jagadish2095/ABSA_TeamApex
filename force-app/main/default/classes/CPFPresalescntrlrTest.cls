/**
 * @description  Test class for CPF Pre sales  Component for CPF Onboarding
 * @author  Haritha P : Absa
 * @version v1.0
 * @since   2021-05-25
 * @param cpfpresales
 * @return Pre-sales
 */
@isTest
public class CPFPresalescntrlrTest {
	@isTest
	public static void getCPFpresalesTest() {
		Account account = new Account();
		account.Name = 'Test Account';
		insert account;
		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
		insert testOpp;
		Application__c app = new Application__c();
		app.Opportunity__c = testOpp.id;
		insert app;
		Application_Product_CPF__c appPrdctcpf = new Application_Product_CPF__c();
		appPrdctcpf.Application__c = app.Id;
		insert appPrdctcpf;
		Application_Contract_Clause__c appcon = new Application_Contract_Clause__c();
		appcon.Application_Product_CPF__c = appPrdctcpf.Id;
		insert appcon;
		List<Application_Contract_Clause__c> lappcon = new List<Application_Contract_Clause__c>();
		lappcon.add(appcon);
		String objData = '{"presalesvalue":"Yes","nonrefundabledepositvalue":"Amount","nonrefundabledepositamount":6,"nonrefundabledepositpercentage":null,"multiplepurchasesvalue":"Percentage","multiplepurchaseamount":null,"multipurposepercentage":4,"proofofprevalue":"Per Phase","numberofpresales":null,"aggregateprice":null,"newperphase":[{"Application_Product_CPF__c":"a2g7Z000002IlNRQA0","Prime_rate_margin__c":"Plus per annum","Number_of_pre_sales__c":123,"Interest_service_frequency__c":"month(s)","Drawdown_inspection_fee__c":"No Fee","Interest_only_period__c":"month(s)","Valuation_fee__c":"No","CurrencyIsoCode":"ZAR","Name":"a3P7Z000000w7zG","Aggregate_price__c":123,"Phase_Number__c":"1","Type__c":"Per Phase","Interest_rate_basis__c":"Prime Rate","Margin__c":2,"Id":"a3P7Z000000w8AYUAY"},{"Application_Product_CPF__c":"a2g7Z000002IlNRQA0","Prime_rate_margin__c":"Plus per annum","Number_of_pre_sales__c":1234,"Interest_service_frequency__c":"month(s)","Drawdown_inspection_fee__c":"No Fee","Interest_only_period__c":"month(s)","Valuation_fee__c":"No","CurrencyIsoCode":"ZAR","Name":"a3P7Z000000w8AZ","Aggregate_price__c":1234556,"Phase_Number__c":"2","Type__c":"Per Phase","Interest_rate_basis__c":"Prime Rate","Margin__c":2,"Id":"a3P7Z000000w8AZUAY"}],"schedulenetsalevalue":"Yes","scheduleofsalevalue":"Yes","maxbysingleinvestor":123,"copyofstandardsalesvalue":"Yes","copiesofallsalesaggrementsvalue":"No"}';
		Application_Product_CPF__c appProductcpfrec=CPFPresalescntrlr.getAppProdctCpfRec(testOpp.Id);
		system.assertEquals(appPrdctcpf.Id, appProductcpfrec.Id);
		CPFPresalescntrlr.getAppPhaseCPFRec(testOpp.Id, 'Per Phase');
		CPFPresalescntrlr.getAppContractClauseRec(testOpp.Id, 'Other Drawdown conditions');
		CPFPresalescntrlr.insertOtherDrawDownConditions(appPrdctcpf.Id, lappcon, lappcon, 'Yes', 'Yes', system.today());
		CPFPresalescntrlr.insertPreLodgmentConditions(appPrdctcpf.Id, lappcon);
		CPFPresalescntrlr.insertpredisbursement(appPrdctcpf.Id, lappcon);
		Application_Product_CPF__c appProductcpf=CPFPresalescntrlr.updateAppPrdctcpf(appPrdctcpf.Id, objData);
	    system.assertEquals(appPrdctcpf.Id, appProductcpf.Id);
	}
}
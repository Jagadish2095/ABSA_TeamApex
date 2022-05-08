/**
* @description ApplicationContractClauseCPFSelectorTest for ApplicationContractClauseCPFSelector class
* @author  Diksha  : Absa
* @version v1.0
* @since   2020-09-07
* @param  Application Contract Clause
* @return Application Contract Clause
*/
@isTest
public class ApplicationContractClauseCPFSelectorTest {
	@isTest
	public static void insertOtherTransactions() {
		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Non Individual';
		account.CASA_Reference_Number__c = '12233';
		account.CASA_Screening_Status__c = 'Cancelled';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		insert account;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Application__c app = new Application__c();
		app.All_transaction_type__c = '';
		app.Payment__c = '';
		app.Withdrawal__c = '';
		app.Deposit__c = '';
		app.Returned_Transactions__c = '';
		app.Scheduled_transaction__c = '';
		app.Notification_time__c = Date.today();
		app.Minimum_amount__c = '';
		app.Account_to_be_debited_monthly_with_the_c__c = '';
		app.Number_of_authorisations_that_will_be_re__c = '';
		app.Number_of_main_users__c = '';
		app.Fee_Structure_code__c = '';
		app.Absa_online_for_business_BIB__c = '';
		app.Cell_phone_banking__c = '';
		app.Telephone_banking__c = '';
		app.Notifyme__c = '';
		app.Funds_transfer__c = '';
		app.Bill_payments__c = '';
		app.Own_defined_payments__c = '';
		app.Future_dated_payments__c = '';
		app.Stop_order_payments__c = '';
		app.Account_Access__c = 'Cellphone';
		app.Foreign_Services__c = 'Currency Swap (Hedging Instruments);Trade Finance Products';
		app.Surplus_Cash__c = 'Fixed Deposits';
		app.Borrowing_Requiment_General__c = 'Credit Card';
		app.Borrowing_requiment_Assest_Acquisition__c = 'Business-Backed Property Finance;Commercial Property Finance';
		app.Protection_Of_Services__c = 'Retirement';
		app.Title__c = 'dd';
		app.FirstNameSignature__c = 'Litha';
		app.SurnameSignature__c = 'Nosekeleza';
		app.Signing_Date__c = System.today();
		app.Opportunity__c = testOpp.Id;
		app.Account_Number__c = '123456789';
		insert app;

		Application_Product_CPF__c appPrdctcpf = new Application_Product_CPF__c();
		appPrdctcpf.Application__c = app.Id;
		insert appPrdctcpf;

		Application_Contract_Clause__c clause = new Application_Contract_Clause__c();
		clause.Category__c = 'CPF Application';
		clause.Application_Product_CPF__c = appPrdctcpf.Id;
		//insert clause;

		test.startTest();
		ApplicationContractClauseCPFSelector obj = new ApplicationContractClauseCPFSelector();
		obj.getSObjectType();
		obj.getSObjectFieldList();
		obj.selectByAppPrdctId(appPrdctcpf.Id, 'CPF Application', '');
		obj.selectByAppPrdctwithtypecategory(appPrdctcpf.Id, 'CPF Application', 'Lease');
		List<Application_Contract_Clause__c> appContractLst=obj.selectByAppPrdctIdAndType(appPrdctcpf.Id, 'CPF Application');
		system.assertNotEquals(null, appContractLst);
		test.stopTest();
	}
}
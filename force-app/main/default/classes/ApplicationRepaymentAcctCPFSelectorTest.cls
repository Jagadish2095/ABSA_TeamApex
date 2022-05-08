/**
 * @description       : Test class for ApplicationRepaymentAcctCPFSelector
 * @author            :Haritha
 * @last modified on  : 2021-07-09
 * @last modified by  :
 * Modifications Log
 * Ver   Date        Author   Modification
 * 1.0   2021-06-17      Initial Version
 **/
@IsTest
public class ApplicationRepaymentAcctCPFSelectorTest{
	@isTest
	static void testMethodforApplicationRepayment(){
		Opportunity opp = new Opportunity();
		opp.Name = 'EPP';
		opp.StageName = 'New';
		opp.CloseDate = Date.today()+10;
		Insert opp;

		Application__c app = new Application__c();
		app.Opportunity__c = opp.Id;

		insert app;
		Application_Product_CPF__c appPrdctcpf = new Application_Product_CPF__c();
		appPrdctcpf.Application__c = app.Id;
		insert appPrdctcpf;

		ApplicationRepaymentAccountCPFSelector selector = new ApplicationRepaymentAccountCPFSelector();

		Test.startTest();
		list<Application_Repayment_Account_CPF__c> appRepaymentAcctCPF = selector.selectByAppPrdctId(appPrdctcpf.Id);
		system.assertNotEquals(null, appRepaymentAcctCPF, 'not null');
		list<Application_Repayment_Account_CPF__c> appRepaymentAcctCPF1 = selector.selectByAppPrdctIdAndType(appPrdctcpf.Id, 'secondary');
		list<Application_Repayment_Account_CPF__c> aralist = selector.selectAraByAppPrdctId(appPrdctcpf.Id);
		Test.stopTest();
	}
}
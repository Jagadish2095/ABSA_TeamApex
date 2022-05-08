@IsTest
public with sharing class ApplicationLeaseCPFSelectorTest{
	@isTest
	static void testSelectByApplicationPrdctId(){
		Opportunity opp = new Opportunity();
		opp.Name = 'EPP';
		opp.StageName = 'Not Interested';
		opp.CloseDate = Date.today()+10;
		Insert opp;

		Application__c app = new Application__c();
		app.Opportunity__c = opp.Id;
		insert app;
        Application_Product_CPF__c appPrdctcpf=new Application_Product_CPF__c();
        appPrdctcpf.Application__c=app.Id;
        insert appPrdctcpf;

		Application_Lease_CPF__c appLeaseCPF = new Application_Lease_CPF__c();
		appLeaseCPF.Application_Product_CPF__c = appPrdctcpf.Id;
		insert appLeaseCPF;
		ApplicationLeaseCPFSelector selector = new ApplicationLeaseCPFSelector();

		Test.startTest();
		LIST<Application_Lease_CPF__c> appProdCpf = selector.selectByAppId(appPrdctcpf.Id);
		Test.stopTest();
	}
}
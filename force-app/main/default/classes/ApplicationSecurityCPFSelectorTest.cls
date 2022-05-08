/**
 * @description ApplicationSecurityCPFSelectorTest Description
 *
 */
@IsTest
public class ApplicationSecurityCPFSelectorTest{
	@isTest
	static void testSelectBySecOffApplicationPrdctId(){
		Opportunity opp = new Opportunity();
		opp.Name = 'EPP';
		opp.StageName = 'Not Interested';
		opp.CloseDate = Date.today()+10;
		Insert opp;

		Application__c app = new Application__c();
		app.Opportunity__c = opp.Id;

		insert app;
		Application_Product_CPF__c appPrdctcpf = new Application_Product_CPF__c();
		appPrdctcpf.Application__c = app.Id;
		insert appPrdctcpf;
		ApplicationSecurityCPFSelector selector = new ApplicationSecurityCPFSelector();
		Test.startTest();
		list<Application_Security_CPF__c> secOfferedcCPF = selector.selectByAppPrdctId(appPrdctcpf.Id, 'Limited Guarantee');
		list<Application_Security_CPF__c> secOfferedcCPF1 = selector.selectByAppPrdctwithtypecategory(appPrdctcpf.Id, 'Limited Guarantee', 'Other');
		selector.selectByAppPrdctIdandClass(appPrdctcpf.Id, 'Limited Guarantee', 'Other');
		selector.selectByAppPrdctwithtypecategoryandClass(appPrdctcpf.Id, 'Other cession', 'Limited Guarantee', 'Other');
		System.assertNotEquals(selector.selectByAppPrdctwithClass(appPrdctcpf.Id, 'New'), null, 'Not null');
		selector.selectByAppPrdctMortgageBondType(appPrdctcpf.Id, 'Other cession', 'Registration of mortgage bond by borrower', 'New');
		Test.stopTest();
	}
}
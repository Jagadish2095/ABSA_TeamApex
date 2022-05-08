/**
 * @description       :Test Class for ApplicationProductCPFSelector
 * @author            :Diksha /Haritha
 * @last modified on  : 2021-07-12
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-06-08      Initial Version
 **/
@IsTest
public class ApplicationProductCPFSelectorTest{
	@isTest
	public static void testSelectByApplicationPrdctId(){
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
		ApplicationProductCPFSelector selector = new ApplicationProductCPFSelector();
		Test.startTest();
		Application_Product_CPF__c appProdCpf = selector.selectByAppId(app.Id);
		List<Application_Product_CPF__c> appProdCpf2 = selector.selectListByAppId(app.Id);
		system.assertNotEquals(null, appProdCpf2);
		Application_Product_CPF__c appProdCpf1 = selector.selectById(appPrdctcpf.Id);
		system.assertEquals(appPrdctcpf.Id, appProdCpf1.Id);
		Test.stopTest();
	}
}
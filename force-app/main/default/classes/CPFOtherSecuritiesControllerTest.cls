/**
 * @description       : Test class for CPFOtherSecuritiesController
 * @author            : Tinashe/Rajesh
 * @last modified on  : 2021-07-09
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-06-08      Initial Version
**/
@isTest
public class CPFOtherSecuritiesControllerTest {
    @isTest
    public static void getCPFOtherSecuritiesControllerTest(){
         Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        insert testOpp;
        Application__c app= new Application__c();
        app.Opportunity__c=testOpp.id;
        insert app;
		Application_Product_CPF__c appPrdctcpf=new Application_Product_CPF__c();
        appPrdctcpf.Application__c=app.Id;
        insert appPrdctcpf;
       Application_Security_CPF__c secuCession =new Application_Security_CPF__c();
    	secuCession.Application_Product_CPF__c =appPrdctcpf.Id;
    	secuCession.Category__c='Other';
    	secuCession.Type__c='Other';
    	insert secuCession;
    	List<Application_Security_CPF__c> lsecOff =new List<Application_Security_CPF__c>();
    	lsecOff.add(secuCession);

        CPFOtherSecuritiesController.getSecurityofferedRec(testOpp.Id,'New');
        CPFOtherSecuritiesController.InsertNewSecurityCessionsCpfRec(testOpp.Id,lsecOff);
        LIST<Application_Security_CPF__c> appSecuritylst = CPFOtherSecuritiesController.getExistingSecurityofferedRec(testOpp.Id);
    	system.assertNotEquals(null, appSecuritylst);
        CPFOtherSecuritiesController.InsertExistingSecurityCessionsCpfRec(testOpp.Id,lsecOff);
    }
}
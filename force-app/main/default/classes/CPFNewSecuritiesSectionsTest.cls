/**
 * @description       : Test class for CPFNewSecurities Class
 * @author            :Diksha wasekar
 * @last modified on  : 2021-07-09
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2021-07-09      Initial Version
**/
@isTest
public class CPFNewSecuritiesSectionsTest {
   @isTest 
   public static void getCPFNewSecuritiesSectionsTest(){
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


        CPFNewSecuritiesSections.getAppProdctCpfRec(testOpp.Id);
    	CPFNewSecuritiesSections.insertCrossCollRec(appPrdctcpf.Id, 'secprovided', 'FacilitiesValue', 'specificdetails', 'crossCollOptionGiven', 'SecurityClass');
        CPFNewSecuritiesSections.insertCrossDefaultClause(appPrdctcpf.Id, 'test', 'test','SecurityClass');
        CPFNewSecuritiesSections.insertCrossDefaultClauseExist(appPrdctcpf.Id, 'test', 'test','SecurityClass');
        CPFNewSecuritiesSections.insertSubAgreeforLoanAcct(appPrdctcpf.Id, 'SubordinationAgreementofLoanAccounts', 'claimsby', 'CPAdocumentversion', 'SecurityClass');
        CPFNewSecuritiesSections.insertSubAgreeforLoanAcctExist(appPrdctcpf.Id,'SubordinationAgreementofLoanAccounts',' claimsby',system.today(),'SecurityClass'); 
        CPFNewSecuritiesSections.insertUndertakingtoinjectcostoverrunfunds(appPrdctcpf.Id, 'Undertakingtoinjectcostoverrunfunds', 'whowillberesponsiblepay', 'SecurityClass');
        CPFNewSecuritiesSections.insertUndertakingtoinjectcostoverrunfundsExist(appPrdctcpf.Id, 'Undertakingtoinjectcostoverrunfunds', 'whowillberesponsiblepay', system.today(),'SecurityClass');        
        CPFNewSecuritiesSections.insertCrossguarantee(appPrdctcpf.Id, 'Crossguarantee', 'Includingcessionofclaimsandloanaccount', 'cpfreleased', 12, 12, 'releasecondition', 'SecurityClass','Parent');
        CPFNewSecuritiesSections.insertCrossguaranteeexist(appPrdctcpf.Id, 'Crossguarantee', 'Includingcessionofclaimsandloanaccount', 'cpfreleased', 12, 12, 'releasecondition', 'SecurityClass','Parent');
        CPFNewSecuritiesSections.insertCrossCollRecExist(appPrdctcpf.Id, 'CrossCollateralisation', 'Includingcessionofclaimsandloanaccount', 'cpfreleased','releasecondition', 'SecurityClass');
        CPFNewSecuritiesSections.getApplicationSecCpfRecExist(testOpp.Id, 'SecurityType', 'SecurityClass');
        CPFNewSecuritiesSections.getApplicationSecCpfRec(testOpp.Id, 'SecurityType', 'SecurityClass');
        CPFNewSecuritiesSections.updateAppPrdctcpf(appPrdctcpf.Id, 'SecurityProviderConsent');
        List<OpportunityLineItem> oppline=CPFNewSecuritiesSections.getprodName(testOpp.Id);
        system.assertNotEquals(null, oppline, 'not null');
        
        
    }


}
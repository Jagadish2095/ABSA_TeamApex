/**
 * @description       :Test class for CPFConditionTabSectionscntrl
 * @author            :Rajesh/Anka 
 * @last modified on  : 2021-07-29
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2021-06-07      Initial Version
**/
@isTest
public class CPFConditionsTabSectionscntrlrTest {
    @isTest
    public static void geconditionssectionsCPFTest(){
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
        Application_Contract_Clause__c limsecOff =new Application_Contract_Clause__c();
        limsecOff.Application_Product_CPF__c =appPrdctcpf.Id;
        limsecOff.Category__c='CPF Application';
        limsecOff.Type__c='Lease';
        insert limsecOff;
        List<Application_Contract_Clause__c> lsecOff =new List<Application_Contract_Clause__c>();
        lsecOff.add(limsecOff);
        Application_Contract_Clause__c appconclause=new Application_Contract_Clause__c();
        appconclause.Application_Product_CPF__c=appPrdctcpf.Id;
        insert appconclause;
        list<Application_Contract_Clause__c>lappconclause=new list<Application_Contract_Clause__c>();
        lappconclause.add(appconclause);
        string obj='{"ObligorincorpoutsideofSA":"Yes","Environmentalpermits":"Yes","Financialassistance":"Yes","Electricalcompliancecertificate":"Yes","Newlyformedcompany":"No","Borrowersconvalue":12,"purchasepricevalue":12,"Preletval":"Yes","Preletreviewval":"Yes","Restraintagainstfreeval":"Yes","leaselist":[{"Application_Product_CPF__c":"a2g7Z000002IlNRQA0","Description__c":"test","Type__c":"Lease","Category__c":"CPF Application","Id":"a2l7Z000000VfzVQAS","CurrencyIsoCode":"ZAR","Name":"a2l7Z000000VfzL"},{"Application_Product_CPF__c":"a2g7Z000002IlNRQA0","Description__c":"test2","Type__c":"Lease","Category__c":"CPF Application","Id":"a2l7Z000000VfzWQAS","CurrencyIsoCode":"ZAR","Name":"a2l7Z000000VfzR"}],"performanceguaramtees":"No","sectioncerti":"No","bankcontractorsorinsurancecomp":"No","confirmationfrmarchitect":"No","structuralintegritycerti":"No","confirmationmechelec":"No","firedesign":"No","sufficientbudget":"No","professionalcerti":"Yes","valueofpaymade":12}';
        Application_Product_CPF__c appProductcpf=CPFConditionsTabSectionscntrlr.getAppProdctCpfRec(testOpp.Id);
        system.assertEquals(appPrdctcpf.Id, appProductcpf.Id);
        CPFConditionsTabSectionscntrlr.getAppContractClauseRec(testOpp.Id);
        CPFConditionsTabSectionscntrlr.updateAppPrdctcpfinsertAppContract(appPrdctcpf.Id,obj);
        CPFConditionsTabSectionscntrlr.updateAppPrdctcpfNorarially(appPrdctcpf.Id,'Consolidated','prop1','prop2');      
    }
    @isTest
    public static void furtherconditionssectionsCPFTest(){
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
        Application_Contract_Clause__c limsecOff =new Application_Contract_Clause__c();
        limsecOff.Application_Product_CPF__c =appPrdctcpf.Id;
        limsecOff.Category__c='CPF Application';
        limsecOff.Type__c='Further Condition Precedent';
        insert limsecOff;
        List<Application_Contract_Clause__c> lsecOff =new List<Application_Contract_Clause__c>();
        lsecOff.add(limsecOff);
        Application_Contract_Clause__c appconclause=new Application_Contract_Clause__c();
        appconclause.Application_Product_CPF__c=appPrdctcpf.Id;
        appconclause.Type__c='Further Condition Precedent'; 
        appconclause.Category__c ='CPF Application';
        insert appconclause;
        list<Application_Contract_Clause__c>lappconclause=new list<Application_Contract_Clause__c>();
        lappconclause.add(appconclause);
        Application_Product_CPF__c appProductcpf=CPFConditionsTabSectionscntrlr.getAppProdctCpfRec(testOpp.Id);
        system.assertEquals(appPrdctcpf.Id, appProductcpf.Id);
        CPFConditionsTabSectionscntrlr.getAppContractClauseRecForFurtherCond(testOpp.Id);
        CPFConditionsTabSectionscntrlr.furtherAppPrdctcpfinsertAppContract(appPrdctcpf.Id,lappconclause);
    }
    @isTest
   public static void specialconditionssectionsCPFTest(){
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
        Application_Contract_Clause__c limsecOff =new Application_Contract_Clause__c();
        limsecOff.Application_Product_CPF__c =appPrdctcpf.Id;
        limsecOff.Category__c='CPF Application';
        limsecOff.Type__c='Special Condition';
        insert limsecOff;
        List<Application_Contract_Clause__c> lsecOff =new List<Application_Contract_Clause__c>();
        lsecOff.add(limsecOff);
        Application_Contract_Clause__c appconclause=new Application_Contract_Clause__c();
        appconclause.Application_Product_CPF__c=appPrdctcpf.Id;
        appconclause.Type__c='Further Condition Precedent'; 
        appconclause.Category__c ='Special Condition';
        insert appconclause;
        list<Application_Contract_Clause__c>lappconclause=new list<Application_Contract_Clause__c>();
        lappconclause.add(appconclause);
        Application_Product_CPF__c appProductcpf=CPFConditionsTabSectionscntrlr.getAppProdctCpfRec(testOpp.Id);
        system.assertEquals(appPrdctcpf.Id, appProductcpf.Id);
        CPFConditionsTabSectionscntrlr.getAppContractClauseRecForSpecialCond(testOpp.Id);
        CPFConditionsTabSectionscntrlr.specialAppPrdctcpfinsertAppContract(appPrdctcpf.Id,lappconclause);
        List<OpportunityLineItem> opplinelst=CPFConditionsTabSectionscntrlr.getprodName(testOpp.Id);
        system.assertNotEquals(null, opplinelst);
    }
}
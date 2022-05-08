/**
 * @description       :
 * @author            :
 * @last modified on  : 2021-06-14
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-06-07      Initial Version
**/
@isTest
public class CPFProfessionalTeamControllerTest {
    @isTest
    public static void getProfessionalteamMemberCPFTest(){
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
        String objData='{"quantitysurveyor":"test1","architect":"test2","landsurveyor":"test3","civilengineer":"test4","structuralengineer":null,"mechanicalengineer":null,"electricalengineer":null,"townplanner":null,"projectmanager":null,"wetserviceengineer":null,"newProfessionalTeamMember":[{"Application_Product_CPF__c":"a2g7Z000002IlNRQA0","Member_Name__c":"diksha","Type__c":"Profession","Category__c":"CPF","Id":"a3R7Z000000LzJpUAK","CurrencyIsoCode":"ZAR","Name":"a3R7Z000000LzJp"},{"Application_Product_CPF__c":"a2g7Z000002IlNRQA0","Member_Name__c":"haritha","Type__c":"Profession","Category__c":"CPF","Id":"a3R7Z000000LzJqUAK","CurrencyIsoCode":"ZAR","Name":"a3R7Z000000LzJq"}]}';

        Test.startTest();
        Application_Product_CPF__c appprodcpf= CPFProfessionalTeamController.getAppProdctCpfRec(testOpp.Id);
        system.assertEquals(appprodcpf.Id, appPrdctcpf.Id);
        Application_Product_CPF__c appprodupdatedRec= CPFProfessionalTeamController.updateAppPrdctcpf(appPrdctcpf.Id,objData);
        system.assertNotEquals(null, appprodupdatedRec);
        List<Application_Team_Member__c> lstTeamMember=CPFProfessionalTeamController.getAppTeamMemberRec(testOpp.Id);
        system.assertNotEquals(null, lstTeamMember);
        Test.stopTest();
    }

}
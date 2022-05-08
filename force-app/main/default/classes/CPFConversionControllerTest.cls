/**
 * @description       :Test class for CPFConversionController 
 * @author            :Diksha Wasekar
 * @last modified on  : 2021-06-30
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2021-06-17      Initial Version
**/
@isTest
public class CPFConversionControllerTest {
    @isTest
    public static void getConversionCPFTest(){
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
        String objData='{"conversion":"An Investment Loan Facility","totalfacilimitonamenddate":1,"finalrepaydateafterconversion":"day(s)","numofperiods":1,"term":120,"interestpayday":1,"interestbasis":"Prime Rate","netmargin":null,"allinriskmargin":null,"fixedrateperiod":null,"primeratemargin":null,"margin":null,"flexifee":1,"gapinsurance":"Yes","newFeesAfterConnversion":[{"Fees_description__c":"1","Application_Product_CPF__c":"a2g7Z000002IlNRQA0","Id":"a3N7Z000001HNiWUAW","CurrencyIsoCode":"ZAR","Type__c":"Conversion","Name":"a3N7Z000001HNiW"}],"newConditionsAfterConnversion":[{"Application_Product_CPF__c":"a2g7Z000002IlNRQA0","Description__c":"test1","Type__c":"Conversion","Category__c":"CPF Application","Id":"a2l7Z000000Vg1OQAS","CurrencyIsoCode":"ZAR","Name":"a2l7Z000000Vg1O"}],"EarlyTerminationFee":"No","earlyTermFeeYr1":null,"earlyTermFeeYr2":null,"earlyTermFeeYr3":null,"earlyTermFeeFurtherYrs":null,"repaymentoptions":"Interest only period with equal instalment period thereafter (Amortising)","instalmentperiods":null,"interestservicefreq":null}';
        Test.startTest();
        Application_Product_CPF__c appProductcpf=CPFConversionController.getAppProdctCpfRec(testOpp.Id);
        system.assertEquals(appPrdctcpf.Id, appProductcpf.Id);
        CPFConversionController.updateAppPrdctcpf(appPrdctcpf.Id,objData);
        CPFConversionController.getApplicationFeesRec(testOpp.Id);
        CPFConversionController.getAppContractClauseRec(testOpp.Id,'Conversion');
        Test.stopTest();
    }

}
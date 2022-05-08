/**
* @description :This is a test class for CPFSingleMultiplePhaseController
*
* @author   :Diksha Wasekar
* @since   : 2021/04/20
*
*/

@isTest
public class CPFSingleMultiplePhaseControllerTest {
    
   

@isTest
public static void getCPFSingleMultiplePhaseConTest(){
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
       appPrdctcpf.Multiple_phases_applicable__c='No';
       insert appPrdctcpf;
       Application_Phase_CPF__c appPhase =new Application_Phase_CPF__c();
       appPhase.Application_Product_CPF__c =appPrdctcpf.Id;
       appPhase.Type__c='Single Phase';
       insert appPhase;
       Application_Financial_Account__c appFinAcc =new Application_Financial_Account__c();
       appFinAcc.Application_Product_CPF__c =appPrdctcpf.Id;
       insert appFinAcc;
       Application_Fees__c appFaci =new Application_Fees__c();
       appFaci.Application_Product_CPF__c =appPrdctcpf.Id;
       appFaci.Type__c='Facility';
       insert appFaci;
       Application_Fees__c appFees =new Application_Fees__c();
       appFees.Application_Product_CPF__c =appPrdctcpf.Id;
       appFees.Type__c='Fees Details';
       insert appFees;
       CPFSingleMultiplePhaseController.appPhasecpf  wrapper = new CPFSingleMultiplePhaseController.appPhasecpf();
       string Obj ='{"balexistingacctsingle":"Yes","repaymentoptionssingle":"Capitalised Interest with Bullet (Converting)","drawdownamtsingle":1234,"retentionamtsingle":1234,"interestratebasissingle":"Fixed rate with net margin","primeratemarginsingle":null,"marginsingle":null,"interestonlyperiodsingle":null,"finalinstalmentamtsingle":2,"freeflowoptionsingle":null,"interestservicefreqsingle":"month(s)","finalrepaymentdatesingle":"Date","dateofFinalrepaymentsingle":"2021-05-03","numberofPeriodsMonthssingle":null,"netmarginsingle":2,"allinriskmarginsingle":null,"fixedrateperiodsingle":null,"practicaldatesingle":"2021-05-03","devperiodmnthssingle":null,"cancellationfeessingle":2,"adminAmtsingle":null,"payablesingle":null,"accTypesingle":null,"restruFeesingle":2,"commFeesingle":2,"ValfeeAmtsingle":null,"earlyPrepFeeYr1single":null,"earlyPrepFeeYr2single":null,"earlyPrepFeeYr3single":null,"drawdowninspfeesingle":null}';
       string multiplePhase ='No';
       List<Application_Phase_CPF__c> appPhaselst =new List<Application_Phase_CPF__c>();
       appPhaselst.add(appPhase);
       List<Application_Financial_Account__c> appFinAcclst =new List<Application_Financial_Account__c>();
       appFinAcclst.add(appFinAcc);
       List<Application_Fees__c> appFacilst =new List<Application_Fees__c>();
       appFacilst.add(appFaci);
       List<Application_Fees__c> appFeeslst =new List<Application_Fees__c>();
       appFeeslst.add(appFees);

        
        
        
        
       Application_Product_CPF__c appproductcpf=CPFSingleMultiplePhaseController.getAppProdctCpfRec(testOpp.Id);
       system.assertEquals(appPrdctcpf.id, appproductcpf.id);
       CPFSingleMultiplePhaseController.updateAppPrdctcpf(testOpp.Id,multiplePhase);
       CPFSingleMultiplePhaseController.getAppFinAccfRec(testOpp.Id,appPrdctcpf.Multiple_phases_applicable__c);
       CPFSingleMultiplePhaseController.getApphaseCpfRec(testOpp.Id,appPhase.Type__c); 
       CPFSingleMultiplePhaseController.getApplicationFeesRec(testOpp.Id,appFees.Type__c,appPrdctcpf.Multiple_phases_applicable__c);
       CPFSingleMultiplePhaseController.insertSinglePhaseCPFRec(appPrdctcpf.Id ,appPrdctcpf.Multiple_phases_applicable__c, appPhase.Id,Obj,appFinAcclst
                                                                   ,appFacilst,appFeeslst );
       CPFSingleMultiplePhaseController.insertMultiplePhaseCPFRec(appPrdctcpf.Id,multiplePhase,appPhaselst);
   }


}
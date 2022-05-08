/**
 * @description       :Test class for CPFGeneralInformationController
 * @author            :Yongama
 * @last modified on  : 2021-07-23
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-06-07      Initial Version
**/
@isTest
public class CPFGeneralInformationControllerTest {
/**
* @description
* @author  | 2021-06-07
**/
@isTest
public static void getotherleaseCPFTest(){

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
limsecOff.Category__c='Other Application';
limsecOff.Type__c='Other Condition Precedent';
insert limsecOff;
List<Application_Contract_Clause__c> lsecOff =new List<Application_Contract_Clause__c>();
lsecOff.add(limsecOff);
Application_Contract_Clause__c appconclause=new Application_Contract_Clause__c();
appconclause.Application_Product_CPF__c=appPrdctcpf.Id;
appconclause.Type__c='Other Application';
appconclause.Category__c ='CPF Application';
insert appconclause;
list<Application_Contract_Clause__c>lappconclause=new list<Application_Contract_Clause__c>();
lappconclause.add(appconclause);
Test.startTest();


Application_Product_CPF__c appProductCpf =  CPFGeneralInformationController.getAppProdctCpfRec(testOpp.Id);
system.assertEquals(appPrdctcpf.Id, appProductCpf.Id);
//  CPFGeneralInformationController.getAppContractClauseRecForotherLease(testOpp.Id);
CPFGeneralInformationController.furtherAppPrdctcpfinsertAppContract(appPrdctcpf.Id,lappconclause);
CPFGeneralInformationController.insertFinancialStatement(testOpp.Id,lappconclause,lappconclause,'No','No',
                                                            'Financial statements of the Borrower',System.today(),'No',System.today(),System.today());//W-008364
Test.stopTest();
}
@isTest
public static void getotherfinancialCPFTest(){
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
appPrdctcpf.Parent_to_provide_the_bank_with_financia__c='Yes';
appPrdctcpf.Guarantor_s_has_have_subsidiaries__c='yes';
appPrdctcpf.Guarantor_s_to_provide_the_bank_with_fi__c='yes';
appPrdctcpf.Borrower_has_subsidiaries__c='yes';
appPrdctcpf.Available__c=1;
appPrdctcpf.Period__c='monthly';
appPrdctcpf.Financial_statements_available_no_later__c='test';
appPrdctcpf.Include_balance_sheet_profit_loss_acc__c='yes';
appPrdctcpf.Other_financial_information__c='test';
insert appPrdctcpf;


list<Application_Lease_CPF__c> appleaseList=new list<Application_Lease_CPF__c>();
Application_Lease_CPF__c applease =new Application_Lease_CPF__c();
applease.Application_Product_CPF__c=appPrdctcpf.Id;
appleaseList.add(applease);

list<Application_Contract_Clause__c> appContractList=new list<Application_Contract_Clause__c>();
Application_Contract_Clause__c appContract =new Application_Contract_Clause__c();
appContract.Application_Product_CPF__c=appPrdctcpf.Id;
appContractList.add(appContract);

list<Application_Portfolio__c> appPortfolioList=new list<Application_Portfolio__c>();
Application_Portfolio__c appPortfolio =new Application_Portfolio__c();
appPortfolio.Application_Product_CPF__c=appPrdctcpf.Id;
appPortfolioList.add(appPortfolio);
string Obj ='{"amendmentClause":"Yes","CPFAccNumber":1234,"chargingDate":"3","uThreshold":null,"withdrawal":"not applicable","ownerOccupied":"No","equityContributions":null,"equityContributionsAmt":null,"otherEquity":null,"bUnderCPA":"No","thresholdAmount":null,"tPeriods":null,"cdThresholdAmt":null,"aFinanceDocsRequired":null,"aFinanceDocsRequiredDocs":null,"fLoanOptions":null,"litThreshloldAmt":null,"fPurpose":null,"pApprovedByCred":null,"pDescription":null,"pDescription1":null,"pSelection":null,"transactionalBankingAccounts":"No","devloanisvat":"Yes","devfaciPurpose":"The acquisition and Development","devproptype":"a retirement village","otherproptype":null,"devpropDescription":null,"devDescription":"test","devloanvatfaciamt":"Amount outstanding","aggmaxiamt":null,"amtoutstanding":null,"devloanterm":12,"devloanfinalrepaypick":"Date","dateoffinalrepay":null,"devloanpurpose":"Purchase price of the Property","vatfacifee":1,"vatrepayoptions":"Interest only with Bullet","insterestfreq":null,"vatfacifinalinstalamt":null,"newPortfolios":[]}';



Application_Product_CPF__c appProductCpf =  CPFGeneralInformationController.getAppProdctCpfRec(testOpp.Id);
system.assertEquals(appPrdctcpf.Id, appProductCpf.Id);
CPFGeneralInformationController.getContractClauseData(testOpp.Id); //W-008364
CPFGeneralInformationController.getAppPortfolioRec(testOpp.Id);
CPFGeneralInformationController.addParentAccount(appPrdctcpf.Id, 'Parenttoprovidethebankwithfinancia', 'GuarantortoprovideBankfinancialinfo', 'amendment', 'Financialstmtavailablenolater', 'Borrowerhassubsidiaries', 'Guarantorshashavesubsidiaries', 'Unauditedinterimstmtreq',2.35, 'Period', 'Includebalancesheetprofitlossacc', 12, 'Otherfinancialinformation');
CPFGeneralInformationController.getLease(appPrdctcpf.Id);
CPFGeneralInformationController.insertFinancialStatement(testOpp.Id, appContractList, appContractList, 'theBankReserveRightTo', 'alreadyHeld', 'fstatement', system.today(), 'Includingfinstatement', system.today(), system.today());
CPFGeneralInformationController.synchronizeLeaseRecords(appleaseList, appleaseList, appPrdctcpf.Id, 'No', 'No');
CPFGeneralInformationController.updateAppPrdctcpf(appPrdctcpf.Id,Obj);

}
}
/*
*  @description  Test Controller for CPFFeeDetailsController
* @author  Haritha P : Absa
* @version v1.0
* @since   2021-1-02
*/
@isTest
public class CPFFeesDetailsControllerTest {
static testMethod void getfeeDetailsCPFTest(){
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
Application_Fees__c feesobj = new Application_Fees__c();
feesobj.Type__c='Facility';

Application_Product_CPF__c appproductcpf=CPFFeesDetailsController.getAppProdctCpfRec(testOpp.Id);
system.assertEquals(appproductcpf.Id, appPrdctcpf.Id);
CPFFeesDetailsController.updateAppPrdctcpf(appPrdctcpf.Id,2 ,' incAdminFeeTotFacility2','adminFee ',2, ' payable' , ' incAdminFee' , ' accType' ,2, 2, ' valFee',2,
                                            'incAdminFeeTotFacility',2, ' earlyTermFee', 1, 2 ,3 ,' earlyTermFeeFurthrYrs',' prepFee',
                                            ' cancelAtrAccept', ' lateBondPnlty',1,2,3,' earlyPreFeeFurtherYrs',' otherfeesapplicable' );
CPFFeesDetailsController.getprodName(testOpp.Id);
CPFFeesDetailsController.getApplicationFeesRec(testOpp.Id);
CPFFeesDetailsController.OtherFeesDetailUpdate(appPrdctcpf.Id,new List<Application_Fees__c>{feesobj});
}
}
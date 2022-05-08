/**
*  @description Test Controller for CPFFacilityPrimarySecondaryAccDetails class
* @author  Haritha P :Absa
* @version v1.0
* @since   2021-1-02
*/
@isTest
public class CPFFacilityPrimarySecondaryAccDtlsTest {
    @isTest
 	public static void getApplicationProductCPFTest()
    {
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
        
        list<Application_Financial_Account__c> lappfinAccList=new list<Application_Financial_Account__c>();
        Application_Financial_Account__c appfinAccList =new Application_Financial_Account__c();
        appfinAccList.Application_Product_CPF__c=appPrdctcpf.Id;
        lappfinAccList.add(appfinAccList);
        insert lappfinAccList;
        List<Application_Repayment_Account_CPF__c> appRepaylst =new List<Application_Repayment_Account_CPF__c>();
        Application_Repayment_Account_CPF__c appRepayRec= new Application_Repayment_Account_CPF__c();
        appRepayRec.Application_Product_CPF__c=appPrdctcpf.Id;
        appRepayRec.Type__c='secondary';
    	appRepaylst.add(appRepayRec);
        insert appRepaylst;
        List<Application_Fees__c> appFeeslst =new List<Application_Fees__c>();
        Application_Fees__c appFeesRec= new Application_Fees__c();
        appFeesRec.Application_Product_CPF__c=appPrdctcpf.Id;
        appFeesRec.Type__c='Facility';
    	appFeeslst.add(appFeesRec);
        insert appFeeslst;
        Application_Product_CPF__c approductcpf =CPFFacilityPrimarySecondaryAccDetails.getAppProdctCpfRec(testOpp.Id);
        system.assertEquals(approductcpf.id, appPrdctcpf.id);
        CPFFacilityPrimarySecondaryAccDetails.getAppFinAccfRec(testOpp.Id);
        double remainingavailableamount=77.66;
        CPFFacilityPrimarySecondaryAccDetails.updateAppPrdctcpf(appPrdctcpf.Id,1111.12,4545.45,'Yes',true,'Yes','None',1112.22,remainingavailableamount,'Y',lappfinAccList,'Yes',2.2);
    	CPFFacilityPrimarySecondaryAccDetails.updateAppPrdctcpf(appPrdctcpf.Id,1111.12,4545.45,'No',false,'No','Standardclause',1112.22,remainingavailableamount,'N',lappfinAccList,'No',2.2);
        CPFFacilityPrimarySecondaryAccDetails.updateAppPrdctcpf(appPrdctcpf.Id,1111.12,4545.45,'No',false,'No','Payoutintranches',1112.22,remainingavailableamount,'N',lappfinAccList,'No',2.2);
    	CPFFacilityPrimarySecondaryAccDetails.updateFacilityRepaymentsec(appPrdctcpf.Id,'N','Prime Rate','Equal Instalment','Plus per annum',123.123,'Y',123.123,123.123,123.123,'Date',system.today(),2.0,2.0,2.0,2.0,2.0,2,2,'days','Monthly',2,2);
       // CPFFacilityPrimarySecondaryAccDetails.updateFacilityRepaymentsec(appPrdctcpf.Id,'N','Prime Rate','Minus per annum',123.123,'N',123.123,123.123,123.123,'Date After First Drawdown',system.today(),2.0,2.0,2.0,2.0);
       // CPFFacilityPrimarySecondaryAccDetails.updateFacilityRepaymentsec(appPrdctcpf.Id,'N','Prime Rate','No variance',123.123,'N',123.123,123.123,123.123,'Date After Signature',system.today(),2.0,2.0,2.0,2.0);
        CPFFacilityPrimarySecondaryAccDetails.InsertNewSecondaryAcctRepayementRecCpf(testOpp.Id, appRepaylst, false ,'Y');
        CPFFacilityPrimarySecondaryAccDetails.insertPrimaryRepaymentsection(testOpp.Id, 'Y', 'Prime Rate', 'Equal Instalment', 'Plus per annum', 2.2, 'Y', 34.2, 12, 12, '1', system.today(), 1.1, 'primary', 2.0, 2.0, 2.0,2.0,2,2,'days','Monthly',2,2,appRepaylst[0].Id);
        CPFFacilityPrimarySecondaryAccDetails.getSecondaryAcctRepaymentRec(testOpp.Id);
        CPFFacilityPrimarySecondaryAccDetails.getPrimaryAcctRepaymentRec(testOpp.Id);
        CPFFacilityPrimarySecondaryAccDetails.dummyRefresh();
        CPFFacilityPrimarySecondaryAccDetails.getApplicationRec(testOpp.Id);
        CPFFacilityPrimarySecondaryAccDetails.getprodName(testOpp.Id);
        CPFFacilityPrimarySecondaryAccDetails.updateBorrowerInfo(testOpp.Id,app.Id, 'Yes', 'Yes', 'test', '1234',0.1, '3 Days', 'the Borrower');
        CPFFacilityPrimarySecondaryAccDetails.getApplicationFeesRec(testOpp.Id);
        CPFFacilityPrimarySecondaryAccDetails.OtherFeesDetailUpdate(appPrdctcpf.Id, appFeeslst);
    }
}
/**
 * @description       : Controller class for Income and Expense
 * @author            : Almas.Aleem@absa.africa
 * @group             :
 * @last modified on  : 2021-07-29
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2020-09-28   Almas.Aleem@absa.africa   Initial Version
**/

@isTest
public class IncomeAndExpenseControllerTest  {
    
    @isTest static void testGetIncomeandExpense() {
         Account acc = [SELECT Id, Registration_Number__c FROM Account WHERE CIF__c = 'SNIFFEL001' LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application__c app =[SELECT Id FROM Application__C WHERE Opportunity__c=:opp.id];
        
       // ApplicationFinancialInformation.getApplicationFinInfo(opp.Id);
        application_Triad__c appTriad = new application_Triad__c();
        appTriad.Application__c = app.Id;
        appTriad.Expected_Credit_Turnover__c = 5501;
        appTriad.Client_Code__c = 'SNIFFEL001';
        
        insert appTriad;
        
        
        List<Application_Profile__c> appProfList = new List<Application_Profile__c>();
        Application_Profile__c appProf = new Application_Profile__c();
        appProf.Client_CIF_Code__c = 'REBELLO001';
        appProf.Client_Name__c = 'Absa Bank';
        appProf.Application__c = app.Id;
        appProf.Applicant_Type__c = 'Main Applicant';
        appProf.Related_to_Client_ID_or_Reg_Number__c = acc.Registration_Number__c;
        appProf.Is_Main_Applicant__c = true;
        appProfList.add(appProf);

        appProf = new Application_Profile__c();
        appProf.Client_CIF_Code__c = 'AABK   007';
        appProf.Client_Name__c = 'Absa Bank';
        appProf.Applicant_Type__c ='Spouse';
        appProf.Application__c = app.Id;
        appProf.Related_to_Client_Code__c = appProf.Related_to_Client_ID_or_Reg_Number__c;
        appProfList.add(appProf);

        Application_Principal__c prin1 = new Application_Principal__c();
        //prin1.Id_Number__c = '830000000000000';
        prin1.Main__c = true;
        prin1.Principal_Shareholder_Name__c = 'HERMAN JOHANNES FOURIE';
        prin1.cif__c = 'FOURIBM001';
        prin1.Application__c =  app.Id;
        insert prin1;

         insert appProfList;
           
        Test.startTest();
        IncomeAndExpenseController.ExpenseWrapper expWrap =  IncomeAndExpenseController.getApplicationExpense(opp.Id);
        
        System.assertNotEquals(null,expWrap);
        	expWrap =  IncomeAndExpenseController.getApplicationExpense(opp.Id);
        
        Test.stopTest();
    }
    
    @testSetup static void createData(){
        
        ClientDetailsSectionCreditTest.dataCreation();
        
      
    }
}
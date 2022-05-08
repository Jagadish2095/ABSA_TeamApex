/**
 * @description Test Class for TriadPreAdvicedController Component
 * @author  Englarmerdge Mongwe
 * @since   2020-12-06
 *
*/
@IsTest
public class TriadPreAdvicedControllerTest {
    /**
    * @description method to setup test data
    * @author englarmerdge.mongwe@absa.africa | 2020-12-06
    **/
    @TestSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    /**
    * @description test method to getApplicationTriadPreAdviced
    * @author englarmerdge.mongwe@absa.africa | 2020-12-06
    **/
    @IsTest
    static void testGetApplicationTriadPreAdviced(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name =:'Cheque Credit Onboarding' LIMIT 1];
        Application__c app = [SELECT Id,SurnameSignature__c FROM Application__c WHERE Opportunity__c =:opp.Id LIMIT 1];
        Application_Triad__c appTriad = new Application_Triad__c();
        appTriad.Application__c = app.Id;
		appTriad.Is_Main_Applicant__c = true;
		appTriad.Client_Code__c = 'SNIFFEL001';
        appTriad.Additional_Monthly_Loan_Repayment__c = 20;
        appTriad.Additional_Monthly_Repayment__c = 20;
        appTriad.Additional_Credit_Card_Limit__c = 20;
        appTriad.Additional_Asset_Finance_Repayment__c = 20;
        appTriad.Additional_Monthly_Mortgage_Repayment__c = 20;
        appTriad.Maximum_Ordinary_Credit_Exposure_Capped__c = 20;
        insert appTriad;

        Test.startTest();
        //TriadPreAdvicedController.getApplicationTriadPreAdviced(opp.Id);
        System.assert(TriadPreAdvicedController.getApplicationTriadPreAdviced(opp.Id) != null, true);
        Test.stopTest();
    }
}
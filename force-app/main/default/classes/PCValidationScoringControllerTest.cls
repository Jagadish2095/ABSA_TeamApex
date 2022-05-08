@IsTest
public class PCValidationScoringControllerTest {
    @testSetup static void createData(){
        Account account = new Account();
        account.Name = 'Absa Bank';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'SNIFFEL001';
        account.Sic='35790';
        account.AccountNumber='0';
        account.Registration_Number__c='1990/011515/23';
        insert account;
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        opp.Illustrative_Decision__c=true;
        //opp.Spouse_Account_Id__c=account.Id;
        Insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        Insert application;
        Application_scoring__c apScore=new Application_scoring__c();
        apScore.Application_Number__c=application.Id;
        apScore.PaprPreapprInd__c='N';
        apScore.PreapprReprocessLowerLmtInd__c='Y';
        apScore.SpouseDetailsRequiredInd__c='Y';
        apScore.Stage__c='1';
        apScore.MIAERequired__c='Y';
        insert apScore;
        
    }
     @isTest static void testgetPCValidation(){
        Opportunity opp=[select Id from Opportunity];
        test.startTest();
        PowerCurveValidationScoringController.getData(opp.Id,'1');
        PowerCurveValidationScoringController.getChequeAndOverdraft(opp.Id);
        PowerCurveValidationScoringController.getApplicationTriadPreAdviced(opp.Id);
        test.stopTest();
     }

}
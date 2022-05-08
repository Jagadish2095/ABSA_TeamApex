/**
 * @description       : 
 * @author            : Himani Joshi
 * @last modified on  : 2021-07-12
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-09   Himani Joshi   Initial Version
 * 
**/

@IsTest
public class ApplicationExposuresControllerTest {
    @testSetup static void createData(){
        Account account = new Account();
        account.Name = 'Test Account';
        account.CIF__c = 'SNIFFEL001';
        account.Sic='35790';
        account.AccountNumber='0';
        account.Registration_Number__c = '1990/011515/23';
        account.Client_Type__c = 'Individual';
        insert account;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opp Onboarding 1';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'New';
        opportunity.AccountId=account.Id;
        insert opportunity;
        
        Application__c app = new Application__c();
        app.Opportunity__c = opportunity.Id;
        insert app;
        
		List<Application_Profile__c> appProfileList = new List<Application_Profile__c>();
		Application_Profile__c appProfile = new Application_Profile__c();
		appProfile.Applicant_Type__c = 'Main Applicant';
		appProfile.Is_Main_Applicant__c = true;
		appProfile.Application__c = app.Id;
        appProfileList.add(appProfile);

		appProfile = new Application_Profile__c();
		appProfile.Applicant_Type__c = 'Principal';
		appProfile.Is_Main_Applicant__c = false;
		appProfile.Client_CIF_Code__c = 'SNIFFEL001';
		appProfile.Application__c = app.Id;
		appProfileList.add(appProfile);
        insert appProfileList;

        List<Application_Exposure__c> appExposures = new List<Application_Exposure__c>();
		Application_Exposure__c appExposure = new Application_Exposure__c();
		appExposure.Application__c = app.Id;
		appExposure.Product__c = 'CHEQ';
		appExposure.subIndicator__c = 'O';
		appExposure.Exposure__c = '300';
		appExposure.Arrears__c = '300';
		appExposure.Excess__c = '300';
		appExposure.Installment__c = '300';
		appExposure.Liability__c = '300';
		appExposure.Limit__c = '300';
		appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
        appExposures.add(appExposure);

		appExposure = new Application_Exposure__c();
		appExposure.Application__c = app.Id;
		appExposure.Product__c = 'AGRI';
		appExposure.subIndicator__c = 'O';
		appExposure.Exposure__c = '300';
		appExposure.Arrears__c = '300';
		appExposure.Excess__c = '300';
		appExposure.Installment__c = '300';
		appExposure.Liability__c = '300';
		appExposure.Limit__c = '300';
		appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
        appExposures.add(appExposure);

		appExposure = new Application_Exposure__c();
		appExposure.Application__c = app.Id;
		appExposure.Product__c = '';
		appExposure.subIndicator__c = '';
		appExposure.Exposure__c = '300';
		appExposure.Arrears__c = '300';
		appExposure.Excess__c = '300';
		appExposure.Installment__c = '300';
		appExposure.Liability__c = '300';
		appExposure.Limit__c = '300';
		appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_ORDINARY_CREDIT_TOTAL;
		appExposures.add(appExposure);

		appExposure = new Application_Exposure__c();
		appExposure.Application__c = app.Id;
		appExposure.Product__c = '';
		appExposure.subIndicator__c = '';
		appExposure.Exposure__c = '300';
		appExposure.Arrears__c = '300';
		appExposure.Excess__c = '300';
		appExposure.Installment__c = '300';
		appExposure.Liability__c = '300';
		appExposure.Limit__c = '300';
		appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_CLIENT_PROFILE_PRODUCT_TOTAL;
		appExposures.add(appExposure);
        insert appExposures;
    }

    @isTest static void testGetApplicationExposures() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        Map<string,List<sobject>> appExposuresMap = ApplicationExposuresController.getApplicationExposures(opp.Id);
        System.assertNotEquals(null, appExposuresMap);
        Test.stopTest();
    }
}
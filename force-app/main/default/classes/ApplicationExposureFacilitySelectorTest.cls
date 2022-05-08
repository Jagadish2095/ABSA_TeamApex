/**
 * @description       : Test class for ApplicationExposureFacilitySelector
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-11
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

@IsTest
public class ApplicationExposureFacilitySelectorTest {
    
	@TestSetup
    static void makeData(){
        Account account = new Account();
		account.Name = 'Test Account';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
        insert account;

        Opportunity opp2 = new Opportunity();
		opp2.Name = 'Onboarding';
		opp2.CloseDate = Date.today();
		opp2.StageName = 'New';
		opp2.AccountId = account.Id;
        insert opp2;

        Application__c app2 = new Application__c();
		app2.Opportunity__c = opp2.id;
		//app2.Transactional_Account__c = '11016 Bussines Essentials';
		app2.Account_Access__c = 'Cellphone';
		//app2.Foreign_Services__c = 'Currency Swap (Hedging Instruments)';
		app2.Surplus_Cash__c = 'Fixed Deposits';
		app2.Borrowing_Requiment_General__c = 'Credit Card';
		//app2.Borrowing_requiment_Assest_Acquisition__c = 'Business /BACKED Property Finance';
		app2.Protection_Of_Services__c = 'Retirement';
		app2.Title__c = 'dd';
		app2.FirstNameSignature__c = 'Litha';
		app2.SurnameSignature__c = 'Nosekeleza';
		app2.Signing_Date__c = System.today();
		//app.Stock_Number__c = '123456';
        insert app2;

        List<Application_Exposure_Facility__c> appExposureFacilities = new List<Application_Exposure_Facility__c>();
		Application_Exposure_Facility__c settlementLimits = new Application_Exposure_Facility__c();
		settlementLimits.Application__c = app2.Id;
		settlementLimits.Approved_Facility__c = 'Settlement Limits Approved';
		settlementLimits.Client_Name__c = 'REBELLO';
		settlementLimits.Client_Code__c = 'REBELLO001';
		settlementLimits.Exposure_Non_Scored__c = 100;
		settlementLimits.Exposure_Scored__c = 100;
		settlementLimits.Installments_Non_Scored__c = 100;
		settlementLimits.Installments_Scored__c = 100;
        appExposureFacilities.add(settlementLimits);

		Application_Exposure_Facility__c ordnryCreditBusBank = new Application_Exposure_Facility__c();
		ordnryCreditBusBank.Application__c = app2.Id;
		ordnryCreditBusBank.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Business Bank';
		ordnryCreditBusBank.Client_Name__c = 'REBELLO';
		ordnryCreditBusBank.Client_Code__c = 'REBELLO001';
		ordnryCreditBusBank.Exposure_Non_Scored__c = 100;
		ordnryCreditBusBank.Exposure_Scored__c = 100;
		ordnryCreditBusBank.Installments_Non_Scored__c = 100;
		ordnryCreditBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(ordnryCreditBusBank);

		Application_Exposure_Facility__c ordnryCreditRetail = new Application_Exposure_Facility__c();
		ordnryCreditRetail.Application__c = app2.Id;
		ordnryCreditRetail.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Retail';
		ordnryCreditRetail.Client_Name__c = 'REBELLO';
		ordnryCreditRetail.Client_Code__c = 'REBELLO001';
		ordnryCreditRetail.Exposure_Non_Scored__c = 100;
		ordnryCreditRetail.Exposure_Scored__c = 100;
		ordnryCreditRetail.Installments_Non_Scored__c = 100;
		ordnryCreditRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(ordnryCreditRetail);

		Application_Exposure_Facility__c assetFinBusBank = new Application_Exposure_Facility__c();
		assetFinBusBank.Application__c = app2.Id;
		assetFinBusBank.Approved_Facility__c = 'Approved Facilities Asset Finance - Business Bank';
		assetFinBusBank.Client_Name__c = 'REBELLO';
		assetFinBusBank.Client_Code__c = 'REBELLO001';
		assetFinBusBank.Exposure_Non_Scored__c = 100;
		assetFinBusBank.Exposure_Scored__c = 100;
		assetFinBusBank.Installments_Non_Scored__c = 100;
		assetFinBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(assetFinBusBank);

		Application_Exposure_Facility__c assetFinRetail = new Application_Exposure_Facility__c();
		assetFinRetail.Application__c = app2.Id;
		assetFinRetail.Approved_Facility__c = 'Approved Facilities Asset Finance- Retail';
		assetFinRetail.Client_Name__c = 'REBELLO';
		assetFinRetail.Client_Code__c = 'REBELLO001';
		assetFinRetail.Exposure_Non_Scored__c = 100;
		assetFinRetail.Exposure_Scored__c = 100;
		assetFinRetail.Installments_Non_Scored__c = 100;
		assetFinRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(assetFinRetail);

		Application_Exposure_Facility__c mortgageFacBusBank = new Application_Exposure_Facility__c();
		mortgageFacBusBank.Application__c = app2.Id;
		mortgageFacBusBank.Approved_Facility__c = 'Approved Mortgage Facilities - Business Bank';
		mortgageFacBusBank.Client_Name__c = 'REBELLO';
		mortgageFacBusBank.Client_Code__c = 'REBELLO001';
		mortgageFacBusBank.Exposure_Non_Scored__c = 100;
		mortgageFacBusBank.Exposure_Scored__c = 100;
		mortgageFacBusBank.Installments_Non_Scored__c = 100;
		mortgageFacBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(mortgageFacBusBank);

		Application_Exposure_Facility__c mortgageFacRetail = new Application_Exposure_Facility__c();
		mortgageFacRetail.Application__c = app2.Id;
		mortgageFacRetail.Approved_Facility__c = 'Approved Mortgage Facilities - Retail';
		mortgageFacRetail.Client_Name__c = 'REBELLO';
		mortgageFacRetail.Client_Code__c = 'REBELLO001';
		mortgageFacRetail.Exposure_Non_Scored__c = 100;
		mortgageFacRetail.Exposure_Scored__c = 100;
		mortgageFacRetail.Installments_Non_Scored__c = 100;
		mortgageFacRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(mortgageFacRetail);

		Application_Exposure_Facility__c appFacTotal = new Application_Exposure_Facility__c();
		appFacTotal.Application__c = app2.Id;
		appFacTotal.Approved_Facility__c = 'Approved Facilities Total';
		appFacTotal.Client_Name__c = 'REBELLO';
		appFacTotal.Client_Code__c = 'REBELLO001';
		appFacTotal.Exposure_Non_Scored__c = 100;
		appFacTotal.Exposure_Scored__c = 100;
		appFacTotal.Installments_Non_Scored__c = 100;
		appFacTotal.Installments_Scored__c = 100;
        appExposureFacilities.add(appFacTotal);

		settlementLimits = new Application_Exposure_Facility__c();
		settlementLimits.Application__c = app2.Id;
		settlementLimits.Approved_Facility__c = 'Settlement Limits Approved';
		settlementLimits.Client_Name__c = 'TUMI';
		settlementLimits.Client_Code__c = 'REBELLO002';
		settlementLimits.Exposure_Non_Scored__c = 100;
		settlementLimits.Exposure_Scored__c = 100;
		settlementLimits.Installments_Non_Scored__c = 100;
		settlementLimits.Installments_Scored__c = 100;
        appExposureFacilities.add(settlementLimits);

		ordnryCreditBusBank = new Application_Exposure_Facility__c();
		ordnryCreditBusBank.Application__c = app2.Id;
		ordnryCreditBusBank.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Business Bank';
		ordnryCreditBusBank.Client_Name__c = 'TUMI';
		ordnryCreditBusBank.Client_Code__c = 'REBELLO002';
		ordnryCreditBusBank.Exposure_Non_Scored__c = 100;
		ordnryCreditBusBank.Exposure_Scored__c = 100;
		ordnryCreditBusBank.Installments_Non_Scored__c = 100;
		ordnryCreditBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(ordnryCreditBusBank);

		ordnryCreditRetail = new Application_Exposure_Facility__c();
		ordnryCreditRetail.Application__c = app2.Id;
		ordnryCreditRetail.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Retail';
		ordnryCreditRetail.Client_Name__c = 'TUMI';
		ordnryCreditRetail.Client_Code__c = 'REBELLO002';
		ordnryCreditRetail.Exposure_Non_Scored__c = 100;
		ordnryCreditRetail.Exposure_Scored__c = 100;
		ordnryCreditRetail.Installments_Non_Scored__c = 100;
		ordnryCreditRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(ordnryCreditRetail);

		assetFinBusBank = new Application_Exposure_Facility__c();
		assetFinBusBank.Application__c = app2.Id;
		assetFinBusBank.Approved_Facility__c = 'Approved Facilities Asset Finance - Business Bank';
		assetFinBusBank.Client_Name__c = 'TUMI';
		assetFinBusBank.Client_Code__c = 'REBELLO002';
		assetFinBusBank.Exposure_Non_Scored__c = 100;
		assetFinBusBank.Exposure_Scored__c = 100;
		assetFinBusBank.Installments_Non_Scored__c = 100;
		assetFinBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(assetFinBusBank);

		assetFinRetail = new Application_Exposure_Facility__c();
		assetFinRetail.Application__c = app2.Id;
		assetFinRetail.Approved_Facility__c = 'Approved Facilities Asset Finance- Retail';
		assetFinRetail.Client_Name__c = 'TUMI';
		assetFinRetail.Client_Code__c = 'REBELLO002';
		assetFinRetail.Exposure_Non_Scored__c = 100;
		assetFinRetail.Exposure_Scored__c = 100;
		assetFinRetail.Installments_Non_Scored__c = 100;
		assetFinRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(assetFinRetail);

		mortgageFacBusBank = new Application_Exposure_Facility__c();
		mortgageFacBusBank.Application__c = app2.Id;
		mortgageFacBusBank.Approved_Facility__c = 'Approved Mortgage Facilities - Business Bank';
		mortgageFacBusBank.Client_Name__c = 'TUMI';
		mortgageFacBusBank.Client_Code__c = 'REBELLO002';
		mortgageFacBusBank.Exposure_Non_Scored__c = 100;
		mortgageFacBusBank.Exposure_Scored__c = 100;
		mortgageFacBusBank.Installments_Non_Scored__c = 100;
		mortgageFacBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(mortgageFacBusBank);

		mortgageFacRetail = new Application_Exposure_Facility__c();
		mortgageFacRetail.Application__c = app2.Id;
		mortgageFacRetail.Approved_Facility__c = 'Approved Mortgage Facilities - Retail';
		mortgageFacRetail.Client_Name__c = 'TUMI';
		mortgageFacRetail.Client_Code__c = 'REBELLO002';
		mortgageFacRetail.Exposure_Non_Scored__c = 100;
		mortgageFacRetail.Exposure_Scored__c = 100;
		mortgageFacRetail.Installments_Non_Scored__c = 100;
		mortgageFacRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(mortgageFacRetail);

		appFacTotal = new Application_Exposure_Facility__c();
		appFacTotal.Application__c = app2.Id;
		appFacTotal.Approved_Facility__c = 'Approved Facilities Total';
		appFacTotal.Client_Name__c = 'TUMI';
		appFacTotal.Client_Code__c = 'REBELLO002';
		appFacTotal.Exposure_Non_Scored__c = 100;
		appFacTotal.Exposure_Scored__c = 100;
		appFacTotal.Installments_Non_Scored__c = 100;
		appFacTotal.Installments_Scored__c = 100;
		appExposureFacilities.add(appFacTotal);
        insert appExposureFacilities;
    }

    @IsTest
    static void shouldSelectById(){
        ApplicationExposureFacilitySelector appExpFacilitySlctr = new ApplicationExposureFacilitySelector();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Onboarding' LIMIT 1];
        Application__c application = [SELECT Id FROM Application__c WHERE Opportunity__c =: opportunity.Id];
        Application_Exposure_Facility__c appExpFacility = [SELECT Id FROM Application_Exposure_Facility__c WHERE Application__c =: application.Id LIMIT 1];

        Test.startTest();
        List<Application_Exposure_Facility__c> appExpFacilities = appExpFacilitySlctr.selectById(new Set<Id>{appExpFacility.Id});
        Test.stopTest();

        System.assertNotEquals(0, appExpFacilities.size());
    }

    @IsTest
    static void shouldSelectByApplicationId(){
        ApplicationExposureFacilitySelector appExpFacilitySlctr = new ApplicationExposureFacilitySelector();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Onboarding' LIMIT 1];
        Application__c application = [SELECT Id FROM Application__c WHERE Opportunity__c =: opportunity.Id];

        Test.startTest();
        List<Application_Exposure_Facility__c> appExpFacilities = appExpFacilitySlctr.selectByApplicationId(new Set<Id>{application.Id});
        List<Application_Exposure_Facility__c> aefList = appExpFacilitySlctr.exposureFacilities(application.Id, 'REBELLO002');
        List<Application_Exposure_Facility__c> anathaList = appExpFacilitySlctr.exposureFacilitiesUsingApplication(application.Id);
        Test.stopTest();

        System.assertNotEquals(0, appExpFacilities.size());
    }

    @IsTest
    static void shouldSelectByOpportunityId(){
        ApplicationExposureFacilitySelector appExpFacilitySlctr = new ApplicationExposureFacilitySelector();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Onboarding' LIMIT 1];

        Test.startTest();
        List<Application_Exposure_Facility__c> appExpFacilities = appExpFacilitySlctr.selectByOpportunityId(new Set<Id>{opportunity.Id});
        Test.stopTest();

        System.assertNotEquals(0, appExpFacilities.size());
    }
}
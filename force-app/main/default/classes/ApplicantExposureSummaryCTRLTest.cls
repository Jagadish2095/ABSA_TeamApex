/**
 * @description       : Test class for ApplicantExposureSummaryCTRL
 * @author            : Ketelo Makalela
 * @last modified on  : 2021-06-11
 
**/

@isTest
public class ApplicantExposureSummaryCTRLTest {
    @TestSetup
    static void createData(){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Maintenance').getRecordTypeId();

        Account account = new Account();
		account.Name = 'Test Account';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
        insert account;

        Opportunity opp5 = new Opportunity();
		opp5.Name = 'Cheque Credit Onboarding';
		opp5.CloseDate = Date.today();
		opp5.StageName = 'New';
		opp5.AccountId = account.Id;
		opp5.RecordTypeId = recordTypeId;
		opp5.Illustrative_Decision__c = false;
        insert opp5;

        Application__c appcovid = new Application__c();
		appcovid.Opportunity__c = opp5.id;
		appcovid.Title__c = 'Dr';
		appcovid.FirstNameSignature__c = 'Rob';
		appcovid.SurnameSignature__c = 'Robbello';
		appcovid.Signing_Date__c = System.today();
        insert appcovid;

        //Application_Product__c
        Application_Product__c appProd = new Application_Product__c();
        appProd.Opportunity__c = opp5.id;
        appProd.Opportunity_Product_Id__c = opp5.id;
        appProd.Alternative_Fund_Code__c = '001';
        appProd.Account_Number__c=1111;
        appProd.Product_Type__c = 'CLASSIC BUSINESS ACCOUNT';
        appProd.Secured_By_Mortgage_Bond__c = true;
        appProd.Alternative_Fund_Indicator__c=true;
        insert appProd;
                
        //Application_Product__c
        Application_Product__c appProdParent = new Application_Product__c();
        appProdParent.Opportunity__c = opp5.id;
        appProdParent.Opportunity_Product_Id__c = opp5.id;
        appProdParent.Application_Product_Parent__c = appProd.Id;
        appProdParent.Product_State__c = 'Existing';
        appProdParent.Alternative_Fund_Code__c = '001'; 
        appProdParent.Account_Number__c=1234;
        appProdParent.Product_Name__c='Overdraft';
        appProdParent.Secured_By_Mortgage_Bond__c = true;
        appProdParent.Alternative_Fund_Indicator__c=false;
        insert appProdParent;

        List<Application_Profile__c> appProfileList = new List<Application_Profile__c>();
		Application_Profile__c appProfile = new Application_Profile__c();
		appProfile.Applicant_Type__c = 'Main Applicant';
		appProfile.Is_Main_Applicant__c = true;
		appProfile.Client_CIF_Code__c = account.CIF__c;
		appProfile.Client_Name__c = account.Name;
		appProfile.Application__c = appcovid.Id;
        appProfileList.add(appProfile);

		appProfile = new Application_Profile__c();
		appProfile.Applicant_Type__c = 'Principal';
		appProfile.Is_Main_Applicant__c = false;
		appProfile.Client_CIF_Code__c = 'SNIFFEL001';
		appProfile.Client_Name__c = account.Name;
		appProfile.Application__c = appcovid.Id;
		appProfileList.add(appProfile);
        insert appProfileList;

        List<Application_Exposure__c> appExposures = new List<Application_Exposure__c>();
		Application_Exposure__c appExposure = new Application_Exposure__c();
		appExposure.Application__c = appcovid.Id;
		appExposure.Client_Name__c = appProfile.Client_Name__c;
		appExposure.Client_Code__c = appProfile.Client_CIF_Code__c;
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
		appExposure.Application__c = appcovid.Id;
		appExposure.Client_Name__c = appProfile.Client_Name__c;
		appExposure.Client_Code__c = appProfile.Client_CIF_Code__c;
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
		appExposure.Application__c = appcovid.Id;
		appExposure.Client_Name__c = appProfile.Client_Name__c;
		appExposure.Client_Code__c = appProfile.Client_CIF_Code__c;
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
        insert appExposures;

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetProductExposureAggre_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest
    static void shouldGetApplicationExposureSummary(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Cheque Credit Onboarding' LIMIT 1];

        GetProductExposureAggre_IH_v1_Test.productExpTestMock();

        Test.startTest();
        String theResult = String.valueOf(ApplicantExposureSummaryCTRL.getApplicationExposureSummary(opp.Id));
        Test.stopTest();

        System.assert(theResult.contains('clientName'));
        System.assert(theResult.contains('clientCode'));
        System.assert(theResult.contains('liability'));
        System.assert(theResult.contains('exposure'));
        System.assert(theResult.contains('limit'));
        System.assert(theResult.contains('arrears'));
        System.assert(theResult.contains('excess'));
        System.assert(theResult.contains('installment'));
        System.assert(theResult.contains('Id'));
        System.assert(theResult.contains('lastUpdatedDate'));
    }

}
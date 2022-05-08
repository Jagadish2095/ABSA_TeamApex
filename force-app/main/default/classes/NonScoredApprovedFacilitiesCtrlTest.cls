/**
 *
 * @description
 * This is the Test Class for the NonScoredApprovedFacilitiesCtrl
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-27
 **/
@IsTest
public class NonScoredApprovedFacilitiesCtrlTest{
	/**
	 * @description
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-12
	 **/
	@testSetup
	public static void dataCreation(){
		ClientDetailsSectionCreditTest.dataCreation();
	}

	@isTest
	public static void testGetNonScoredApprovedFacilities(){

		Test.startTest();
		Application_Principal__c appPrinc = [SELECT Id, Name, Application__c
		                                     FROM Application_Principal__c
		                                     LIMIT 1];
		Application__c app = [SELECT Id, Name, Opportunity__c
		                      FROM Application__c
		                      where Id = :appPrinc.Application__c];
		Opportunity opportnity = [SELECT Id, Name
		                          FROM Opportunity
		                          where id = :app.Opportunity__c];

		String mapFac = NonScoredApprovedFacilitiesCtrl.getNonScoredApprovedFacilities(opportnity.Id);
		System.assert(mapFac != null, 'Not null');
		opportnity = [SELECT Id, Name
		              FROM Opportunity
		              where Name = 'Test Opp Onboarding 1'];

		mapFac = NonScoredApprovedFacilitiesCtrl.getNonScoredApprovedFacilities(opportnity.Id);
		Test.stopTest();
	}

	@isTest
	public static void testupdateInterestOffset(){

		Test.startTest();
		Opportunity opportnity = [SELECT Id, Name
		                          FROM Opportunity
		                          LIMIT 1];
		NonScoredApprovedFacilitiesCtrl.updateInterestOffset(opportnity.Id);
		Test.stopTest();
		//future method returns void
		System.assert(opportnity != null);
	}

	@isTest
	public static void testaddSpouseFacilities(){
		//Insert a Account for spouse
		Account spouseAcc = new Account();
		spouseAcc.FirstName = 'Spouse';
		spouseAcc.LastName = 'Account';
		spouseAcc.Sic = '36798';
		spouseAcc.AccountNumber = '0';
		spouseAcc.ID_Number__pc = '7211190142089';
		spouseAcc.ID_Type__c = 'SA Identity Document';
		spouseAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId();
		insert spouseAcc;
		Opportunity opportnity = [SELECT Id, Spouse_Account_Id__c, Name
		                          FROM Opportunity
		                          LIMIT 1];
		opportnity.Spouse_Account_Id__c = spouseAcc.Id;
		update opportnity;
		Application__c app2 = new Application__c();
		app2.Opportunity__c = opportnity.id;
		insert app2;
		List<Application_Exposure_Facility__c> appExposureFacilities = new List<Application_Exposure_Facility__c>();
		Application_Exposure_Facility__c settlementLimits = new Application_Exposure_Facility__c();
		settlementLimits.Application__c = app2.Id;
		settlementLimits.Approved_Facility__c = 'Settlement Limits Approved';
		settlementLimits.Client_Name__c = 'Spouse Account';
		settlementLimits.Client_Code__c = 'REBELLO001';
		settlementLimits.Exposure_Non_Scored__c = 100;
		settlementLimits.Exposure_Scored__c = 100;
		settlementLimits.Installments_Non_Scored__c = 100;
		settlementLimits.Installments_Scored__c = 100;
		appExposureFacilities.add(settlementLimits);
        
		Test.startTest();
		NonScoredApprovedFacilitiesCtrl.getNonScoredApprovedFacilities(opportnity.Id);
		NonScoredApprovedFacilitiesCtrl.addSpouseFacilities(app2.Id, opportnity);
		Test.stopTest();
		//future method returns void
		System.assert(opportnity != null);
	}

	@isTest
	public static void testSaveNonScoredApprovedFacilities(){
		String jsonObj = '[{"IsOutput":false,"IsInput":true,"IsFirstInSVis":false,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"1","ClientCode":"REBELLO001","ClientName":"REBELLO","ApprovedFacility":"Settlement Limits Approved"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"2","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":"","ApprovedFacility":"Approved Facilities Ordinary Credit - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"3","ClientCode":"REBELLO001","ClientName":"","ApprovedFacility":"Approved Facilities Ordinary Credit - Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"4","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":"","ApprovedFacility":"Approved Facilities Asset Finance - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"5","ClientCode":"REBELLO001","ClientName":"","ApprovedFacility":"Approved Facilities Asset Finance- Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"6","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":"","ApprovedFacility":"Approved Mortgage Facilities - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"7","ClientCode":"REBELLO001","ClientName":"","ApprovedFacility":"Approved Mortgage Facilities - Retail"},{"IsOutput":true,"IsInput":false,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":12,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":16,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":"","ApprovedFacility":"Approved Facilities Total"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":false,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"9","ClientCode":"REBELLO002","ClientName":"Sindiso Mahl","ApprovedFacility":"Settlement Limits Approved"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"8","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO002","ClientName":"","ApprovedFacility":"Approved Facilities Ordinary Credit - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"11","ClientCode":"REBELLO002","ClientName":"","ApprovedFacility":"Approved Facilities Ordinary Credit - Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"10","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO002","ClientName":"","ApprovedFacility":"Approved Facilities Asset Finance - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"13","ClientCode":"REBELLO002","ClientName":"","ApprovedFacility":"Approved Facilities Asset Finance- Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"12","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientName":"","ApprovedFacility":"Approved Mortgage Facilities - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"15","ClientCode":"REBELLO002","ClientName":"","ApprovedFacility":"Approved Mortgage Facilities - Retail"},{"IsOutput":true,"IsInput":false,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":30,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":48,"ExposureNonScored":null,"ClientCode":"REBELLO002","ClientName":"","ApprovedFacility":"Approved Facilities Total"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":false,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"17","ClientCode":"REBELLO003","ClientName":"MOSO MOSHE BOLOFO","ApprovedFacility":"Settlement Limits Approved"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"14","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO003","ClientName":"","ApprovedFacility":"Approved Facilities Ordinary Credit - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"19","ClientCode":"REBELLO003","ClientName":"","ApprovedFacility":"Approved Facilities Ordinary Credit - Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"16","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO003","ClientName":"","ApprovedFacility":"Approved Facilities Asset Finance - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"21","ClientCode":"REBELLO003","ClientName":"","ApprovedFacility":"Approved Facilities Asset Finance- Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":"18","Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO003","ClientName":"","ApprovedFacility":"Approved Mortgage Facilities - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":null,"ExposureNonScored":"23","ClientCode":"REBELLO003","ClientName":"","ApprovedFacility":"Approved Mortgage Facilities - Retail"},{"IsOutput":true,"IsInput":false,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":48,"InstallmentsNonScored":null,"Id":null,"ExposureNonScoredTotal":80,"ExposureNonScored":null,"ClientCode":"REBELLO003","ClientName":"","ApprovedFacility":"Approved Facilities Total"}]';
		String jsonObjUpd = '[{"IsOutput":false,"IsInput":true,"IsFirstInSVis":false,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0ZQAQ","ExposureNonScoredTotal":null,"ExposureNonScored":1,"ClientCode":"REBELLO001","ClientName":"REBELLO","ApprovedFacility":"Settlement Limits Approved"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":2,"Id":"a1k3N0000001q0aQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Ordinary Credit - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0bQAA","ExposureNonScoredTotal":null,"ExposureNonScored":3,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Ordinary Credit - Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":4,"Id":"a1k3N0000001q0cQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Asset Finance - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0dQAA","ExposureNonScoredTotal":null,"ExposureNonScored":5,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Asset Finance- Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":6,"Id":"a1k3N0000001q0eQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientName":null,"ApprovedFacility":"Approved Mortgage Facilities - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0fQAA","ExposureNonScoredTotal":null,"ExposureNonScored":7,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Mortgage Facilities - Retail"},{"IsOutput":true,"IsInput":false,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":12,"InstallmentsNonScored":12,"Id":"a1k3N0000001q0gQAA","ExposureNonScoredTotal":16,"ExposureNonScored":16,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Total"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":false,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0hQAA","ExposureNonScoredTotal":null,"ExposureNonScored":9,"ClientCode":"REBELLO001","ClientName":"Sindiso Mahl","ApprovedFacility":"Settlement Limits Approved"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":8,"Id":"a1k3N0000001q0iQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Ordinary Credit - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0jQAA","ExposureNonScoredTotal":null,"ExposureNonScored":11,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Ordinary Credit - Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":10,"Id":"a1k3N0000001q0kQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Asset Finance - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0lQAA","ExposureNonScoredTotal":null,"ExposureNonScored":13,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Asset Finance- Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":12,"Id":"a1k3N0000001q0mQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Mortgage Facilities - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0nQAA","ExposureNonScoredTotal":null,"ExposureNonScored":15,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Mortgage Facilities - Retail"},{"IsOutput":true,"IsInput":false,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":30,"InstallmentsNonScored":30,"Id":"a1k3N0000001q0oQAA","ExposureNonScoredTotal":48,"ExposureNonScored":48,"ClientCode":"REBELLO001","ClientName":null,"ApprovedFacility":"Approved Facilities Total"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":false,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0pQAA","ExposureNonScoredTotal":null,"ExposureNonScored":17,"ClientCode":"REBELLO002","ClientName":"MOSO MOSHE BOLOFO","ApprovedFacility":"Settlement Limits Approved"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":14,"Id":"a1k3N0000001q0qQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO002","ClientName":null,"ApprovedFacility":"Approved Facilities Ordinary Credit - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0rQAA","ExposureNonScoredTotal":null,"ExposureNonScored":19,"ClientCode":"REBELLO002","ClientName":null,"ApprovedFacility":"Approved Facilities Ordinary Credit - Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":16,"Id":"a1k3N0000001q0sQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO002","ClientName":null,"ApprovedFacility":"Approved Facilities Asset Finance - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0tQAA","ExposureNonScoredTotal":null,"ExposureNonScored":21,"ClientCode":"REBELLO002","ClientName":null,"ApprovedFacility":"Approved Facilities Asset Finance- Retail"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":18,"Id":"a1k3N0000001q0uQAA","ExposureNonScoredTotal":null,"ExposureNonScored":null,"ClientCode":"REBELLO002","ClientName":null,"ApprovedFacility":"Approved Mortgage Facilities - Business Bank"},{"IsOutput":false,"IsInput":true,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":null,"InstallmentsNonScored":null,"Id":"a1k3N0000001q0vQAA","ExposureNonScoredTotal":null,"ExposureNonScored":23,"ClientCode":"REBELLO002","ClientName":null,"ApprovedFacility":"Approved Mortgage Facilities - Retail"},{"IsOutput":true,"IsInput":false,"IsFirstInSVis":true,"InstallmentsNonScoredTotal":48,"InstallmentsNonScored":48,"Id":"a1k3N0000001q0wQAA","ExposureNonScoredTotal":80,"ExposureNonScored":80,"ClientCode":"REBELLO002","ClientName":null,"ApprovedFacility":"Approved Facilities Total"}]';

		Test.startTest();

		Opportunity opportnity = [SELECT Id, Name
		                          FROM Opportunity
		                          LIMIT 1];

		Map<String, String> mapFac = NonScoredApprovedFacilitiesCtrl.saveNonScoredApprovedFacilities(opportnity.Id, jsonObj, true);
		Map<String, String> mapFacUpd = NonScoredApprovedFacilitiesCtrl.saveNonScoredApprovedFacilities(opportnity.Id, jsonObj, false);

		Test.stopTest();

		System.assert(!mapFac.isEmpty());
		System.assert(!mapFacUpd.isEmpty());
	}

	@isTest
	public static void ApplicationProfileClientDetails(){
		Application_Profile__c appprof = [select id
		                                  from Application_Profile__c
		                                  limit 1];
		//List<Application_Profile__c> appProfList = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
		Set<Id> ApplicationProfileIds = new Set<Id>();
		ApplicationProfileIds.add(appprof.Id);
		/*for (Application_Profile__c aprofile : appProfList) {
		 if (aprofile.Client_CIF_Code__c != null) {
		 ApplicationProfileIds.add(aprofile.Id);
		 }
		 }*/
		ApplicationProfileClientDetails.updateAppProfiles(ApplicationProfileIds);
		system.assertNotEquals(null, appprof, 'appprofile');
	}
    
}
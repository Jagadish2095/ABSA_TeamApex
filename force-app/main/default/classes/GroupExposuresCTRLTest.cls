/**
 * @description       : Test class for GroupExposuresCTRL
 * @author            : Thabo Senkomane
 * @last modified on  : 2021-06-11
 * @last modified by  : Thabo Senkomane
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   2021-06-11   Thabo Senkomane   Initial Version
**/

@isTest
public class GroupExposuresCTRLTest {
	@testSetup
	static void createData() {
		ExposureControllerTest.dataCreation();
	}

	@isTest
	static void testAllMethods() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
		Application__c app = [SELECT Id FROM Application__c LIMIT 1];

		List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
        List<Application_Profile__c> newAppProfList = ExposureController.orderedProfilesList(appProfileList, opp.Id);
        Map<String,String>mapClientDetails=new Map<String,String>();
        mapClientDetails.put(newAppProfList[0].client_cif_code__c,newAppProfList[0].client_name__c);
		Test.startTest();
		GroupExposuresCTRL.getAndSaveGroupExposureAggregationsFuture(opp.Id);
		System.assertNotEquals(null, GroupExposuresCTRL.getInvokeGroupExposureFromServiceFuture(newAppProfList,app.Id));
		System.assertNotEquals(null, GroupExposuresCTRL.getAndSaveGroupExposureAggregations(opp.Id,app.Id));
		System.assertNotEquals(null, GroupExposuresCTRL.getGroupExposureRecord(opp.Id));
        GroupExposuresCTRL.getGroupExposureFromServiceFuture(mapClientDetails,app.Id);
		Test.stopTest();
	}

	@isTest
	static void testExcMethods() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
		Application__c app = [SELECT Id FROM Application__c LIMIT 1];

		Application_Exposure_Total_Group__c totalGroupRecord = new Application_Exposure_Total_Group__c();
        totalGroupRecord.Application__c = app.id;
        totalGroupRecord.Client_Code__c = 'SNIFFEL001';
        totalGroupRecord.Control_Branch__c = 'test';
        totalGroupRecord.Branch_code__c = 'test';
        totalGroupRecord.Business_Segment__c = 'test';
        totalGroupRecord.Overall_Control_Branch__c = 'test';
        totalGroupRecord.Application_Total_Group__c = 'Total Group Exposure';
        totalGroupRecord.TGAE__c = 10.00;
        totalGroupRecord.TGBE__c = 10.00;
        totalGroupRecord.TGE__c = 10.00;
        totalGroupRecord.TGIE__c = 10.00;
        insert totalGroupRecord;
		List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
		List<Application_Profile__c> orderedAppProfiles = ExposureController.orderedProfilesList(appProfileList,opp.Id);
		List<Application_Exposure_Total_Group__c> appAllExpTotList = new ApplicationsTotalGroupSelector().getAllApplicationsTotalGroup(app.Id);

		Test.startTest();
		System.assertNotEquals(null, GroupExposuresCTRL.getGroupExposureFromService(opp.Id));
		System.assertNotEquals(null, GroupExposuresCTRL.getTotalGroupService(appAllExpTotList, orderedAppProfiles));
		Test.stopTest();
	}
}
/**
 * @description       : Test class for ApplicationsTotalGroupSelector class
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-11
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-10   Englarmerdge Mongwe   Initial Version
**/

@IsTest
public class ApplicationsTotalGroupSelectorTest {    @testSetup
    /**
    * @description : Method to create test data
    * @author Englarmerdge Mongwe | 2021-06-10 
    **/
    public static void dataCreation() {
        ExposureControllerTest.dataCreation();
        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        Application_Exposure_Total_Group__c totalGroupRecord = new Application_Exposure_Total_Group__c();
        totalGroupRecord.Application__c = app.id;
        totalGroupRecord.Client_Code__c = 'SNIFFEL001';
        totalGroupRecord.Control_Branch__c = 'test';
        totalGroupRecord.Branch_code__c = 'test';
        totalGroupRecord.Business_Segment__c = 'test';
        totalGroupRecord.Overall_Control_Branch__c = 'test';
        totalGroupRecord.Overall_Control_Branch_Code__c = '';
        totalGroupRecord.Application_Total_Group__c = 'Total Group Exposure';
        totalGroupRecord.TGAE__c = 10.00;
        totalGroupRecord.TGBE__c = 10.00;
        totalGroupRecord.TGE__c  = 10.00;
        totalGroupRecord.TGIE__c = 10.00;
        insert totalGroupRecord;
    }

    @IsTest public static void testAllSelectorMethods() {
        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        Application_profile__c appProfile=[select Client_CIF_Code__c,client_name__c from Application_profile__c where Applicant_Type__c='Main Applicant' limit 1];
        List<String> groupType = new List<String>();
        groupType.add('Total Group Exposure');

        System.assertNotEquals(null, new ApplicationsTotalGroupSelector().getAllApplicationsTotalGroup(app.Id));
        System.assertNotEquals(null, new ApplicationsTotalGroupSelector().getApplicationTotalGroup(app.Id,groupType[0]));
        System.assertNotEquals(null, new ApplicationsTotalGroupSelector().getApplicationTotalGroupbyGrpType(app.Id,groupType[0]));
        System.assertNotEquals(null, new ApplicationsTotalGroupSelector().getApplicationTotalGroupbyGrpTypeList(app.Id,groupType));
        System.assertNotEquals(null, new ApplicationsTotalGroupSelector().getApplicationTotalGroupbyGrpTypeClientCode(app.Id,'SNIFFEL001',groupType[0]));
        System.assertNotEquals(null, new ApplicationsTotalGroupSelector().getApplicationTotalGroupByClientCode('SNIFFEL001',app.Id));
        System.assertNotEquals(null, new ApplicationsTotalGroupSelector().getCMSFields(app.Id,appProfile.Client_CIF_Code__c));
    }
}
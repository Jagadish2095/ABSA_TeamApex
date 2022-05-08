/**
 * @description Test Class for the Selector layer for Application_Exposure_Facility__c objects
 *
 *@author  Englarmerdge Mongwe|2020-08-27
 **/
@IsTest
public class NonScoredApprovedFacilitiesSelectorTest {

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-20 
    **/
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    @isTest
    static  void testGetSObjectType() {
        System.assert(new NonScoredApprovedFacilitiesSelector().getSObjectType() != null);
    }

    @isTest
    static  void testGetSObjectFieldList() {
        System.assert(new NonScoredApprovedFacilitiesSelector().getSObjectFieldList() != null);
    }

    @isTest
    static  void testSelectByApplicationId() {
        Application__c testApp = [SELECT Id, Name FROM Application__c LIMIT 1];

        System.assert(new NonScoredApprovedFacilitiesSelector().selectByApplicationId(testApp.Id) != null);
    }
    @isTest
    static  void testSelectByName() {
        Application__c testApp = [SELECT Id, Name FROM Application__c LIMIT 1];

        System.assert(new NonScoredApprovedFacilitiesSelector().selectByClientName(testApp.Id,'Test Account') != null);
    }
}